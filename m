Return-Path: <linux-kernel-owner+w=401wt.eu-S932611AbXBNW2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611AbXBNW2b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:28:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932618AbXBNW2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:28:31 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:58704 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932611AbXBNW23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:28:29 -0500
Date: Wed, 14 Feb 2007 22:28:24 +0000
From: Christoph Hellwig <hch@infradead.org>
To: Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, openib-general@openib.org, hch@infradead.org,
       raisch@de.ibm.com, h.carstens@de.ibm.com
Subject: Re: [PATCH 2.6.21-rc1 4/5] ehca: replace yield() by wait_for_completion()
Message-ID: <20070214222824.GA11579@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	Hoang-Nam Nguyen <hnguyen@linux.vnet.ibm.com>,
	Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
	linuxppc-dev@ozlabs.org, openib-general@openib.org,
	raisch@de.ibm.com, h.carstens@de.ibm.com
References: <200702141741.35444.hnguyen@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200702141741.35444.hnguyen@linux.vnet.ibm.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> @@ -332,7 +333,7 @@ int ehca_destroy_cq(struct ib_cq *cq)
>         spin_lock_irqsave(&ehca_cq_idr_lock, flags);
>         while (my_cq->nr_callbacks) {
>                 spin_unlock_irqrestore(&ehca_cq_idr_lock, flags);
> -               yield();
> +               wait_for_completion(&my_cq->zero_callbacks);
>                 spin_lock_irqsave(&ehca_cq_idr_lock, flags);
>         }

A while loop around wait_for_completion doesn't make all that much sense.
I suspect a simple

	if (my_cq->nr_callbacks)
		wait_for_completion(&my_cq->zero_callbacks);

Is what you need.

