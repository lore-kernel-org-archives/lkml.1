Return-Path: <linux-kernel-owner+w=401wt.eu-S1752138AbZGWEn3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752138AbZGWEn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 00:43:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbZGWEn2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 00:43:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.226]:41356 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbZGWEn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 00:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VKYSh/S9sT4SMLaDHPAqsEw6bDeE4DcKDGx+q4XwytgGRjbd9+CgdaHQ3Nrhf36IVJ
         6BZfDA6SfJouGsVKUke+T8G+cofMzLAXdaGsFqprRCuww3mZGd8SXcdBLsuiOv76KD3A
         RirgpvBJ97/ZfYoeWzM05zjNgzbdqCYBNYKfU=
Date: Wed, 22 Jul 2009 21:43:22 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090723044321.GA2782@dtor-d630.eng.vmware.com>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <1248269443.27058.1449.camel@twins> <200907220957.16499.david-b@pacbell.net> <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907222226270.2813@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 11:04:33PM +0200, Thomas Gleixner wrote:
> 
> Any more ?
> 

Can we also have something like below by any chance?

-- 
Dmitry

genirq: provide dummy hard irq handler for threaded interrupts

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Quite often drivers using threaded interrupts don't do anything
in the hard IRQ portion of their interrupt handler; everything
is offloaded to the threaded half. Instead of having every driver
implement a stub have one ready in the IRQ core.

Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
---

 kernel/irq/manage.c |   22 ++++++++++++++++++----
 1 files changed, 18 insertions(+), 4 deletions(-)


diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 50da676..cdc52f6 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -695,6 +695,15 @@ out_thread:
 	return ret;
 }
 
+/*
+ * Default hardirq handler for threaded irqs that is used when
+ * driver did not provide its own implementation.
+ */
+static irqreturn_t dummy_hardirq_handler(int irq, void *dev_id)
+{
+	return IRQ_WAKE_THREAD;
+}
+
 /**
  *	setup_irq - setup an interrupt
  *	@irq: Interrupt line to setup
@@ -837,8 +846,11 @@ EXPORT_SYMBOL(free_irq);
  *	request_threaded_irq - allocate an interrupt line
  *	@irq: Interrupt line to allocate
  *	@handler: Function to be called when the IRQ occurs.
- *		  Primary handler for threaded interrupts
- *	@thread_fn: Function called from the irq handler thread
+ *		  Primary handler for threaded interrupts.
+ *		  May be NULL, in which case a dummy interrupt
+ *		  handler is used that simply returns
+ *		  IRQ_WAKE_THREAD
+ *	@thread_fn: Function called from the irq handler thread.
  *		    If NULL, no irq thread is created
  *	@irqflags: Interrupt type flags
  *	@devname: An ascii name for the claiming device
@@ -917,14 +929,16 @@ int request_threaded_irq(unsigned int irq, irq_handler_t handler,
 
 	if (desc->status & IRQ_NOREQUEST)
 		return -EINVAL;
-	if (!handler)
+
+	if (!handler && !thread_fn) {
 		return -EINVAL;
+	}
 
 	action = kzalloc(sizeof(struct irqaction), GFP_KERNEL);
 	if (!action)
 		return -ENOMEM;
 
-	action->handler = handler;
+	action->handler = handler ?: dummy_hardirq_handler;
 	action->thread_fn = thread_fn;
 	action->flags = irqflags;
 	action->name = devname;
