Return-Path: <linux-kernel-owner+w=401wt.eu-S1751772Ab0AZFs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0AZFs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 00:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750821Ab0AZFsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 00:48:54 -0500
Received: from waste.org ([173.11.57.241]:53489 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab0AZFsy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 00:48:54 -0500
Subject: Re: UBIFS assert failed in ubifs_dirty_inode
From: Matt Mackall <mpm@selenic.com>
To: dedekind1@gmail.com
Cc: Jeff Angielski <jeff@theptrgroup.com>, linux-mtd@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <1264480808.2401.78.camel@localhost.localdomain>
References: <4B591573.60602@theptrgroup.com>
	 <1264480808.2401.78.camel@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 23:48:48 -0600
Message-ID: <1264484928.3536.1017.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 06:40 +0200, Artem Bityutskiy wrote:
> On Thu, 2010-01-21 at 22:03 -0500, Jeff Angielski wrote:
> > I am trying use an UBIFS root filesystem on my PowerPC MPC8544 but I am 
> > seeing some intermitent problems with "UBIFS assert failed in 
> > ubifs_dirty_inode" errors.
> > 
> > On the first boot after I program the NAND with a fresh UBI image, 
> > everything seems to work ok.
> > 
> > After that, on subsequent powercycles or reboots, I sometimes see a boot 
> > with the following error:
> > 
> > [    5.984232] UBIFS assert failed in ubifs_dirty_inode at 377 (pid 1011)
> 
> Interesting.
> 
> The stack trace for this assertion is:
> 
> [   42.724193] [df121e60] [c00070f8] show_stack+0x3c/0x17c (unreliable)
> [   42.730566] [df121ea0] [c017e754] ubifs_dirty_inode+0xe0/0xe4
> [   42.736325] [df121eb0] [c00c6fbc] __mark_inode_dirty+0x3c/0x16c
> [   42.742260] [df121ec0] [c01f9034] random_write+0x8c/0xa4
> [   42.747584] [df121ef0] [c00a4d2c] vfs_write+0xb4/0x184
> [   42.752730] [df121f10] [c00a53e8] sys_write+0x4c/0x90
> [   42.757795] [df121f40] [c000fd48] ret_from_syscall+0x0/0x3c
> 
> Which leads us to
> 
> ~/git/linux-2.6/drivers/char/random.c, where we can find this code:
> 
>         inode->i_mtime = current_fs_time(inode->i_sb);
>         mark_inode_dirty(inode);
>         return (ssize_t)count;
> 
> which is the reason for the assertion and for the further budgeting
> screw-up.
> 
> The thing is that UBIFS has to allocate budget every-time a clean inode
> is made dirty. But the 'random' driver bypasses UBIFS budget allocation,
> and instead, changes mtime directly and marks the inode as dirty
> directly.
> 
> The driver should instead call the ->setattr() method of the inode,
> which should do the right thing. IOW, something like this is needed:
> 
> diff --git a/drivers/char/random.c b/drivers/char/random.c
> index 8258982..f911781 100644
> --- a/drivers/char/random.c
> +++ b/drivers/char/random.c
> @@ -1108,6 +1108,7 @@ static ssize_t random_write(struct file *file,
> const char __user *buffer,
>  {
>         size_t ret;
>         struct inode *inode = file->f_path.dentry->d_inode;
> +       struct iattr;
> 
>         ret = write_pool(&blocking_pool, buffer, count);
>         if (ret)
> @@ -1116,8 +1117,11 @@ static ssize_t random_write(struct file *file,
> const char __user *buffer,
>         if (ret)
>                 return ret;
> 
> -       inode->i_mtime = current_fs_time(inode->i_sb);
> -       mark_inode_dirty(inode);
> +       iattr->i_mtime = current_fs_time(inode->i_sb);
> +       iattr->ia_valid = ATTR_ATIME;
> +       ret = inode_setattr(inode, &attr);
> +       if (ret)
> +               return ret;
>         return (ssize_t)count;
>  }
> 
> Note - I did not even compile-test this. Would you try that please :-)

Hmm. I'd just as soon drop it entirely. Here's a patch. Herbert, you
want to send this through your crypto tree?


random: drop weird m_time/a_time manipulation

No other driver does anything remotely like this that I know of except
for the tty drivers, and I can't see any reason for random/urandom to do
it. In fact, it's a (trivial, harmless) timing information leak. And
obviously, it generates power- and flash-cycle wasting I/O, especially
if combined with something like hwrngd. Also, it breaks ubifs's
expectations.

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r 29db0c391ce8 drivers/char/random.c
--- a/drivers/char/random.c	Sun Jan 17 11:01:16 2010 -0800
+++ b/drivers/char/random.c	Mon Jan 25 23:32:00 2010 -0600
@@ -1051,12 +1051,6 @@
 				/* like a named pipe */
 	}
 
-	/*
-	 * If we gave the user some bytes, update the access time.
-	 */
-	if (count)
-		file_accessed(file);
-
 	return (count ? count : retval);
 }
 
@@ -1116,8 +1110,6 @@
 	if (ret)
 		return ret;
 
-	inode->i_mtime = current_fs_time(inode->i_sb);
-	mark_inode_dirty(inode);
 	return (ssize_t)count;
 }
 

-- 
http://selenic.com : development and support for Mercurial and Linux


