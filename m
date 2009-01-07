Return-Path: <linux-kernel-owner+w=401wt.eu-S1763558AbZAGXBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763558AbZAGXBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763429AbZAGW7B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 17:59:01 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54286 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763121AbZAGW67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 17:58:59 -0500
Date: Wed, 7 Jan 2009 14:58:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Miller <davem@davemloft.net>
Cc: rmk+kernel@arm.linux.org.uk, adobriyan@gmail.com,
       linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: hardirq.h removal broke sparc64 build...
Message-Id: <20090107145822.625960f2.akpm@linux-foundation.org>
In-Reply-To: <20090107.144310.79937111.davem@davemloft.net>
References: <20090107.144310.79937111.davem@davemloft.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 07 Jan 2009 14:43:10 -0800 (PST)
David Miller <davem@davemloft.net> wrote:

> 
> [ Andrew, read carefully, I think some part of a patch you
>   merged might have been lost while reshuffling or whatever. ]
> 
> This change:
> 
> commit ba84be2338d3a2b6020d39279335bb06fcd332e1
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Tue Jan 6 14:41:07 2009 -0800
> 
>     remove linux/hardirq.h from asm-generic/local.h
> 
> broke the build on sparc64:

urgh, sorry.

> drivers/base/topology.c: In function ___show_physical_package_id___:
> drivers/base/topology.c:103: error: implicit declaration of function ___cpu_data___
> drivers/base/topology.c:103: error: request for member ___proc_id___ in something not a structure or union
> drivers/base/topology.c: In function ___show_core_id___:
> drivers/base/topology.c:106: error: request for member ___core_id___ in something not a structure or union
> 
> Even though there is a footnote there from Alexey saying that
> sparc64 was fixed up :-)
> 
>     [adobriyan@gmail.com: fix sparc64]

OK, that patch was misdescribed.  It in fact added the <asm/hardirq.h>
includes to arch/avr32/kernel/traps.c and arch/sh/kernel/traps_32.c.

The "sparc fix" was Sam's patch:

--- a/arch/sparc/kernel/mdesc.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix
+++ a/arch/sparc/kernel/mdesc.c
@@ -11,6 +11,7 @@
 #include <linux/mm.h>
 #include <linux/miscdevice.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/mdesc.h>
 #include <asm/prom.h>
--- a/arch/sparc/kernel/sysfs.c~remove-linux-hardirqh-from-asm-generic-localh-sparc-fix
+++ a/arch/sparc/kernel/sysfs.c
@@ -8,6 +8,7 @@
 #include <linux/percpu.h>
 #include <linux/init.h>
 
+#include <asm/cpudata.h>
 #include <asm/hypervisor.h>
 #include <asm/spitfire.h>


which did get included. 


> I've spent most of last night and this morning trying to figure out
> a way to fix this, it is very non-trivial.
> 
> Adding a simple asm/cpudata.h include into asm/topology_64.h for the
> SMP case does not work.
> 
> asm/cpudata.h brings in percpu.h which wants SLAB which wants to use
> GFP_* values and thus includes gfp.h
> 
> And thus because of the include loop:
> 
> 	linux/gfp.h --> linux/mmzone.h --> linux/topology.h -->
> 	asm/topology.h --> asm/cpudata.h --> linux/percpu.h -->
> 	linux/slab.h
> 
> we can't include asm/cpudata.h into asm/topology.h otherwise
> we get:
> 
> include/linux/slub_def.h: In function ___kmalloc_large___:
> include/linux/slub_def.h:209: error: implicit declaration of function _____get_free_pages___
> include/linux/slub_def.h:209: error: _____GFP_COMP___ undeclared (first use in this function)
> include/linux/slub_def.h:209: error: (Each undeclared identifier is reported only once
> include/linux/slub_def.h:209: error: for each function it appears in.)
> include/linux/slub_def.h:209: warning: cast to pointer from integer of different size
> 
> for the drivers/base/topology.o build failure case above.

yes, there were some nasty problems liek that.  In several cases we wimped
out and added the necessary includes to the .c file.  Will that (sad hack)
work here?

