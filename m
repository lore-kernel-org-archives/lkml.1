Return-Path: <linux-kernel-owner+w=401wt.eu-S1755739AbZGVOTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739AbZGVOTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbZGVOTn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:19:43 -0400
Received: from www.tglx.de ([62.245.132.106]:57262 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbZGVOTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:19:42 -0400
Date: Wed, 22 Jul 2009 16:18:26 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
In-Reply-To: <1248269443.27058.1449.camel@twins>
Message-ID: <alpine.LFD.2.00.0907221615480.2813@localhost.localdomain>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>  <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk>  <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>  <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
  <20090721124933.GA5668@rakim.wolfsonmicro.main>  <20090721160436.GD4352@dtor-d630.eng.vmware.com>  <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>  <20090721222547.GA1948@opensource.wolfsonmicro.com>  <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
  <20090722121800.GD21171@rakim.wolfsonmicro.main>  <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <1248269443.27058.1449.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Peter Zijlstra wrote:
> On Wed, 2009-07-22 at 14:58 +0200, Thomas Gleixner wrote:
> > Thinking further we should even provide some infrastructure for that
> > in the common code which would handle the completion and attach it to
> > the interrupts in question, so the driver authors would not have to
> > deal with that at all. They just would return from thread_fn and let
> > the generic code deal with the notification. The notification has to
> > be set up by the interrupt controller code. That way you can use the
> > same device driver code w/o knowledge of the interrupt controller
> > implementation it is attached to.
> 
> Wouldn't it be better if we could express the nesting property from
> within genirq, so that we can do things like:
> 
>   register_chip_nested(parent_chip, parent_irq, slave_chip);
> 
> And let genirq set-up the needed magic to make the nesting work.

Good point. 
 
> Also, how important is it that subhandler1..n run in their own thread?
> That is, can't we let them run from the thread that is otherwise waiting
> for the completino anyway?

In those cases I suspect we can do that. I guess there can be async
handling as well: the main handler queries the pending interrupts,
masks them, wakes the handlers and returns. No wait for all threads to
finish necessary before unmasking the main interrupt line.

Thanks,

	tglx

