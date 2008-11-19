Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbYKSJac@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbYKSJac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 04:30:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752531AbYKSJaS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 04:30:18 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:49443 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbYKSJaQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 04:30:16 -0500
Date: Wed, 19 Nov 2008 10:30:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jarek Poplawski <jarkao2@gmail.com>
Cc: David Miller <davem@davemloft.net>, Jeff Garzik <jeff@garzik.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Ferenc Wagner <wferi@niif.hu>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netconsole: Disable softirqs in write_msg()
Message-ID: <20081119093004.GD22309@elte.hu>
References: <87y6zwwy5c.fsf@tac.ki.iif.hu> <20081119084106.GA6699@ff.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081119084106.GA6699@ff.dom.local>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jarek Poplawski <jarkao2@gmail.com> wrote:

> This report: http://marc.info/?l=linux-netdev&m=122599341430090&w=2
> shows local_bh_enable() is used in the wrong context (irqs disabled).
> It happens when a usual network path is called by netconsole, which
> simply turns off hardirqs around this all.
> 
> This patch additionally disables softirqs to avoid possibility of
> enabling bh and calling do_softirq() with hardirqs disabled.
> 
> Reported-by: Ferenc Wagner <wferi@niif.hu>
> Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
> ---
> 
>  drivers/net/netconsole.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/netconsole.c b/drivers/net/netconsole.c
> index d304d38..f6ecad8 100644
> --- a/drivers/net/netconsole.c
> +++ b/drivers/net/netconsole.c
> @@ -702,6 +702,8 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
>  	if (list_empty(&target_list))
>  		return;
>  
> +	/* Avoid enabling softirqs with hardirqs disabled */
> +	local_bh_disable();
>  	spin_lock_irqsave(&target_list_lock, flags);
>  	list_for_each_entry(nt, &target_list, list) {
>  		netconsole_target_get(nt);
> @@ -723,6 +725,7 @@ static void write_msg(struct console *con, const char *msg, unsigned int len)
>  		netconsole_target_put(nt);
>  	}
>  	spin_unlock_irqrestore(&target_list_lock, flags);
> +	local_bh_enable();

but netconsole can be triggered from printk - and printk can be called 
from hardirqs-off sections - so this doesnt really fix the bug. 
Netconsole should not do BH processing.

	Ingo
