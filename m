Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbZDBEvW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbZDBEvW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:51:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751483AbZDBEvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:51:13 -0400
Received: from tomts36.bellnexxia.net ([209.226.175.93]:39585 "EHLO
	tomts36-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751411AbZDBEvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:51:13 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmEFAPbe00lMQW1W/2dsb2JhbACBUs0bg30G
Date: Thu, 2 Apr 2009 00:51:04 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       ltt-dev@lists.casi.polymtl.ca
Subject: Ftrace code in the 2.6.29 kernel
Message-ID: <20090402045104.GA21896@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 00:39:18 up 33 days,  1:05,  1 user,  load average: 0.70, 0.31,
	0.17
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

I am giving a look at the ftrace code, and I am a bit confused by the
way you handle reentrancy in ring_buffer.c. (this is the code in 2.6.29)
Please tell me if I missed important details :

1) you seem to have removed any sort of "nesting" check to allow NMI
handlers to run. Previously, I remember that you simply discarded the
event if a NMI handler appeared to run over the ring buffer code.

2) Assuming 1) is true, then __rb_reserve_next() called from
ring_buffer_lock_reserve() is protected by :

               local_irq_save(flags);
                __raw_spin_lock(&cpu_buffer->lock);

Which I think is the last thing you want to see in a NMI handler. It
sounds like this code is begging for a deadlock to occur if run in NMI
context. Or maybe you don't claim that this code supports NMI, but then
you should remove the following comment from ring_buffer.c :

rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
{
        /*
         * We only race with interrupts and NMIs on this CPU.

So basically, if an NMI nests over that code, or if an instrumented
fault happens within the ring_buffer code, this would generate an
infinite recursive call chain of trap/tracing/trap/tracing...

So this is why I think I might have missed a sanity check somewhere.

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
