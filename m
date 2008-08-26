Return-Path: <linux-kernel-owner+w=401wt.eu-S1759020AbYHZSQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759020AbYHZSQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754664AbYHZSQB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:16:01 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:43066 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752571AbYHZSQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:16:00 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEAK7is0hMRKxB/2dsb2JhbACBZbgcgWs
Date: Tue, 26 Aug 2008 14:15:58 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Luiz Fernando N. Capitulino" <lcapitulino@mandriva.com.br>
Cc: Gerhard Brauer <gerhard.brauer@web.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.{26.2,27-rc} oops on virtualbox
Message-ID: <20080826181558.GA16887@Krystal>
References: <20080822132948.57e47076@doriath.conectiva> <20080822163520.GA9860@Krystal> <20080822142054.403cbdef@doriath.conectiva> <20080822175741.6bc83dc8@doriath.conectiva> <48AF2ABD.9070100@zytor.com> <20080826141851.GA5300@tux1.brauer.lan> <20080826145338.GA8601@Krystal> <20080826131354.356ae11d@doriath.conectiva> <20080826171822.GB14906@Krystal> <20080826150222.0cf1542c@doriath.conectiva>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20080826150222.0cf1542c@doriath.conectiva>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:07:36 up 82 days, 22:48,  5 users,  load average: 0.31, 0.35,
	0.49
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> Em Tue, 26 Aug 2008 13:18:22 -0400
> Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
> 
> | * Luiz Fernando N. Capitulino (lcapitulino@mandriva.com.br) wrote:
> | > Em Tue, 26 Aug 2008 10:53:38 -0400
> | > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> escreveu:
> | > 
> | > | Then, after having tested (2), try this on top of it :
> | > | 
> | > | In arch/x86/kernel/alternative.c, alternatives_smp_switch()
> | > | 
> | > | Add   unsigned long flags;
> | > | Change 
> | > | spin_lock -> spin_lock_irqsave(&smp_alt, flags);
> | > | spin_unlock(&smp_alt); -> spin_unlock_irqrestore(&smp_alt, flags);
> | > 
> | >  Hmm, I can't find spin_lock functions in alternatives_smp_switch()
> | > looks like the current implementation is now using mutexes.
> | > 
> | 
> | Sorry, I was looking directly at the commit which caused the problem.
> | Yes, these modif should go on top of the text_poke -> text_poke_early.
> | 
> | So in current mainline, change, in alternatives_smp_switch() :
> | 
> | mutex_lock(&smp_alt);
> | ...
> | 
> | mutex_unlock(&smp_alt);
> | 
> | to
> | 
> | mutex_lock(&smp_alt);
> | local_irq_save(flags);
> | ...
> | 
> | local_irq_restore(flags);
> | mutex_unlock(&smp_alt);
> 
>  Did not help, same oops here.
> 

Ok, it might still be caused by paravirt and alternatives instruction
patching. What if you also do :

alternative_instructions()

+        unsigned long flags;
        /* The patching is not fully atomic, so try to avoid local interruptions
           that might execute the to be patched code.
           Other CPUs are not running. */
        stop_nmi();
#ifdef CONFIG_X86_MCE
        stop_mce();
#endif
+        local_irq_save(flags);


...
+        local_irq_restore(flags);
        restart_nmi();
#ifdef CONFIG_X86_MCE
        restart_mce();
#endif

?

Hrm,

Since those local_irq_save/restore occur _before_ the paravirt patching
is done, I wonder if there would be a race in the way cli/sti traps are
handled by Virtualbox wrt incoming interrupt ?

Thanks,

Mathieu

> -- 
> Luiz Fernando N. Capitulino

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
