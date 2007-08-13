Return-Path: <linux-kernel-owner+w=401wt.eu-S1031773AbXHMPT4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031773AbXHMPT4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 11:19:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969266AbXHMNIY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 09:08:24 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:34011 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031146AbXHMNIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 09:08:18 -0400
Message-ID: <46C057C0.7020003@bull.net>
Date: Mon, 13 Aug 2007 15:08:16 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Avi Kivity <avi@qumranet.com>
Cc: kvm-devel <kvm-devel@lists.sourceforge.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       virtualization <virtualization@lists.linux-foundation.org>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [kvm-devel] [PATCH 0/2][KVM] guest time accounting
References: <46BC8B39.6050202@bull.net> <46C00FC1.1070306@qumranet.com> <46C012A8.2040908@bull.net> <46C01877.7060007@qumranet.com>
In-Reply-To: <46C01877.7060007@qumranet.com>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 15:13:19,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 13/08/2007 15:13:20,
	Serialize complete at 13/08/2007 15:13:20
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig3A84E6FF9C7F3F20A6623399"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig3A84E6FF9C7F3F20A6623399
Content-Type: multipart/mixed;
 boundary="------------080702060106080804090907"

This is a multi-part message in MIME format.
--------------080702060106080804090907
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Avi Kivity wrote:
> Laurent Vivier wrote:
>>> - perhaps the new fields should be guarded by a #ifdef CONFIG_HYPERVI=
SOR
>>> (selected by CONFIG_KVM)?  that way the (minor) additional overhead i=
s
>>> only incurred if it can possibly be used.  I imagine that our canine
>>> cousin will want to use this as well.
>>>    =20
>>
>> There is also a CONFIG_VIRTUALIZATION and a CONFIG_VIRT_CPU_ACCOUNTING=

>> (from
>> s390 and powerpc) Which one to use ?
>>  =20
>=20
> Are these options for using the kernel as a guest or host?  I'd guess
> the former.

I didn't find CONFIG_HYPERVISOR.
The good one seems to be CONFIG_VIRTUALIZATION that is used to activate C=
ONFIG_KVM.

>> I'm wondering if we can have a more accurate accounting:
>>
>> - For the moment we add all system time since the previous entering to=

>> the VCPU
>> to the guest time (and I guess there is some real system time in it ??=
?)
>>
>> - Perhaps we can sum nanoseconds spent in the VCPU and add it to
>> cpustat when
>> these ns are greater than 1 ms ? (I'm trying to make something in this=

>> way)
>>  =20

Ingo (or other guru), could you have a look to the attached patch, it is =
what I
was thinking about when I wrote this.

Laurent
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------080702060106080804090907
Content-Type: text/plain;
 name="kvm_stat_guest"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline;
 filename="kvm_stat_guest"

Index: kvm/drivers/kvm/vmx.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kvm.orig/drivers/kvm/vmx.c	2007-08-13 14:11:38.000000000 +0200
+++ kvm/drivers/kvm/vmx.c	2007-08-13 14:29:44.000000000 +0200
@@ -2052,6 +2052,7 @@
 	struct vcpu_vmx *vmx =3D to_vmx(vcpu);
 	u8 fail;
 	int r;
+	ktime_t now, delta;
=20
 preempted:
 	if (vcpu->guest_debug.enabled)
@@ -2078,6 +2079,7 @@
 	local_irq_disable();
=20
 	vcpu->guest_mode =3D 1;
+	now =3D ktime_get();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    vmx_flush_tlb(vcpu);
@@ -2198,6 +2200,8 @@
 		[cr2]"i"(offsetof(struct kvm_vcpu, cr2))
 	      : "cc", "memory" );
=20
+	delta =3D ktime_sub(ktime_get(), now);
+	current->vtime =3D ktime_add(current->vtime, delta);
 	vcpu->guest_mode =3D 0;
 	local_irq_enable();
