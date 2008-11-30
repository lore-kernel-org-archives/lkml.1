Return-Path: <linux-kernel-owner+w=401wt.eu-S1756534AbYK3XoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbYK3XoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 18:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755004AbYK3XoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 18:44:10 -0500
Received: from smtp6-g19.free.fr ([212.27.42.36]:37648 "EHLO smtp6-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYK3XoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 18:44:09 -0500
Message-ID: <49332545.5020604@free.fr>
Date: Mon, 01 Dec 2008 00:44:05 +0100
From: Laurent Riffard <laurent.riffard@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; fr-FR; rv:1.8.1.18) Gecko/20081030 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, Jan Kara <jack@suse.cz>,
       Marcin Slusarz <marcin.slusarz@gmail.com>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: next-2008-11-28 : can't mount UDF DVD
References: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
In-Reply-To: <20081128213620.2ec593d4.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

With next-2008-11-28, I was unable to mount an UDF-formatted DVD-RW:

~$ mount -oro -t udf /dev/sr0 /media/cdrom/
mount: Not a directory

There was no problem with 2.6.28-rc6.

I made a bisection:

33284bdf40f88160a154202510b27d983138c805 is first bad commit
commit 33284bdf40f88160a154202510b27d983138c805
Author: Marcin Slusarz <marcin.slusarz@gmail.com>
Date:   Sun Nov 16 20:52:19 2008 +0100

    udf: implement mode and dmode mounting options

    "dmode" allows overriding permissions of directories and
    "mode" allows overriding permissions of files.

    Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
    Cc: Jan Kara <jack@suse.cz>
    Signed-off-by: Jan Kara <jack@suse.cz>


Indeed, with this commit, I *must* use the dmode option to mount my DVD:

~$ sudo mount -oro,dmode=0755 -t udf /dev/sr0 /media/cdrom/
~$ grep /media/cdrom /proc/mounts 
/dev/scd0 /media/cdrom udf ro,mode=177777,dmode=755,utf8 0 0
~$ ls -la /media/cdrom/
total 46
drwxr-xr-x  5 root    root     344 Dec 24  2007 .
drwxr-xr-x 12 root    root    4096 Dec  1 00:17 ..
drwxr-xr-x  2 laurent laurent 7112 Nov 30 20:14 flexbackup
drwxr-xr-x  2 root    root      40 Nov 20  2005 lost+found
drwxr-xr-x 10 laurent laurent 4548 Nov 25  2005 patches
~$ ls -la /media/cdrom/flexbackup/
total 4307946
drwxr-xr-x 2 laurent laurent       7112 Nov 30 20:14 .
drwxr-xr-x 5 root    root           344 Dec 24  2007 ..
?rwsrwsrwt 1 laurent laurent         44 Oct  1  2006 00-index-key
...

Althought I was able to mount it with no special option on 2.6.28-rc6:

~$ sudo mount -oro -t udf /dev/sr0 /media/cdrom/
~$ grep /media/cdrom /proc/mounts 
/dev/scd0 /media/cdrom udf ro,utf8 0 0
~$ ls -la /media/cdrom/
total 46
drwxrwxrwx  5 root    root     344 2007-12-24 18:09 .
drwxr-xr-x 12 root    root    4096 2008-12-01 00:22 ..
drwxr-x---  2 laurent laurent 7112 2008-11-30 20:14 flexbackup
drwxr-xr-x  2 root    root      40 2005-11-20 23:37 lost+found
drwxr-x--- 10 laurent laurent 4548 2005-11-25 18:18 patches
~$ ls -la /media/cdrom/flexbackup/
total 4307946
drwxr-x--- 2 laurent laurent       7112 2008-11-30 20:14 .
drwxrwxrwx 5 root    root           344 2007-12-24 18:09 ..
-rw-r----- 1 laurent laurent         44 2006-10-01 15:36 00-index-key
...

~~
laurent
