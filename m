Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031470Ab0B1H30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 02:29:26 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:56264 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031422Ab0B1H3Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 02:29:25 -0500
Date: Sat, 27 Feb 2010 23:29:25 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: benh@au1.ibm.com, anton@au1.ibm.com, paulus@au1.ibm.com,
       akpm@linux-foundation.org
Subject: [PATCH RFC] powerpc: Fixes to allow pseries to build for
	HOTPLUG_CPU=n
Message-ID: <20100228072925.GA26097@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building for a pseries machine with HOTPLUG_CPU=n on 2.6.33 gives the
following build errors:

arch/powerpc/platforms/built-in.o: In function `.smp_xics_setup_cpu':
smp.c:(.devinit.text+0x8c): undefined reference to `.set_cpu_current_state'
smp.c:(.devinit.text+0x98): undefined reference to `.set_default_offline_state'
arch/powerpc/platforms/built-in.o: In function `.smp_pSeries_kick_cpu':
smp.c:(.devinit.text+0x13c): undefined reference to `.get_cpu_current_state'
smp.c:(.devinit.text+0x1c4): undefined reference to `.set_preferred_offline_state'
smp.c:(.devinit.text+0x1d0): undefined reference to `.get_cpu_current_state'

This patch fixes this by providing empty (or nearly empty) functions for
the HOTPLUG_CPU=n case.  Passes moderate rcutorture testing.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

 offline_states.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/powerpc/platforms/pseries/offline_states.h b/arch/powerpc/platforms/pseries/offline_states.h
index 22574e0..195f9c7 100644
--- a/arch/powerpc/platforms/pseries/offline_states.h
+++ b/arch/powerpc/platforms/pseries/offline_states.h
@@ -9,10 +9,40 @@ enum cpu_state_vals {
 	CPU_MAX_OFFLINE_STATES
 };
 
+#ifdef CONFIG_HOTPLUG_CPU
+
 extern enum cpu_state_vals get_cpu_current_state(int cpu);
 extern void set_cpu_current_state(int cpu, enum cpu_state_vals state);
 extern enum cpu_state_vals get_preferred_offline_state(int cpu);
 extern void set_preferred_offline_state(int cpu, enum cpu_state_vals state);
 extern void set_default_offline_state(int cpu);
+
+#else /* #ifdef CONFIG_HOTPLUG_CPU */
+
+static inline enum cpu_state_vals get_cpu_current_state(int cpu)
+{
+	return cpu_online(cpu) ? CPU_STATE_ONLINE : CPU_STATE_OFFLINE;
+}
+
+static inline void set_cpu_current_state(int cpu, enum cpu_state_vals state)
+{
+}
+
+static inline enum cpu_state_vals get_preferred_offline_state(int cpu)
+{
+	return CPU_STATE_OFFLINE;
+}
+
+static inline void set_preferred_offline_state(int cpu,
+					       enum cpu_state_vals state)
+{
+}
+
+static inline void set_default_offline_state(int cpu)
+{
+}
+
+#endif /* #else #ifdef CONFIG_HOTPLUG_CPU */
+
 extern int start_secondary(void);
 #endif
