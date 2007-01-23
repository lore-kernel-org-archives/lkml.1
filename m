Return-Path: <linux-kernel-owner+w=401wt.eu-S965050AbXAWVEq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965050AbXAWVEq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 16:04:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965067AbXAWVEq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 16:04:46 -0500
Received: from relay02.mail-hub.dodo.com.au ([202.136.32.45]:34232 "EHLO
	relay02.mail-hub.dodo.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965050AbXAWVEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 16:04:44 -0500
From: Grant Coady <grant_lkml@dodo.com.au>
To: dann frazier <dannf@dannf.org>
Cc: Grant Coady <gcoady.lk@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Santiago Garcia Mantinan <manty@debian.org>,
       linux-kernel@vger.kernel.org, debian-kernel@lists.debian.org
Subject: Re: problems with latest smbfs changes on 2.4.34 and security backports
Date: Wed, 24 Jan 2007 08:04:36 +1100
Organization: http://bugsplatter.mine.nu/
Reply-To: Grant Coady <gcoady.lk@gmail.com>
Message-ID: <mstcr2hm6aar4t58o3gm0hit6thpdd6ohp@4ax.com>
References: <20070117100030.GA11251@clandestino.aytolacoruna.es> <20070117215519.GX24090@1wt.eu> <20070119010040.GR16053@colo> <20070120010544.GY26210@colo> <t1r7r2thimh3gpuhtfc9l3aehjdd6dqkp8@4ax.com> <20070121230321.GC2480@1wt.eu> <20070123201936.GA26310@colo>
In-Reply-To: <20070123201936.GA26310@colo>
X-Mailer: Forte Agent 2.0/32.652
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jan 2007 13:19:37 -0700, dann frazier <dannf@dannf.org> wrote:

>On Mon, Jan 22, 2007 at 12:03:21AM +0100, Willy Tarreau wrote:
>> Hi Grant !
>> 
>> On Mon, Jan 22, 2007 at 09:52:44AM +1100, Grant Coady wrote:
>> > On Fri, 19 Jan 2007 18:05:44 -0700, dann frazier <dannf@dannf.org> wrote:
>> > 
>> > >On Thu, Jan 18, 2007 at 06:00:40PM -0700, dann frazier wrote:
>> > >Ah, think I see the problem now:
>> > >
>> > >--- kernel-source-2.4.27.orig/fs/smbfs/proc.c	2007-01-19 17:53:57.247695476 -0700
>> > >+++ kernel-source-2.4.27/fs/smbfs/proc.c	2007-01-19 17:49:07.480161733 -0700
>> > >@@ -1997,7 +1997,7 @@
>> > > 		fattr->f_mode = (server->mnt->dir_mode & (S_IRWXU | S_IRWXG | S_IRWXO)) | S_IFDIR;
>> > > 	else if ( (server->mnt->flags & SMB_MOUNT_FMODE) &&
>> > > 	          !(S_ISDIR(fattr->f_mode)) )
>> > >-		fattr->f_mode = (server->mnt->file_mode & (S_IRWXU | S_IRWXG | S_IRWXO)) | S_IFREG;
>> > >+		fattr->f_mode = (server->mnt->file_mode & (S_IRWXU | S_IRWXG | S_IRWXO)) | (fattr->f_mode & S_IFMT);
>> > > 
>> > > }
>> > > 
>> > client running 2.4.34 with above patch, server is running 2.6.19.2 to 
>> > eliminate it from the problem space (hopefully ;) :
>> > grant@sempro:/home/other$ uname -r
>> > 2.4.34b
>> > grant@sempro:/home/other$ ls -l
>> > total 9
>> > drwxr-xr-x 1 grant wheel 4096 2007-01-21 11:44 dir/
>> > drwxr-xr-x 1 grant wheel 4096 2007-01-21 11:44 dirlink/
>> > -rwxr-xr-x 1 grant wheel   15 2007-01-21 11:43 file*
>> > -rwxr-xr-x 1 grant wheel   15 2007-01-21 11:43 filelink*
>> 
>> It seems to me that there is a difference, because filelink now appears the
>> same size as file. It's just as if we had hard links instead of symlinks.
>
>I was running into this yesterday - turns out that Debian's current
>smbfs package contains a patch that checks for user passed options,
>and disables unix capabilities in that case. It was added in
>3.0.14a-4. I've filed a bug requesting the removal of this patch:
>  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=408033
>
>Grant: Do you know if are you running a version of smbfs w/ this
>       patch?

Hi Dann,
I'm running slackware-11, no smbfs package, 'smbmnt' is from samba-3.0.23c 
package with two tiny unrelated (?) patches:

grant@deltree:/home/mirror/slackware-11.0/source$ find . -name samba*
./n/samba
./n/samba/samba.cups.diff.gz
./n/samba/samba.ssl.diff.gz
./n/samba/samba.SlackBuild
./n/samba/samba-3.0.23c.tar.asc
./n/samba/samba-3.0.23c.tar.bz2
grant@deltree:/home/mirror/slackware-11.0/source$ zless n/samba/samba.cups.diff.gz
--- ./source/configure.orig     2002-10-23 18:06:43.000000000 -0700
+++ ./source/configure  2002-10-23 18:07:12.000000000 -0700
@@ -3789,7 +3789,7 @@

                CFLAGS="$CFLAGS `$CUPS_CONFIG --cflags`"
                LDFLAGS="$LDFLAGS `$CUPS_CONFIG --ldflags`"
-               LIBS="$LIBS `$CUPS_CONFIG --libs`"
+               LIBS="-lcrypt $LIBS `$CUPS_CONFIG --libs`"
         fi
 fi

grant@deltree:/home/mirror/slackware-11.0/source$ zcat n/samba/samba.ssl.diff.gz
--- ./source/configure.orig     2002-10-09 13:27:21.000000000 -0700
+++ ./source/configure  2002-10-23 18:06:43.000000000 -0700
@@ -12479,7 +12479,7 @@

     fi

-    LIBS="-lssl -lcrypto $LIBS"
+    LIBS="$LIBS -lssl -lcrypto"

 #    if test ! -d ${withval}; then
 #      echo "configure: error: called with --with-ssl, but ssl base directory ${withval} does not exist or is not a directory. Aborting config" 1>&2

Grant.
