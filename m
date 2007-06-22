Return-Path: <linux-kernel-owner+w=401wt.eu-S1760677AbXFVWRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760677AbXFVWRD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 18:17:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760459AbXFVWQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 18:16:51 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:46264 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760386AbXFVWQt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 18:16:49 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v18
Date: Sat, 23 Jun 2007 01:16:28 +0300
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Dmitry Adamushko <dmitry.adamushko@gmail.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
References: <20070622220202.GA16872@elte.hu> <200706230109.08310.caglar@pardus.org.tr>
In-Reply-To: <200706230109.08310.caglar@pardus.org.tr>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1591549.gF3B4eDs7l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706230116.29615.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1591549.gF3B4eDs7l
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

23 Haz 2007 Cts tarihinde, S.=C3=87a=C4=9Flar Onur =C5=9Funlar=C4=B1 yazm=
=C4=B1=C5=9Ft=C4=B1:=20
> Hi Ingo;
>
> 23 Haz 2007 Cts tarihinde, Ingo Molnar =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9F=
t=C4=B1:
> > As usual, any sort of feedback, bugreport, fix and suggestion is more
> > than welcome!
>
> caglar@zangetsu linux-2.6 $ LC_ALL=3DC make
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CALL    scripts/checksyscalls.sh
>   CHK     include/linux/compile.h
>   CC      kernel/sched.o
> kernel/sched.c:745:28: sched_idletask.c: No such file or directory

Ahh and this happens with [1], grabbing sched_idletask.c from .18 one solve=
s=20
the problem...

Index: linux/kernel/sched_idletask.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
=2D-- /dev/null
+++ linux/kernel/sched_idletask.c
@@ -0,0 +1,68 @@
+/*
+ * idle-task scheduling class.
+ *
+ * (NOTE: these are not related to SCHED_IDLE tasks which are
+ *  handled in sched_fair.c)
+ */
+
+/*
+ * Idle tasks are unconditionally rescheduled:
+ */
+static void check_preempt_curr_idle(struct rq *rq, struct task_struct *p)
+{
+	resched_task(rq->idle);
+}
+
+static struct task_struct *pick_next_task_idle(struct rq *rq, u64 now)
+{
+	schedstat_inc(rq, sched_goidle);
+
+	return rq->idle;
+}
+
+/*
+ * It is not legal to sleep in the idle task - print a warning
+ * message if some code attempts to do it:
+ */
+static void
+dequeue_task_idle(struct rq *rq, struct task_struct *p, int sleep, u64 now)
+{
+	spin_unlock_irq(&rq->lock);
+	printk(KERN_ERR "bad: scheduling from the idle thread!\n");
+	dump_stack();
+	spin_lock_irq(&rq->lock);
+}
+
+static void put_prev_task_idle(struct rq *rq, struct task_struct *prev, u6=
4=20
now)
+{
+}
+
+static struct task_struct *load_balance_start_idle(struct rq *rq)
+{
+	return NULL;
+}
+
+static void task_tick_idle(struct rq *rq, struct task_struct *curr)
+{
+}
+
+/*
+ * Simple, special scheduling class for the per-CPU idle tasks:
+ */
+struct sched_class idle_sched_class __read_mostly =3D {
+	/* no enqueue/yield_task for idle tasks */
+
+	/* dequeue is not valid, we print a debug message there: */
+	.dequeue_task		=3D dequeue_task_idle,
+
+	.check_preempt_curr	=3D check_preempt_curr_idle,
+
+	.pick_next_task		=3D pick_next_task_idle,
+	.put_prev_task		=3D put_prev_task_idle,
+
+	.load_balance_start	=3D load_balance_start_idle,
+	/* no .load_balance_next for idle tasks */
+
+	.task_tick		=3D task_tick_idle,
+	/* no .task_new for idle tasks */
+};


[1]=20
http://people.redhat.com/mingo/cfs-scheduler/sched-cfs-v2.6.22-git-v18.patch

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1591549.gF3B4eDs7l
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGfEo9y7E6i0LKo6YRAtPnAKDK32kIpSv7aKttvVmfW6Dh1kbGXwCgrLeO
0gIk7hq0Pgp9guObc8iR1hY=
=rmeL
-----END PGP SIGNATURE-----

--nextPart1591549.gF3B4eDs7l--
