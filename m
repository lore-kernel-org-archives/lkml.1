Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936603Ab0B1T2Y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 14:28:24 -0500
Received: from ms01.sssup.it ([193.205.80.99]:37173 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S936463Ab0B1T2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 14:28:22 -0500
Subject: [RFC][PATCH 11/11] sched: add sched_dl documentation.
From: Raistlin <raistlin@linux.it>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Chris Friesen <cfriesen@nortel.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Darren Hart <darren@dvhart.com>, Henrik Austad <henrik@austad.us>,
       Johan Eker <johan.eker@ericsson.com>, "p.faure" <p.faure@akatech.ch>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Claudio Scordino <claudio@evidence.eu.com>,
       michael trimarchi <trimarchi@retis.sssup.it>,
       Fabio Checconi <fabio@gandalf.sssup.it>,
       Tommaso Cucinotta <t.cucinotta@sssup.it>,
       Juri Lelli <juri.lelli@gmail.com>,
       Nicola Manica <nicola.manica@gmail.com>,
       Luca Abeni <luca.abeni@unitn.it>
In-Reply-To: <1267383976.13676.79.camel@Palantir>
References: <1267383976.13676.79.camel@Palantir>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-IBXXONY2cFlBmJ+NMKU/"
Date: Sun, 28 Feb 2010 20:28:12 +0100
Message-ID: <1267385292.13676.102.camel@Palantir>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IBXXONY2cFlBmJ+NMKU/
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Add in Documentation/scheduler/ some hints about the design
choices, the usage and the future possible developments of the
sched_dl scheduling class and of the SCHED_DEADLINE policy.

Signed-off-by: Dario Faggioli <raistlin@linux.it>
---
 Documentation/scheduler/sched-deadline.txt |  188 ++++++++++++++++++++++++=
++++
 init/Kconfig                               |    1 +
 2 files changed, 189 insertions(+), 0 deletions(-)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/sch=
eduler/sched-deadline.txt
new file mode 100644
index 0000000..1ff0e1e
--- /dev/null
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -0,0 +1,188 @@
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
+  2.1 System wide settings
+  2.2 Task interface
+  2.3 Group interface
+  2.4 Default behavior
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
+ The SCHED_DEADLINE policy contained inside the sched_dl scheduling class =
is
+ basically an implementation of the Earliest Deadline First (EDF) scheduli=
ng
+ algorithm, augmented with a mechanism (called Constant Bandwidth Server, =
CBS)
+ that make it possible to isolate the behaviour of tasks between each othe=
r.
+
+
+1.1 Task scheduling
+-------------------
+
+ The typical -deadline task will be made up of a computation phase (instan=
ce)
+ which is activated on a periodic or sporadic fashion. The expected (maxim=
um)
+ duration of such computation is called the task's runtime; the time inter=
val
+ by which each instance need to be completed is called the task's relative
+ deadline. The task's absolute deadline is dynamically calculated as the
+ time instant a task (better, an instance) activates plus the relative
+ deadline.
+
+ The EDF algorithms selects the task with the smallest absolute deadline a=
s
+ the one to be executed first, while the CBS ensures each task to run for
+ at most the its runtime every (relative) deadline length time interval,
+ avoiding any interference between different tasks (bandwidth isolation).
+ Thanks to this feature, also tasks that do not strictly comply with the
+ computational model sketched above can effectively use the new policy.
+ IOW, there are no limitations on what kind of task can exploit this new
+ scheduling discipline, even if it must be said that it is particularly
+ suited for periodic or sporadic tasks that need guarantees on their
+ timing behaviour, e.g., multimedia, streaming, control applications, etc.
+
+
+1.2 Group scheduling
+----------------
+
+ In order of -deaadline scheduling to be effective and useful, it is impor=
tant
+ that some method of having the allocation of the available CPU bandwidth =
to
+ tasks and task groups under control.
+ This is usually called "admission control" and if it is not performed at =
all,
+ no guarantee can be given on the actual scheduling of the -deadline tasks=
.
+
+ Since when RT-throttling has been introduced each task group have a bandw=
idth
+ associated to itself, calculated as a certain amount of runtime over a
+ period. Moreover, to make it possible to manipulate such bandwidth,
+ readable/writable controls have been added to both procfs (for system
+ wide settings) and cgroupfs (for per-group settings).
+ Therefore, the same interface is being used for controlling the bandwidth
+ distrubution to -deadline tasks and task groups, i.e., new controls but
+ with similar names, equivalent meaning and with the same usage paradigm a=
re
+ added.
+
+ The main differences between deadline bandwidth management and RT-throttl=
ing
+ is that -deadline tasks have bandwidth on their own (while -rt ones doesn=
't!),
+ and thus we don't need a throttling mechanism in the groups, which can be
+ used nothing more than for admission control of tasks.
+
+ This means that what we check is the sum of the bandwidth of all the task=
s
+ belonging to the group stays, on each CPU, below the bandwidth of the gro=
up
+ itself.
+
+
+2. The Interface
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+2.1 System wide settings
+------------------------
+
+The system wide settings are configured under the /proc virtual file syste=
m:
+
+ The per-group controls that are added to the cgroupfs virtual file system=
 are:
+  * /proc/sys/kernel/sched_dl_runtime_us,
+  * /proc/sys/kernel/sched_dl_period_us,
+  * /proc/sys/kernel/sched_dl_total_bw.
+
+ The first two accepts (if written) and provides (if read) the new runtime=
 and
+ period, respectively, for each CPU.
+ The last one accepts (if written) the index of one online CPU, and it pro=
vides
+ (if read) the total amount of bandwidth currently alloceted on that CPU.
+
+ Settings are checked against the following limit:
+
+  * for the whole system, on each CPU:
+      rt_runtime / rt_period + dl_runtime + dl_period <=3D 100%
+
+
+2.2 Task interface
+------------------
+
+ Specifying a periodic/sporadic task that executes for a given amount of
+ runtime at each instance, and that is scheduled according to the usrgency=
 of
+ their own timing constraints needs, in general, a way of declaring:
+  - a (maximum/typical) instance execution time,
+  - a minimum interval between consecutive instances,
+  - a time constraint by which each instance must be completed.
+
+ Therefore:
+  * a new struct sched_param_ex, containing all the necessary fields is
+    provided;
+  * the new scheduling related syscalls that manipulate it, i.e.,
+    sched_setscheduler_ex(), sched_setparam_ex() and sched_getparam_ex()
+    are implemented.
+
+
+2.3 Group Interface
+-------------------
+
+ The per-group controls that are added to the cgroupfs virtual file system=
 are:
+  * /cgroup/<cgroup>/cpu.dl_runtime_us,
+  * /cgroup/<cgroup>/cpu.dl_period_us,
+  * /cgroup/<cgroup>/cpu.dl_total_bw.
+
+ The first two accepts (if written) and provides (if read) the new runtime=
 and
+ period, respectively, of the group for each CPU.
+ The last one accepts (if written) the index of one online CPU, and it pro=
vides
+ (if read) the total amount of bandwidth currently alloceted inside the gr=
oup
+ on that CPU.
+
+ Group settings are checked against the following limits:
+
+  * for the root group {r}, on each CPU:
+      dl_runtime_{r} / dl_period_{r} <=3D dl_runtime / dl_period
+
+  * for each group {i}, subgroup of group {j}, on each CPU:
+      dl_runtime_{i} / dl_period_{i} < 100%
+      \Sum_{i} dl_runtime_{i} / dl_period_{i} <=3D dl_runtime_{j} / dl_per=
iod_{j}
+
+ For more information on working with control groups,
+ Documentation/cgroups/cgroups.txt should be read.
+
+
+2.4 Default behavior
+---------------------
+
+The default values for system wide and root group dl_runtime and dl_period=
 are
+500000 over 1000000.  This means -deadline tasks and task groups can use a=
t
+most 5% bandwidth on each CPU.
+
+When a -deadline task fork a child, its dl_runtime is set to 0, which mean=
s
+someone must call sched_setscheduler_ex() on it, or it won't even start.
+
+When a new group is created, its dl_runtime is 0, which means someone must
+(try to) increase it before tasks can be added to the group.
+
+
+3. Future plans
+=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
+
+Still Missing parts:
+
+ - bandwidth reclaiming mechanisms, i.e., methods that avoid stopping the
+   tasks until their next deadline when overrunning. There are at least
+   three of them that are very simple, and patches are on their way;
+
+ - migration of tasks throughout push and pull (as in -rt) to make it
+   possible to deploy global-EDF scheduling. Patches are ready, they're
+   just being tested and adapted to this last version;
+
+ - refinements in deadline inheritance, especially regarding the possibili=
ty
+   of retaining bandwidth isolation among non-interacting tasks. This is
+   being studied from both theoretical and practical point of views, and
+   hopefully we can have some demonstrative code soon.
+
diff --git a/init/Kconfig b/init/Kconfig
index de57415..377caed 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -486,6 +486,7 @@ config DEADLINE_GROUP_SCHED
 	  tasks (and other groups) can be added to it only up to such
 	  "bandwidth cap", which might be useful for avoiding or
 	  controlling oversubscription.
+	  See Documentation/scheduler/sched-deadline.txt for more.
=20
 choice
 	depends on GROUP_SCHED
--=20
1.7.0

--=20
<<This happens because I choose it to happen!>> (Raistlin Majere)
----------------------------------------------------------------------
Dario Faggioli, ReTiS Lab, Scuola Superiore Sant'Anna, Pisa  (Italy)

http://blog.linux.it/raistlin / raistlin@ekiga.net /
dario.faggioli@jabber.org

--=-IBXXONY2cFlBmJ+NMKU/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkuKw8wACgkQk4XaBE3IOsTvrwCggeY8u8zt04Z5Kzlghlql1PDK
kdsAni3g9PVFEdvQbx69SUgoOUIaJIY/
=sIBH
-----END PGP SIGNATURE-----

--=-IBXXONY2cFlBmJ+NMKU/--

