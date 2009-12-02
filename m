Return-Path: <linux-kernel-owner+w=401wt.eu-S1753518AbZLBHuT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518AbZLBHuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 02:50:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750759AbZLBHuS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 02:50:18 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:34275 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359AbZLBHuR (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;4:1>);
	Wed, 2 Dec 2009 02:50:17 -0500
Message-Id: <4B162A3C0200007800022F98@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 02 Dec 2009 07:50:04 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: <mingo@elte.hu>, <tglx@linutronix.de>, <hpa@zytor.com>
Cc: <stable@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86/mce: timer must be setup unconditionally
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part153F453C.3__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part153F453C.3__=
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

mce_timer must be passed to setup_timer() in all cases, no matter
whether it is going to be actually used. Otherwise, when the CPU gets
brought down, its call to del_timer_sync() will never return, as the
timer won't have a base associated, and hence lock_timer_base() will
loop infinitely.

(Patch applying to -tip is attached.)

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: <stable@kernel.org>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-2.6.32-rc8/arch/x86/kernel/cpu/mcheck/mce.c
+++ 2.6.32-rc8-x86-mce-setup-timer-always/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1374,13 +1374,14 @@ static void mce_init_timer(void)
 	struct timer_list *t =3D &__get_cpu_var(mce_timer);
 	int *n =3D &__get_cpu_var(mce_next_interval);
=20
+	setup_timer(t, mcheck_timer, smp_processor_id());
+
 	if (mce_ignore_ce)
 		return;
=20
 	*n =3D check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires =3D round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }




--=__Part153F453C.3__=
Content-Type: text/plain; name="linux-tip-x86-mce-setup-timer-always.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="linux-tip-x86-mce-setup-timer-always.patch"

mce_timer must be passed to setup_timer() in all cases, no matter=0Awhether=
 it is going to be actually used. Otherwise, when the CPU gets=0Abrought =
down, its call to del_timer_sync() will never return, as the=0Atimer won't =
have a base associated, and hence lock_timer_base() will=0Aloop infinitely.=
=0A=0ASigned-off-by: Jan Beulich <jbeulich@novell.com>=0ACc: <stable@kernel=
.org>=0A=0A---=0A arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-=0A 1 file =
changed, 2 insertions(+), 1 deletion(-)=0A=0A--- a/arch/x86/kernel/cpu/mche=
ck/mce.c=0A+++ b/arch/x86/kernel/cpu/mcheck/mce.c=0A@@ -1388,13 +1388,14 =
@@ static void __mcheck_cpu_init_timer(=0A 	struct timer_list *t =3D =
&__get_cpu_var(mce_timer);=0A 	int *n =3D &__get_cpu_var(mce_next_interval=
);=0A =0A+	setup_timer(t, mce_start_timer, smp_processor_id());=0A+=0A=
 	if (mce_ignore_ce)=0A 		return;=0A =0A 	*n =3D check_interv=
al * HZ;=0A 	if (!*n)=0A 		return;=0A-	setup_timer(t, =
mce_start_timer, smp_processor_id());=0A 	t->expires =3D round_jiffie=
s(jiffies + *n);=0A 	add_timer_on(t, smp_processor_id());=0A }=0A
--=__Part153F453C.3__=--
