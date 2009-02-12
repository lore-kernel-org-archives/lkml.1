Return-Path: <linux-kernel-owner+w=401wt.eu-S1761567AbZBLX2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761567AbZBLX2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 18:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750764AbZBLX2F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 18:28:05 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:43201 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbZBLX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 18:28:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=AFu1es8XzCbubB0H3dd6I8gAbkYmpNvyTdHjtBJHjf5OTwfcgiCwlBQppYSJ+LhVis
         Q1dQUzIRCIfmzt9kl8tmgAxfPNTdDuYquUcQjhcnVKelk+UGT0IMn+Sdn9nD28OzROEV
         gO0T7G5fXXdiPRYQsO+tYyE6vql0H0XtWeFVc=
Date: Fri, 13 Feb 2009 00:27:58 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] rt/threadirqs: don't need to save irqs in
	do_hardirq()
Message-ID: <20090212232758.GA5865@nowhere>
References: <4994ae18.1358560a.454d.403b@mx.google.com> <20090212232459.GD5348@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090212232459.GD5348@ghostprotocols.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 12, 2009 at 09:24:59PM -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 12, 2009 at 07:27:08PM +0100, Frederic Weisbecker escreveu:
> > do_hardirq() has only one caller do_irqd() in a path where irq are already
> > disabled. So we don't need to save irqs while holding desc->lock
> > 
> > Replace spin_lock_irqsave by spin_lock.
> > 
> > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > ---
> >  kernel/irq/manage.c |    4 ++--
> >  1 files changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
> > index ed7c5e3..6e9baf8 100644
> > --- a/kernel/irq/manage.c
> > +++ b/kernel/irq/manage.c
> > @@ -905,7 +905,7 @@ static void do_hardirq(struct irq_desc *desc)
> >  {
> >  	unsigned long flags;
> 
> Can flags be removed too?


Actually... I cheated.
Once the two patches were done, I saw the unused variable warning. So I remade the second patch
to remove flags but..yes it should be on the first patch, I must confess...
   
> > -	spin_lock_irqsave(&desc->lock, flags);
> > +	spin_lock(&desc->lock);
> >  
> >  	if (!(desc->status & IRQ_INPROGRESS))
> >  		goto out;
> > @@ -921,7 +921,7 @@ static void do_hardirq(struct irq_desc *desc)
> >  	else
> >  		thread_do_irq(desc);
> >   out:
> > -	spin_unlock_irqrestore(&desc->lock, flags);
> > +	spin_unlock(&desc->lock);
> >  
> >  	if (waitqueue_active(&desc->wait_for_handler))
> >  		wake_up(&desc->wait_for_handler);

