Return-Path: <linux-kernel-owner+w=401wt.eu-S1753706AbZL3U7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753706AbZL3U7h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 15:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbZL3U7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 15:59:36 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54253 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227AbZL3U7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 15:59:35 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Marvin <marvin24@gmx.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: vfs related crash in 2.6.33-rc2
References: <200912301733.19077.marvin24@gmx.de>
	<87637oi6v8.fsf@devron.myhome.or.jp>
	<200912302144.36718.marvin24@gmx.de>
Date: Thu, 31 Dec 2009 05:59:32 +0900
In-Reply-To: <200912302144.36718.marvin24@gmx.de> (Marvin's message of "Wed,
	30 Dec 2009 21:44:36 +0100")
Message-ID: <87637omb4b.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marvin <marvin24@gmx.de> writes:

>> Marvin <marvin24@gmx.de> writes:
>> > Hi,
>> >
>> > I'm getting a lot of these:
>> >
>> > kernel: general protection fault: 0000 [#1] SMP
>> > kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:18.3/modalias
>> > kernel: CPU 0
>> > kernel: Pid: 12177, comm: packagekitd Not tainted 2.6.33-rc2 #1
>> > ...
>> >
>> > filesystem is ext4 (in case it matters).
>> 
>> BTW, are you using nfs client on this machine?
>>
>
> um - yes, now that I think about it... I killed a nfs umount process (because of an 
> offline server) shortly before the oopses started to fire.

OK. Probably, this oops would be same with one which happened on my
machine recently. That path in patch corrupts dcache hash, so it can be
the cause of strange behavior or oops on dcache hash.

If so, the attached patch would fix it.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>


Recent change is missing to update "rehash". With that change, it will
become the cause of adding dentry to hash twice.

This explains the reason of Oops (dereference the freed dentry in
__d_lookup()) on my machine.

Signed-off-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
---

 fs/nfs/dir.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/nfs/dir.c~nfs-d_rehash-fix fs/nfs/dir.c
--- linux-2.6/fs/nfs/dir.c~nfs-d_rehash-fix	2009-12-28 06:18:09.000000000 +0900
+++ linux-2.6-hirofumi/fs/nfs/dir.c	2009-12-28 06:18:16.000000000 +0900
@@ -1615,6 +1615,7 @@ static int nfs_rename(struct inode *old_
 				goto out;
 
 			new_dentry = dentry;
+			rehash = NULL;
 			new_inode = NULL;
 		}
 	}
_
