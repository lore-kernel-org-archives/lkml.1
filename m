Return-Path: <linux-kernel-owner+w=401wt.eu-S1754935AbZHGGYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935AbZHGGYE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 02:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752786AbZHGGYD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 02:24:03 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:49666 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbZHGGYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 02:24:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ninh6Sdxs6m8L08iOheT6bQ7vVLO2AkSn1XOuKlrgsWowfh7wwS9LnfiZzaAyOrxeH
         h23wf5WvkB/QoOm7XoiGudozzFSA+jSOq7WoJk04uwMJKUzp8Xsk3joDl9aVQg1wI4E+
         YE+dXj5MN5rfPE0kgcoREQhDGiSdBfoKAH5UI=
Date: Fri, 7 Aug 2009 08:23:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       Andi Kleen <andi@firstfloor.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tty: handle VT specific compat ioctls in vt driver
Message-ID: <20090807062356.GA4955@nowhere>
References: <1249564170-18627-1-git-send-email-arnd@arndb.de> <1249564170-18627-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249564170-18627-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Aug 06, 2009 at 03:09:28PM +0200, Arnd Bergmann wrote:
> The VT specific compat_ioctl handlers are the only ones
> in common code that require the BKL. Moving them into
> the vt driver lets us remove the BKL from the other handlers
> and cleans up the code.


Why does it require the bkl?


> +
> +long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
> +	     unsigned int cmd, unsigned long arg)
> +{
> +	struct vc_data *vc = tty->driver_data;
> +	struct console_font_op op;	/* used in multiple places here */
> +	struct kbd_struct *kbd;
> +	unsigned int console;
> +	void __user *up = (void __user *)arg;
> +	int perm;
> +	int ret = 0;
> +
> +	console = vc->vc_num;
> +
> +	lock_kernel();



It would be really nice to add a comment here that explain what it
is protecting.
I would like to work on removing the bkl from tty, and such nude lock_kernel()
don't help much to work in this area.
This is more than ever a FUD lock, nothing about its role in tty in the Lockronomicon,
and even not in the comments :-)

Thanks!
Frederic.


> +
> +	if (!vc_cons_allocated(console)) { 	/* impossible? */
> +		ret = -ENOIOCTLCMD;
> +		goto out;
> +	}
> +
> +	/*
> +	 * To have permissions to do most of the vt ioctls, we either have
> +	 * to be the owner of the tty, or have CAP_SYS_TTY_CONFIG.
> +	 */
> +	perm = 0;
> +	if (current->signal->tty == tty || capable(CAP_SYS_TTY_CONFIG))
> +		perm = 1;
> +
> +	kbd = kbd_table + console;
> +	switch (cmd) {
> +	/*
> +	 * these need special handlers for incompatible data structures
> +	 */
> +	case PIO_FONTX:
> +	case GIO_FONTX:
> +		ret = compat_fontx_ioctl(cmd, up, perm, &op);
> +		break;
> +
> +	case KDFONTOP:
> +		ret = compat_kdfontop_ioctl(up, perm, &op, vc);
> +		break;
> +
> +	case PIO_UNIMAP:
> +	case GIO_UNIMAP:
> +		ret = do_unimap_ioctl(cmd, up, perm, vc);
> +		break;
> +
> +	/*
> +	 * all these treat 'arg' as an integer
> +	 */
> +	case KIOCSOUND:
> +	case KDMKTONE:
> +#ifdef CONFIG_X86
> +	case KDADDIO:
> +	case KDDELIO:
> +#endif
> +	case KDSETMODE:
> +	case KDMAPDISP:
> +	case KDUNMAPDISP:
> +	case KDSKBMODE:
> +	case KDSKBMETA:
> +	case KDSKBLED:
> +	case KDSETLED:
> +	case KDSIGACCEPT:
> +	case VT_ACTIVATE:
> +	case VT_WAITACTIVE:
> +	case VT_RELDISP:
> +	case VT_DISALLOCATE:
> +	case VT_RESIZE:
> +	case VT_RESIZEX:
> +		goto fallback;
> +
> +	/*
> +	 * the rest has a compatible data structure behind arg,
> +	 * but we have to convert it to a proper 64 bit pointer.
> +	 */
> +	default:
> +		arg = (unsigned long)compat_ptr(arg);
> +		goto fallback;
> +	}
> +out:
> +	unlock_kernel();
> +	return ret;
> +
> +fallback:
> +	unlock_kernel();
> +	return vt_ioctl(tty, file, cmd, arg);
> +}
> +
> +
> +#endif /* CONFIG_COMPAT */
> +
> +
>  /*
>   * Sometimes we want to wait until a particular VT has been activated. We
>   * do it in a very simple manner. Everybody waits on a single queue and
> diff --git a/include/linux/tty.h b/include/linux/tty.h
> index e8c6c91..38f3786 100644
> --- a/include/linux/tty.h
> +++ b/include/linux/tty.h
> @@ -526,5 +526,8 @@ extern void console_print(const char *);
>  extern int vt_ioctl(struct tty_struct *tty, struct file *file,
>  		    unsigned int cmd, unsigned long arg);
>  
> +extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
> +		     unsigned int cmd, unsigned long arg);
> +
>  #endif /* __KERNEL__ */
>  #endif
> -- 
> 1.6.3.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

