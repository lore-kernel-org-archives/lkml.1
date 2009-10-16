Return-Path: <linux-kernel-owner+w=401wt.eu-S1762142AbZJPPrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762142AbZJPPrq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 11:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760234AbZJPPrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 11:47:45 -0400
Received: from ms01.sssup.it ([193.205.80.99]:54642 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759444AbZJPPro (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 11:47:44 -0400
Subject: [RFC 11/12][PATCH] SCHED_DEADLINE: documentation
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       michael trimarchi <michael@evidence.eu.com>,
       Fabio Checconi <fabio@gandalf.sssup.it>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dhaval Giani <dhaval.giani@gmail.com>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       Chris Friesen <cfriesen@nortel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Henrik Austad <henrik@austad.us>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       Bjoern Brandenburg <bbb@cs.unc.edu>,
       Tommaso Cucinotta <tommaso.cucinotta@sssup.it>,
       "giuseppe.lipari" <giuseppe.lipari@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>
In-Reply-To: <1255707324.6228.448.camel@Palantir>
References: <1255707324.6228.448.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-oC/YK2sOvW6Rk37i0iEK"
Date: Fri, 16 Oct 2009 17:47:23 +0200
Message-Id: <1255708043.6228.467.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oC/YK2sOvW6Rk37i0iEK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

This commit adds some more documentation and comments on how the new
scheduling policy works.

Signed-off-by: Raistlin <raistlin@linux.it>
---
 Documentation/scheduler/sched-deadline.txt |  174 ++++++++++++++++++++++++=
++++
 include/linux/sched.h                      |   45 +++++++
 init/Kconfig                               |    1 +
 3 files changed, 220 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/scheduler/sched-deadline.txt

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/sch=
eduler/sched-deadline.txt
new file mode 100644
index 0000000..cadfa9f
--- /dev/null
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -0,0 +1,174 @@
+			Deadline Task and Group Scheduling
+			----------------------------------
+
+CONTENTS
+=3D=3D=3D=3D=3D=3D=3D=3D
+
+0. WARNING
+1. Overview
+  1.1 Task scheduling
+  1.2 Group scheduling
+2. The interface
+  2.1 System-wide settings
+  2.2 Default behavior
+  2.3 Basis for grouping tasks
+3. Future plans
+
+
+0. WARNING
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+ Fiddling with these settings can result in an unpredictable or even unsta=
ble
+ system behavior. As for -rt (group) scheduling, it is assumed that root
+ knows what he is doing.
+
+
+1. Overview
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+The SCHED_DEADLINE scheduling class implements the Earliest Deadline First
+(EDF) algorithm and uses the Constant Bandwidth Server (CBS) to provide
+bandwidth isolation among tasks.
+The implementation is aligned with the current mainstream kernel, and it
+relies on standard Linux mechanisms (e.g., control groups) to natively sup=
port
+multicore platforms and to provide hierarchical scheduling through a stand=
ard
+API.
+
+
+1.1 Task scheduling
+-------------------
+
+The SCHED_DEADLINE scheduling class does not make any restrictive assumpti=
on
+on the characteristics of the tasks, thus it can handle:
+ * periodic tasks, typical in real-time and control applications;
+ * sporadic tasks, typical in soft real-time and multimedia applications;
+ * aperiodic tasks.
+
+This is mainly because temporal isolation is ensured: the temporal behavio=
r
+of each task (i.e., its ability to meet deadlines) is not affected by what
+happens in any other task in the system.
+In other words, even if a task misbehaves, it is not able to exploit large=
r
+execution time than the amount that has been devoted to it.
+
+In fact, each task is assigned a ``scheduling budget'' (sched_runtime) and=
 a
+``scheduling deadline'' (sched_deadline, also called period in this branch
+of the real-time literature).
+This means the task is guaranteed to execute for an amount of time equal t=
o
+sched_runtime every sched_deadline, i.e., to utilize at most a CPU bandwid=
th
+equal to sched_runtime/sched_deadline.
+If it tries to execute more than its sched_runtime it is slowed down, by
+stopping it until the time instant of its next deadline.
+
+However, although this algorithm (i.e., the CBS) is effective for encapsul=
ating
+aperiodic or sporadic --real-time or non real-time-- tasks in a real-time
+EDF scheduled system, it imposes some overhead to ``standard'' periodic ta=
sks.
+Therefore, we make it possible for periodic task to specify that they are =
going
+to sleep, waiting for the next activation, because a periodic instance jus=
t
+ended. This avoid them (provided they behave well!) being disturbed by
+the CBS bandwidth management logic.
+
+
+Group scheduling
+----------------
+
+The scheduling class is integrated with the control groups mechanism in or=
der
+to allow the creation of groups of tasks with a cap on their total utiliza=
tion.
+
+However, groups plays no role in the on-line scheduling decisions. This is
+different on how group scheduling works for the -rt scheduling class, and
+the difference comes from the fact that -deadline tasks _already_ have the=
ir
+own bandwidth, which is not true for standard POSIX SCHED_FIFO or SCHED_RR
+processes and threads.
+
+Therefore, there is no need for fully hierarchical runqueue implementation=
,
+hierarchical runtime accounting, etc., which result in simpler code and
+smaller overhead.
+All we do are bandwidth ``consistency checks'', which are performed at the
+occurrence of the following events:
+ * a -deadline task is created or moved inside a group,
+ * the parameters of a -deadline task (if inside a group) are modified,
+ * the -deadline related parameters of a group are modified.
+
+The purpose of this is ensuring the cumulative utilization of tasks and
+groups is below the one of the group containing them (see below).
+
+
+2. The Interface
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+
+2.1 System wide settings
+------------------------
+
+The system wide settings are configured under the /proc virtual file syste=
m:
+
+/proc/sys/kernel/sched_deadline_period_us:
+  The scheduling period that is equivalent to 100% CPU bandwidth
+
+/proc/sys/kernel/sched_deadline_runtime_us:
+  A global limit on how much time real-time scheduling may use. Even witho=
ut
+  CONFIG_DEADLINE_GROUP_SCHED enabled, this will limit time reserved to
+  -deadline processes. With CONFIG_DEADLINE_GROUP_SCHED it signifies the
+  total bandwidth available to all real-time groups.
+
+  * Time is specified in us because the interface is s32. This gives an
+    operating range from 1us to about 35 minutes;
+  * sched_deadline_period_us takes values from 1 to INT_MAX;
+  * sched_deadline_runtime_us takes values from 1 to INT_MAX;
+  * setting runtime =3D period specifies 100% bandwidth exploitable by
+    -deadline tasks;
+  * setting runtime > period allows for more than 100% bandwidth
+    exploitable by -deadline tasks, which still might make sense,
+    especially in SMP systems.
+
+
+2.2 Default behavior
+---------------------
+
+The default values for sched_deadline_period_us and
+sched_deadline_runtime_us are 0.  This means no -deadline tasks or
+groups can be created!
+
+Consistently, bandwidth assigned to the root group, and to each newly crea=
ted
+group, is 0 as well.
+
+
+2.3 Basis for grouping tasks
+----------------------------
+
+There are two compile-time settings for allocating CPU bandwidth. These ar=
e
+configured using the "Basis for grouping tasks" multiple choice menu under
+General setup > Group CPU Scheduler:
+
+CONFIG_USER_SCHED (aka "Basis for grouping tasks" =3D  "user id")
+
+This, for now, is not supported for deadline group scheduling.
+
+CONFIG_CGROUP_SCHED (aka "Basis for grouping tasks" =3D "Control groups")
+
+This uses the /cgroup virtual file system, i.e.:
+ * /cgroup/<cgroup>/cpu.deadline_runtime_us and
+ * /cgroup/<cgroup>/cpu.deadline_period_us,
+to control the CPU time reserved or each control group.
+
+For more information on working with control groups, you should read
+Documentation/cgroups/cgroups.txt as well.
+
+Group settings are checked against the following limits:
+
+ * for the root group {r}
+     runtime_{r} / period_{r} <=3D global_runtime / global_period
+ * for each group {i}, subgroup of group {j}
+     \Sum_{i} runtime_{i} / period_{i} <=3D runtime_{j} / period_{j}
+
+
+3. Future plans
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Only two, but very important pieces are missing:
+
+ * SMP/multicore global scheduling throughout push and pull logic (as in
+   -rt). This is not finished, but is on it's way, and will come very soon=
!
+ * Deadline/BandWidth Inheritance and/or Proxy Execution mechanisms for th=
e
+  rt_mutexes. This probably need some more discussion, and also some more =
time
+  to have it implemented!
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 4de72eb..ec0324f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -95,6 +95,51 @@ struct sched_param {
=20
 #include <asm/processor.h>
=20
+/*
+ * Extended sched_param for SCHED_DEADLINE tasks.
+ *
+ * In fact, struct sched_param can not be modified for binary compatibilit=
y
+ * issues.
+ *
+ * A SCHED_DEADLINE task have at least a scheduling deadline (sched_deadli=
ne)
+ * and a scheduling runtime (sched_runtime). Space for a scheduling
+ * period (sched_period) is reserved, but the field is not used right now.
+ *
+ * When a SCHED_DEADLINE task activates at time t, its absolute deadline i=
s
+ * computed as:
+ *	deadline =3D t + sched_deadline.
+ * The SCHED_DEADLINE runqueue is ordered according to ascending tasks'
+ * deadline values, thus the task with the _earliest_ deadline is the one
+ * that will be scheduled.
+ *
+ * In order of avoiding one task to cause intefrerence on the others, each
+ * task activation is allowed to run for at its runtime, which is at most
+ * sched_runtime.
+ * After that, the task is stopped until its deadline, when it is reactiva=
ted
+ * with a new 'runtime quota' and a new deadline.
+ *
+ * Period (or minimum interarrival time) is not dealt with in the kernel, =
and
+ * it is up to the user to make the task suspend at the end of each instan=
ce.
+ * The sched_wait_interval() --with clock_nanosleep like semantic-- syscal=
l
+ * can be used for this purpose. In this case, when the task resumes, the
+ * scheduler assumes a new instance is just starting, and provide the task
+ * with new runtime and deadline values.
+ *
+ * Scheduling flags, finally, let the user specify if runtime overruns (wh=
ich
+ * may occur, e.g., for timing resolution issues) and/or deadline misses
+ * (e.g., because system is oversubscribed) have to be notified by means o=
f
+ * SIGXCPU signals.
+ *
+ * @sched_priority:	not used right now
+ *
+ * @sched_deadline:	scheduling deadline of the task
+ * @sched_runtime:	scheduling runtime of the task
+ * @sched_period:	not used right now
+ *
+ * @sched_flags:	scheduling flags of the task (runtime overrun and/or
+ *			deadline miss only, for now)
+ */
+
 #define SCHED_SIG_RORUN		0x80000000
 #define SCHED_SIG_DMISS		0x40000000
=20
diff --git a/init/Kconfig b/init/Kconfig
index 17318ca..d4a52b7 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -467,6 +467,7 @@ config DEADLINE_GROUP_SCHED
 	  tasks (and other groups) can be added to it only up to such
 	  ``bandwidth cap'', which might be useful for avoiding or
 	  controlling oversubscription.
+	  See Documentation/scheduler/sched-deadline.txt for more.
=20
 choice
 	depends on GROUP_SCHED
--=20
1.6.0.4


--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-oC/YK2sOvW6Rk37i0iEK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkrYlYsACgkQk4XaBE3IOsQ/tgCeJQOY6w7x1nDvTm2PO27TYv55
2vwAmwX4UeDclPgvcgxmQWE1iER1Ga8/
=nxA9
-----END PGP SIGNATURE-----

--=-oC/YK2sOvW6Rk37i0iEK--

