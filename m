Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbYBRMXh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbYBRMXh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 07:23:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759431AbYBRMXN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 07:23:13 -0500
Received: from ns.suse.de ([195.135.220.2]:57035 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752284AbYBRMXM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 07:23:12 -0500
To: Yinghai Lu <Yinghai.Lu@Sun.COM>
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Travis <travis@sgi.com>, lameter@sgi.com
Subject: Re: [PATCH] x86_64: remove never used nodenumer in pda
From: Andi Kleen <andi@firstfloor.org>
References: <200802162302.04131.yinghai.lu@sun.com>
Date: Mon, 18 Feb 2008 13:23:11 +0100
In-Reply-To: <200802162302.04131.yinghai.lu@sun.com> (Yinghai Lu's message of "Sat\, 16 Feb 2008 23\:02\:03 -0800")
Message-ID: <p73ve4mxxlc.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu <Yinghai.Lu@Sun.COM> writes:

> we don't need copy too. already have x86_cpu_to_node_map

That's a regression (probably from Mike's patches?). Until recently it was 
used.

The reason the node number was put in there is that it generates far
shorter code to just fetch the local node number from the PDA than to
first go through a array lookup from the cpu number. It also saves a
costly cache line miss on the array if you're unlucky.

It is far better to fix it than to remove it.

I know Mike/Christoph want to get rid of the PDA and make per cpu data 
as efficient as the PDA. If that happens the right fix is to create
a new per CPU data variable for the node number again.

Here's a quick patch (tested on kvm with numa emulation only) 

It should be ok because PDA is set up early and
the early node is always 0 and there is a 0 in there
at early boot.

Saves about 1.6k of text on a vmlinux here.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/asm-x86/topology.h
===================================================================
--- linux.orig/include/asm-x86/topology.h
+++ linux/include/asm-x86/topology.h
@@ -34,11 +34,12 @@
 extern int cpu_to_node_map[];
 
 #else
+#include <asm/pda.h>
 DECLARE_PER_CPU(int, x86_cpu_to_node_map);
 extern int x86_cpu_to_node_map_init[];
 extern void *x86_cpu_to_node_map_early_ptr;
 /* Returns the number of the current Node. */
-#define numa_node_id()		(early_cpu_to_node(raw_smp_processor_id()))
+#define numa_node_id()		(read_pda(nodenumber))
 #endif
 
 extern cpumask_t node_to_cpumask_map[];



