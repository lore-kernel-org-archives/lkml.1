Return-Path: <linux-kernel-owner+w=401wt.eu-S932346AbYBTVXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932346AbYBTVXl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 16:23:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758707AbYBTVXO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 16:23:14 -0500
Received: from Mycroft.westnet.com ([216.187.52.7]:51981 "EHLO
	Mycroft.westnet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757606AbYBTVXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 16:23:09 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18364.39445.347911.402466@stoffel.org>
Date: Wed, 20 Feb 2008 16:22:29 -0500
From: "John Stoffel" <john@stoffel.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cyclades: Prepare for relaxed locking in callers
In-Reply-To: <20080220201216.40d70747@core>
References: <20080220201216.40d70747@core>
X-Mailer: VM 8.0.x-xemacs-542 under Emacs 22.1.1 (i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan> Basically wrap it in lock_kernel where it is hard to prove the
Alan> locking is ok.

I've got cyclades cards, both ISA and Serial.  Do you want/need any
specific tests?  Or should I just send you (or your deputy) the ISA
card for your collection?

John

Alan> Signed-off-by: Alan Cox <alan@redhat.com>

Alan> diff -u --new-file --recursive --exclude-from /usr/src/exclude linux.vanilla-2.6.25-rc2-mm1/drivers/char/cyclades.c linux-2.6.25-rc2-mm1/drivers/char/cyclades.c
Alan> --- linux.vanilla-2.6.25-rc2-mm1/drivers/char/cyclades.c	2008-02-19 11:01:43.000000000 +0000
Alan> +++ linux-2.6.25-rc2-mm1/drivers/char/cyclades.c	2008-02-20 11:45:28.000000000 +0000
Alan> @@ -3464,6 +3464,8 @@
Alan>  	if (serial_paranoia_check(info, tty->name, __FUNCTION__))
Alan>  		return -ENODEV;
 
Alan> +	lock_kernel();
Alan> +	
Alan>  	card = info->card;
Alan>  	channel = info->line - card->first_line;
Alan>  	if (!IS_CYC_Z(*card)) {
Alan> @@ -3506,10 +3508,12 @@
Alan>  				((lstatus & C_RS_CTS) ? TIOCM_CTS : 0);
Alan>  		} else {
Alan>  			result = 0;
Alan> +			unlock_kernel();
Alan>  			return -ENODEV;
Alan>  		}
 
Alan>  	}
Alan> +	unlock_kernel();
Alan>  	return result;
Alan>  }				/* cy_tiomget */
 
Alan> @@ -3880,6 +3884,7 @@
Alan>  	printk(KERN_DEBUG "cyc:cy_ioctl ttyC%d, cmd = %x arg = %lx\n",
info-> line, cmd, arg);
Alan>  #endif
Alan> +	lock_kernel();
 
Alan>  	switch (cmd) {
Alan>  	case CYGETMON:
Alan> @@ -3988,47 +3993,47 @@
Alan>  		p_cuser = argp;
Alan>  		ret_val = put_user(cnow.cts, &p_cuser->cts);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.dsr, &p_cuser->dsr);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.rng, &p_cuser->rng);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.dcd, &p_cuser->dcd);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.rx, &p_cuser->rx);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.tx, &p_cuser->tx);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.frame, &p_cuser->frame);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.overrun, &p_cuser->overrun);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.parity, &p_cuser->parity);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.brk, &p_cuser->brk);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = put_user(cnow.buf_overrun, &p_cuser->buf_overrun);
Alan>  		if (ret_val)
Alan> -			return ret_val;
Alan> +			break;
Alan>  		ret_val = 0;
Alan>  		break;
Alan>  	default:
Alan>  		ret_val = -ENOIOCTLCMD;
Alan>  	}
Alan> +	unlock_kernel();
 
Alan>  #ifdef CY_DEBUG_OTHER
Alan>  	printk(KERN_DEBUG "cyc:cy_ioctl done\n");
Alan>  #endif
Alan> -
Alan>  	return ret_val;
Alan>  }				/* cy_ioctl */
 
Alan> --
Alan> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
Alan> the body of a message to majordomo@vger.kernel.org
Alan> More majordomo info at  http://vger.kernel.org/majordomo-info.html
Alan> Please read the FAQ at  http://www.tux.org/lkml/


Alan> !DSPAM:47bc8c2521682037060298!
