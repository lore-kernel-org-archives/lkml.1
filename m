Return-Path: <linux-kernel-owner+w=401wt.eu-S1751923AbZGVOxK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923AbZGVOxK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 10:53:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751549AbZGVOxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 10:53:09 -0400
Received: from www.tglx.de ([62.245.132.106]:52439 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514AbZGVOxG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 10:53:06 -0400
Date: Wed, 22 Jul 2009 16:52:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
cc: Peter Zijlstra <peterz@infradead.org>,
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
In-Reply-To: <20090722143211.GB29404@rakim.wolfsonmicro.main>
Message-ID: <alpine.LFD.2.00.0907221645240.2813@localhost.localdomain>
References: <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain> <20090721222547.GA1948@opensource.wolfsonmicro.com>
 <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain> <20090722121800.GD21171@rakim.wolfsonmicro.main> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <1248269443.27058.1449.camel@twins> <alpine.LFD.2.00.0907221615480.2813@localhost.localdomain>
 <20090722143211.GB29404@rakim.wolfsonmicro.main>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jul 2009, Mark Brown wrote:

> On Wed, Jul 22, 2009 at 04:18:26PM +0200, Thomas Gleixner wrote:
> > On Wed, 22 Jul 2009, Peter Zijlstra wrote:
> 
> > > Also, how important is it that subhandler1..n run in their own thread?
> > > That is, can't we let them run from the thread that is otherwise waiting
> > > for the completino anyway?
> 
> > In those cases I suspect we can do that. I guess there can be async
> > handling as well: the main handler queries the pending interrupts,
> > masks them, wakes the handlers and returns. No wait for all threads to
> > finish necessary before unmasking the main interrupt line.
> 
> The chips I'm deling with can certainly support doing that but I'm not
> sure there'd be enormous advantages - a lot of the interrupt handlers
> will either be trivial (eg, RTC ticks or alarms) or be serialised by a
> need to interact with the chip anyway.  I'd expect this to be generally
> true, though ICBW.

So in your case it would be possible to run the various subdevice
thread_fn handlers from your main interrupt thread one after each
other ?

Well, that indeed makes it a candidate for a nested structure
handling, where your main thread calls handle_nested_irq(irq) which
simply runs the thread function of that nested interrupt while keeping
the semantics vs. disable/enable ... intact.

Thanks,

	tglx



