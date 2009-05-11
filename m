Return-Path: <linux-kernel-owner+w=401wt.eu-S1752334AbZEKGYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbZEKGYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 02:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751416AbZEKGYF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 02:24:05 -0400
Received: from araneidae.co.uk ([62.3.233.233]:4052 "EHLO araneidae.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751378AbZEKGYE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 02:24:04 -0400
Date: Mon, 11 May 2009 07:23:58 +0100 (BST)
From: Michael Abbott <michael@araneidae.co.uk>
To: Jan Engelhardt <jengelh@medozas.de>
cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] Re: /proc/uptime idle counter remains at 0
In-Reply-To: <alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
 <20090510191229.71f43f3c@skybase> <alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="682240-455491026-1242022758=:6983"
Content-ID: <Pine.LNX.4.64.0905110719530.7158@venus.araneidae.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--682240-455491026-1242022758=:6983
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Content-ID: <Pine.LNX.4.64.0905110719531.7158@venus.araneidae.co.uk>

On Mon, 11 May 2009, Jan Engelhardt wrote:
> On Sunday 2009-05-10 19:12, Martin Schwidefsky wrote:
> >> So, were the updates to uptime.c missed, or do we now live on with=20
> >> /proc/uptime constantly having 0?

Please, let's not do this -- it breaks my instrument (which currently=20
thinks the processor is overloaded).

> >The second paragraph from git commit 79741dd tells you more about this:
> >
> >In addition idle time is no more added to the stime of the idle=20
> >process. This field now contains the system time of the idle process as=
=20
> >it should be. On systems without VIRT_CPU_ACCOUNTING this will always=20
> >be zero as every tick that occurs while idle is running will be=20
> >accounted as idle time.
> >
> >The point is the semantics of the stime field for the idle process. The=
=20
> >stime field used to contain the real system time (cpu really did=20
> >something) of the idle process plus the idle time (cpu is stopped).=20
> >After the change the field only contains the real system time. Which is=
=20
> >ihmo much more useful, no?
>=20
> Actually doing something while idle would then probably be limited to=20
> CPUs that have no HLT instruction/state, like ancient i386, right?
>=20
> Are the semantics of /proc/uptime (more-or-less standardsly) defined=20
> somewhere, e.g. written down into a manual page?
>=20
> Nevertheless, one could argue that, hypothetically, some people or their=
=20
> scripts interpreted the second field as the time that there was no=20
> process running; sort of a minimalistic way to tell the average system=20
> use in % beyond the 1/5/15-loadavg counters. So the field could be kept,=
=20
> or now that 2nd place displays 0.00, be re-added. Depending on how=20
> =E2=80=9Cstandardized=E2=80=9D /proc/uptime's format is, the 0.00 could e=
ither stay=20
> as second position or move to third position.

I have to confess I don't really understand the logic of what's going on=20
here -- in particular, what does the idle process do other than account=20
for time when the processor has nothing useful to do?  It does seem to me=
=20
now that the .utime and .stime fields are now less than useful -- maybe=20
they can be deleted now?

I've always assumed that the second field of /proc/uptime was a simple=20
measure of time not spent doing real work, in other words a crude measure=
=20
of spare CPU resources.  My instrument basically uses the the two fields=20
of this file to compute a measure of CPU loading so it can raise an alert=
=20
if the CPU doesn't have enough spare (idle) capacity.

So as a simple solution, I've attached a patch where I just copy the idle=
=20
field processing from fs/proc/stat.c.  I expect that on a multi-processor=
=20
machine things may not be quite so simple -- as up time is in elapsed=20
wall-clock time, then so should idle time be, so we probably need to also=
=20
divide by the number of processors.  Afraid I don't have a multiprocessor=
=20
test system, and /proc/stat seems ok, so I've not made this refinement.


Date: Mon, 11 May 2009 07:14:19 +0100
Subject: [PATCH] Fix idle time field in /proc/uptime

Git commit 79741dd changes idle cputime accounting, but unfortunately
the /proc/uptime file hasn't caught up.  Here the idle time calculation
from /proc/stat is copied over.

Signed-off-by: Michael Abbott <michael.abbott@diamond.ac.uk>
---
 fs/proc/uptime.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/proc/uptime.c b/fs/proc/uptime.c
index df26aa8..0d531bf 100644
--- a/fs/proc/uptime.c
+++ b/fs/proc/uptime.c
@@ -2,6 +2,7 @@
 #include <linux/proc_fs.h>
 #include <linux/sched.h>
 #include <linux/time.h>
+#include <linux/kernel_stat.h>
 #include <asm/cputime.h>
=20
 static int proc_calc_metrics(char *page, char **start, off_t off,
@@ -23,8 +24,12 @@ static int uptime_read_proc(char *page, char **start, of=
f_t off, int count,
 {
 =09struct timespec uptime;
 =09struct timespec idle;
-=09int len;
-=09cputime_t idletime =3D cputime_add(init_task.utime, init_task.stime);
+=09int len, i;
+=09cputime_t idletime =3D 0;
+
+=09for_each_possible_cpu(i)=20
+=09=09idletime =3D cputime64_add(idletime, kstat_cpu(i).cpustat.idle);
+=09idletime =3D cputime64_to_clock_t(idletime);
=20
 =09do_posix_clock_monotonic_gettime(&uptime);
 =09monotonic_to_bootbased(&uptime);
--=20
1.6.1.3

--682240-455491026-1242022758=:6983--
