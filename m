Return-Path: <linux-kernel-owner+w=401wt.eu-S1756579AbYH0Xdj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579AbYH0Xdj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:33:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753929AbYH0Xdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:33:31 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:55411 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753857AbYH0Xda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:33:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIEACB8tUhMRKxB/2dsb2JhbACBZbgxgWg
Date: Wed, 27 Aug 2008 19:33:28 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Gerhard Brauer <gerhard.brauer@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080827233328.GC25531@Krystal>
References: <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva> <20080826181558.GA16887@Krystal> <20080826203449.GD5300@tux1.brauer.lan> <20080827161346.35b48d75@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080827161346.35b48d75@doriath.conectiva>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 19:31:34 up 84 days,  4:11,  5 users,  load average: 0.20, 0.48,
	0.41
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> Em Tue, 26 Aug 2008 22:34:49 +0200
> Gerhard Brauer <gerhard.brauer@web.de> escreveu:
> 
> | On Tue, Aug 26, 2008 at 02:15:58PM -0400, Mathieu Desnoyers wrote:
> | > 
> | > Ok, it might still be caused by paravirt and alternatives instruction
> | > patching. What if you also do :
> | > 
> | > alternative_instructions()
> | > 
> | > +        unsigned long flags;
> | >         /* The patching is not fully atomic, so try to avoid local interruptions
> | >            that might execute the to be patched code.
> | >            Other CPUs are not running. */
> | >         stop_nmi();
> | > #ifdef CONFIG_X86_MCE
> | >         stop_mce();
> | > #endif
> | > +        local_irq_save(flags);
> | > 
> | > 
> | > ...
> | > +        local_irq_restore(flags);
> | >         restart_nmi();
> | > #ifdef CONFIG_X86_MCE
> | >         restart_mce();
> | > #endif
> | > 
> | > ?
> | 
> | Hej! This last changes (in addition to the others you mentioned) seems
> | to be a good shot. I could reboot 8 times the guest, compile several
> | packages (something which always leeds to the oops) and currently i
> | build two big packages simultan. So this is heavy IO.
> 
>  Yeah, it works for me too and it's good to know that you are doing
> additional tests. I'm doing only boot tests... I was testing lots of
> kernels and doing additional tests would take a lot of time.
> 
>  Now, what does this mean? Is VirtualBox issuing interrupts when it
> shouldn't or should this section of the code be better protected?
> 

Since this problem appears while we are using a simple memcpy (the
text_poke_early version), but disappears when we disable interrupts for
a longer period of this, I suspect a problem with irq disabling in
Virtualbox.

We could try to add some nsleep() or msleep() calls within text_poke and
text_poke_early before and after the code modificatoin to see if the
problem disappears. If it does, then that would somewhat confirm the
racy irq disable thesis.

Mathieu

> -- 
> Luiz Fernando N. Capitulino

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
