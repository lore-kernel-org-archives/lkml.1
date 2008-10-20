Return-Path: <linux-kernel-owner+w=401wt.eu-S1753599AbYJTNoi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753599AbYJTNoi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 09:44:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbYJTNo1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 09:44:27 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13781 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751957AbYJTNo0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 09:44:26 -0400
To: Jeff Moyer <jmoyer@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 1/2] fs: truncate blocks outside i_size after generic_file_direct_write error
References: <1224424981-5144-1-git-send-email-dmonakhov@openvz.org>
	<x498wsj302t.fsf@segfault.boston.devel.redhat.com>
From: Dmitri Monakhov <dmonakhov@openvz.org>
Date: Mon, 20 Oct 2008 17:43:07 +0400
In-Reply-To: <x498wsj302t.fsf@segfault.boston.devel.redhat.com> (Jeff Moyer's message of "Mon\, 20 Oct 2008 08\:47\:22 -0400")
Message-ID: <m3r66bidqs.fsf@dmon-lap.sw.ru>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Moyer <jmoyer@redhat.com> writes:

> Dmitri Monakhov <dmonakhov@openvz.org> writes:
>
>> We need to remove block that was allocated in generic_file_direct_write()
>> if we fail. We have to do it *regardless* to blocksize. At least ext2,
>> ext3 and reiserfs interpret (i_size < biggest block) condition as error.
>> Fsck will complain about wrong i_size. Then fsck will fix the error
>> by changing i_size according to the biggest block. This is bad because
>> this blocks contain gurbage from previous write attempt. And result in
>> data corruption.
>>
>> In order to call vmtruncate() we have to hold host->i_mutex. This is true
>> for generic_file_aio_write(). In fact occasionally it is also true for all
>> generic_file_aio_write_nolock() callers except blockdev. But this situation
>> may change someday. This patch fix only generic_write_aio_write() case.
>> BTW: update generic_file_direct_write's comment with currently outdated.
>
> Do you have a test case for this, by any chance?
Off courre.
####TESTCASE_BEGIN
$touch /mnt/test/BIG_FILE
## at this moment /mnt/test/BIG_FILE size and blocks equal to zero
open("/mnt/test/BIG_FILE", O_WRONLY|O_CREAT|O_DIRECT, 0666) = 3
write(3, "aaaaaaaaaaaa"..., 104857600) = -1 ENOSPC (No space left on device)
## size and block sould't be changed because write op failed.
$stat /mnt/test/BIG_FILE
File: `/mnt/test/BIG_FILE'
Size: 0 Blocks: 110896 IO Block: 1024 regular empty file
<<<<<<<<^^^^^^^^^^^^^^^^^^^^^^^^^^^^^file size is less than biggest block idx
Device: fe07h/65031d Inode: 14 Links: 1
Access: (0644/-rw-r--r--) Uid: ( 0/ root) Gid: ( 0/ root)
Access: 2007-01-24 20:03:38.000000000 +0300
Modify: 2007-01-24 20:03:38.000000000 +0300
Change: 2007-01-24 20:03:39.000000000 +0300

#fsck.ext3 -f /dev/VG/test
e2fsck 1.39 (29-May-2006)
Pass 1: Checking inodes, blocks, and sizes
Inode 14, i_size is 0, should be 56556544. Fix<y>? yes
Pass 2: Checking directory structure
....
#####TESTCASE_END

>
> Cheers,
>
> Jeff
