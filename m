Return-Path: <linux-kernel-owner+w=401wt.eu-S1755611AbXFUQRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611AbXFUQRa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 12:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752792AbXFUQRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 12:17:21 -0400
Received: from terminus.zytor.com ([192.83.249.54]:35040 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbXFUQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 12:17:20 -0400
Message-ID: <467AA3B4.6090609@zytor.com>
Date: Thu, 21 Jun 2007 09:13:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Al Viro <viro@ftp.linux.org.uk>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org, util-linux-ng@vger.kernel.org
Subject: Re: Adding subroot information to /proc/mounts, or obtaining that
 through other means
References: <467994BD.6000403@zytor.com> <20070620210343.GQ21478@ftp.linux.org.uk>
In-Reply-To: <20070620210343.GQ21478@ftp.linux.org.uk>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Wed, Jun 20, 2007 at 01:57:33PM -0700, H. Peter Anvin wrote:
>> ... or, alternatively, add a subfield to the first field (which would
>> entail escaping whatever separator we choose):
>>
>> /dev/md6 /export ext3 rw,data=ordered 0 0
>> /dev/md6:/users/foo /home/foo ext3 rw,data=ordered 0 0
>> /dev/md6:/users/bar /home/bar ext3 rw,data=ordered 0 0
> 
> Hell, no.  The first field is in principle impossible to parse unless
> you know the fs type.
> 
> How about making a new file with sane format?  From the very
> beginning.  E.g. mountpoint + ID + relative path + type + options,
> where ID uniquely identifies superblock (e.g. numeric st_dev)
> and backing device (if any) is sitting among the options...

The more I'm thinking about this, I think it's simplest to just add
fields to the right of the existing /proc/*/mounts.  Yes, the format is
ugly, and it will end up being uglier still, but it's also ugly to have
a bunch of different chunks of information formatted in different ways.

So, the existing fields are:

mnt_devname mnt_path filesystem_type options 0 0

... and we'd want to add ...

mnt_id propagation_info sb_dev path_to_fs_root

As previously stated, in order to avoid having to expose kernel
addresses to userspace, I suggest we simply add a counter field to
struct vfsmount and use that for mnt_id.

I'm not all that up on what is needed for propagation_info.  I presume
we want to be able to deduce the full mount lattice.  One particularly
important thing in my mind is to be able to distinguish overmounted
filesystems (which I think is possible in the current setup only by
ordering -- the filesystem on top I believe will end up last in
/proc/mounts, but I don't know if there actually is anything that
enforces that.)

	-hpa
