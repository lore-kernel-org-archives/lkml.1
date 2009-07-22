Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZGVN3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZGVN3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 09:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZGVN3o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 09:29:44 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:34160 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbZGVN3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 09:29:43 -0400
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>, Daniel Ribeiro <drwyrm@gmail.com>
In-Reply-To: <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com>
	 <20090721105924.GK4133@elf.ucw.cz> <20090721113642.GC13286@sirena.org.uk>
	 <5d5443650907210518i6ee4df1evdc04d9ae9453707c@mail.gmail.com>
	 <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com>
	 <20090721124933.GA5668@rakim.wolfsonmicro.main>
	 <20090721160436.GD4352@dtor-d630.eng.vmware.com>
	 <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain>
	 <20090721222547.GA1948@opensource.wolfsonmicro.com>
	 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain>
	 <20090722121800.GD21171@rakim.wolfsonmicro.main>
	 <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 22 Jul 2009 15:30:43 +0200
Message-Id: <1248269443.27058.1449.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 14:58 +0200, Thomas Gleixner wrote:
>  One
> thing which I definitely want to change is the thread_eoi function. We
> probably want to have it customizable for the following reason:
> 
> main interrupt
>      hardirq handler wakes main thread handler
> 
> main thread handler
>     bus magic
>    	subdevice1 "hardirq" handler wakes subdevice1 irq thread
>    	subdevice2 "hardirq" handler wakes subdevice2 irq thread
>     main thread handler waits for subdevice1/2 handlers to complete
> 
> subdevice1 thread handler
>     bus magic
>     ....
>     thread_fn returns
>     signal main thread handler via completion
> 
> subdevice2 thread handler
>     bus magic
>     ....
>     thread_fn returns
>     signal main thread handler via completion
> 
> main thread handler resumes
>     bus magic
>     main thread handler returns from thread_fn
>     unmask main interrupt
> 
> So the thread_eoi function is useful for both the main and the
> subdevice handlers. The main handler probably just issues the unmask
> while the subdevice handlers probably want to call a completion to
> notify the main thread handler that they are done. That would be a
> fairly proper design I think and would encourage driver writers to
> follow the common scheme instead of doing their own black magic.
> 
> Thinking further we should even provide some infrastructure for that
> in the common code which would handle the completion and attach it to
> the interrupts in question, so the driver authors would not have to
> deal with that at all. They just would return from thread_fn and let
> the generic code deal with the notification. The notification has to
> be set up by the interrupt controller code. That way you can use the
> same device driver code w/o knowledge of the interrupt controller
> implementation it is attached to.

Wouldn't it be better if we could express the nesting property from
within genirq, so that we can do things like:

  register_chip_nested(parent_chip, parent_irq, slave_chip);

And let genirq set-up the needed magic to make the nesting work.


Also, how important is it that subhandler1..n run in their own thread?
That is, can't we let them run from the thread that is otherwise waiting
for the completino anyway?


