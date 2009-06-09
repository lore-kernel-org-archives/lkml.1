Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbZFIHFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbZFIHFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 03:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZFIHEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 03:04:54 -0400
Received: from smtp.nokia.com ([192.100.122.230]:42257 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZFIHEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 03:04:53 -0400
Message-ID: <4A2E095C.6070603@gmail.com>
Date: Tue, 09 Jun 2009 10:03:56 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Jan Kara <jack@suse.cz>, Eric Sandeen <sandeen@sandeen.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Masayoshi MIZUMA <m.mizuma@jp.fujitsu.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
       Nick Piggin <npiggin@suse.de>, Jeff Layton <jlayton@redhat.com>
Subject: Re: [PATCH] writeback: skip new or to-be-freed inodes
References: <20090324120502.GC23439@duck.suse.cz> <20090324124001.GA25326@localhost> <4A244A5B.7070605@sandeen.net> <20090602085523.GC7161@localhost> <20090602113736.GB15010@duck.suse.cz> <20090603141021.GB5738@localhost> <20090603141636.GC5650@duck.suse.cz> <20090603144711.GC5738@localhost> <20090606030725.GA12852@localhost> <4A2CB7AE.6080909@gmail.com> <20090608092930.GA13846@localhost>
In-Reply-To: <20090608092930.GA13846@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 09 Jun 2009 07:04:03.0878 (UTC) FILETIME=[79112C60:01C9E8D0]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> Hi Artem,
> 
> On Mon, Jun 08, 2009 at 03:03:10PM +0800, Artem Bityutskiy wrote:
>> Wu Fengguang wrote:
>>> The above race and warning didn't turn up because writeback_inodes() holds
>>> the s_umount lock, so generic_forget_inode() finds MS_ACTIVE and returns
>>> early. But we are not sure the UBIFS calls and future callers will guarantee
>>> that. So skip I_WILL_FREE inodes for the sake of safety.
>> The inode states are a bit vague for me, but vs. UBIFS - feel
>> free to ask questions.
> 
> Thank you. Basically I'm not sure if UBIFS guarantees it won't be
> unmounted (hence the MS_ACTIVE bit is on) when calling
> generic_sync_sb_inodes() in shrink_liability() and ubifs_sync_fs().

To be frank my VFS knowledge is not good enough to give you a
good answer. MS_ACTIVE seems to be set by file-systems when
they are mounted, and cleaned by VFS when unmounting.
I guess MS_ACTIVE is used by FS-es to check whether unmounting
is in progress or not. Anyway, UBIFS does not use it.

The generic_sync_sb_inodes() is called only from within
VFS operations, e.g., from ->create, ->rename, ->mknod,
->write_begin, ->setattr, etc. I mean, it is called from
UBIFS implementations of the above calls. UBIFS never calls
generic_sync_sb_inodes() function by itself, e.g., from
the UBIFS background thread.

Also, all calls to generic_sync_sb_inodes() are from within
VFS operations which need writing, e.g., VFS called
'mnt_want_write()' for all of them.

I think VFS must protect the FS from being unmunted while
it is in the middle of an operation, right? I'm just not
sure how this mechanism works. This would mean that yes,
we cannot be unmounted while we are in
generic_sync_sb_inodes() called by UBIFS.

Did this help :-) ?

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
