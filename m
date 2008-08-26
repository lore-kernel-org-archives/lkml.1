Return-Path: <linux-kernel-owner+w=401wt.eu-S1758682AbYHZOxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758682AbYHZOxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 10:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754317AbYHZOxl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 10:53:41 -0400
Received: from tomts43.bellnexxia.net ([209.226.175.110]:50915 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753915AbYHZOxk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 10:53:40 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAHaxs0hMRKxB/2dsb2JhbACBZbZ3gWs
Date: Tue, 26 Aug 2008 10:53:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Gerhard Brauer <gerhard.brauer@web.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826145338.GA8601@Krystal>
References: <48AE5FCF.6030103@zytor.com> <20080822065012.GV14110@elte.hu> <20080822113941.147a1db0@doriath.conectiva> <20080822153451.GA8390@Krystal> <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826141851.GA5300@tux1.brauer.lan>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 10:44:00 up 82 days, 19:24,  5 users,  load average: 0.75, 0.55,
	0.43
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Gerhard Brauer (gerhard.brauer@web.de) wrote:
> On Fri, Aug 22, 2008 at 02:08:13PM -0700, H. Peter Anvin wrote:
> > Luiz Fernando N. Capitulino wrote:
> >>
> >>  I have asked Mandriva and Ubuntu users to test this and all of
> >> them so far are saying that noreplace-paravirt works.
> >>
> >>  It makes the system slower, but it works.
> >>
> >
> > Yes, the big issue is exactly what VirtualBox screws up in this matter,  
> > how to detect it, and how to work around it.
> >
> > It's pretty clear it's a VirtualBox f*ckup at this point, but the failure 
> > mechanism isn't at all obvious and so far the workaround is elusive.
> >
> > I'm strongly suspect this is a VirtualBox tcache management failure, but  
> > that doesn't help the situation without knowing how it happens.
> 
> On Archlinux we have the same problem. We have a bugreport here:
> http://bugs.archlinux.org/task/11141
> 
> Myself test it with a LiveCD/Install-ISO which has 2.6.26 as install
> kernel. We have the guest oops on virtualbox-ose, virtualbox-sun and both on
> i686 or x86_64 hosts.
> 
> Some things i noticed:
> - The system boots always when i either enable VT-x in guest settings or
>   disable acpi and run the guest with acpi=off.
> - The oops occurs always on (disk)-io, no matter which file system i
>   use.
> - When the oops has occured and the guest has to close and restart then,
>   if i don't use VT-x or acpi=off, i always get an oops directly when
>   initrd/kernel is starting. Last screen message before the oops then is
>   "Freeing SMP alternatives".
> 
> Here is also an archive with guest dmesg and messages.log from such an
> oops when heavy disk io leads to the oops:
> http://bugs.archlinux.org/task/11141?getfile=2445
> 

Hrm, can you try this ?

1 - Make sure you kernel is not CONFIG_DEBUG_RODATA

2 - Change the whole text_poke implementation in
arch/x86/kernel/alternative.c to this :

void *__kprobes text_poke(void *addr, const void *opcode, size_t len)
{
  return text_poke_early(addr, opcode, len);
}

If this works, I suspect that the problem comes from a vmap/vunmap
problem. If it still fails, the problem would likely come from a race
with interrupt disabling probably due to missing data/instruction cache
flush.

Then, after having tested (2), try this on top of it :

In arch/x86/kernel/alternative.c, alternatives_smp_switch()

Add   unsigned long flags;
Change 
spin_lock -> spin_lock_irqsave(&smp_alt, flags);
spin_unlock(&smp_alt); -> spin_unlock_irqrestore(&smp_alt, flags);

This will help testing if there is a problem with interrupts coming
shortly after the modification. If it fixes the problem, my guess is
that we should flush the instruction cache (and maybe the data cache ?)
in text_poke and text_poke early when interrupts are off.

Mathieu


> 
> > 	-hpa
> 
> Gerhard
> 
> -- 
> Standards sind eine tolle Sache.
> Ich finde, jeder sollte einen haben.

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
