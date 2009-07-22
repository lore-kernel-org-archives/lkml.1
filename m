Return-Path: <linux-kernel-owner+w=401wt.eu-S1753949AbZGVRIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbZGVRIe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 13:08:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864AbZGVRId
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 13:08:33 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:25692 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZGVRIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 13:08:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XPW0NoO3qoJTp9+bkfUWkqLojlISFvGG8HS/rAegjPs2Yzz4EUVNHG5sh5eFvszzsl
         SHHUrYFIt7pTetZksi/3khyeRhYlFD4JAOe5Xvb9U49yPmGDhZPGOalK7CzDd7++/AB+
         WmTLBW7x7KEjHryC/LqIfAPS/RH0+7aaZPJ14=
Date: Wed, 22 Jul 2009 10:08:28 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Trilok Soni <soni.trilok@gmail.com>, Pavel Machek <pavel@ucw.cz>,
       Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       Brian Swetland <swetland@google.com>, linux-input@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, linux-i2c@vger.kernel.org,
       Joonyoung Shim <jy0922.shim@samsung.com>, m.szyprowski@samsung.com,
       t.fujak@samsung.com, kyungmin.park@samsung.com,
       David Brownell <david-b@pacbell.net>,
       Peter Zijlstra <peterz@infradead.org>,
       Daniel Ribeiro <drwyrm@gmail.com>
Subject: Re: Threaded interrupts for synaptic touchscreen in HTC dream
Message-ID: <20090722170828.GD2775@dtor-d630.eng.vmware.com>
References: <5d5443650907210530x4aaa03d6gd47ef5f79a3ef8a4@mail.gmail.com> <20090721124933.GA5668@rakim.wolfsonmicro.main> <20090721160436.GD4352@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907212225030.2813@localhost.localdomain> <20090721222547.GA1948@opensource.wolfsonmicro.com> <alpine.LFD.2.00.0907221022190.2813@localhost.localdomain> <20090722121800.GD21171@rakim.wolfsonmicro.main> <alpine.LFD.2.00.0907221427380.2813@localhost.localdomain> <20090722155811.GA2775@dtor-d630.eng.vmware.com> <alpine.LFD.2.00.0907221830410.2813@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0907221830410.2813@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 22, 2009 at 06:40:21PM +0200, Thomas Gleixner wrote:
> On Wed, 22 Jul 2009, Dmitry Torokhov wrote:
> > > I don't think it belongs into the driver code. It belongs into the
> > > platform code which sets up the system and knows what's on which
> > > interrupt line.
> > >  
> > 
> > I do think this should be set up by the driver - the platform/arch code
> > can't be 100% certain what model of servicing interrupts driver will
> > chose, nor the driver can know whether arch code set things up for
> > threaded or classic interrupt handling.
> > 
> > Since handle_level_oneshot_irq requires drivers to use threaded IRQ
> > model (in absence of thread interrupt will never be unmasked) it would
> > be better if we did set it up automatically, right there in
> > request_threaded_irq(). This would reduce maintenance issues between
> > platform and driver code.
> 
> No, it's the wrong way round. 
> 
> The platform code sets up the platform devices. So there is no real
> good reason that the platform code does not know about the details.
> 
> If it conveys the wrong irq number then it wont work, if it sets the
> wrong handler it wont work either. So what ?
> 
> If the driver is implemented to use a threaded handler, which it
> better is no matter what as it uses a bus, and the interrupt
> controller logic is proper implemented as well then the driver does
> not care about those details at all. It will magically work with any
> interrupt controller you put in front of it.
> 
> If the platform maintainer sets the wrong handler or the wrong
> platform data then it's not the driver writers problem.
> 

It is not matter of setting handler or platform data incorrctly. There
can be a perfectly working driver using I2C and non-threaded IRQ and
there can be a similar driver using threaded IRQ. The problem with your
approach that only _one_ can work with given platform setup. If platform
sets the oneshot interrup handler then threaded will work and standard
will break, otherwise standard will work and threaded will break. This
is not the best outcome, don't you agree?

-- 
Dmitry
