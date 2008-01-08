Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbYAHNvE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbYAHNvE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 08:51:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753639AbYAHNus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 08:50:48 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:49227 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751321AbYAHNur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 08:50:47 -0500
To: Valdis.Kletnieks@vt.edu
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp>
	<20071231200247.GA30373@sergelap.austin.ibm.com>
	<200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
	<200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
	<6879.1199725780@turing-police.cc.vt.edu>
In-Reply-To: <6879.1199725780@turing-police.cc.vt.edu>
Message-Id: <200801082250.CJH13533.OFSMHFVOLtJQOF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Tue, 8 Jan 2008 22:50:43 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Valdis.Kletnieks@vt.edu wrote:
> Ouch.  The .c files should generally be built into their own .o files and
> then the Makefile should do something like
> 
> obj-$(CONFIG_SYAORAN) += syaoran.o
> 
> unless there's *really* good reasons for including .c files (such as an
> otherwise-messy variable-namespace issue or similar).
Yes. The final implementation will become so.
This is a temporal hack to keep all functions and variables "static".

> Also, has this been double-checked to Do The Right Thing if you have
> *two* instances of ramfs mounted, one with Syaoran and one without?
Yes. The memory for superblock is allocated for each instance.
Thus, mounting one as syaoran and the other as tmpfs won't cause problems.

> (incidentally, all of these should probably be abstracted into a helper
> function that's 'static inline' so we have just one #ifdef in the definition
> in a .h file, and none in open .c code).
Oh, good idea.

> Similarly for other places you have #ifdef CONFIG_ in ramfs .c code - see if
> you can abstract it out.
This patch replaces the previous patch and
this patch modifies only tmpfs (fs/shm*) files.
I'm no longer modifying ramfs (fs/ramfs/*) files.

