Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbZKCJrd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbZKCJrd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 04:47:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755558AbZKCJrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 04:47:33 -0500
Received: from mail.gmx.net ([213.165.64.20]:33401 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755435AbZKCJrb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 04:47:31 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/ERhsJwt7EhrX8dmi+hwQGu96UljCvrMzNRgcFKy
	2024OV2jsWTQ+4
Subject: Re: [Bug 12309] Large I/O operations result in slow performance
 and high iowait times
From: Mike Galbraith <efault@gmx.de>
To: Thomas Pilarski <thomas.pi@arcor.de>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1257193609.2378.28.camel@localhost>
References: <20091101134207.b97e4f5f.akpm@linux-foundation.org>
	 <1257177364.10173.23.camel@marge.simson.net>
	 <1257193609.2378.28.camel@localhost>
Content-Type: text/plain
Date: Tue, 03 Nov 2009 10:47:32 +0100
Message-Id: <1257241652.13856.79.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-11-02 at 21:26 +0100, Thomas Pilarski wrote:
> Hi Mike,

Hi,


> Am Montag, den 02.11.2009, 16:56 +0100 schrieb Mike Galbraith: 
> > > --- Comment #412 from Thomas Pilarski <thomas.pi@arcor.de>  2009-11-01 21:28:24 ---
> > > Created an attachment (id=23618)
> > >  --> (http://bugzilla.kernel.org/attachment.cgi?id=23618)
> > > Simple sleeper test case
> > > 
> > > [...]
> > 
> > Can you please try the latest -rc?  I spent the day trying to coax a
> > latency spike out of -tip, including thumping disk with dd, mysql+oltp
> > rw test et al, and failed.
> 
> I have just tries the rc5 and the spikes are still there, but much
> shorter. The test case does not show latencies <15ms. For these tests, I
> have reduced the minimum printout time to 3ms. The notebook with the
> first generation ssd in not available for testing, till next weekend.

Thanks for taking it for a spin.

Latencies < 15ms aren't a problem.  It's the large ones, way past our
latency target I'm concerned about.

> The freezes still exists with the kernel 32, but the freezes are more
> seldom and shorter. But I am not sure, as the X-Server is unusable on my
> machine in vesa mode with the rc5 kernel.

That's block layer work I'm sure.  Jens Axboe's work reduced read vs
write latency by roughly a truckload.  If an important bit of your GUI
has been evicted from ram though, you still have to go get it back, and
any latency above nearly zero is going to be felt in a very big way.

> Here are the results with the rc5 kernel and the fedora kernel
> vmlinuz-2.6.31.5-96.fc12.x86_64. I have changed my system yesterday.
> 
> This test was made during a kernel build.
> 
> Kernel 32:
> Timediff     220114:    3.01ms Total:   9.44ms
> Timediff     222460:    3.58ms Total:  10.82ms
> Timediff     234968:    3.23ms Total:   9.99ms
> Timediff     235916:    3.19ms Total:  11.50ms
> Timediff     236448:    3.55ms Total:  12.71ms
> Timediff     236485:    3.56ms Total:  16.14ms
> Timediff     236793:    3.49ms Total:  10.54ms
> Timediff     237076:    3.58ms Total:  11.29ms
> Timediff     237417:    3.88ms Total:  12.05ms
> Timediff     237694:    4.03ms Total:  15.36ms
> Timediff     238039:    3.55ms Total:  11.64ms
> Timediff     238347:    3.57ms Total:  10.23ms
> Timediff     278945:    4.82ms Total:  11.25ms
> Timediff     306303:    3.14ms Total:  10.22ms
> Timediff     310378:    3.00ms Total:   9.49ms
> Timediff     312685:    3.08ms Total:   9.53ms
> Timediff     323824:    3.93ms Total:  10.37ms
> Timediff     324150:    3.25ms Total:   9.90ms
> 
> With the kernel 31 the latencies are ~3-5ms with about 10 spikes every
> 10 seconds >15ms.

You'll always see spikes, that's the only way sleepers can get their
fair share to be able to perform well.  Important is the magnitude.

> This test was made with eight concurrent writing operations. With kernel
> 32, the system freezes for up to 5 seconds. With the 31 kernel the
> system is unusable and freezes for more than 15 seconds.
> 
> Kernel 32:
> Timediff     562105:   47.17ms Total:  54.12ms
> Timediff     562108:    4.72ms Total:  62.26ms
..

> Timediff     607985:   36.17ms Total:  43.24ms
> Timediff     607988:    6.44ms Total:  51.55ms
> Timediff     607991:    3.96ms Total:  57.71ms

These look a bit too high, depending on the number of runnable tasks at
any instant.  I have a patch pending which will cut these way down if
they're not legitimate.

> Kernel 31:
> Timediff    3064913:  209.00ms Total: 215.89ms
> Timediff    3147899:  195.24ms Total: 202.19ms
> Timediff    3221487:  155.74ms Total: 162.68ms

These OTOH are unacceptable, and have been squashed (knocks wood).

<snip>

> As you can see, the spikes are still there, but much more seldom and
> shorter. Perhaps the opposite way, a delay or something equal in the
> block-layer or scheduler to maximize this problem, can help to locate
> the culprit.

I think your GUI etc stalls are just things being evicted by the vm, at
which time you pay heavily getting it back.  The large wakeup latencies
were indeed scheduler, but not the stalls, that's I/O.

	-Mike

