Return-Path: <linux-kernel-owner+w=401wt.eu-S1765789AbZFOSjX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765789AbZFOSjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 14:39:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765213AbZFOSi5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 14:38:57 -0400
Received: from tomts36-srv.bellnexxia.net ([209.226.175.93]:54583 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755514AbZFOSiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 14:38:55 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokFAAcwNkpMQWQl/2dsb2JhbACBT9VwhA0F
Date: Mon, 15 Jun 2009 14:38:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       hpa@zytor.com, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090615183840.GA6520@Krystal>
References: <tip-74193ef0ecab92535c8517f082f1f50504526c9b@git.kernel.org> <alpine.LFD.2.01.0906151007560.3305@localhost.localdomain> <20090615171845.GA7664@elte.hu> <alpine.LFD.2.01.0906151029160.3305@localhost.localdomain> <20090615180527.GB4201@Krystal> <20090615182348.GC11248@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090615182348.GC11248@elte.hu>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 14:28:28 up 107 days, 14:54,  3 users,  load average: 1.06, 0.95,
	0.70
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar (mingo@elte.hu) wrote:
> 
> * Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> 
> > Hrm, would it be possible to save the c2 register upon nmi handler 
> > entry and restore it before iret instead ? This would ensure a 
> > nmi-interrupted page fault handler would continue what it was 
> > doing with a non-corrupted cr2 register after returning from nmi.
> > 
> > Plus, this involves no modification to the page fault handler fast 
> > path.
> 
> I guess this kind of nesting would work too - assuming the cr2 can 
> be written to robustly.
> 
> And i suspect CPU makers pull off a few tricks to stage the cr2 info 
> away from the page fault entry execution asynchronously, so i'd not 
> be surprised if writing to it uncovered unknown-so-far side-effects 
> in CPU implementations.
> 
> If possible i wouldnt want to rely on such a narrowly possible hack 
> really - any small change in CPU specs could cause problems years 
> down the line.
> 
> The GUP based method is pretty generic though - and can be used on 
> other architectures as well. It's not as fast as direct access 
> though.
> 
> 	Ingo

I guess. However, having the ability to call module code in NMI handler
context without having to fear for page fault handler re-entrancy (on
x86 32) seems like an interesting overall simplification of nmi-handler
rules. It is currently far from trivial to write code aimed at NMI
handler context. I mean.. LTTng should not have to run
vmalloc_sync_all() after loading its modules as it currently does.

Maybe it would be worth trying the save/restore cr2 approach and test to
figure out how a large variety of machines react. The fact is that
hypervisor code already writes into the cr2 register :

kvm/vmx.c :
vmx_vcpu_run()
...
                "mov %%"R"ax, %%cr2 \n\t"

Mathieu



-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
