Return-Path: <linux-kernel-owner+w=401wt.eu-S933779AbXJRJCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933779AbXJRJCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 05:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932896AbXJRJCH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 05:02:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:35036 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932697AbXJRJCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 05:02:04 -0400
Message-ID: <471720FE.4090004@garzik.org>
Date: Thu, 18 Oct 2007 05:01:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [bug] ata subsystem related crash with latest -git
References: <20071017172932.GI15552@kernel.dk> <20071017173408.GA1960@elte.hu> <20071017174503.GA4622@elte.hu> <20071017175337.GN15552@kernel.dk> <20071017183716.GU15552@kernel.dk> <20071017190901.GA13780@elte.hu> <alpine.LFD.0.999.0710171217160.26902@woody.linux-foundation.org> <20071017193542.GA15552@kernel.dk> <20071018070706.GA7435@elte.hu> <471717BF.4030108@pobox.com> <20071018083213.GN5063@kernel.dk>
In-Reply-To: <20071018083213.GN5063@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> index 4df8311..b858183 100644
> --- a/drivers/ata/sata_mv.c
> +++ b/drivers/ata/sata_mv.c
> @@ -1139,6 +1139,7 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>  	struct mv_port_priv *pp = qc->ap->private_data;
>  	struct scatterlist *sg;
>  	struct mv_sg *mv_sg;
> +	int end_marked = 0;
>  
>  	mv_sg = pp->sg_tbl;
>  	ata_for_each_sg(sg, qc) {
> @@ -1159,13 +1160,15 @@ static void mv_fill_sg(struct ata_queued_cmd *qc)
>  			sg_len -= len;
>  			addr += len;
>  
> -			if (!sg_len && ata_sg_is_last(sg, qc))
> +			if (!sg_len && ata_sg_is_last(sg, qc)) {
>  				mv_sg->flags_size |= cpu_to_le32(EPRD_FLAG_END_OF_TBL);
> +				end_marked++;
> +			}
>  
>  			mv_sg++;
>  		}
> -
>  	}
> +	BUG_ON(end_marked != 1);


Your BUG_ON() does indeed trip, here.

Its surprising that other folks don't explode, considering that 
mv_fill_sg() intentionally mirrors the logic in ata_fill_sg().

	Jeff


