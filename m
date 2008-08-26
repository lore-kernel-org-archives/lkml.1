Return-Path: <linux-kernel-owner+w=401wt.eu-S1759317AbYHZT1s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759317AbYHZT1s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 15:27:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYHZT1i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 15:27:38 -0400
Received: from mout1.freenet.de ([195.4.92.91]:41972 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754012AbYHZT1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 15:27:37 -0400
Date: Tue, 26 Aug 2008 21:27:34 +0200
From: Gerhard Brauer <gerhard.brauer@web.de>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826192734.GC5300@tux1.brauer.lan>
References: <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826145338.GA8601@Krystal>
User-Agent: Mutt/1.5.18-muttng (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2008 at 10:53:38AM -0400, Mathieu Desnoyers wrote:
> * Gerhard Brauer (gerhard.brauer@web.de) wrote:
> > 
> > Here is also an archive with guest dmesg and messages.log from such an
> > oops when heavy disk io leads to the oops:
> > http://bugs.archlinux.org/task/11141?getfile=2445
> > 
> 
> Hrm, can you try this ?

Sorry for the delay but i need to build a complete distribution kernel
and my machine is not the fastest.

My host:
archlinux 2.6.26 P4 2Ghz
VirtualBox: Sun xVM 1.6.4
gcc 4.4.1-3

My guest:
archlinux 2.6.26

My "tests":
I could sometimes boot the guest with the "tricks" (VT-x enabled, acpi
off,...). But i always get an oops if i compile something bigger on this
guest (ex. virtualbox-modules where the tarball must be untarrt with
bsdtar -> disk io)
If this happens the next reboot leads always to the early oops (Freeing
smp....). Each reboot do this. Then i close virtualbox application,
unload/reload vboxdrv from host and start vbox again. Then i could
mostimes boot the guest again. But next heavy disk IO leads again to the
oops.
If i could boot without oops, and reboot or halt the guest, then the
next boots are clean.


> 1 - Make sure you kernel is not CONFIG_DEBUG_RODATA
Not set.

> 2 - Change the whole text_poke implementation in
> arch/x86/kernel/alternative.c to this :
With this changes i also get the oops, in all above mentioned tests.

> Then, after having tested (2), try this on top of it :
> 
> In arch/x86/kernel/alternative.c, alternatives_smp_switch()
> 
> Add   unsigned long flags;
> Change 
> spin_lock -> spin_lock_irqsave(&smp_alt, flags);
> spin_unlock(&smp_alt); -> spin_unlock_irqrestore(&smp_alt, flags);

With our distribution kernel i could change these spin_lock/unlock in
alternatives.c. Fist thought was that there was a slightly better
behavior (first boot goes on, i could compile something, but next
package i build thee opps (heavy io opps) comes again. And then also
after reboot the early oops (freeing smp...)
Here is a screenie from oops when building something:
http://users.archlinux.de/~gerbra/tmp/2008-08-26-210724_724x456_scrot.png

Sometimes (could not be reproduced) the virtualbox app also traps with
an error dialog (Guru message), which offers a log from the VM and a
scren shot. Maybe this could be helpfull. Log and screenie could be
found here:
http://users.archlinux.de/~gerbra/tmp/vbox-guru/

> 
> This will help testing if there is a problem with interrupts coming
> shortly after the modification. If it fixes the problem, my guess is
> that we should flush the instruction cache (and maybe the data cache ?)
> in text_poke and text_poke early when interrupts are off.

>From my side i would say: both changes would not solve the oops.

> Mathieu

Regards
	Gerhard

