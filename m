Return-Path: <linux-kernel-owner+w=401wt.eu-S1758151AbYGNVCY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151AbYGNVCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 17:02:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756632AbYGNVCP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 17:02:15 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43710 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348AbYGNVCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 17:02:14 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Linux Power Management List <linux-pm@lists.osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Mon, 14 Jul 2008 16:02:00 -0500
Subject: [RFC-PATCH] Improve Menu Governor Prediction of interrupted C
 states.
Thread-Topic: [RFC-PATCH] Improve Menu Governor Prediction of interrupted C
 states.
Thread-Index: Acjl9NwKQ0on4gDvSK+0rYSuOpnIRw==
Message-ID: <13B9B4C6EF24D648824FF11BE8967162035BEA0EDF@dlee02.ent.ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_13B9B4C6EF24D648824FF11BE8967162035BEA0EDFdlee02enttico_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_13B9B4C6EF24D648824FF11BE8967162035BEA0EDFdlee02enttico_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi,

Any comments on the following?

I'm finding with high interrupt rates for some USB devices the menu governo=
r guesses wrong enough that throughput drops.

With the below tweak tests with fixed data sizes which were taking 12s to c=
omplete drop back to 9s.  Also my standby idle doesn't change before and af=
ter activity with our with out the patch.

What it does is simply timestamp incoming irqs, then in the menu governor w=
ill use current & last irq time delta to refine its guess as to how long sl=
eep will happen.

Regards,
Richard W.

Signed-off-by: Richard Woodruff <r-woodruff2@ti.com>

