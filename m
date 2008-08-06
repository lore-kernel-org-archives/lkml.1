Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbYHFQN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbYHFQN3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 12:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754046AbYHFQNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 12:13:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:60958 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859AbYHFQNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 12:13:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Yinghai Lu <yhlu.kernel@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <1217732365-16595-1-git-send-email-yhlu.kernel@gmail.com>
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
	<m163qg62bu.fsf@frodo.ebiederm.org>
	<20080806140943.7d94a713@lxorguk.ukuu.org.uk>
Date: Wed, 06 Aug 2008 09:10:46 -0700
In-Reply-To: <20080806140943.7d94a713@lxorguk.ukuu.org.uk> (Alan Cox's message
	of "Wed, 6 Aug 2008 14:09:43 +0100")
Message-ID: <m1k5eukttl.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Alan Cox <alan@lxorguk.ukuu.org.uk>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0152]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH] serial: Remove NR_IRQS usage
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> writes:

> Works on my test box with a quick test.
>
> 8250: Remove NR_IRQ usage
>
> From: Alan Cox <alan@redhat.com>
>
> Signed-off-by: Alan Cox <alan@redhat.com>

This looks good.

Two final nits.

> -static struct irq_info irq_lists[NR_IRQS];
> +#define NR_IRQ_HASH		32	/* Can be adjusted later */
> +static struct hlist_head irq_lists[NR_IRQ_HASH];
> +static DEFINE_MUTEX(hash_mutex);	/* Used to walk the hash */

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
....
> +	mutex_unlock(&hash_mutex);

Could you move the unlock down to the end of serial_link_irq_chain?
So that it covers serial_do_unlink on the error cleanup path?
> +
>  	spin_lock_irq(&i->lock);
>  
>  	if (i->head) {
> @@ -1567,14 +1599,28 @@ static int serial_link_irq_chain(struct uart_8250_port
> *up)
>  
>  static void serial_unlink_irq_chain(struct uart_8250_port *up)
...
> -	if (list_empty(i->head))
...
> +	
> +	if (list_empty(i->head)) {
>  		free_irq(up->port.irq, i);
> -
> +	}

Adding the braces here just appears to be extra noise.

>  	serial_do_unlink(i, up);
> +	mutex_unlock(&hash_mutex);
>  }

Eric


