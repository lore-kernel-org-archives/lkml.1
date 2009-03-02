Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbZCBV2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbZCBV2e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755841AbZCBV2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:28:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49742 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755543AbZCBV2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:28:12 -0500
Date: Mon, 2 Mar 2009 13:27:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cedric Roux <sed@free.fr>
Cc: linux-kernel@vger.kernel.org, mtk.manpages@gmail.com,
       linux-api@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH 1/1] vt: add ioctl commands to /dev/vcsaX to get/put the
 current palette of the given tty
Message-Id: <20090302132741.26eaf124.akpm@linux-foundation.org>
In-Reply-To: <17015927.368551235932826484.JavaMail.root@spooler2-g27.priv.proxad.net>
References: <17015927.368551235932826484.JavaMail.root@spooler2-g27.priv.proxad.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 1 Mar 2009 19:40:26 +0100 (CET)
Cedric Roux <sed@free.fr> wrote:

> From: Cedric Roux <sed@free.fr>
> 
> Adding a ioctl interface and two ioctl commands to /dev/vcsaX
> to get/put the current palette of the given tty.
> 

Please also cc linux-api on API-affecting changes.

> ---
> This patch exists because there is no way to get the current
> installed palette of a given tty. The PIO_CMAP and GIO_CMAP
> in vt_ioctl.c:vt_ioctl play with the global default colormap.
> And /dev/vcsaX don't dump the palette through their read
> interface. And since a user may change colors of a given
> tty by escape sequences, one should be able to retrieve
> the palette through /dev/vcsaX, leading to this patch.
> 
> Some points I am not fully confident with:
> - I am not sure about the return values in case of error.

Me either.

> - vt.c:set_colormap is now used in vc_screen.c so cannot be static
>   anymore.
>   The goal of this patch is to allow read access to the palette,
>   I can remove the PIO_CMAP case and make set_colormap static again.
>   This case is there because /dev/vcsaX is read/write so the access
>   to the palette should also be read/write. (Or I can do it
>   differently, no problem, just tell me how.)
> 
> (In case of formatting problem of this mail, I apologize.
> I have a very bad mail access... Just tell me and I'll
> do my best to resend something clean.)
> 
> diff -uprN -X linux-2.6.28/Documentation/dontdiff linux-2.6.28-vanilla/drivers/char/vc_screen.c linux-2.6.28/drivers/char/vc_screen.c
> --- linux-2.6.28-vanilla/drivers/char/vc_screen.c	2008-12-24 23:26:37.000000000 +0000
> +++ linux-2.6.28/drivers/char/vc_screen.c	2009-03-01 17:42:59.000000000 +0000
> @@ -19,6 +19,8 @@
>   * machek@k332.feld.cvut.cz - modified not to send characters to wrong console
>   *	 - fixed some fatal off-by-one bugs (0-- no longer == -1 -> looping and looping and looping...)
>   *	 - making it shorter - scr_readw are macros which expand in PRETTY long code
> + *
> + * Colormap put/get for /dev/vcsaX, Cedric Roux <sed@free.fr>, March 2009.
>   */
>  
>  #include <linux/kernel.h>
> @@ -470,11 +472,64 @@ vcs_open(struct inode *inode, struct fil
>  	return ret;
>  }
>  
> +static int
> +vcs_ioctl(struct inode *inode, struct file *file, unsigned int cmd,
> +	  unsigned long arg)
> +{
> +	unsigned int currcons = iminor(inode);
> +	struct vc_data *vc;
> +	unsigned char pal[16*3];
> +	int ret = 0;
> +
> +	/* access only defined for /dev/vcsaX, not /dev/vcsX */
> +	if (currcons < 128)
> +		return -ENOIOCTLCMD;

What's going on with vfs_ioctl():

	if (filp->f_op->unlocked_ioctl) {
		error = filp->f_op->unlocked_ioctl(filp, cmd, arg);
		if (error == -ENOIOCTLCMD)
			error = -EINVAL;
		goto out;
	} else if (filp->f_op->ioctl) {
		lock_kernel();
		error = filp->f_op->ioctl(filp->f_path.dentry->d_inode,
					  filp, cmd, arg);
		unlock_kernel();
	}

So if ->unlocked_ioctl exists we'll convert ENOIOCTLCMD into EINVAL. 
Isn't that supposed to be ENOTTY?  The comment thinks so:

 * Invokes filesystem specific ->unlocked_ioctl, if one exists; otherwise
 * invokes filesystem specific ->ioctl method.  If neither method exists,
 * returns -ENOTTY.


If ->unlocked_ioctl doesn't exist, we'll return ENOIOCTLCMD back to
userspace, I think.  That would be wrong.


> +	acquire_console_sem();
> +
> +	currcons &= 127;
> +	if (currcons == 0)
> +		currcons = fg_console;
> +	else
> +		currcons--;
> +	if (!vc_cons_allocated(currcons)) {
> +		ret = -ENXIO;
> +		goto unlock_out;
> +	}
> +	vc = vc_cons[currcons].d;
> +
> +	switch (cmd) {
> +	case PIO_CMAP:
> +		if (copy_from_user(pal, (void __user *)arg, 16*3)) {
> +			ret = -EFAULT;
> +			goto unlock_out;
> +		}
> +		memcpy(vc->vc_palette, pal, 16*3);
> +		set_palette(vc);
> +		break;
> +	case GIO_CMAP:
> +		if (copy_to_user((void __user *)arg, vc->vc_palette, 16*3)) {
> +			ret = -EFAULT;
> +			goto unlock_out;
> +		}
> +		break;
> +	default:
> +		ret = -ENOIOCTLCMD;
> +		break;
> +	}
> +
> +unlock_out:
> +	release_console_sem();
> +
> +	return ret;
> +}
> +
>  static const struct file_operations vcs_fops = {
>  	.llseek		= vcs_lseek,
>  	.read		= vcs_read,
>  	.write		= vcs_write,
>  	.open		= vcs_open,
> +	.ioctl		= vcs_ioctl,
>  };

.ioctl is old and deprecated.  Please use .unlocked_ioctl