diff -purN img/2.6_kernel/arch/arm/kernel/irq.c 2.6_kernel/arch/arm/kernel/=
irq.c
--- img/2.6_kernel/arch/arm/kernel/irq.c        2008-04-03 22:43:09.0000000=
00 -0500
+++ 2.6_kernel/arch/arm/kernel/irq.c    2008-07-14 15:09:48.000000000 -0500
@@ -122,6 +131,8 @@ asmlinkage void __exception asm_do_IRQ(u

        irq_enter();

+       kstat_irq_stamp();
+
        desc_handle_irq(irq, desc);

        /* AT91 specific workaround */
diff -purN img/2.6_kernel/drivers/cpuidle/governors/menu.c 2.6_kernel/drive=
rs/cpuidle/governors/menu.c
--- img/2.6_kernel/drivers/cpuidle/governors/menu.c     2008-07-04 15:31:23=
.000000000 -0500
+++ 2.6_kernel/drivers/cpuidle/governors/menu.c 2008-07-14 15:22:55.0000000=
00 -0500
@@ -7,6 +7,7 @@
  */

 #include <linux/kernel.h>
+#include <linux/kernel_stat.h>
 #include <linux/cpuidle.h>
 #include <linux/latency.h>
 #include <linux/time.h>
@@ -70,6 +71,7 @@ static void menu_reflect(struct cpuidle_
        unsigned int measured_us =3D
                cpuidle_get_last_residency(dev) + data->elapsed_us;
        struct cpuidle_state *target =3D &dev->states[last_idx];
+       const unsigned int cpu =3D smp_processor_id();

        /*
         * Ugh, this idle state doesn't support residency measurements, so =
we
@@ -92,6 +94,10 @@ static void menu_reflect(struct cpuidle_
                        data->elapsed_us =3D -1;
                data->predicted_us =3D max(measured_us, data->last_measured=
_us);
        }
+
+       /* Guess & factor in interrupt wake rate */
+       data->predicted_us =3D min((s64)data->predicted_us, ktime_to_us(
+               ktime_sub(kstat_cpu(cpu).irq_now, kstat_cpu(cpu).irq_last))=
);
 }

 /**
diff -purN img/2.6_kernel/include/linux/kernel_stat.h 2.6_kernel/include/li=
nux/kernel_stat.h
--- img/2.6_kernel/include/linux/kernel_stat.h  2008-04-03 21:51:50.0000000=
00 -0500
+++ 2.6_kernel/include/linux/kernel_stat.h      2008-07-14 13:11:09.0000000=
00 -0500
@@ -7,6 +7,7 @@
 #include <linux/percpu.h>
 #include <linux/cpumask.h>
 #include <asm/cputime.h>
+#include <linux/hrtimer.h>

 /*
  * 'kernel_stat.h' contains the definitions needed for doing
@@ -29,6 +30,8 @@ struct cpu_usage_stat {
 struct kernel_stat {
        struct cpu_usage_stat   cpustat;
        unsigned int irqs[NR_IRQS];
+       ktime_t irq_now;
+       ktime_t irq_last;
 };

 DECLARE_PER_CPU(struct kernel_stat, kstat);
@@ -52,6 +55,16 @@ static inline int kstat_irqs(int irq)
        return sum;
 }

+/*
+ * Provide hook to try and understand interrupt rate on a processor
+ */
+static inline void kstat_irq_stamp(void)
+{
+       const unsigned int cpu =3D smp_processor_id();
+       kstat_cpu(cpu).irq_last =3D kstat_cpu(cpu).irq_now;
+       kstat_cpu(cpu).irq_now =3D ktime_get();
+}
+
 extern void account_user_time(struct task_struct *, cputime_t);
 extern void account_user_time_scaled(struct task_struct *, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t);

--_002_13B9B4C6EF24D648824FF11BE8967162035BEA0EDFdlee02enttico_
Content-Type: application/octet-stream; name="menu_gov_irq_guess.diff"
Content-Description: menu_gov_irq_guess.diff
Content-Disposition: attachment; filename="menu_gov_irq_guess.diff";
	size=2725; creation-date="Mon, 14 Jul 2008 15:25:31 GMT";
	modification-date="Mon, 14 Jul 2008 15:25:31 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtcHVyTiBpbWcvMi42X2tlcm5lbC9hcmNoL2FybS9rZXJuZWwvaXJxLmMgMi42X2tlcm5l
bC9hcmNoL2FybS9rZXJuZWwvaXJxLmMKLS0tIGltZy8yLjZfa2VybmVsL2FyY2gvYXJtL2tlcm5l
bC9pcnEuYwkyMDA4LTA0LTAzIDIyOjQzOjA5LjAwMDAwMDAwMCAtMDUwMAorKysgMi42X2tlcm5l
bC9hcmNoL2FybS9rZXJuZWwvaXJxLmMJMjAwOC0wNy0xNCAxNTowOTo0OC4wMDAwMDAwMDAgLTA1
MDAKQEAgLTEyMiw2ICsxMzEsOCBAQCBhc21saW5rYWdlIHZvaWQgX19leGNlcHRpb24gYXNtX2Rv
X0lSUSh1CiAKIAlpcnFfZW50ZXIoKTsKIAorCWtzdGF0X2lycV9zdGFtcCgpOworCiAJZGVzY19o
YW5kbGVfaXJxKGlycSwgZGVzYyk7CiAKIAkvKiBBVDkxIHNwZWNpZmljIHdvcmthcm91bmQgKi8K
ZGlmZiAtcHVyTiBpbWcvMi42X2tlcm5lbC9kcml2ZXJzL2NwdWlkbGUvZ292ZXJub3JzL21lbnUu
YyAyLjZfa2VybmVsL2RyaXZlcnMvY3B1aWRsZS9nb3Zlcm5vcnMvbWVudS5jCi0tLSBpbWcvMi42
X2tlcm5lbC9kcml2ZXJzL2NwdWlkbGUvZ292ZXJub3JzL21lbnUuYwkyMDA4LTA3LTA0IDE1OjMx
OjIzLjAwMDAwMDAwMCAtMDUwMAorKysgMi42X2tlcm5lbC9kcml2ZXJzL2NwdWlkbGUvZ292ZXJu
b3JzL21lbnUuYwkyMDA4LTA3LTE0IDE1OjIyOjU1LjAwMDAwMDAwMCAtMDUwMApAQCAtNyw2ICs3
LDcgQEAKICAqLwogCiAjaW5jbHVkZSA8bGludXgva2VybmVsLmg+CisjaW5jbHVkZSA8bGludXgv
a2VybmVsX3N0YXQuaD4KICNpbmNsdWRlIDxsaW51eC9jcHVpZGxlLmg+CiAjaW5jbHVkZSA8bGlu
dXgvbGF0ZW5jeS5oPgogI2luY2x1ZGUgPGxpbnV4L3RpbWUuaD4KQEAgLTcwLDYgKzcxLDcgQEAg
c3RhdGljIHZvaWQgbWVudV9yZWZsZWN0KHN0cnVjdCBjcHVpZGxlXwogCXVuc2lnbmVkIGludCBt
ZWFzdXJlZF91cyA9CiAJCWNwdWlkbGVfZ2V0X2xhc3RfcmVzaWRlbmN5KGRldikgKyBkYXRhLT5l
bGFwc2VkX3VzOwogCXN0cnVjdCBjcHVpZGxlX3N0YXRlICp0YXJnZXQgPSAmZGV2LT5zdGF0ZXNb
bGFzdF9pZHhdOworCWNvbnN0IHVuc2lnbmVkIGludCBjcHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7
CiAKIAkvKgogCSAqIFVnaCwgdGhpcyBpZGxlIHN0YXRlIGRvZXNuJ3Qgc3VwcG9ydCByZXNpZGVu
Y3kgbWVhc3VyZW1lbnRzLCBzbyB3ZQpAQCAtOTIsNiArOTQsMTAgQEAgc3RhdGljIHZvaWQgbWVu
dV9yZWZsZWN0KHN0cnVjdCBjcHVpZGxlXwogCQkJZGF0YS0+ZWxhcHNlZF91cyA9IC0xOwogCQlk
YXRhLT5wcmVkaWN0ZWRfdXMgPSBtYXgobWVhc3VyZWRfdXMsIGRhdGEtPmxhc3RfbWVhc3VyZWRf
dXMpOwogCX0KKworCS8qIEd1ZXNzICYgZmFjdG9yIGluIGludGVycnVwdCB3YWtlIHJhdGUgKi8K
KwlkYXRhLT5wcmVkaWN0ZWRfdXMgPSBtaW4oKHM2NClkYXRhLT5wcmVkaWN0ZWRfdXMsIGt0aW1l
X3RvX3VzKAorCQlrdGltZV9zdWIoa3N0YXRfY3B1KGNwdSkuaXJxX25vdywga3N0YXRfY3B1KGNw
dSkuaXJxX2xhc3QpKSk7CiB9CiAKIC8qKgpkaWZmIC1wdXJOIGltZy8yLjZfa2VybmVsL2luY2x1
ZGUvbGludXgva2VybmVsX3N0YXQuaCAyLjZfa2VybmVsL2luY2x1ZGUvbGludXgva2VybmVsX3N0
YXQuaAotLS0gaW1nLzIuNl9rZXJuZWwvaW5jbHVkZS9saW51eC9rZXJuZWxfc3RhdC5oCTIwMDgt
MDQtMDMgMjE6NTE6NTAuMDAwMDAwMDAwIC0wNTAwCisrKyAyLjZfa2VybmVsL2luY2x1ZGUvbGlu
dXgva2VybmVsX3N0YXQuaAkyMDA4LTA3LTE0IDEzOjExOjA5LjAwMDAwMDAwMCAtMDUwMApAQCAt
Nyw2ICs3LDcgQEAKICNpbmNsdWRlIDxsaW51eC9wZXJjcHUuaD4KICNpbmNsdWRlIDxsaW51eC9j
cHVtYXNrLmg+CiAjaW5jbHVkZSA8YXNtL2NwdXRpbWUuaD4KKyNpbmNsdWRlIDxsaW51eC9ocnRp
bWVyLmg+CiAKIC8qCiAgKiAna2VybmVsX3N0YXQuaCcgY29udGFpbnMgdGhlIGRlZmluaXRpb25z
IG5lZWRlZCBmb3IgZG9pbmcKQEAgLTI5LDYgKzMwLDggQEAgc3RydWN0IGNwdV91c2FnZV9zdGF0
IHsKIHN0cnVjdCBrZXJuZWxfc3RhdCB7CiAJc3RydWN0IGNwdV91c2FnZV9zdGF0CWNwdXN0YXQ7
CiAJdW5zaWduZWQgaW50IGlycXNbTlJfSVJRU107CisJa3RpbWVfdCBpcnFfbm93OworCWt0aW1l
X3QgaXJxX2xhc3Q7CiB9OwogCiBERUNMQVJFX1BFUl9DUFUoc3RydWN0IGtlcm5lbF9zdGF0LCBr
c3RhdCk7CkBAIC01Miw2ICs1NSwxNiBAQCBzdGF0aWMgaW5saW5lIGludCBrc3RhdF9pcnFzKGlu
dCBpcnEpCiAJcmV0dXJuIHN1bTsKIH0KIAorLyoKKyAqIFByb3ZpZGUgaG9vayB0byB0cnkgYW5k
IHVuZGVyc3RhbmQgaW50ZXJydXB0IHJhdGUgb24gYSBwcm9jZXNzb3IKKyAqLworc3RhdGljIGlu
bGluZSB2b2lkIGtzdGF0X2lycV9zdGFtcCh2b2lkKQoreworCWNvbnN0IHVuc2lnbmVkIGludCBj
cHUgPSBzbXBfcHJvY2Vzc29yX2lkKCk7CisJa3N0YXRfY3B1KGNwdSkuaXJxX2xhc3QgPSBrc3Rh
dF9jcHUoY3B1KS5pcnFfbm93OworCWtzdGF0X2NwdShjcHUpLmlycV9ub3cgPSBrdGltZV9nZXQo
KTsKK30KKwogZXh0ZXJuIHZvaWQgYWNjb3VudF91c2VyX3RpbWUoc3RydWN0IHRhc2tfc3RydWN0
ICosIGNwdXRpbWVfdCk7CiBleHRlcm4gdm9pZCBhY2NvdW50X3VzZXJfdGltZV9zY2FsZWQoc3Ry
dWN0IHRhc2tfc3RydWN0ICosIGNwdXRpbWVfdCk7CiBleHRlcm4gdm9pZCBhY2NvdW50X3N5c3Rl
bV90aW1lKHN0cnVjdCB0YXNrX3N0cnVjdCAqLCBpbnQsIGNwdXRpbWVfdCk7Cg==

--_002_13B9B4C6EF24D648824FF11BE8967162035BEA0EDFdlee02enttico_--
