Return-Path: <linux-kernel-owner+w=401wt.eu-S1761783AbXIZSpg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761783AbXIZSpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:45:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754467AbXIZSp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:45:27 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:10178 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbXIZSp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:45:26 -0400
Message-Id: <46FA545D0200006C0001930D@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 26 Sep 2007 12:45:17 -0600
From: "David Bahi" <dbahi@novell.com>
To: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Cc: <rostedt@goodmis.org>, <tglx@linutronix.de>,
       "Gregory Haskins" <GHaskins@novell.com>
Subject: [PATCH 1/1] nmi_watchdog: x86_64 count timer and hpet like
	i386
References: <46FA4AE7020000FC00012412@sinclair.provo.novell.com>
 <46FA545D0200006C0001930D@sinclair.provo.novell.com>
In-Reply-To: <46FA545D0200006C0001930D@sinclair.provo.novell.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartD1F660AD.2__="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=__PartD1F660AD.2__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

This modifies nmi_watchdog_tick behavior for x86_64 arch to=20
consider both timer and pit/hpet IRQs just as the i386 arch does.

Without this fix a kernel crash occurs very early in the boot=20
process if nmi_watchdog is on.

Signed-off-by: David Bahi <dbahi@novell.com>

---
 arch/x86_64/kernel/nmi.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

Index: linux-2.6.22.8-rt9_1267/arch/x86_64/kernel/nmi.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.22.8-rt9_1267.orig/arch/x86_64/kernel/nmi.c
+++ linux-2.6.22.8-rt9_1267/arch/x86_64/kernel/nmi.c
@@ -369,8 +369,6 @@ int notrace __kprobes nmi_watchdog_tick(
                touched =3D 1;
        }
=20
-       sum =3D read_pda(apic_timer_irqs);
-
        if (__get_cpu_var(nmi_touch)) {
                __get_cpu_var(nmi_touch) =3D 0;
                touched =3D 1;
@@ -386,6 +384,12 @@ int notrace __kprobes nmi_watchdog_tick(
                cpu_clear(cpu, backtrace_mask);
        }
=20
+       /*
+        * Take the local apic timer and PIT/HPET into account. We don't
+        * know which one is active, when we have highres/dyntick on
+        */
+       sum =3D read_pda(apic_timer_irqs) + kstat_cpu(cpu).irqs[0];
+
 #ifdef CONFIG_X86_MCE
        /* Could check oops_in_progress here too, but it's safer
           not too */



--=__PartD1F660AD.2__=
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC4yIChHTlUv
TGludXgpCgppRDhEQlFCRytxaTJIMjhKSFlhekxhUVJBbEJyQUtDSWxLOTczRVNJNmdFbWk1enVl
OUJoeXkzMlV3Q2ZTQzhBCldHbUNpTEVwMkRDa2Q3T242Umk1d0NNPQo9NUhTVgotLS0tLUVORCBQ
R1AgU0lHTkFUVVJFLS0tLS0KCg==

--=__PartD1F660AD.2__=--
