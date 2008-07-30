Return-Path: <linux-kernel-owner+w=401wt.eu-S1757740AbYG3USV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757740AbYG3USV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 16:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753408AbYG3USG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 16:18:06 -0400
Received: from mailout10.t-online.de ([194.25.134.21]:49236 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752977AbYG3USE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 16:18:04 -0400
From: =?iso-8859-1?q?J=FCrgen_Mell?= <j.mell@t-online.de>
Reply-To: j.mell@t-online.de
To: Chirag Jog <chirag@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix Bug messages
Date: Wed, 30 Jul 2008 22:16:50 +0200
User-Agent: KMail/1.9.9
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       "rt-users" <linux-rt-users@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Clark Williams <williams@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Josh Triplett <josht@linux.vnet.ibm.com>,
       "Timothy R. Chavez" <tim.chavez@linux.vnet.ibm.com>
References: <alpine.LFD.1.10.0807252141420.574@apollo.tec.linutronix.de> <200807301101.32417.j.mell@t-online.de> <20080730171842.GB3420@linux.vnet.ibm.com>
In-Reply-To: <20080730171842.GB3420@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_zwMkIClYiFhP70E"
Message-Id: <200807302216.51211.j.mell@t-online.de>
X-ID: bRm6ZmZXYhXtYSoFqTpFGIsSP4aX3jBiVhDu4oUDblw1xVO34JF+fGsM4HrzGzdwVC
X-TOI-MSGID: 93ebc8e6-8ae6-4e53-8ffc-e6e4b93fe86b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_zwMkIClYiFhP70E
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Mittwoch, 30. Juli 2008, Chirag Jog wrote:
> * J?rgen Mell <j.mell@t-online.de> [2008-07-30 11:01:32]:
> > On Wednesday, 30. July 2008, Thomas Gleixner wrote:
> > > We are pleased to announce the 2.6.26-rt1 tree, which can be
> > > downloaded from the location:
> >
> > The bad news: It produces continuously lots of bug messages in the
> > error logs (cf. attached dmesg.tgz). The error at rtmutex.c:743 was
> > already present in 2.6.25-rt* when ACPI was enabled. The 'using
> > smp_processor_id ()  in preemptible code' is new here with 2.6.26.
> >
>
> This patch should solve some of the bug messages.
> It does two things:
> 1. Change rt_runtime_lock to be a raw spinlock as the comment above it
> says: it is nested inside the rq lock.
>
> 2. Change mnt_writers to be a per_cpu locked variable.
> This eliminates the need for the codepath to disable preemption and
> then potentially sleep, leading to the BUG messages
>
> Signed-Off-By: Chirag <chirag@linux.vnet.ibm.com>
>
>
>
> Index: linux-2.6.26-rt1/kernel/sched.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.26-rt1.orig/kernel/sched.c	2008-07-30 22:37:19.000000000
> +0530 +++ linux-2.6.26-rt1/kernel/sched.c	2008-07-30 22:37:24.000000000
> +0530 @@ -208,7 +208,7 @@
>
>  struct rt_bandwidth {
>  	/* nests inside the rq lock: */
> -	spinlock_t		rt_runtime_lock;
> +	raw_spinlock_t		rt_runtime_lock;
>  	ktime_t			rt_period;
>  	u64			rt_runtime;
>  	struct hrtimer		rt_period_timer;
> @@ -472,7 +472,7 @@
>  	u64 rt_time;
>  	u64 rt_runtime;
>  	/* Nests inside the rq lock: */
> -	spinlock_t rt_runtime_lock;
> +	raw_spinlock_t rt_runtime_lock;
>
>  #ifdef CONFIG_RT_GROUP_SCHED
>  	unsigned long rt_nr_boosted;
> Index: linux-2.6.26-rt1/fs/namespace.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.26-rt1.orig/fs/namespace.c	2008-07-30 22:39:30.000000000
> +0530 +++ linux-2.6.26-rt1/fs/namespace.c	2008-07-30 22:39:36.000000000
> +0530 @@ -178,13 +178,13 @@
>  	unsigned long count;
>  	struct vfsmount *mnt;
>  } ____cacheline_aligned_in_smp;
> -static DEFINE_PER_CPU(struct mnt_writer, mnt_writers);
> +static DEFINE_PER_CPU_LOCKED(struct mnt_writer, mnt_writers);
>
>  static int __init init_mnt_writers(void)
>  {
>  	int cpu;
>  	for_each_possible_cpu(cpu) {
> -		struct mnt_writer *writer =3D &per_cpu(mnt_writers, cpu);
> +		struct mnt_writer *writer =3D &per_cpu_var_locked(mnt_writers, cpu);
>  		spin_lock_init(&writer->lock);
>  		lockdep_set_class(&writer->lock, &writer->lock_class);
>  		writer->count =3D 0;
> @@ -199,7 +199,7 @@
>  	struct mnt_writer *cpu_writer;
>
>  	for_each_possible_cpu(cpu) {
> -		cpu_writer =3D &per_cpu(mnt_writers, cpu);
> +		cpu_writer =3D &per_cpu_var_locked(mnt_writers, cpu);
>  		spin_unlock(&cpu_writer->lock);
>  	}
>  }
> @@ -251,8 +251,8 @@
>  {
>  	int ret =3D 0;
>  	struct mnt_writer *cpu_writer;
> -
> -	cpu_writer =3D &get_cpu_var(mnt_writers);
> +	int cpu =3D 0;
> +	cpu_writer =3D &get_cpu_var_locked(mnt_writers, &cpu);
>  	spin_lock(&cpu_writer->lock);
>  	if (__mnt_is_readonly(mnt)) {
>  		ret =3D -EROFS;
> @@ -262,7 +262,7 @@
>  	cpu_writer->count++;
>  out:
>  	spin_unlock(&cpu_writer->lock);
> -	put_cpu_var(mnt_writers);
> +	put_cpu_var_locked(mnt_writers, cpu);
>  	return ret;
>  }
>  EXPORT_SYMBOL_GPL(mnt_want_write);
> @@ -273,7 +273,7 @@
>  	struct mnt_writer *cpu_writer;
>
>  	for_each_possible_cpu(cpu) {
> -		cpu_writer =3D &per_cpu(mnt_writers, cpu);
> +		cpu_writer =3D &per_cpu_var_locked(mnt_writers, cpu);
>  		spin_lock(&cpu_writer->lock);
>  		__clear_mnt_count(cpu_writer);
>  		cpu_writer->mnt =3D NULL;
> @@ -332,8 +332,8 @@
>  {
>  	int must_check_underflow =3D 0;
>  	struct mnt_writer *cpu_writer;
> -
> -	cpu_writer =3D &get_cpu_var(mnt_writers);
> +	int cpu =3D 0;
> +	cpu_writer =3D &get_cpu_var_locked(mnt_writers, &cpu);
>  	spin_lock(&cpu_writer->lock);
>
>  	use_cpu_writer_for_mount(cpu_writer, mnt);
> @@ -360,7 +360,7 @@
>  	 * __mnt_writers can underflow.  Without it,
>  	 * we could theoretically wrap __mnt_writers.
>  	 */
> -	put_cpu_var(mnt_writers);
> +	put_cpu_var_locked(mnt_writers, cpu);
>  }
>  EXPORT_SYMBOL_GPL(mnt_drop_write);
>
> @@ -612,7 +612,7 @@
>  	 * can come in.
>  	 */
>  	for_each_possible_cpu(cpu) {
> -		struct mnt_writer *cpu_writer =3D &per_cpu(mnt_writers, cpu);
> +		struct mnt_writer *cpu_writer =3D &per_cpu_var_locked(mnt_writers,
> cpu); if (cpu_writer->mnt !=3D mnt)
>  			continue;
>  		spin_lock(&cpu_writer->lock);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-rt-users" in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Yes, the number of bug messages is reduced very much by this patch,=20
although both messages are still present in the log (cf. attached dmesg).=20
But with the patch they only occur sporadically after the system has=20
completed start-up and no longer continuously. Thanks a lot!

Bye,
           J=FCrgen

--Boundary-00=_zwMkIClYiFhP70E
Content-Type: application/x-tgz;
  name="dmesg.tgz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="dmesg.tgz"

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

--Boundary-00=_zwMkIClYiFhP70E--
