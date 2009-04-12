Return-Path: <linux-kernel-owner+w=401wt.eu-S1753445AbZDLR0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445AbZDLR0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Apr 2009 13:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753303AbZDLRZy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Apr 2009 13:25:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60354 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753355AbZDLRZx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Apr 2009 13:25:53 -0400
Date: Sun, 12 Apr 2009 19:25:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: hpa@zytor.com, tglx@linutronix.de, xemul@openvz.org, yhlu.kernel@gmail.com,
       linux-kernel@vger.kernel.org, macro@linux-mips.org, andi@firstfloor.org
Subject: Re: [rfc 1/4] x86: irq.c - tiny cleanup
Message-ID: <20090412172536.GB26459@elte.hu>
References: <20090412164738.967602112@openvz.org> <20090412165058.277579847@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090412165058.277579847@openvz.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cyrill Gorcunov <gorcunov@openvz.org> wrote:

> Impact: cleanup
> 
> 1) guard ack_bad_irq with printk_ratelimit since there is no
>    guarantee we will not be flooded one day
> 2) use pr_emerg helper
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  arch/x86/kernel/irq.c |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> Index: linux-2.6.git/arch/x86/kernel/irq.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/irq.c
> +++ linux-2.6.git/arch/x86/kernel/irq.c
> @@ -24,7 +24,8 @@ void (*generic_interrupt_extension)(void
>   */
>  void ack_bad_irq(unsigned int irq)
>  {
> -	printk(KERN_ERR "unexpected IRQ trap at vector %02x\n", irq);
> +	if (printk_ratelimit())
> +		pr_err("unexpected IRQ trap at vector %02x\n", irq);

Btw, this is not so theoretical - in the past i've had bugs where a 
flood of these messages made the system unusable. (granted, it would 
have been unusable even with rate-limiting - but it's still nice to 
have a throttle in place for something like this.)

	Ingo
