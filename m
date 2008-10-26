Return-Path: <linux-kernel-owner+w=401wt.eu-S1753155AbYJZVI5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155AbYJZVI5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2008 17:08:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751933AbYJZVIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Oct 2008 17:08:47 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:23747 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbYJZVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2008 17:08:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Pty8VGUiB2CQk1i+SJjpwyUoIJhAtXtIwXL7/+sXksogwrP0H4ufLKiZ1RmtHBswpV
         W+enEHUIq+fz6/SQ3ORocWBvTUKijK34MAgSdpTcaDbl3wBMTy46s56zzqyBBgh3dE7s
         erO/lPFtg58uHXbMuDn7clgACK4UEKDParNHU=
Message-ID: <19f34abd0810261408w61b1e2dbvb9a0e16ce5a10022@mail.gmail.com>
Date: Sun, 26 Oct 2008 22:08:45 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>
Subject: Re: v2.6.28-rc1: readlink /proc/*/exe returns uninitialized data to userspace
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Pekka Enberg" <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>, "Greg KH" <greg@kroah.com>,
       "Kay Sievers" <kay.sievers@vrfy.org>, linux-fsdevel@vger.kernel.org
In-Reply-To: <m163nggvhq.fsf@frodo.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0810251014s7968557br38e43aa0b9cdcf09@mail.gmail.com>
	 <200810252241.53601.rjw@sisk.pl> <m163nggvhq.fsf@frodo.ebiederm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Combined result for Eric & Viro]

On Sat, Oct 25, 2008 at 11:28 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
>> On Saturday, 25 of October 2008, Vegard Nossum wrote:
>>> Hi,
>>>
>>> When I run readlink on the /proc/*/exe-file for udevd, the kernel
>>> returns some unitialized data to userspace:
>>>
>>> # strace -e trace=readlink readlink /proc/4762/exe
>>> readlink("/proc/4762/exe", "/sbin/udevd", 1025) = 30
>>>
>>> You can see it because the kernel thinks that the string is 30 bytes
>>> long, but in fact it is only 12 (including the '\0').
...

> Weird.  The dentry for "udevd" has an incorrect length.
> Is something stomping the length somewhere?
>
> What filesystem does /sbin/udevd reside on?

Ext3 on a USB flash-disk.

On Sun, Oct 26, 2008 at 1:23 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> (For the record: This didn't show up in 2.6.27-rc with the same
>> version of LTP, so it seems to be a recent regression.)
>
> Very odd.  Do you see that for any other processes?  Where does
> /sbin/udevd live on your box?  BTW, .config might be useful here...
>
> Can you reproduce that on e.g. amd64 and/or without kmemcheck?

IIRC, it did show up for other processes, but udevd was the only one
which exhibited the problem reliably.

Now, I've been trying to reproduce the problem (with exact same setup)
since I first saw it, but can't :-/ At the time that the machine
started showing the problem, it had been running LTP, scrashme, etc.
for hours, so it seems that it might have had something to do with it.
I couldn't reproduce it after rebooting.

This was my setup:
 - root filesystem (ext3) on USB flash disk
 - mounted LVM2/ext3 from harddisk on /mnt
 - bind-mounted /proc onto /mnt/proc

I noticed the problem from chroot /mnt, but it reproduced afterwards
on the outside as well. I also remember having remounted (with -o
remount) both /mnt (adding user_xattr to options) and /mnt/proc from
within the chroot (so with /mnt prefix removed). This could of course
all be unrelated since it didn't reproduce the problem, but at least
it is what I did.

Cosmic rays may have been involved. Will keep trying to reproduce.
Thanks for attention so far.


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
