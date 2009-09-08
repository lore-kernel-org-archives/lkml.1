Return-Path: <linux-kernel-owner+w=401wt.eu-S1751882AbZIHR1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbZIHR1T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 13:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750932AbZIHR1T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 13:27:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:43987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbZIHR1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 13:27:18 -0400
Subject: Re: Stop using tasklets for bottom halves
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Michael Buesch <mb@bu3sch.de>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Matt Smith <Matt.Smith@atheros.com>, Kevin Hayes <kevin@atheros.com>,
       Bob Copeland <me@bobcopeland.com>, Jouni Malinen <j@w1.fi>,
       Ivan Seskar <Seskar@winlab.rutgers.edu>, ic.felix@gmail.com,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20090908100144.6e06872b@nehalam>
References: <43e72e890909071558s637b45c7i10807587dc40e8c4@mail.gmail.com>
	 <20090907171406.6a4b6116@nehalam>
	 <1252376254.21261.2052.camel@gandalf.stny.rr.com>
	 <20090908091143.1e613963@nehalam>
	 <1252428023.15626.30.camel@gandalf.stny.rr.com>
	 <20090908100144.6e06872b@nehalam>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 08 Sep 2009 13:27:18 -0400
Message-Id: <1252430838.5493.5.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added Thomas Gleixner to Cc]

On Tue, 2009-09-08 at 10:01 -0700, Stephen Hemminger wrote:
> On Tue, 08 Sep 2009 12:40:23 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > On Tue, 2009-09-08 at 09:11 -0700, Stephen Hemminger wrote:
> > 
> > > > > Process context is too slow.
> > > > 
> > > > Well, I'm hoping to prove the opposite. I'm working on some stuff that I
> > > > plan to present at Linux Plumbers. I've been too distracted by other
> > > > things, but hopefully I'll have some good numbers to present by then.
> > > > 
> > > 
> > > 
> > > That's great, does it keep the good properties of NAPI (irq disabling
> > > and throttling?)
> > 
> > Not exactly sure what you mean by throttling, but I'm assuming it will.
> > 
> > As for irqs disabling, I'm trying to avoid doing that. Note, the device
> > will have its interrupts disabled, but not all other devices will.
> > 
> > -- Steve
> > 
> > 
> 
> The way NAPI works is that in irq routine, the device disables interrupts
> then schedules processing packets, when processing is done irq's are re-enabled.
> This means that if machine is being flooded, irq's stay off, and the packets
> get discarded (because device hardware ring is full), rather than in software
> (because software receive queue is full).

That sounds exactly like what threaded IRQs will do. When an interrupt
comes in, the device driver will disable the device interrupts, and then
the device irq thread handler is awoken.

The device irq handler will handle all the packets. If new packets come
in, and the hardware ring buffer is full, those packets will be dropped.
When the irq handler thread is done processing all pending packets, it
will re-enable the device's interrupts and go to sleep.

Yeah, looking at the NAPI code, it does seem to follow what threaded
interrupts do.

-- Steve


