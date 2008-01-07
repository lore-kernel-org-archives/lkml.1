Return-Path: <linux-kernel-owner+w=401wt.eu-S1756250AbYAGL4o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbYAGL4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 06:56:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYAGL4f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 06:56:35 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:41228 "EHLO
	viefep12-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754345AbYAGL4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 06:56:34 -0500
Subject: Re: [PATCH 04/11] hrtimer: fixup the HRTIMER_CB_IRQSAFE_NO_SOFTIRQ
	fallback
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       dmitry.adamushko@gmail.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080106162123.431344000@chello.nl>
References: <20080106161128.152634000@chello.nl>
	 <20080106162123.431344000@chello.nl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VMr4boGlbNeTFDX0w89C"
Date: Mon, 07 Jan 2008 12:56:28 +0100
Message-Id: <1199706988.7143.30.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VMr4boGlbNeTFDX0w89C
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Sun, 2008-01-06 at 17:11 +0100, Peter Zijlstra wrote:
> plain text document attachment (hrtimer-fallback.patch)


I know I should have boot tested more combinations :-(
Please fold this into the patch.


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/hrtimer.c |   38 ++++++++++++++++++--------------------
 1 file changed, 18 insertions(+), 20 deletions(-)

Index: linux-2.6/kernel/hrtimer.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.orig/kernel/hrtimer.c
+++ linux-2.6/kernel/hrtimer.c
@@ -325,6 +325,22 @@ unsigned long ktime_divns(const ktime_t=20
 }
 #endif /* BITS_PER_LONG >=3D 64 */
=20
+/*
+ * Check, whether the timer is on the callback pending list
+ */
+static inline int hrtimer_cb_pending(const struct hrtimer *timer)
+{
+	return timer->state & HRTIMER_STATE_PENDING;
+}
+
+/*
+ * Remove a timer from the callback pending list
+ */
+static inline void hrtimer_remove_cb_pending(struct hrtimer *timer)
+{
+	list_del_init(&timer->cb_entry);
+}
+
 /* High resolution timer related functions */
 #ifdef CONFIG_HIGH_RES_TIMERS
=20
@@ -494,29 +510,12 @@ void hres_timers_resume(void)
 }
=20
 /*
- * Check, whether the timer is on the callback pending list
- */
-static inline int hrtimer_cb_pending(const struct hrtimer *timer)
-{
-	return timer->state & HRTIMER_STATE_PENDING;
-}
-
-/*
- * Remove a timer from the callback pending list
- */
-static inline void hrtimer_remove_cb_pending(struct hrtimer *timer)
-{
-	list_del_init(&timer->cb_entry);
-}
-
-/*
  * Initialize the high resolution related parts of cpu_base
  */
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base)
 {
 	base->expires_next.tv64 =3D KTIME_MAX;
 	base->hres_active =3D 0;
-	INIT_LIST_HEAD(&base->cb_pending);
 }
=20
 /*
@@ -524,7 +523,6 @@ static inline void hrtimer_init_hres(str
  */
 static inline void hrtimer_init_timer_hres(struct hrtimer *timer)
 {
-	INIT_LIST_HEAD(&timer->cb_entry);
 }
=20
 /*
@@ -618,8 +616,6 @@ static inline int hrtimer_enqueue_reprog
 {
 	return 0;
 }
-static inline int hrtimer_cb_pending(struct hrtimer *timer) { return 0; }
-static inline void hrtimer_remove_cb_pending(struct hrtimer *timer) { }
 static inline void hrtimer_init_hres(struct hrtimer_cpu_base *base) { }
 static inline void hrtimer_init_timer_hres(struct hrtimer *timer) { }
 static inline int hrtimer_reprogram(struct hrtimer *timer,
@@ -1006,6 +1002,7 @@ void hrtimer_init(struct hrtimer *timer,
 		clock_id =3D CLOCK_MONOTONIC;
=20
 	timer->base =3D &cpu_base->clock_base[clock_id];
+	INIT_LIST_HEAD(&timer->cb_entry);
 	hrtimer_init_timer_hres(timer);
=20
 #ifdef CONFIG_TIMER_STATS
@@ -1419,6 +1416,7 @@ static void __devinit init_hrtimers_cpu(
 	for (i =3D 0; i < HRTIMER_MAX_CLOCK_BASES; i++)
 		cpu_base->clock_base[i].cpu_base =3D cpu_base;
=20
+	INIT_LIST_HEAD(&cpu_base->cb_pending);
 	hrtimer_init_hres(cpu_base);
 }
=20



--=-VMr4boGlbNeTFDX0w89C
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHghNsXA2jU0ANEf4RAov3AKCGsYtW+r5R7AIE0uep7uj/Fyo0zgCfZmp7
jHgXPXpPaS2H+GfUqF6irZ0=
=kLGj
-----END PGP SIGNATURE-----

--=-VMr4boGlbNeTFDX0w89C--

