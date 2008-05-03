Return-Path: <linux-kernel-owner+w=401wt.eu-S1760590AbYECGc7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760590AbYECGc7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:32:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754053AbYECGct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:32:49 -0400
Received: from 1wt.eu ([62.212.114.60]:3722 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYECGcs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:32:48 -0400
Date: Sat, 3 May 2008 08:32:31 +0200
From: Willy Tarreau <w@1wt.eu>
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Lothar =?iso-8859-1?Q?Wa=DFmann?= <lw@karo-electronics.de>,
       linux-kernel@vger.kernel.org
Subject: Re: linux-2.6.25: 'mkdir -p' does not work with rootdir as mount point inside a read only filesystem
Message-ID: <20080503063231.GA688@1wt.eu>
References: <18456.34604.472989.35082@ipc1.ka-ro> <20080501215231.297e0d9d.akpm@linux-foundation.org> <53722.192.168.1.70.1209711343.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53722.192.168.1.70.1209711343.squirrel@neil.brown.name>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 02, 2008 at 04:55:43PM +1000, NeilBrown wrote:
> On Fri, May 2, 2008 2:52 pm, Andrew Morton wrote:
> > On Wed, 30 Apr 2008 16:50:20 +0200 Lothar Wa__mann
> > <LW@KARO-electronics.de> wrote:
> >
> >> Hi,
> >
> > (y'know that ~4000 people read your email and hit 'n'?  Except for me?
> > That's one bug I'd like to get fixed)
> 
> Tricky....
> 
> >
> >> when trying to create a directory path with 'mkdir -p' with the root
> >> being a mount point of a writeable filesystem that exists inside a
> >> read-only file system, mkdir return -EROFS.
> 
> My guess is that you have an old/buggy version of mkdir.
> 
> What does
>     mkdir --version
> 
> say?
> Mine says:
> mkdir (GNU coreutils) 6.10
> Copyright (C) 2008 Free Software Foundation, Inc.
> etc...

I would bet this is the problem for the reporter.

I tried the same here, and cannot exhibit the problem. Just like the
reporter, my / is ro and /dev is rw :

# mkdir --version
mkdir (coreutils) 5.2.1
...

# uname -a
Linux alix-2C3 2.6.25-wt4-alix #3 Thu Apr 24 08:30:05 CEST 2008 i586 i586 i386 GNU/Linux

(this is essentially 2.6.25+squashfs+some geode patches)

# mount
/dev/sda4 on / type ext3 (ro,errors=continue,data=ordered)
/dev on /dev type tmpfs (rw,size=0k,nr_inodes=4096,mode=755)

# mkdir -p /dev/a/b/c
# ls -lad /dev/a/b/c
drwxr-xr-x  2 root root 40 Jan  3 00:49 /dev/a/b/c/

# rmdir -p /dev/a/b/c
rmdir: `/dev': Read-only file system
# strace mkdir -p /dev/a/b/c

stat64("/dev/a/b/c", 0xbf9175dc)        = -1 ENOENT (No such file or directory)
umask(0)                                = 022
open(".", O_RDONLY|O_LARGEFILE|O_DIRECTORY) = 3
chdir("/")                              = 0
mkdir("dev", 0755)                      = -1 EEXIST (File exists)
stat64("dev", {st_mode=S_IFDIR|0755, st_size=17080, ...}) = 0
chdir("dev")                            = 0
mkdir("a", 0755)                        = 0
chdir("a")                              = 0
mkdir("b", 0755)                        = 0
chdir("b")                              = 0
umask(022)                              = 0
mkdir("c", 0777)                        = 0
fchdir(3)                               = 0
close(3)                                = 0

Regards,
Willy

