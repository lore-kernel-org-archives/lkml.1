Return-Path: <linux-kernel-owner+w=401wt.eu-S1755145AbYIGKSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145AbYIGKSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 06:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbYIGKSW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 06:18:22 -0400
Received: from qb-out-0506.google.com ([72.14.204.224]:34164 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752908AbYIGKSV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 06:18:21 -0400
Message-ID: <48C3AA6A.3060402@colorfullife.com>
Date: Sun, 07 Sep 2008 12:18:18 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, cl@linux-foundation.org, mingo@elte.hu,
       akpm@linux-foundation.org, dipankar@in.ibm.com,
       josht@linux.vnet.ibm.com, schamp@sgi.com, niv@us.ibm.com,
       dvhltc@us.ibm.com, ego@in.ibm.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, penberg@cs.helsinki.fi,
       andi@firstfloor.org
Subject: [RFC, PATCH] Add a CPU_STARTING notifier (was: Re: [PATCH, RFC] v4
 scalable classic RCU implementation)
References: <20080821234318.GA1754@linux.vnet.ibm.com> <20080825000738.GA24339@linux.vnet.ibm.com> <20080830004935.GA28548@linux.vnet.ibm.com> <20080905152930.GA8124@linux.vnet.ibm.com>
In-Reply-To: <20080905152930.GA8124@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------080701070004000200020903"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080701070004000200020903
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Paul E. McKenney wrote:
> +/*
> + * If the specified CPU is offline, tell the caller that it is in
> + * a quiescent state.  Otherwise, whack it with a reschedule IPI.
> + * Grace periods can end up waiting on an offline CPU when that
> + * CPU is in the process of coming online -- it will be added to the
> + * rcu_node bitmasks before it actually makes it online.  Because this
> + * race is quite rare, we check for it after detecting that the grace
> + * period has been delayed rather than checking each and every CPU
> + * each and every time we start a new grace period.
> + */
> +static int rcu_implicit_offline_qs(struct rcu_data *rdp)
> +{
> +	/*
> +	 * If the CPU is offline, it is in a quiescent state.  We can
> +	 * trust its state not to change because interrupts are disabled.
> +	 */
> +	if (cpu_is_offline(rdp->cpu)) {
> +		rdp->offline_fqs++;
> +		return 1;
> +	}
>   
I fear that this won't work.
E.g. look at x86, smp_callin() [arch/x86/kernel/smpboot.c]:
The boot code must enable local interrupts around calibrate_delay(), 
otherwise the NMI watchdog would complain.
That means the first interrupts, the first read side critical sections 
can run way before the cpu bit is set within cpu_online_map.
cpus are just started, we are not within stop_machine. Thus we cannot 
make any assumption about what the remaining cpus are doing.

What about introducing a CPU_STARTING notifier call, similar to CPU_DYING:
- called with disabled interrupts
- called before interrupts are enabled
- must not sleep
- called on the new cpu.

This might also be useful for something like kvm. I'm not sure if it's 
guaranteed that hardware_enable() runs early enough.

Attached is a patch proposal. Note that it doesn't work correctly: On 
x86-64, I have seen that CPU_STARTING is called after CPU_ONLINE. Thus 
frozen_cpus could already be cleared, then _FROZEN would be wrong.

--
Manfred

--------------080701070004000200020903
Content-Type: text/plain;
 name="patch-CPU_STARTING-wip"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch-CPU_STARTING-wip"

diff --git a/include/linux/cpu.h b/include/linux/cpu.h
index d7faf88..c2747ac 100644
--- a/include/linux/cpu.h
+++ b/include/linux/cpu.h
@@ -69,6 +69,7 @@ static inline void unregister_cpu_notifier(struct notifier_block *nb)
 #endif
 
 int cpu_up(unsigned int cpu);
+void notify_cpu_starting(unsigned int cpu);
 extern void cpu_hotplug_init(void);
 extern void cpu_maps_update_begin(void);
 extern void cpu_maps_update_done(void);
diff --git a/include/linux/notifier.h b/include/linux/notifier.h
index da2698b..8e47661 100644
--- a/include/linux/notifier.h
+++ b/include/linux/notifier.h
@@ -213,9 +213,16 @@ static inline int notifier_to_errno(int ret)
 #define CPU_DOWN_FAILED		0x0006 /* CPU (unsigned)v NOT going down */
 #define CPU_DEAD		0x0007 /* CPU (unsigned)v dead */
 #define CPU_DYING		0x0008 /* CPU (unsigned)v not running any task,
-				        * not handling interrupts, soon dead */
+				        * not handling interrupts, soon dead.
+				        * Called on the dying cpu, interrupts
+				        * are already disabled. Must not
+				        * sleep, must not fail */
 #define CPU_POST_DEAD		0x0009 /* CPU (unsigned)v dead, cpu_hotplug
 					* lock is dropped */
+#define CPU_STARTING		0x000A /* CPU (unsigned)v soon running.
+					* Called on the new cpu, just before
+					* enabling interrupts. Must not sleep,
+					* must not fail */
 
 /* Used for CPU hotplug events occuring while tasks are frozen due to a suspend
  * operation in progress
diff --git a/kernel/cpu.c b/kernel/cpu.c
index 5b7c88f..2300fc0 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -455,6 +455,25 @@ out:
 }
 #endif /* CONFIG_PM_SLEEP_SMP */
 
+/**
+ * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
+ * @cpu: cpu that just started
+ *
+ * This function calls the cpu_chain notifiers with CPU_STARTING.
+ * It must be called by the arch code on the new cpu, immediately
+ * before enabling interrupts.
+ */
+void notify_cpu_starting(unsigned int cpu)
+{
+	unsigned long val = CPU_STARTING;
+
+#ifdef CONFIG_PM_SLEEP_SMP
+	if (cpu_isset(cpu, frozen_cpus))
+		val = CPU_STARTING_FROZEN;
+#endif /* CONFIG_PM_SLEEP_SMP */
+	raw_notifier_call_chain(&cpu_chain, val, (void*)(long)cpu);
+}
+
 #endif /* CONFIG_SMP */
 
 /*

--------------080701070004000200020903--
