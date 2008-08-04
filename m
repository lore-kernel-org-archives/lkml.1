Return-Path: <linux-kernel-owner+w=401wt.eu-S1760715AbYHDSxr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715AbYHDSxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 14:53:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759936AbYHDSxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 14:53:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:40294 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754830AbYHDSxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:53:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-9-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-10-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-11-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-12-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-13-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-14-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-15-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-16-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-17-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-18-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-19-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-20-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-21-git-send-email-yhlu.kernel@gmail.com>
	<1217732365-16595-22-git-send-email-yhlu.kernel@gmail.com>
	<20080803161447.791705bb@lxorguk.ukuu.org.uk>
	<m1hca150t8.fsf@frodo.ebiederm.org>
	<20080804151734.0d82fbe9@lxorguk.ukuu.org.uk>
Date: Mon, 04 Aug 2008 11:51:33 -0700
In-Reply-To: <20080804151734.0d82fbe9@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Mon, 4 Aug 2008 15:17:34 +0100")
Message-ID: <m163qg62bu.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.7 BAYES_20 BODY: Bayesian spam probability is 5 to 20%
	*      [score: 0.0511]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 21/25] serial: change remove NR_IRQS in 8250.c v2
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

>> Looks like we can also tweak serial_do_unlink to free irq_info when
>> the list goes empty, so we don't have a leak if the driver is ever
>> unloaded.
>
> Like this (again not yet tested) 
>
> 8250: Remove NR_IRQ usage
>
> From: Alan Cox <alan@redhat.com>

I think we've just about got it.

>  /*
>   * Here we define the default xmit fifo size used for each type of UART.
> @@ -1541,9 +1545,32 @@ static void serial_do_unlink(struct irq_info *i, struct
> uart_8250_port *up)
>  
>  static int serial_link_irq_chain(struct uart_8250_port *up)
>  {
> -	struct irq_info *i = irq_lists + up->port.irq;
> +	struct hlist_head *h;
> +	struct hlist_node *n;
> +	struct irq_info *i;
>  	int ret, irq_flags = up->port.flags & UPF_SHARE_IRQ ? IRQF_SHARED : 0;
>  
> +	mutex_lock(&hash_mutex);
> +
> +	h = &irq_lists[up->port.irq % NR_IRQ_HASH];
> +	
> +	hlist_for_each(n, h) {
> +		i = hlist_entry(n, struct irq_info, node);
> +		if (i->irq == up->port.irq)
> +			break;
> +	}
> +
> +	if (n == NULL) {
> +		i = kzalloc(sizeof(struct irq_info), GFP_KERNEL);
> +		if (i == NULL) {
> +			mutex_unlock(&hash_mutex);
> +			return -ENOMEM;
> +		}
> +		spin_lock_init(&i->lock);
> +		hlist_add_head(&i->node, h);
> +	}
> +	mutex_unlock(&hash_mutex);
> +
>  	spin_lock_irq(&i->lock);
>  
>  	if (i->head) {

Note there is also an error path that calls serial_do_unlink in serial_link_irq_chain.
That we might want to free the entry in.  Do we want move hash table entry freeing
into serial_do_unlink or duplicate it here?

Eric
