Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591AbZAIVdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591AbZAIVdc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 16:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757061AbZAIVcs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 16:32:48 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:55259 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753966AbZAIVcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 16:32:46 -0500
Date: Fri, 9 Jan 2009 21:32:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: torvalds@linux-foundation.org, tj@kernel.org
Subject: Re: libata: use WARN_ON_ONCE on hot paths
Message-ID: <20090109213216.19889bdb@lxorguk.ukuu.org.uk>
In-Reply-To: <200901092100.n09L0S96016532@hera.kernel.org>
References: <200901092100.n09L0S96016532@hera.kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 21:00:28 GMT
Linux Kernel Mailing List <linux-kernel@vger.kernel.org> wrote:

Most of these look ok but several should never have been WARN in the
first place:

@@ -4556,7 +4556,7 @@ void ata_sg_clean(struct ata_queued_cmd
*qc)
>  	struct scatterlist *sg = qc->sg;
>  	int dir = qc->dma_dir;
>  
> -	WARN_ON(sg == NULL);
> +	WARN_ON_ONCE(sg == NULL);

If that ever occurs we are in deep deep doodo - this should be a BUG() so
we stop the box before we do serious damage.


> @@ -651,7 +651,7 @@ void ata_sff_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
>  			iowrite8(tf->ctl, ioaddr->ctl_addr);
>  			ap->last_ctl = tf->ctl;
>  		} else
> -			WARN_ON(1);
> +			WARN_ON_ONCE(1);

This one should always have been a BUG(). At the point we hit this (which
we never have yet) the returned data for the command executed is *lost*
and we return garbage. It's a case that will only trigger due to a clear
internal bug (where we want the driver author to catch it promptly) or
memory corruption. It's not something that will pop up from a quirky bit
of timing.

> @@ -891,7 +891,7 @@ static void ata_pio_sectors(struct ata_queued_cmd *qc)
>  		/* READ/WRITE MULTIPLE */
>  		unsigned int nsect;
>  
> -		WARN_ON(qc->dev->multi_count == 0);
> +		WARN_ON_ONCE(qc->dev->multi_count == 0);

Ditto should be a BUG().

> -	WARN_ON(qc->dev->cdb_len < 12);
> +	WARN_ON_ONCE(qc->dev->cdb_len < 12);

If this ever occurs we are writing garbage to the ATAPI device and
continuing is a very bad idea. It could remain a warn but the command
issue should be aborted

(Should be a WARN/return)
	if (qc->dev->cdb_len < 12) {
		WARN_ON_ONCE(...)
		return;

