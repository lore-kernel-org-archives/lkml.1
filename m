Return-Path: <linux-kernel-owner+w=401wt.eu-S1754111AbYJCRsH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbYJCRsH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 13:48:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752935AbYJCRrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 13:47:55 -0400
Received: from ms01.sssup.it ([193.205.80.99]:45395 "EHLO sssup.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752332AbYJCRrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 13:47:55 -0400
X-Greylist: delayed 3599 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Oct 2008 13:47:54 EDT
Subject: [PATCH] sched_rt.c: resch needed in rt_rq_enqueue() for the root
	rt_rq
From: Dario Faggioli <raistlin@linux.it>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Michael Trimarchi <trimarchimichael@yahoo.it>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5/ttfLF2kyKWjOHrVugj"
Date: Fri, 03 Oct 2008 17:40:46 +0200
Message-Id: <1223048447.6714.46.camel@Palanthas>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5/ttfLF2kyKWjOHrVugj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi all,

While working on the new version of the code for SCHED_SPORADIC I
noticed something strange in the present throttling mechanism. More
specifically in the throttling timer handler in sched_rt.c
(do_sched_rt_period_timer()) and in rt_rq_enqueue().

The problem is that, when unthrottling a runqueue, rt_rq_enqueue() only
asks for rescheduling if the runqueue has a sched_entity associated to
it (i.e., rt_rq->rt_se !=3D NULL).
Now, if the runqueue is the root rq (which has a rt_se =3D NULL)
rescheduling does not take place, and it is delayed to some undefined
instant in the future.

This imply some random bandwidth usage by the RT tasks under throttling.
For instance, setting rt_runtime_us/rt_period_us =3D 950ms/1000ms an RT
task will get less than 95%. In our tests we got something varying
between 70% to 95%.
Using smaller time values, e.g., 95ms/100ms, things are even worse, and
I can see values also going down to 20-25%!!

The tests we performed are simply running 'yes' as a SCHED_FIFO task,
and checking the CPU usage with top, but we can investigate thoroughly
if you think it is needed.

Things go much better, for us, with the attached patch... Don't know if
it is the best approach, but it solved the issue for us.

Best Regards,
Dario Faggioli

---
Signed-off-by: Dario Faggioli <raistlin@linux.it>
Signed-off-by: Michael Trimarchi <trimarchimichael@yahoo.it>
---
diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
index 1113157..37f0721 100644
--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -102,12 +102,12 @@ static void dequeue_rt_entity(struct sched_rt_entity =
*rt_se);
=20
 static void sched_rt_rq_enqueue(struct rt_rq *rt_rq)
 {
+	struct task_struct *curr =3D rq_of_rt_rq(rt_rq)->curr;
 	struct sched_rt_entity *rt_se =3D rt_rq->rt_se;
=20
-	if (rt_se && !on_rt_rq(rt_se) && rt_rq->rt_nr_running) {
-		struct task_struct *curr =3D rq_of_rt_rq(rt_rq)->curr;
-
-		enqueue_rt_entity(rt_se);
+	if (rt_rq->rt_nr_running) {
+		if (rt_se && !on_rt_rq(rt_se))
+			enqueue_rt_entity(rt_se);
 		if (rt_rq->highest_prio < curr->prio)
 			resched_task(curr);
 	}

--=20
<<This happens because I choose it to happen!>>
(Raistlin Majere, DragonLance Chronicles -Dragons of Spring Drawning-)
----------------------------------------------------------------------
Dario Faggioli
GNU/Linux Registered User: #340657
Web: http://www.linux.it/~raistlin
Blog: http://blog.linux.it/raistlin
SIP Account: dario.faggioli@sipproxy.wengo.fr or
             raistlin@ekiga.net
Jabber Account: dario.faggioli@jabber.org/WengoPhone
GnuPG Key ID: 4DC83AC4
GnuPG Key Fingerprint: 2A78 AD5D B9CF A082 0836 08AD 9385 DA04 4DC8 3AC4

--=-5/ttfLF2kyKWjOHrVugj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBI5jz+k4XaBE3IOsQRAq9gAJ9EadnhW3Q7pmBgfhOF3mQNvIahnwCgihQY
3kVH6t+dMYHgruVdzUKUq6Q=
=WMst
-----END PGP SIGNATURE-----

--=-5/ttfLF2kyKWjOHrVugj--

