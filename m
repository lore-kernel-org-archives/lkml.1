Return-Path: <linux-kernel-owner+w=401wt.eu-S1751626AbXCLWhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751626AbXCLWhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2007 18:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751592AbXCLWhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Mar 2007 18:37:53 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:53452 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbXCLWhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2007 18:37:52 -0400
Date: Mon, 12 Mar 2007 18:37:49 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Masami Hiramatsu <hiramatu@sdl.hitachi.co.jp>,
       linux-kernel@vger.kernel.org, systemtap@sources.redhat.com,
       mbligh@google.com
Subject: Djprobes questions
Message-ID: <20070312223749.GA22280@Krystal>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 18:26:06 up 38 days, 12:33,  4 users,  load average: 2.07, 2.09, 1.92
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

I recently had to add support for inline code patching on i386 to my
marker infrastructure. Clearly, it looks like what is done in djprobes,
with the main difference that I only patch the immediate value of a 2
bytes "load immediate" instruction.

I think I found a solution to one of the main issues with djprobes : it
currently has to wait for each CPU to hit the probe before being sure
that it's safe to patch the code with something else than an int3. This
is due to PIII errata 49, which says that a CPU much execute a
serializing instruction before executing cross-modified code.

Here is what I do : While I use a breakpoint to fall in a trap for the
CPUs that hit the site currently being modified, I also send an IPI to
all CPUs so they execute cpuid. Once it returns, I am sure that every
CPU has executed a serializing instruction, which enables me to go on
with the complete code modification, therefore removing the initial
breakpoint.

Here is my code :

http://ltt.polymtl.ca/cgi-bin/gitweb.cgi?p=linux-2.6-lttng.git;a=blob;f=arch/i386/kernel/marker.c;h=89b06f02f0966685be260d6364a0dd94c3d14456;hb=v2.6.20-lttng

(Comments are welcome)

On a second note, looking at the djprobes code triggered some question 
in my mind about the safety of using a worker thread to "make sure"
every interrupt context has returned (so there is no IP pointing into
the modified code). The following scenario might be possible : an
interrupt handler (or trap handler) reenables interrupts, does irq_exit()
or nmi_exit() (which reenables preemption) but does not do iret yet. My
understanding is that it could be scheduled and have a return IP
pointing to the code that is being modified. Am I right ?

Regards,

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
