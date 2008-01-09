Return-Path: <linux-kernel-owner+w=401wt.eu-S1753839AbYAIPbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839AbYAIPbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 10:31:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751944AbYAIPbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 10:31:08 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:41373 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYAIPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 10:31:06 -0500
Message-ID: <4784E7E1.4060308@keyaccess.nl>
Date: Wed, 09 Jan 2008 16:27:29 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Christer Weinigel <christer@weinigel.se>
CC: Zachary Amsden <zach@vmware.com>, "David P. Reed" <dpreed@reed.com>,
       Avi Kivity <avi@quramnet.com>, Ondrej Zary <linux@rainbow-software.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Bodo Eggert <7eggert@gmx.de>,
       Ingo Molnar <mingo@elte.hu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Paul Rolland <rol@as2917.net>, Pavel Machek <pavel@ucw.cz>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, rol <rol@witbe.net>
Subject: Re: [linux-kernel] Re: [PATCH] x86: provide a DMI based port 0x80
 I/O delay override.
References: <9BdU5-1YW-9@gated-at.bofh.it>	<200801081810.58904.linux@rainbow-software.org>	<4783B1B2.6070005@reed.com>	<200801081838.16241.linux@rainbow-software.org>	<4783C4A6.9060402@reed.com>	<20080108185120.3ff7ed18@lxorguk.ukuu.org.uk>	<4783CBD9.7020709@reed.com>	<1199847162.7369.323.camel@bodhitayantram.eng.vmware.com> <20080109063052.48a5709c@weinigel.se>
In-Reply-To: <20080109063052.48a5709c@weinigel.se>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09-01-08 06:30, Christer Weinigel wrote:

> On Tue, 08 Jan 2008 18:52:42 -0800
> Zachary Amsden <zach@vmware.com> wrote:

>> What is the outcome of this thread?  Are we going to use timing based
>> port delays, or can we finally drop these things entirely on 64-bit
>> architectures?
>>
>> I a have a doubly vested interest in this, both as the owner of an
>> affected HP dv9210us laptop and as a maintainer of paravirt code - and
>> would like 64-bit Linux code to stop using I/O to port 0x80 in both
>> cases (as I suspect would every other person involved with
>> virtualization).
>>
>> I've tried to follow this thread, but with all the jabs, 1-ups, and
>> obscure legacy hardware pageantry going on, it isn't clear what we're
>> really doing.
> 
> I belive Alan Cox is doing a review of some drivers, to see if they
> actually need the I/O port delay.  A lot of drivers probably use outb_p
> just because it was copy-pasted from some other driver and it can be
> removed.  Alan's review has also brought to light a lack of locking in
> some drivers, so I think Alan has been adding proper locking to some of
> the watchdog drivers.

Yes, Alan should be considered to be in the driver seat here (and current 
x86.git changes should be tossed).

> Most old ISA only device drivers can keep using OUT 80h.  They are not
> used on modern machines and it's better to keep them unchanged to avoid
> unneccesary incompatibilities.
> 
> As far as I know, the 8253 PIT timer code needs outb_p on some older
> platform, and this is one of the most troublesome since the same PIT
> controller (or a register compatible one) has been used since the
> original IBM PC, and it is frequently executed code.  Ingo Molnar has
> done an alternate implementation of the PIT clock source which uses
> udelay instead of OUT 80h to delay accesses to the ports. The kernel
> could make a choice of which variant to use based on the DMI year, if
> compiling for x86_64, or something similar.  Maybe have a command line
> option too.

Just udelay() should be fine after "fixing" udelay() to be somewhat usefully 
defined pre-calibration.

> The keyboard controller on some platform needs the delay, and the same
> driver is used on both ancient and modern systems, I think it can be
> changed to udelay since it's not so time critical code.
> 
> The 8259 interrupt controller on some platform needs the delay, I think
> it can be changed to udelay since it's only some setup code that uses
> outb_p.  I guess there are time critical accesses to the interrupt
> controller from assembly code somewhere to acknowledge interrupts, and
> that code needs a review.

I'd not expect very time crtical. The current outb_p use gives a delay 
somewhere between .5 and 2 microseconds as per earlier survey meaning a 
udelay(1) or 2 would be enough -- again, at the point that udelay() is sensible.

New machines don't use the legacy PIC anymore anyway.

> The floppy controller code uses outb_p.  Even though there might be
> floppy controllers on modern systems, I'd rather leave the floppy code
> alone since it's supposed to be very fragile.  If you still use
> floppies you deserve what you get.

Floppies forever. In practice, leaving it alone isn't going to matter, but 
in that same practice changing it to udelay() probably doesn't either. The 
ones to leave alone are the ones that are clumsy/impossible to test and the 
ones such as in NIC drivers that were specifically tuned.

> Some specific drivers, such as drivers for 8390 or 8390 clone based
> network cards are also a bit troublesome, they do need outb_p (and
> the delay for the original 8390 chip is specified in bus cycles), and
> there can be a big performance loss if pessimistic udelays are used for
> the delay.  There are still a bunch of PCMCIA cards based on that chip
> which means that those cards can be used with modern machines.  There
> are also PCI and memory mapped variants of the 8390, some of them new
> designs which are only register compatible, some other designs are
> using a real 8390 with a FPGA used as glue logic. I think Alan
> suggested compiling two versions of that driver, one with OUT 80h, and
> one with udelay.  Old machines can choose the old driver, and new
> machines can use the new one.  Other drivers can probably do the same
> thing, or if not time critical, always use a pessimistic udelay.

Not sure what the final suggestion for those was either....

> As for the implementation, I like the suggestion to split outb_b into
> two calls, one to outb and one to isa_slow_down_io.  It makes it very
> obvious that it is really two function calls, and that it needs
> locking.  For those uses that are not ISA port accesses,
> isa_slow_down_io should be changed to an appropriate udelay instead.

... or simply deleted. The current outb_p is "outb; slow_down_io" as a macro 
so that with this you also get no binary changes, making it rather easy to 
prove that things do not change timing in cases where you keep the delay.

(they're not so much function calls though -- they're inlined).

> The goal is anyway that a modern machine should not do OUT 80h, and old
> machines keep doing it since it has been working well for some 15-odd
> years, both in DOS device drivers and on Linux.  Using an alternate
> port may be a workaround, but it's probaby not a good idea since
> alternate ports have received less testing and there's bound to be some
> platform out there that has problems with any alternate port we
> might choose.

Based on specific DMI strings this can be limited to tested machines (as in 
current x86.git) but yes, that's not particularly pleasing.

> Allowing an alternate port will also add code bloat (OUT 80h, AL becomes
> MOV DX, alternate_port; OUT DX, AL) for a dubious gain.


... destroying DX while it's at it meaning this might (will) also need DX 
reloads. Not an argument versus a function call, but an argument versus the 
current and proposed manual "outb; slow_down_io" split.

> Did I miss anyting?

Not so much it seems. Only that the only reason for the outb_p slit is an 
API one. Molnar wants the API cleaned up to make sure no new users of outb_p 
creep in, and being explkicit abhout what it that you're doing is going to 
take care of that.

If simple outb_p() deprecation is considered enough instead, no need to 
touch anything in drivers/, only changes to "outb(); udelay()" outside drivers/.

I'd let Alan decide here.

Thanks for the roundup.

Rene.
