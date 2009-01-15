Return-Path: <linux-kernel-owner+w=401wt.eu-S1761849AbZAORaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761849AbZAORaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 12:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755567AbZAORaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 12:30:06 -0500
Received: from relay2.sgi.com ([192.48.179.30]:54389 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758272AbZAORaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 12:30:04 -0500
Message-ID: <496F7299.3060900@sgi.com>
Date: Thu, 15 Jan 2009 09:30:01 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: crash: IP: [<ffffffff80478092>] __bitmap_intersects+0x48/0x73
 [PATCH supplied]
References: <496BF6D5.9030403@sgi.com> <20090113130048.GB31147@elte.hu> <496CAF5A.3010304@sgi.com> <496D0F46.2010907@sgi.com> <496D2172.6030608@sgi.com> <20090114165431.GA18826@elte.hu> <20090114165524.GA21742@elte.hu> <20090114175126.GA21078@elte.hu> <496E78BA.5040609@sgi.com> <20090115101617.GH5833@elte.hu> <20090115122156.GA20349@elte.hu>
In-Reply-To: <20090115122156.GA20349@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> FYI, there's new warnings due to cpumask changes:
> 
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function â€˜show_cache_disableâ€™:
> arch/x86/kernel/cpu/intel_cacheinfo.c:710: warning: unused variable â€˜maskâ€™
> arch/x86/kernel/cpu/intel_cacheinfo.c: In function â€˜store_cache_disableâ€™:
> arch/x86/kernel/cpu/intel_cacheinfo.c:745: warning: unused variable â€˜maskâ€™
> 
> on 32-bit defconfig.
> 
> 	Ingo

Hi Ingo,

You can pull the following patch to fix this build warning.

Thanks!
Mike
--- 

The following changes since commit e46d51787e23a607cac5f593ac9926743a636dff:
  Ingo Molnar (1):
        Merge branch 'master' of ssh://master.kernel.org/.../travis/linux-2.6-cpus4096-for-ingo into cpus4096

are available in the git repository at:

  ssh://master.kernel.org/pub/scm/linux/kernel/git/travis/linux-2.6-cpus4096-for-ingo master

Mike Travis (1):
      x86: fix build warning when CONFIG_NUMA not defined.

 arch/x86/include/asm/topology.h |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

commit f2a082711905312dc7b6675e913fee0c4689f7ae
Author: Mike Travis <travis@sgi.com>
Date:   Thu Jan 15 09:19:32 2009 -0800

    x86: fix build warning when CONFIG_NUMA not defined.
    
    Impact: fix build warning
    
    The macro cpu_to_node did not reference it's argument, and instead
    simply returned a 0.  This causes a "unused variable" warning if
    it's the only reference in a function (show_cache_disable).
    
    Replace it with the more correct inline function.
    
    Signed-off-by: Mike Travis <travis@sgi.com>

diff --git a/arch/x86/include/asm/topology.h b/arch/x86/include/asm/topology.h
index 4e2f2e0..d0c68e2 100644
--- a/arch/x86/include/asm/topology.h
+++ b/arch/x86/include/asm/topology.h
@@ -192,9 +192,20 @@ extern int __node_distance(int, int);
 
 #else /* !CONFIG_NUMA */
 
-#define numa_node_id()		0
-#define	cpu_to_node(cpu)	0
-#define	early_cpu_to_node(cpu)	0
+static inline int numa_node_id(void)
+{
+	return 0;
+}
+
+static inline int cpu_to_node(int cpu)
+{
+	return 0;
+}
+
+static inline int early_cpu_to_node(int cpu)
+{
+	return 0;
+}
 
 static inline const cpumask_t *cpumask_of_node(int node)
 {
