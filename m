Return-Path: <linux-kernel-owner+w=401wt.eu-S1752170AbXA0IZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbXA0IZm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 03:25:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752180AbXA0IZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 03:25:01 -0500
Received: from relay01.mail-hub.dodo.com.au ([203.220.32.149]:53138 "EHLO
	relay01.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752177AbXA0IYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 03:24:43 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: Willy Tarreau <w@1wt.eu>
Cc: Santiago Garcia Mantinan <manty@debian.org>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org, dannf@dannf.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Date: Thu, 18 Jan 2007 11:09:57 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <4pctq2tqjnoap3khma0496h2fhfpg1rs75@4ax.com>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu>
In-Reply-To: <20070117215519.GX24090@1wt.eu>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jan 2007 22:55:19 +0100, Willy Tarreau <w@1wt.eu> wrote:

>Hello Santiago,
>
>On Wed, Jan 17, 2007 at 11:00:30AM +0100, Santiago Garcia Mantinan wrote:
>> Hi!
>> 
>> I have discovered a problem with the changes applied to smbfs in 2.4.34 and
>> in the security backports like last Debian's 2.4 kernel update these changes
>> seem to be made to solve CVE-2006-5871 and they have broken symbolic links
>> and changed the way that special files (like devices) are seen.
>> 
>> For example:
>> Before: symbolic links were seen as that, symbolic links an thus if you tried
>> to open the file the link was followed and you ended up reading the
>> destination file
>> Now: symbolic links are seen as normal files (at least with a ls) but their
>> length (N) is the length of the symbolic link, if you read it, you'll get the
>> first N characters of the destination file. For example, on my filesystem
>> bin/sh is a symlink to bash, thus it is 4 bytes long, if I to a cat bin/sh I
>> get ELF (this is, the first 4 characters of the bash program, first one
>> being a DEL).
>> 
>> Another example:
>> Before: if you did a ls of a device file, like dev/zero you could see it as
>> a device, if you tried opening it, it wouldn't work, but if you did a cp -a
>> of that file to a local filesystem the result was a working zero device.
>> Now: the devices are seen as normal files with a length of 0 bytes.
>> 
>> Seems to me like a mask is erasing some mode bits that shouldn't be erased.
>> 
>> I have carried my tests on a Debian Sarge machine always mounting the share
>> using: smbmount //server/share /mnt without any other options. The tests
>> were carried on a unpatched 2.4.34 comparing it to 2.4.33 and also on
>> Debian's 2.4.27 comparing 2.4.27-10sarge4 vs -10sarge5. The server is a
>> samba 3.0.23d and I have experienced the same behaviour with samba's
>> unix extensions = yes and unix extensions = no.
>> 
>> I don't know what else to add, if you need any more info or want me to do
>> any tests just ask for it.
>
>Well, there is not much to add there. Thanks very much for all your tests.
>This problem was not easy to fix, and Dann Frazier did a careful job at
>backporting it and testing it. Unfortunately, corner cases like this may
>sometimes pass through the tests.
>
>Dann, do you still have your samba server ready to try to reproduce this
>problem ? Also, there are very suspect lines right there in the patch :
>
>@@ -505,8 +510,13 @@
> 		mnt->file_mode = (oldmnt->file_mode & S_IRWXUGO) | S_IFREG;
> 		mnt->dir_mode = (oldmnt->dir_mode & S_IRWXUGO) | S_IFDIR;
> 
>-		mnt->flags = (oldmnt->file_mode >> 9);
>+		mnt->flags = (oldmnt->file_mode >> 9) | SMB_MOUNT_UID |
>+			SMB_MOUNT_GID | SMB_MOUNT_FMODE | SMB_MOUNT_DMODE;
> 	} else {
>+		mnt->file_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>+						S_IROTH | S_IXOTH | S_IFREG;
>+		mnt->dir_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>+						S_IROTH | S_IXOTH | S_IFDIR;
> 		if (parse_options(mnt, raw_data))
> 			goto out_bad_option;
> 	}
>
>
>See above ? mnt->dir_mode being assigned 3 times. It still *seems* to do the
>expected thing like this but I wonder if the initial intent was exactly this.
>Also, would not it be necessary to add "|S_IFLNK" to the file_mode ? Maybe
>what I say is stupid, but it's just a guess.
>
>Santiago, if you feel brave enough to try completely untested code, I
>would suggest to try this change :
>
> 	} else {
>-		mnt->file_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>-						S_IROTH | S_IXOTH | S_IFREG;
>-		mnt->dir_mode = mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>-						S_IROTH | S_IXOTH | S_IFDIR;
>+		mnt->file_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>+				S_IROTH | S_IXOTH | S_IFREG | S_IFLNK;
>+		mnt->dir_mode = S_IRWXU | S_IRGRP | S_IXGRP |
>+				S_IROTH | S_IXOTH | S_IFDIR;
> 		if (parse_options(mnt, raw_data))
> 			goto out_bad_option;

I'm comparing 2.4.33.3 with 2.4.34, with 2.4.34 and above patch symlinks 
to directories seen as target, nor can they be created (Operation not 
permitted...)

(copied /usr to spare partition on server)

Grant.

Results:

grant@sempro:/home/other$ uname -r
2.4.33.3
grant@sempro:/home/other$ ls -l
total 1536
lrwxrwxrwx 1 grant wheel  5 2007-01-18 10:08 X11 -> X11R6/
drwxr-xr-x 1 grant wheel  0 2002-02-22 11:45 X11R6/
lrwxrwxrwx 1 grant wheel  8 2007-01-18 10:08 adm -> /var/adm/
drwxr-xr-x 1 grant wheel  0 2006-12-05 09:06 bin/
drwxr-xr-x 1 grant wheel  0 1993-11-26 14:40 dict/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 doc/
drwxr-xr-x 1 grant wheel  0 2006-08-17 16:01 etc/
drwxr-xr-x 1 grant wheel  0 2006-09-09 10:51 games/
drwxr-xr-x 1 grant wheel  0 2005-04-22 05:45 i486-slackware-linux/
drwxr-xr-x 1 grant wheel  0 2006-12-05 09:05 include/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 info/
drwxr-xr-x 1 grant wheel  0 2006-12-05 09:05 lib/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 libexec/
drwxr-xr-x 1 grant wheel  0 1994-03-16 11:50 local/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 man/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 sbin/
drwxr-xr-x 1 grant wheel  0 2006-12-01 09:00 share/
lrwxrwxrwx 1 grant wheel 10 2007-01-18 10:13 spool -> /var/spool/
drwxr-xr-x 1 grant wheel  0 1993-11-25 07:33 src/
drwxr-xr-x 1 grant wheel  0 2007-01-18 10:31 test/
lrwxrwxrwx 1 grant wheel  4 2007-01-18 10:36 testlink -> test/
lrwxrwxrwx 1 grant wheel  4 2007-01-18 10:55 testlink2 -> test/
lrwxrwxrwx 1 grant wheel  8 2007-01-18 10:13 tmp -> /var/tmp/


grant@sempro:/home/other$ uname -r
2.4.34
grant@sempro:/home/other$ ls -l
total 92
drwxr-xr-x 1 grant wheel 4096 2002-02-22 11:45 X11/
drwxr-xr-x 1 grant wheel 4096 2002-02-22 11:45 X11R6/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:12 adm/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:06 bin/
drwxr-xr-x 1 grant wheel 4096 1993-11-26 14:40 dict/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 doc/
drwxr-xr-x 1 grant wheel 4096 2006-08-17 16:01 etc/
drwxr-xr-x 1 grant wheel 4096 2006-09-09 10:51 games/
drwxr-xr-x 1 grant wheel 4096 2005-04-22 05:45 i486-slackware-linux/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:05 include/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 info/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:05 lib/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 libexec/
drwxr-xr-x 1 grant wheel 4096 1994-03-16 11:50 local/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 man/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 sbin/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 share/
drwxr-xr-x 1 grant wheel 4096 2004-06-07 14:40 spool/
drwxr-xr-x 1 grant wheel 4096 1993-11-25 07:33 src/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 test/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 testlink/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 testlink2/
drwxr-xr-x 1 grant wheel 4096 2007-01-17 12:45 tmp/

Symlinks appear as target.

grant@sempro:/home/other$ uname -r
2.4.34-b
grant@sempro:/home/other$ ls -l
total 92
drwxr-xr-x 1 grant wheel 4096 2002-02-22 11:45 X11/
drwxr-xr-x 1 grant wheel 4096 2002-02-22 11:45 X11R6/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:12 adm/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:06 bin/
drwxr-xr-x 1 grant wheel 4096 1993-11-26 14:40 dict/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 doc/
drwxr-xr-x 1 grant wheel 4096 2006-08-17 16:01 etc/
drwxr-xr-x 1 grant wheel 4096 2006-09-09 10:51 games/
drwxr-xr-x 1 grant wheel 4096 2005-04-22 05:45 i486-slackware-linux/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:05 include/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 info/
drwxr-xr-x 1 grant wheel 4096 2006-12-05 09:05 lib/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 libexec/
drwxr-xr-x 1 grant wheel 4096 1994-03-16 11:50 local/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 man/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 sbin/
drwxr-xr-x 1 grant wheel 4096 2006-12-01 09:00 share/
drwxr-xr-x 1 grant wheel 4096 2004-06-07 14:40 spool/
drwxr-xr-x 1 grant wheel 4096 1993-11-25 07:33 src/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 test/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 testlink/
drwxr-xr-x 1 grant wheel 4096 2007-01-18 10:31 testlink2/
drwxr-xr-x 1 grant wheel 4096 2007-01-17 12:45 tmp/

Ditto with the patch.


