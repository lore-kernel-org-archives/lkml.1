Return-Path: <linux-kernel-owner+w=401wt.eu-S1762606AbXESRK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762606AbXESRK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 13:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755016AbXESRKQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 13:10:16 -0400
Received: from mail.gmx.net ([213.165.64.20]:41422 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754078AbXESRKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 13:10:14 -0400
X-Authenticated: #5039886
X-Provags-ID: V01U2FsdGVkX199K0F+4+R9r77wWz7++5tGsNot/cNNu+aRXGF0xY
	HEyPOzz9b94KRA
Date: Sat, 19 May 2007 19:10:11 +0200
From: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>
To: tglx@linutronix.de, mingo@elte.hu, yi.zhu@intel.com,
       linux-kernel@vger.kernel.org, arjan@infradead.org
Subject: Re: Increased ipw2200 power usage with dynticks
Message-ID: <20070519171011.GA1995@atjola.homenet>
Mail-Followup-To: =?iso-8859-1?Q?Bj=F6rn?= Steinbrink <B.Steinbrink@gmx.de>,
	tglx@linutronix.de, mingo@elte.hu, yi.zhu@intel.com,
	linux-kernel@vger.kernel.org, arjan@infradead.org
References: <20070518154629.GA27105@atjola.homenet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070518154629.GA27105@atjola.homenet>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2007.05.18 17:46:29 +0200, Björn Steinbrink wrote:
> Hi,
> 
> while playing around with powertop, I noticed that my power usage wasn't
> what it used to be. In total idle mode, everything was fine, but as soon
> as I loaded the ipw2200 module and bring up the device, power usage
> rises to about 16.8W, while kernel up to 2.6.20 used only about 15.3W. A
> day worth of bisecting later, I could put my finger on dynticks, tested
> 2.6.22-rc1 without dynticks and power usage was at least down to about
> 15.5-15.6W, not perfect, but a lot better.
> 
> It seems that ipw2200 wants to do something about its power usage, but
> dynticks stops it from doing so, as holding down the "Fn" key, and
> thereby generating about 60 additional wakeups per second, brings the
> power usage down to about the same as in the non-dynticks case.
> 
> Powertop also revealed, that with dynticks, my CPU is spending 99% in C2
> when the power usage is high, but about 50% in C3 when I hold down "Fn".
> 
> Let me know if you need further details.

Ok, it seems that ipw2200 is just a trigger for the problem here. AFAICT
the cause of the worse C state usage is that after ipw2200 has woken the
cpu, acpi_processor_idle() chooses C2 (due to dma? bm? I have no
idea...) as the prefered sleep state. Now without NO_HZ or when I hold
down a key, there are interrupts that wake up the CPU and when
acpi_processor_idle() is called again the promotion to C3/C4 happens.
But with NO_HZ, there are no such interrupts, most wakeups are caused by
ipw2200 and so the processor doesn't go any deeper than C2 most of the
time and thus wastes lots of power.

Björn
