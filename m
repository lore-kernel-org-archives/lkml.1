Return-Path: <linux-kernel-owner+w=401wt.eu-S1761678AbXIZSX5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761678AbXIZSX5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:23:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759030AbXIZSX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:23:28 -0400
Received: from sinclair.provo.novell.com ([137.65.248.137]:9516 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758546AbXIZSX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:23:27 -0400
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 14:23:27 EDT
Message-Id: <46FA4A800200006C000192FE@sinclair.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 26 Sep 2007 12:03:12 -0600
From: "David Bahi" <dbahi@novell.com>
To: <linux-kernel@vger.kernel.org>, <linux-rt-users@vger.kernel.org>
Cc: <tglx@linutronix.de>, "Gregory Haskins" <GHaskins@novell.com>
Subject: nmi_watchdog fix for x86_64 to be more like i386
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__PartBA9D0BF0.1__="
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--=__PartBA9D0BF0.1__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Thanks to tglx and ghaskins for all the help in tracking down a very
early nmi_watchdog crash on certain x86_64 machines.


--=__PartBA9D0BF0.1__=
Content-Type: text/plain; name="watchdog_use_timer_and_hpet_on_x86_64.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="watchdog_use_timer_and_hpet_on_x86_64.patch"

This modifies nmi_watchdog_tick behavior for=20
x86_64 arch to consider both timer and hpet IRQs
just as the i386 arch does.

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
-	sum =3D read_pda(apic_timer_irqs);
-
 	if (__get_cpu_var(nmi_touch)) {
 		__get_cpu_var(nmi_touch) =3D 0;
 		touched =3D 1;
@@ -386,6 +384,12 @@ int notrace __kprobes nmi_watchdog_tick(
 		cpu_clear(cpu, backtrace_mask);
 	}
=20
+	/*
+	 * Take the local apic timer and PIT/HPET into account. We don't
+	 * know which one is active, when we have highres/dyntick on
+	 */
+	sum =3D read_pda(apic_timer_irqs) + kstat_cpu(cpu).irqs[0];
+
 #ifdef CONFIG_X86_MCE
 	/* Could check oops_in_progress here too, but it's safer
 	   not too */

--=__PartBA9D0BF0.1__=
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="signature.asc"

LS0tLS1CRUdJTiBQR1AgU0lHTkFUVVJFLS0tLS0KVmVyc2lvbjogR251UEcgdjEuNC4yIChHTlUv
TGludXgpCgppRDhEQlFCRytwMzFIMjhKSFlhekxhUVJBZ1FYQUo0eitpbXBpNDg2M25kaUh4RnhS
UDVyeGVUN1FBQ2d3dmpICjdpck12eWZZcGc3ajh4a0M4WmNQdVd3PQo9YlpDeAotLS0tLUVORCBQ
R1AgU0lHTkFUVVJFLS0tLS0KCg==

--=__PartBA9D0BF0.1__=--
