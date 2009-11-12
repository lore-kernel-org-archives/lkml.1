Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZKLWyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZKLWyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 17:54:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754806AbZKLWyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 17:54:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42482 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754550AbZKLWyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 17:54:38 -0500
Date: Thu, 12 Nov 2009 17:22:01 -0500
From: Dave Jones <davej@redhat.com>
To: Mike Travis <travis@sgi.com>
Cc: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Roland Dreier <rdreier@cisco.com>, Randy Dunlap <rdunlap@xenotime.net>,
       Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86_64: Limit the number of processor bootup messages
Message-ID: <20091112222200.GA19109@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Mike Travis <travis@sgi.com>, Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Roland Dreier <rdreier@cisco.com>,
	Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
	David Rientjes <rientjes@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Jack Steiner <steiner@sgi.com>,
	Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20091023233743.439628000@alcatraz.americas.sgi.com>
 <20091023233746.128967000@alcatraz.americas.sgi.com>
 <87tyxmy6x6.fsf@basil.nowhere.org>
 <4AE5E48F.6020408@sgi.com>
 <20091026215544.GA3355@basil.fritz.box>
 <4AEB3D95.50300@sgi.com>
 <4AEEBE65.3070202@linux.intel.com>
 <4AEF3143.2030701@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AEF3143.2030701@sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 02, 2009 at 11:21:39AM -0800, Mike Travis wrote:
 
 > >>     [   90.981402] CPU: L1 I cache: 32K, L1 D cache: 32K
 > >>     [   90.985888] CPU: L2 cache: 256K
 > >>     [   90.988032] CPU: L3 cache: 24576K
 > > 
 > > I would recommend to drop the cache information; this can be easily
 > > gotten at runtime and is often implied in the CPU name anyways
 > > (and especially L1 and increasingly L2 too change only very rarely)
 > 
 > Ok, though because of future system upgrades to a UV system, you can
 > end up with slightly different processors (of the same family).  The
 > only differences I've detected so far in testing is the stepping has
 > changed.

I happened to be annoyed by dozens of these three printk's earlier,
and hacked up the following (currently untested) patch.

But I don't disagree with Andi either, that it's not particularly useful,
and we can get all this from userspace in /proc/cpuinfo, or x86info.

If someone still finds it valuable to have the kernel keep printing it
though, perhaps something like the following ?

	Dave



On processors with a large number of cores, we print dozens of lines of information about
the CPU cache topology, most of which is unnecessary.
This patch reduces spew a lot (down to a single line unless someone uses a mix of processors
with different cache sizes)

- Check if the total cache size on APs is equal to the boot processors cache size.
  Print nothing if equal.
- The three printk's will fit on one line.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 804c40e..cc4f44d 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -358,9 +362,9 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #ifdef CONFIG_X86_HT
 	unsigned int cpu = c->cpu_index;
 #endif
+	static int is_initialized;
 
 	if (c->cpuid_level > 3) {
-		static int is_initialized;
 
 		if (is_initialized == 0) {
 			/* Init num_cache_leaves from boot CPU */
@@ -488,6 +492,21 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 #endif
 	}
 
+	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
+
+	/*
+	 * cache topology on all AP's is likely equal to that of the BP
+	 * if this is the case, don't bother printing anything out for the AP's.
+	 */
+	if (is_initialized != 0) {
+		if (c->x86_cache_size == boot_cpu_data.x86_cache_size)
+			return l2;
+		else
+			printk(KERN_INFO "CPU: AP has different cache size (%d) to BP (%d)\n",
+				c->x86_cache_size,
+				boot_cpu_data.x86_cache_size);
+	}
+
 	if (trace)
 		printk(KERN_INFO "CPU: Trace cache: %dK uops", trace);
 	else if (l1i)
@@ -495,16 +512,12 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 
 	if (l1d)
 		printk(KERN_CONT ", L1 D cache: %dK\n", l1d);
-	else
-		printk(KERN_CONT "\n");
 
 	if (l2)
-		printk(KERN_INFO "CPU: L2 cache: %dK\n", l2);
+		printk(KERN_CONT ", L2 cache: %dK\n", l2);
 
 	if (l3)
-		printk(KERN_INFO "CPU: L3 cache: %dK\n", l3);
-
-	c->x86_cache_size = l3 ? l3 : (l2 ? l2 : (l1i+l1d));
+		printk(KERN_CONT ", L3 cache: %dK\n", l3);
 
 	return l2;
 }