=20
Index: kvm/include/linux/sched.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kvm.orig/include/linux/sched.h	2007-08-13 14:25:58.000000000 +0200
+++ kvm/include/linux/sched.h	2007-08-13 14:29:44.000000000 +0200
@@ -1192,6 +1192,9 @@
 #ifdef CONFIG_FAULT_INJECTION
 	int make_it_fail;
 #endif
+#ifdef CONFIG_VIRTUALIZATION
+	ktime_t vtime;
+#endif
 };
=20
 /*
Index: kvm/kernel/sched.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kvm.orig/kernel/sched.c	2007-08-13 14:11:38.000000000 +0200
+++ kvm/kernel/sched.c	2007-08-13 14:34:47.000000000 +0200
@@ -3212,6 +3212,29 @@
 	return ns;
 }
=20
+#ifdef CONFIG_VIRTUALIZATION
+static cputime_t account_guest_time(struct task_struct *p, cputime_t cpu=
time)
+{
+	struct cpu_usage_stat *cpustat =3D &kstat_this_cpu.cpustat;
+	ktime_t kmsec =3D ktime_set(0, NSEC_PER_MSEC);
+	cputime_t cmsec =3D msecs_to_cputime(1);
+
+	while ((ktime_to_ns(p->vtime) >=3D NSEC_PER_MSEC) &&
+	       (cputime_to_msecs(cputime) >=3D 1)) {
+		p->vtime =3D ktime_sub(p->vtime, kmsec);
+		p->utime =3D cputime_add(p->utime, cmsec);
+
+		cputime =3D cputime_sub(cputime, cmsec);
+
+		cpustat->guest =3D cputime64_add(cpustat->guest,
+				cputime_to_cputime64(cmsec));
+		cpustat->user =3D cputime64_add(cpustat->user,
+				cputime_to_cputime64(cmsec));
+	}
+	return cputime;
+}
+#endif
+
 /*
  * Account user cpu time to a process.
  * @p: the process that the cpu time gets accounted to
@@ -3246,6 +3269,10 @@
 	struct rq *rq =3D this_rq();
 	cputime64_t tmp;
=20
+#ifdef CONFIG_VIRTUALIZATION
+	cputime =3D account_guest_time(p, cputime);
+#endif
+
 	p->stime =3D cputime_add(p->stime, cputime);
=20
 	/* Add system time to cpustat. */
Index: kvm/drivers/kvm/svm.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- kvm.orig/drivers/kvm/svm.c	2007-08-13 14:31:16.000000000 +0200
+++ kvm/drivers/kvm/svm.c	2007-08-13 14:33:10.000000000 +0200
@@ -1392,6 +1392,7 @@
 	u16 gs_selector;
 	u16 ldt_selector;
 	int r;
+	ktime_t now, delta;
=20
 again:
 	r =3D kvm_mmu_reload(vcpu);
@@ -1404,6 +1405,7 @@
 	clgi();
=20
 	vcpu->guest_mode =3D 1;
+	now =3D ktime_get();
 	if (vcpu->requests)
 		if (test_and_clear_bit(KVM_TLB_FLUSH, &vcpu->requests))
 		    svm_flush_tlb(vcpu);
@@ -1536,6 +1538,8 @@
 #endif
 		: "cc", "memory" );
=20
+	delta =3D ktime_sub(ktime_get(), now);
+	current->vtime =3D ktime_add(current->vtime, delta);
 	vcpu->guest_mode =3D 0;
=20
 	if (vcpu->fpu_active) {

--------------080702060106080804090907--

--------------enig3A84E6FF9C7F3F20A6623399
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFGwFfE9Kffa9pFVzwRAjzaAJ0XoOmk/d9sGaINf9r/1h2/7QyJ5wCgmGKq
f7UIoOvKWjWQRrGGT5JO2V4=
=Gc+L
-----END PGP SIGNATURE-----

--------------enig3A84E6FF9C7F3F20A6623399--
