Return-Path: <linux-kernel-owner+w=401wt.eu-S1754979AbYGLQ3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979AbYGLQ3d (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 12:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751731AbYGLQ3Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 12:29:24 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:37983 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370AbYGLQ3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 12:29:23 -0400
Date: Sat, 12 Jul 2008 10:29:21 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       kernel-janitors <kernel-janitors@vger.kernel.org>,
       kernelnewbies <kernelnewbies@nl.linux.org>, linux-scsi@vger.kernel.org,
       hch@infradead.org
Subject: Re: [PATCH] advansys: use request_firmware
Message-ID: <20080712162921.GZ14894@parisc-linux.org>
References: <1215770322.2733.12.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1215770322.2733.12.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 03:28:42PM +0530, Jaswinder Singh wrote:
> ???this is a first draft; please be kind :)

Hi Jaswinder, I wondered when you were going to get around to advansys
;-)  My concern is:

> -/* Microcode buffer is kept after initialization for error recovery. */
[...]
> +	err = request_firmware(&fw, fwname, asc_dvc->drv_ptr->dev);
> +	if (err) {
> +		printk(KERN_ERR "Failed to load image \"%s\" err %d\n",
> +		       fwname, err);
> +		return err;
> +	}
> +	if (fw->size < 4) {
> +		printk(KERN_ERR "Bogus length %d in image \"%s\"\n",
> +		       fw->size, fwname);
> +		release_firmware(fw);
> +		return -EINVAL;
> +	}
> +	chksum = (fw->data[3] << 24) | (fw->data[2] << 16) |
> +		 (fw->data[1] << 8) | fw->data[0];
> +	ASC_DBG(1, "_asc_mcode_chksum 0x%lx\n", (ulong)chksum);
> +	if (AscLoadMicroCode(iop_base, 0, &fw->data[4],
> +			     fw->size - 4) != chksum) {
>  		asc_dvc->err_code |= ASC_IERR_MCODE_CHKSUM;
>  		return warn_code;
>  	}
> +	release_firmware(fw);

You're calling release_firmware() here.  I don't know if that actually
frees the firmware when it's built-in, but if it does, then freeing the
firmware could cause the chip to stop working if it gets reset before
userspace is up.

If it is OK to call release_firmware here, then the error path is
missing a release_firmware() call.

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
