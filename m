Return-Path: <linux-kernel-owner+w=401wt.eu-S1752528AbYGXHMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbYGXHMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750856AbYGXHL5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:11:57 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:24938 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbYGXHL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:11:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent:from;
        b=CJwiibLPmswa1z948Ks2ogBzHxzB/5hcfuQFsAI1L+SuWX0oCY76G2nfmuyRbw/Wj9
         nVf0NZTnBC8kO3iD3MB0qBbkk+0rhzK50J71f393W/JY2c0/nvlsQI8hWVwEI3tuziiU
         l05J7C3Gp9hcyOSa+MgI5k5deM/Y83kWZq0mQ=
Date: Thu, 24 Jul 2008 09:12:10 +0200
To: Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [lockdep warning] INFO: inconsistent lock state,
	serial8250_interrupt(), &port_lock_key
Message-ID: <20080724071210.GA2738@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Ingo Molnar <mingo@elte.hu>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
	Peter Zijlstra <a.p.zijlstra@chello.nl>
References: <20080723093332.GA22109@elte.hu> <20080723093604.GA29817@elte.hu> <20080724065329.GE17724@gollum.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080724065329.GE17724@gollum.tnic>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 24, 2008 at 08:53:29AM +0200, Borislav Petkov wrote:
> On Wed, Jul 23, 2008 at 11:36:04AM +0200, Ingo Molnar wrote:
> > 
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > =================================
> > > [ INFO: inconsistent lock state ]
> > > 2.6.26-tip-06509-gb4ebc67-dirty #13600
> > > ---------------------------------
> > 
> > the upstream component of that is: v2.6.26-6077-gc010b2f
> > 
> > i.e. my suspicion is that this got introduced via the recent tty 
> > changes.
> 
> Hi,
> 
> i hit the same warning here. How about the following fix (this is at least what
> i think happens):
> --
> 
> serial8250_startup() might unconditionally enable irqs after releasing
> &up->port.lock while we're still servicing an interrupt.

Actually, this explanation is not correct - it should be more like:

serial8250_startup() doesn't disable interrupts while taking the &up->port.lock
which might race against the interrupt handler serial8250_interrupt(), which
when entered, will deadlock waiting for the lock to be released.

> 
> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
> 
> --
> diff --git a/drivers/serial/8250.c b/drivers/serial/8250.c
> index 27f34a9..55eca08 100644
> --- a/drivers/serial/8250.c
> +++ b/drivers/serial/8250.c
> @@ -1874,7 +1874,7 @@ static int serial8250_startup(struct uart_port *port)
>  		 * the interrupt is enabled.  Delays are necessary to
>  		 * allow register changes to become visible.
>  		 */
> -		spin_lock(&up->port.lock);
> +		spin_lock_irqsave(&up->port.lock, flags);
>  		if (up->port.flags & UPF_SHARE_IRQ)
>  			disable_irq_nosync(up->port.irq);
>  
> @@ -1890,7 +1890,7 @@ static int serial8250_startup(struct uart_port *port)
>  
>  		if (up->port.flags & UPF_SHARE_IRQ)
>  			enable_irq(up->port.irq);
> -		spin_unlock(&up->port.lock);
> +		spin_unlock_irqrestore(&up->port.lock, flags);
>  
>  		/*
>  		 * If the interrupt is not reasserted, setup a timer to
> 
> -- 
> Regards/Gruﬂ,
>     Boris.

-- 
Regards/Gruﬂ,
    Boris.
