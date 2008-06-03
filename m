Return-Path: <linux-kernel-owner+w=401wt.eu-S1754203AbYFCKID@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203AbYFCKID (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 06:08:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751542AbYFCKHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 06:07:53 -0400
Received: from mail.hevs.ch ([153.109.23.10]:60266 "EHLO mail.hevs.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbYFCKHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 06:07:52 -0400
From: Marc Pignat <marc.pignat@hevs.ch>
Organization: HEVs
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH 3/3] mmc: change .get_ro() callback semantics
Date: Tue, 3 Jun 2008 12:07:49 +0200
User-Agent: KMail/1.9.9
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>,
       Jochen Friedrich <jochen@scram.de>, Timur Tabi <timur@freescale.com>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       spi-devel-general@lists.sourceforge.net
References: <20080523154204.GA19803@polina.dev.rtsoft.ru> <20080523154347.GC24862@polina.dev.rtsoft.ru>
In-Reply-To: <20080523154347.GC24862@polina.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806031207.49843.marc.pignat@hevs.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all!

On Friday 23 May 2008, Anton Vorontsov wrote:
> get_ro() callback must return values >= 0 for its logical state, and
...
>  static void pxamci_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
> diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
> index f2e9885..ef3b773 100644
> --- a/include/linux/mmc/host.h
> +++ b/include/linux/mmc/host.h
> @@ -55,6 +55,9 @@ struct mmc_host_ops {
>  	 * Avoid calling these three functions too often or in a "fast path",
>  	 * since underlaying controller might implement them in an expensive
>  	 * and/or slow way.
> +	 *
> +	 * .get_ro and .get_cd should return >= 0 for their logical values,
> +	 * or negative errno value in case of error.
>  	 */

I would suggest to use something more strict (bulletproof), something like:

/*
 * get_ro will return:
 *   0 for a read/write card
 *   1 for a read-only card 
 *   -ENOSYS when not supported
 *   or a negative errno when something bad happened
 * 
 * get_cd will return:
 *   0 for a absent card
 *   1 for a present card 
 *   -ENOSYS when not supported
 *   or a negative errno when something bad happened
 */

I think we have missed one important information: which context these callbacks
can rely on (hard_irq, soft_irq, ...).



Best regards

Marc

