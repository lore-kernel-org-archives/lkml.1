Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYAGRJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYAGRJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 12:09:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754231AbYAGRJr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 12:09:47 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:58262 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753393AbYAGRJq (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 12:09:46 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       serue@us.ibm.com
Subject: Re: [PATCH][RFC] Simple tamper-proof device filesystem.
In-Reply-To: Your message of "Sun, 06 Jan 2008 15:20:00 +0900."
             <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
From: Valdis.Kletnieks@vt.edu
References: <200712232344.JBJ90661.FQOFtFOVLJHSOM@I-love.SAKURA.ne.jp> <20071231200247.GA30373@sergelap.austin.ibm.com> <200801011116.AFH73928.MHFLtOSOOVJFQF@I-love.SAKURA.ne.jp>
            <200801061520.JEF52626.LFHMtSQJOOVFFO@I-love.SAKURA.ne.jp>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1199725780_2703P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 07 Jan 2008 12:09:40 -0500
Message-ID: <6879.1199725780@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1199725780_2703P
Content-Type: text/plain; charset=us-ascii

On Sun, 06 Jan 2008 15:20:00 +0900, Tetsuo Handa said:

> --- linux-2.6-mm.orig/fs/ramfs/inode.c
> +++ linux-2.6-mm/fs/ramfs/inode.c
> @@ -36,6 +36,20 @@
>  #include <asm/uaccess.h>
>  #include "internal.h"
>  
> +static struct inode *__ramfs_get_inode(struct super_block *sb, int mode,
> +				       dev_t dev, bool tmpfs_with_mac);
> +
> +#define TMPFS_WITH_MAC    1
> +#define TMPFS_WITHOUT_MAC 0
> +#include <linux/quotaops.h>
> +
> +#ifdef CONFIG_SYAORAN
> +#include "syaoran.h"
> +#include "syaoran_init.c"
> +#include "syaoran_main.c"
> +#include "syaoran_debug.c"
> +#endif

Ouch.  The .c files should generally be built into their own .o files and
then the Makefile should do something like

obj-$(CONFIG_SYAORAN) += syaoran.o

unless there's *really* good reasons for including .c files (such as an
otherwise-messy variable-namespace issue or similar).

Also, has this been double-checked to Do The Right Thing if you have
*two* instances of ramfs mounted, one with Syaoran and one without?  I don't
know the code well enough to know if you found *all* the places you need
something like:

> -	inode = ramfs_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
> +#ifdef CONFIG_SYAORAN
> +	/*** SYAORAN start. ***/
> +	if (dir->i_sb->s_op == &syaoran_ops) {
> +		if (syaoran_may_create_node(dentry, S_IFLNK, 0) < 0)
> +			return -EPERM;
> +		inode = syaoran_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);
> +	/*** SYAORAN end. ***/
> +	} else
> +#endif
> +		inode = ramfs_get_inode(dir->i_sb, S_IFLNK|S_IRWXUGO, 0);

(incidentally, all of these should probably be abstracted into a helper
function that's 'static inline' so we have just one #ifdef in the definition
in a .h file, and none in open .c code).

Similarly for other places you have #ifdef CONFIG_ in ramfs .c code - see if
you can abstract it out.

> +/*
> + * Original tmpfs doesn't set ramfs_dir_inode_operations.setattr field.
> + * Now I'm setting the field to share tmpfs/rootfs/syaoran code.

Question for the audience: *should* ramfs set that field so setattr works
on ramfs (even if it's just a stub similar to the SELinux fscontext= mount
stuff)?

Question for Tetsuo:  What happens to this code if somebody actually does the
above change?

> --- linux-2.6-mm.orig/fs/Kconfig
> +++ linux-2.6-mm/fs/Kconfig
> @@ -978,6 +978,24 @@ config TMPFS_POSIX_ACL

> +	  "Applications using well-known device locations under /dev
> +	   get the device they want" (e.g. an application that accesses
> +	   /dev/null can always get a character special device
> +	   with major=1 and minor=3).

This should say "will always get", not "can always", as this code will
mandate, rather than just make possible.

> +	  The list of possible combinations of filename and its attributes
> +	  that can exist on this filesystem is defined at mount time
> +	  using a configuration file.

The format of this file needs to be documented.  I'm not terribly thrilled by
the idea of passing a file to be read by the kernel, but I also understand
that if it isn't done before mount, you have a race condition betweet the
mount and the load.  Perhaps write some configfs code so that you can
'mount /configfs; cat config.file > /configfs/syaoran; mount -t syaoran"?

Similarly, it looks like you create your debug files inside the ramfs - that
is probably a bad idea and possibly can exhaust resources.  Convert it to
use debugfs instead?

> +       if (!filename) {
> +               printk(KERN_INFO "SYAORAN: Missing config-file path.\n");
> +               return -EINVAL;

Does this (and the code right after Do The Right Thing if somebody does this:

mount -t syaoran -o noatime,noexec /some/path

(I admit not knowing if mount options common to all mounts are stripped out
by the VFS code or passed down to this code).

Or even worse, "-o noatime,accept=/some/path/ramfs.cfg"?

> +       f = open_pathname(AT_FDCWD, filename, O_RDONLY, 0600);
> +       if (IS_ERR(f)) {
> +               printk(KERN_INFO "SYAORAN: Can't open '%s'\n", filename);
> +               return -EINVAL;
> +       }

Does this do what you think it does if run in a chroot process or if
some creative person does "accept=../../path/to/bad_data.cfg"?

That printk should be KERN_ERR, I think.

That's all that's immediately obvious to me - somebody who actually understands
the filesystem code better will probably need to review it for all the stuff
I missed before it can be included.

--==_Exmh_1199725780_2703P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFHglzUcC3lWbTT17ARAuimAKDwKEtU54lmK5e/DDaFyEVnsaO4YgCglQ5S
UTIZivKhiWgWlJ6oj2GdpdE=
=++70
-----END PGP SIGNATURE-----

--==_Exmh_1199725780_2703P--
