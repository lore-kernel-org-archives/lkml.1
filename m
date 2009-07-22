Return-Path: <linux-kernel-owner+w=401wt.eu-S1753889AbZGVQv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbZGVQv5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 12:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZGVQv4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 12:51:56 -0400
Received: from smtp109.sbc.mail.gq1.yahoo.com ([67.195.14.39]:32983 "HELO
	smtp109.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753863AbZGVQvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 12:51:55 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1PA6RCjDBA5jQAzT2kn2n/Sfztl1/x5ih7+KDS1My1P9U4Lms8GjEIjM1EsKXy73B/fZhx2cSVXgf6XJa3SxVkMsj/qrnXkjKJe9EkC9ajBJMM6P+B4hKJYyxnwzd8lT5qqT7mHDCpQ1rtu1T6vJvboLXJLjPOgLl4hULMuHauI=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: s4fzSs4VM1krDSauBv2ppPsjrXJUfZPi.i0Nko0hri9dUtYfr3GJRiKjS59x0B8m9UaAKbhBes2Z3e3pfuwHHMej8NWShaRZAfXGYvuKH_glb09_.32J.51elNGiwVdj0I2iy4KZ02AK9D5AVHbz3h4nYsNdIHV92GW7UURhqJ7wX05AyVNsDs4GbjYjJAERSMH7y6oQ_h2JFqencO99je1b0qVVIu5OhLs1BIvEvl714pn2Wrx_a2S22nbjil_k3Unm3SXGk7cvSEta
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Date: Wed, 22 Jul 2009 09:51:53 -0700
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       "Arve Hj?nnev?g" <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
References: <5d5443650907151033w36008b71pe4b32bcea9489b75@mail.gmail.com> <20090722121800.GD21171@rakim.wolfsonmicro.main> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200907220951.54419.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 July 2009, Thomas Gleixner wrote:
> main interrupt
>      hardirq handler wakes main thread handler
> 
> main thread handler
>     bus magic
>         subdevice1 "hardirq" handler wakes subdevice1 irq thread
>         subdevice2 "hardirq" handler wakes subdevice2 irq thread

Why force this wasteful/undesired "all subdevices must
have their own IRQ handling thread" policy?

As previously noted, a single thread typically suffices.
There's no need to waste a dozen (or so) pages of memory
for such purposes ... these events are (as noted most
recently by Mark) infrequent/rare and performance isn't
a functionality gatekeeper.  Plus ...


>     main thread handler waits for subdevice1/2 handlers to complete

... sharing that thread can eliminate that synchronization
problem, and simplify the whole process.


> subdevice1 thread handler
>     bus magic
>     ....
>     thread_fn returns
>     signal main thread handler via completion
> 
> subdevice2 thread handler
>     bus magic
>     ....
>     thread_fn returns
>     signal main thread handler via completion
> 
> main thread handler resumes
>     bus magic
>     main thread handler returns from thread_fn
>     unmask main interrupt


