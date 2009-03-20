Return-Path: <linux-kernel-owner+w=401wt.eu-S1760864AbZCTTTY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760864AbZCTTTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 15:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753716AbZCTTTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 15:19:15 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58567 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752265AbZCTTTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 15:19:14 -0400
Subject: Re: [Announce] 2.6.29-rc8-rt2
From: Will Schmidt <will_schmidt@vnet.ibm.com>
Reply-To: will_schmidt@vnet.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>
In-Reply-To: <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0902122353050.16972@localhost.localdomain>
	 <alpine.LFD.2.00.0902231854360.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241849230.3523@localhost.localdomain>
	 <alpine.LFD.2.00.0902241856480.9135@localhost.localdomain>
	 <alpine.LFD.2.00.0903122013230.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903200014320.29264@localhost.localdomain>
	 <alpine.LFD.2.00.0903201832590.29264@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Organization: IBM
Date: Fri, 20 Mar 2009 14:19:11 -0500
Message-Id: <1237576751.8951.146.camel@lexx>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-20 at 18:45 +0100, Thomas Gleixner wrote:
> We are pleased to announce the next update to our new preempt-rt
> series.
>     
>      - resurrected ARM and PowerPC support
>      - tracing fixes for ARM (Uwe Kleine-Koenig)
> 
> The support for ARM/PowerPC has only been lightly tested. It might
> crash and burn your system, make your hair curl, frigthen your cat and
> give you sleepless nights. You have been warned !

During a build attempt on powerpc, I am seeing:

In file included from include/linux/mmzone.h:776,
                 from include/linux/gfp.h:5,
                 from include/linux/slab.h:13,
                 from include/linux/percpu.h:6,
                 from include/linux/rcupdate.h:40,
                 from include/linux/rculist.h:11,
                 from include/linux/dcache.h:7,
                 from include/linux/fs.h:299,
                 from init/do_mounts_rd.c:4:
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/mmzone.h:32: error:
expected ‘=’, ‘,’, ‘;’, ‘asm’ or ‘__attribute__’ before
‘numa_cpumask_lookup_table’
In file included from include/linux/topology.h:35,
                 from include/linux/gfp.h:8,
                 from include/linux/slab.h:13,
                 from include/linux/percpu.h:6,
                 from include/linux/rcupdate.h:40,
                 from include/linux/rculist.h:11,
                 from include/linux/dcache.h:7,
                 from include/linux/fs.h:299,
                 from init/do_mounts_rd.c:4:
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h: In function
‘node_to_cpumask’:
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
‘numa_cpumask_lookup_table’ undeclared (first use in this function)
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
(Each undeclared identifier is reported only once
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:22: error:
for each function it appears in.)
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h: In function
‘node_to_first_cpu’:
/root/linux-2.6.29-rc8/arch/powerpc/include/asm/topology.h:29: error:
‘numa_cpumask_lookup_table’ undeclared (first use in this function)
make[1]: *** [init/do_mounts_rd.o] Error 1
make[1]: *** Waiting for unfinished jobs....



I have locally fixed by adding an include just above the cpumask_t
reference.  The include may belong elsewhere, but in case I got it
right,.. :-)

Signed-Off-By:  Will Schmidt <will_schmidt@vnet.ibm.com>

--


diff --git a/arch/powerpc/include/asm/mmzone.h
b/arch/powerpc/include/asm/mmzone.h
index 19f299b..530fa41 100644
--- a/arch/powerpc/include/asm/mmzone.h
+++ b/arch/powerpc/include/asm/mmzone.h
@@ -28,6 +28,8 @@ extern struct pglist_data *node_data[];
  * Following are specific to this numa platform.
  */

+#include <linux/cpumask.h>
+
 extern int numa_cpu_lookup_table[];
 extern cpumask_t numa_cpumask_lookup_table[];
 #ifdef CONFIG_MEMORY_HOTPLUG



Thanks, 
-Will

> 
> On PowerPC watch out for the following warning:
> 
>    __do_IRQ called for irq X. PREEMPT_RT will crash your system soon.
> 
> __do_IRQ is deprecated and -rt does not support it anymore. Most of
> the PowerPC subarchitectures do not longer use it, but you might be
> unlucky and hit one of the remaining users. RT will spit out the
> message above and then do what it said. :)
> 
> Download locations:
>  
>     http://rt.et.redhat.com/download/
>     http://www.kernel.org/pub/linux/kernel/projects/rt/
>   
> Information on the RT patch can be found at:
> 
>     http://rt.wiki.kernel.org/index.php/Main_Page
> 
> to build the 2.6.29-rc8-rt1 tree, the following patches should be
> applied:
> 
>   http://www.kernel.org/pub/linux/kernel/v2.6/testing/linux-2.6.29-rc8.tar.bz2
>   http://www.kernel.org/pub/linux/kernel/projects/rt/patch-2.6.29-rc8-rt2.bz2
>   
> The broken out patches are also available at the same download
> locations.
> 
> Enjoy !
> 
>        tglx
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

