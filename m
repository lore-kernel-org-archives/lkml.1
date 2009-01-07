Return-Path: <linux-kernel-owner+w=401wt.eu-S1757596AbZAGBxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757596AbZAGBxF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 20:53:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753525AbZAGBws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 20:52:48 -0500
Received: from outbound.icp-qv1-irony-out1.iinet.net.au ([203.59.1.108]:52145
	"EHLO outbound.icp-qv1-irony-out1.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753019AbZAGBwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 20:52:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiYBAJKZY0l8qMTI/2dsb2JhbAAIz02ENYFA
X-IronPort-AV: E=Sophos;i="4.37,222,1231081200"; 
   d="scan'208";a="437773486"
Subject: Re: [RFC 2.6.27 1/1] gpiolib: add support for batch set of pins
From: Ben Nizette <bn@niasdigital.com>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: Jaya Kumar <jayakumar.lkml@gmail.com>,
       David Brownell <david-b@pacbell.net>, Eric Miao <eric.y.miao@gmail.com>,
       Sam Ravnborg <sam@ravnborg.org>, Eric Miao <eric.miao@marvell.com>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Philipp Zabel <philipp.zabel@gmail.com>,
       Russell King <rmk@arm.linux.org.uk>, Ben Gardner <bgardner@wabtec.com>,
       Greg KH <greg@kroah.com>, linux-arm-kernel@lists.arm.linux.org.uk,
       linux-fbdev-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org
In-Reply-To: <200901061802.39072.rgetz@blackfin.uclinux.org>
References: <12276535632759-git-send-email-jayakumar.lkml@gmail.com>
	 <200812281346.56703.rgetz@blackfin.uclinux.org>
	 <1230501634.16910.57.camel@linux-51e8.site>
	 <200901061802.39072.rgetz@blackfin.uclinux.org>
Content-Type: text/plain
Date: Wed, 07 Jan 2009 12:52:52 +1100
Message-Id: <1231293172.16910.273.camel@linux-51e8.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 18:02 -0500, Robin Getz wrote:
> On Sun 28 Dec 2008 17:00, Ben Nizette pondered:
> > On Sun, 2008-12-28 at 13:46 -0500, Robin Getz wrote:
> > > > gpio_set_batch(DB0, value, 0xFFFF, 16)
> > > > 
> > > > which has the nice performance benefit of skipping all the bit
> > > > counting in the most common use case scenario.
> > > 
> > > but has the requirement that the driver know exactly the board level 
> > > impmentation details (something that doesn't sound generic).
> > 
> > The original use case for these batch operations was in a fastpath -
> > setting data lines on a framebuffer.  Sure it's arguably not as generic
> > as may be, but it optimises for speed and current usage patterns - I'm
> > OK with that.  Other usage patterns which don't have a speed requirement
> > can be done using the individual pin operations and a loop.
> 
> The tradeoff for speed is always made with extensibility. If you want best
> speed - you shouldn't be using the GPIO framework at all - just bang directly
> on the registers yourself...
> 
> If you want something extensible/generic that serves multiple use cases - 
> it will normally come with a performance tradeoff...

Yeah there's certainly a sliding scale here.  At the speedy end you've
got register banging, $SUBJECT is one level higher, your concepts are
higher again.

If your concept can perform at a speed which solves the problem which
inspired $SUBJECT then IMO it's a better way to go.  The thing which
worries me is that if we did end up sliding right up the Generic end of
the Generic-Performance slider then we'd end up with a sexy interface
which isn't actually usable for the case which inspired this activity in
the first place!

And yes the speed is primarily the concern of the implementation and
your comments really concern the interface.  On paper the 2 are largely
orthogonal but until I see an alternate/competing patch I'm not prepared
to bet it'll all play nice.

> 
> > > > While we are here, I was thinking about it, and its better if I give
> > > > gpio_request/free/direction_batch a miss for now. Nothing prevents
> > > > those features being added at a later point.
> > > 
> > > I don't think that request/free are optional.
> > > 
> > > For example - in most SoC implementations - gpios are implemented as
> > > banks of 16 or 32. (a 16 or 32 bit register).
> > > 
> > > Are there facilities to span these registers? 
> > >  - can you request 64 gpios as a 'bank'?
> > >  - can you request gpio_8 -> gpio_40 as a 'bank' on a 32-bit system?
> > > 
> > > Are non-adjacent/non-contiguous gpios avaliable to be put into 
> > > a 'bank/batch/bus'? can you use gpio_8 -> 11 &  28 -> 31 as a 8-bit
> > > 'bus'? 
> > > 
> > > How do you know what is avaliable to be talked to as a bank/bus/batch
> > > without the request/free operation?
> > 
> > I think the read/write operations should be able to fail if you give
> > them invalid chunks of gpio, sure. 
> 
> Can you define "invalid"? what are the limitations?
> 
> Can I use gpio_8 -> 11 &  28 -> 31 as a chunk?

With the $SUBJECT patch, I understand you can (they both fit in a u32
bitmask).  The limitations aren't really the point though - no matter
what the final interface/implementation there will be some limitations.
Either there must be a bulk request interface which will fail if you try
and break the limitations or else the read/write will fail under these
circumstances.

A limitation which springs to mind for any implementation would be if
you specify that the chunk must be accessible in irq context but you
specify some gpios which must sleep.  Yes this is a silly case and
totally the platform's responsibility but the fact is that if someone
makes this mistake an error should be returned *somewhere* rather than
just letting things explode.

In my own personal library of standalone code I've got a GPIO driver
which uses request() to build a cookie representing the gpios to be
driven; read/write then use this cookie.  If the requested pins can't be
batched then it's the request which fails.  I liked this approach.  For
$SUBJECT's purposes though I think it's more symmetric with the single
bit operations to keep request as a refcount and have read/write able to
fail.  Not too fussed though.

> 
> > Request/free are not really designed 
> > for that operation - they just ensure exclusive access to a gpio if
> > that's what the driver wants.  In the batch case the
> > request/free/direction operations can once again be performed by single
> > pin operations and iteration.
> 
> That depends on the semantics of "request". 
> 
> If it is "request & build up a monolithic chunk from xxx GPIO's" - then
> my definition works.

Indeed, see above.

> 
>  
> > > I have seen various hardware designs (both at the PCB and SoC level)
> > > require all of these options, and would like to see common infrastructure
> > > which handles this.
> >
> > Yeah the request/free operation doesn't deal with muxing or any other
> > platform-specific kinda gumph, that was an original design decision.
> > They're really just a usage counter.
> 
> Sorry for bringing up the muxing - that wasn't the point.
> 
> It was really the issue of being non-contiguous, spanning various implementations.
> 
> > An example which comes to mind is the avr32-specific userspace gpio
> > interface.  This takes a bitmask, loops over the set bits and fails if
> > any of the gpio are previously requested or have been assigned to
> > non-gpio peripherals. 
> 
> I'll have a look. I don't understand why everyone decided to make their own
> userspace GPIO interface - can't we all just get along? :)

Yeah for sure.  Of course since .27 there's been a nice consistant
userspace gpio interface (/sys/class/gpio) so theoretically all the
others are deprecated.  I know that at least on avrfreaks, the main
avr32 support forum, users have to have a good reason to be using the
avr32-specific interface if they expect to be helped.

> 
> > I don't really see a need to streamline this. 
> 
> 
> 
> > > I would think that a 'bank' / 'bus' (whatever) would be a collection
> > > of random/multiple GPIOs (a struct of gpio_port_t) rather than a
> > > start/length (as you described) - or better yet - the request 
> > > function takes a list (of individual GPIO's - defined in the 
> > > platform data), and creates the struct itself.
> > 
> > Hmm, this seems a little overengineered for the basic use-cases I can
> > think of. 
> 
> Not the ones I run into all the time...
> 
> More complex pin multiplexing results in less contiguous free GPIO.
> (which again - has nothing to do with multiplexing - it is the result
> that is the important thing).

Which is why we're having this bit of a discussion!  Jaya was the first
person to have this problem and has a patch which, in his case, solves
it.  If you have other concrete cases which need to be solved at the
same time then now's the time to come forward and share with the class.

OK so I've got a board which collects the status of a number of gpio all
over a bunch of chips at a few 10s of Hz, encodes it and fires it across
a network.  This works with single gpio ops but would be streamlined
with batch access.  If the final solution to this problem can be used
for my pins then great, I'll move to it.  However, if supporting my
use-case breaks Jaya's then it's not worth it.

> 
> > If this can be cranked up to the same speed as the current 
> > proposition then OK maybe someone will like it but otherwise, once
> > again, I think most people will be happy with individual operations and
> > iteration.
> 
> It will be easier to maintain (from a end user perceptive - if someone 
> wants a "chunk" of gpio's - they just define it in their platform data). 
> It does put a bigger burden on the person writing things.
> 
> I would think that the overhead would only be at init - runtime shouldn't
> be much different in the simple case, but allowing the complex usecases
> with the same interface is better (since we only have to teach people one
> thing) :)

Yeah I'll say again that if we can find an interface as generic as you
suggest and an implementation which performs as well as Jaya needs then
hells yeah, let's go for it.  If however a sexy interface means Jaya's
original use case breaks then I for one won't support that interface.

	--Ben.

> 
> -Robin

