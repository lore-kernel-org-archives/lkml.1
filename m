Return-Path: <linux-kernel-owner+w=401wt.eu-S1764395AbXJPQlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764395AbXJPQlR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 12:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753227AbXJPQlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 12:41:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:19438 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXJPQlC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 12:41:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=c1wOBUbUGDW6paEd+pI3BP8NLP6R8Ftueo9QYIjCAxqnn4XaRLpvjK6qFT9ieroDLUwaDgiKPRJxWL2zgPnu+Yos/8icUwaA5zpb8uQ3P7TxVv+16WzghD+vWStjdZN6pq+Y7YawNd/7IJsQA6rsj9ZsmQc5br6tFHC1ZqcPwTg=
Date: Tue, 16 Oct 2007 18:40:51 +0200
To: Bryan Wu <cooloney.lkml@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, bryan.wu@analog.com,
       Andrey Panin <pazke@donpac.ru>, Roel Kluin <12o3l@tiscali.nl>,
       linux-input@atrey.karlin.mff.cuni.cz,
       linux-joystick@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Jean Delvare <khali@linux-fr.org>
Subject: Re: [PATCH try #3] Input/Joystick Driver: add support AD7142 joystick driver
Message-ID: <20071016164051.GC2528@Ahmed>
References: <1192459625.6215.17.camel@roc-laptop> <d120d5000710150848t1993b0aavbbc0cd7971e3ef3e@mail.gmail.com> <20071015182743.GA2529@Ahmed> <386072610710152308o3d4a04bfgfcecafc9c345286b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <386072610710152308o3d4a04bfgfcecafc9c345286b@mail.gmail.com>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 16, 2007 at 02:08:04PM +0800, Bryan Wu wrote:
> On 10/16/07, Ahmed S. Darwish <darwish.07@gmail.com> wrote:
> > On Mon, Oct 15, 2007 at 11:48:17AM -0400, Dmitry Torokhov wrote:
> > > Hi Bryan,
> > >
> > > On 10/15/07, Bryan Wu <bryan.wu@analog.com> wrote:
> > > > +
> > > > +static int ad7142_thread(void *nothing)
> > > > +{
> > > > +       do {
> > > > +               wait_for_completion(&ad7142_completion);
> > > > +               ad7142_decode();
> > > > +               enable_irq(CONFIG_BFIN_JOYSTICK_IRQ_PFX);
> > > > +       } while (!kthread_should_stop());
> > > > +
> > >
> > > No, this is not going to work well:
> > > - you at least need to reinitialize the completion before enabling
> > > IRQ, otherwise you will spin in a very tight loop
> > > - if noone would touch the joystick ad7142_clsoe would() block
> > > infinitely because noone would signal the completion and
> > > ad7142_thread() would never stop.
> > >
> > > Completion is just not a good abstraction here... Please use work
> > > abstraction and possibly a separate workqueue.
> > >
> >
> > Bryan, I'm very interested in the technical advantage of using a completion
> > here.
> >
> You are welcome, I'd like to discuss these things here.
> 
> > In my _not-experienced_ opinion, I remember completions was created mainly for
> > "create_task, wait till task got finished, go on" case. Why using it in a
> > different context while workqueues was created for a similar situation to
> > ad7142 one (non-irq context bottom-half) ?
> 
> I like completion because it is simple to use and understand. Your
> understanding is right. But there is no limit for using different
> context with completion. completion is a wrapper of waitqueue+done
> flag. For some drivers, in process context call
> wait_for_completetion(), then schedule out and in irq handler call
> complete(). This is very simple and helpful for driver design (For
> example, you call dma function to transfer data, then you schedule out
> and then DMA IRQ handler will call complete() to wakeup you).
> 

Thank you for such a useful information.

> But in this driver, a) can not call ad7142_decode() in IRQ handler,
> because it will sleep in IRQ context by calling some i2c API, b) in
> original design, creating a new kthread and using some waitqueue API
> is the same way as using workqueue, c) cannot use completion as Dmitry
> said.
> 
> I am going to use workqueue here.
> 
> Any idea?
> 

I have no better thoughts than the ones provided by Dmitry actually.

> Thanks
> -Bryan Wu

Regards :),

-- 
Ahmed S. Darwish
HomePage: http://darwish.07.googlepages.com
Blog: http://darwish-07.blogspot.com