> > +/*
> > + * Original tmpfs doesn't set ramfs_dir_inode_operations.setattr field.
> > + * Now I'm setting the field to share tmpfs/rootfs/syaoran code.
> 
> Question for the audience: *should* ramfs set that field so setattr works
> on ramfs (even if it's just a stub similar to the SELinux fscontext= mount
> stuff)?
> 
> Question for Tetsuo:  What happens to this code if somebody actually does the
> above change?
Please forget this question.
I'm no longer setting "ramfs_dir_inode_operations.setattr" field.

> > +	  "Applications using well-known device locations under /dev
> > +	   get the device they want" (e.g. an application that accesses
> > +	   /dev/null can always get a character special device
> > +	   with major=1 and minor=3).
> 
> This should say "will always get", not "can always", as this code will
> mandate, rather than just make possible.
OK.

> > +	  The list of possible combinations of filename and its attributes
> > +	  that can exist on this filesystem is defined at mount time
> > +	  using a configuration file.
> 
> The format of this file needs to be documented.
Yes. It is a line-by-line processable format defined as:

  filename permission owner group flags type [ symlink_data | major minor ]

where flags are bit-wised combinations of

  *  1: Allow creation of the file.
  *  2: Allow deletion of the file.
  *  4: Allow changing permissions of the file.
  *  8: Allow changing owner or group of the file.
  * 16: For internal use. Remembers whether this file is opened or not.
  * 32: Don't create this file at mount time.

and here are some example entries:

  pts     755     0       0       0       d
  shm     755     0       0       0       d
  fd      777     0       0       0       l       /proc/self/fd
  stdin   777     0       0       0       l       /proc/self/fd/0
  stdout  777     0       0       0       l       /proc/self/fd/1
  stderr  777     0       0       0       l       /proc/self/fd/2
  null    666     0       0       0       c       1       3
  zero    666     0       0       0       c       1       5
  random  644     0       0       0       c       1       8
  urandom 644     0       0       0       c       1       9
  tty     666     0       0       0       c       5       0
  tty0    600     0       0       12      c       4       0
  cdrom   777     0       0       3       l       /dev/scd0
  console 600     0       0       1       c       5       1
  hda     660     0       6       0       b       3       0
  hda1    660     0       6       0       b       3       1
  initctl 600     0       0       3       p
  log     666     0       0       15      s
  rtc     644     0       0       0       c       10      135
  ptmx    666     0       0       0       c       5       2
  ram     777     0       0       3       l       /dev/ram0
  ram0    660     0       6       0       b       1       0
  ram1    660     0       6       0       b       1       1
  sda     660     0       6       0       b       8       0
  initrd  660     0       6       1       b       1       250

Full documentation of this filesystem is at
http://tomoyo.sourceforge.jp/en/1.5.x/policy-syaoran.html

> I'm not terribly thrilled by
> the idea of passing a file to be read by the kernel, but I also understand
> that if it isn't done before mount, you have a race condition betweet the
> mount and the load.
What race condition is possible?
Are you worrying that the file gets modified while reading?

>  Perhaps write some configfs code so that you can
> 'mount /configfs; cat config.file > /configfs/syaoran; mount -t syaoran"?
If you worry that the file gets modified while reading in kernel space,
you will also worry that the file gets modified while doing
"cat config.file > /configfs/syaoran".

To use configfs (or whatever approach that is done before mount syscall),
some tag for associating "list of permitted entries" and "mount point" is needed
so that an administrator can mount this filesystem for each chroot'ed environment
with different "list of permitted entries" (e.g. /dev with all entries,
/var/jail1/dev with only "null", /var/jail2/dev with only "null" and "random").

It would be possible to pass "list of permitted entries" (which is the content of
a config file) through mount syscall's parameter. But since the number of entries
in "list of permitted entries" is not constant, it sometimes requires much memory
for passing whole entries at once upon mount syscall.

I wonder why many of kernel developers hate opening files in kernel space.
I think it won't cause bugs as long as the file is alive within single syscall.
I'm using a path to config file as a tag for associating "list of permitted entries"
and "mount point". I'm opening a config file and reading the file and closing the file
within a single mount() syscall.

> Similarly, it looks like you create your debug files inside the ramfs - that
> is probably a bad idea and possibly can exhaust resources.  Convert it to
> use debugfs instead?
It is named as "debug", but is not a debug interface.
It is a interface for obtaining snapshots of "flags" values.
The kernel updates "flags" values if this filesytem is mounted with
"accept=" option. (The kernel doesn't update if mounted with "enforce=" option.)

> Does this (and the code right after Do The Right Thing if somebody does this:
> 
> mount -t syaoran -o noatime,noexec /some/path
> 
> (I admit not knowing if mount options common to all mounts are stripped out
> by the VFS code or passed down to this code).
Yes. /bin/mount parses common mount options like "noatime" and "noexec"
and passes common mount options stored in "mountflags" variable of mount(2)
and passes non-common mount options stored in "data" variable of mount(2).

> Or even worse, "-o noatime,accept=/some/path/ramfs.cfg"?
In that case, mount(2) receives MS_NOATIME stored in "mountflags" and
"accept=/some/path/ramfs.cfg" stored in "data".

> > +       f = open_pathname(AT_FDCWD, filename, O_RDONLY, 0600);
> > +       if (IS_ERR(f)) {
> > +               printk(KERN_INFO "SYAORAN: Can't open '%s'\n", filename);
> > +               return -EINVAL;
> > +       }
> 
> Does this do what you think it does if run in a chroot process or if
> some creative person does "accept=../../path/to/bad_data.cfg"?
sys_open() calls open_pathname() with AT_FDCWD.
So, it is the same thing as calling
open("../../path/to/bad_data.cfg", O_RDONLY) from the userland.

> That printk should be KERN_ERR, I think.
May be. But I think KERN_WARNING is enough because this is not such emergent error.


> That's all that's immediately obvious to me - somebody who actually understands
> the filesystem code better will probably need to review it for all the stuff
> I missed before it can be included.
Thank you.
