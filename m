Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab0CBEP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 23:15:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:39312 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790Ab0CBEPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 23:15:55 -0500
Subject: Re: USB mass storage and ARM cache coherency
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>,
       Oliver Neukum <oliver@neukum.org>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "Mankad, Maulik Ojas" <x0082077@ti.com>,
       Sergei Shtylyov <sshtylyov@ru.mvista.com>,
       Ming Lei <tom.leiming@gmail.com>,
       Sebastian Siewior <bigeasy@linutronix.de>, linux-usb@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
       Pavel Machek <pavel@ucw.cz>, Greg KH <greg@kroah.com>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
In-Reply-To: <1267441814.23333.65.camel@e102109-lin.cambridge.arm.com>
References: <1266979632.23523.1668.camel@pasglop>
	 <1267201521.14703.50.camel@e102109-lin.cambridge.arm.com>
	 <1267220429.23523.1811.camel@pasglop>
	 <20100226214908.GD23933@n2100.arm.linux.org.uk>
	 <1267316647.23523.1852.camel@pasglop>
	 <1267441814.23333.65.camel@e102109-lin.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 02 Mar 2010 15:11:01 +1100
Message-ID: <1267503061.2173.4.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-01 at 11:10 +0000, Catalin Marinas wrote:
> 
> 
> Yes. That could be solved at set_pte_at() level using IPIs.

Well, set_pte_at() itself is called with the PTE lock held, so you have
to be careful with IPIs at that point. You need the flush to happen
-before- the PTE is visible and you cannot synchronously send an IPI.

> > For that case, I see two options. One is a big hammer but would make
> > existing code work to "most" extent: Don't allow a page to be both
> > writable and executable. Ping-pong the page permission lazily and
> flush
> > when transitioning from write to exec.
> 
> Are you referring to the SMP and non-broadcasting cache maintenance
> issue? The same pte could be shared between multiple CPUs, so once you
> make it executable on one it becomes executable on the others.

Right, you would have to play the ping-pong trick globally. That's what
I do on ppc 440 for bluegene though that code isn't upstream.

Cheers,
Ben.


