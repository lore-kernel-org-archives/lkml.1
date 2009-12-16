Return-Path: <linux-kernel-owner+w=401wt.eu-S934526AbZLPCRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934526AbZLPCRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 21:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934499AbZLPCRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 21:17:51 -0500
Received: from wm34.inbox.com ([64.135.83.34]:1443 "HELO WM34.inbox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S933390AbZLPCRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 21:17:50 -0500
X-Greylist: delayed 601 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Dec 2009 21:17:50 EST
Mime-Version: 1.0
Date: Tue, 15 Dec 2009 18:06:37 -0800
Message-ID: <BC87A9C3FC0.0000013Dstartww3@inbox.com>
From: startww3@inbox.com
Subject: PROBLEM: irqflags
To: linux-kernel@vger.kernel.org
X-Mailer: INBOX.COM
X-Originating-IP: 130.179.165.125
Content-Type: multipart/mixed;
  boundary="------------Boundary-00=_KMDYLUVFA5V8W92RKAQ8"
X-IWM-ACU: IaZpTilLO4XNXdhqPHwa0-bw1InE6QMu0m5z4l8Ug8c-r0T_-TaqDIm_RlaC
  3bgyNkMWgB7fVJu281HitKhzgVeg-DEqjSjfkY99KILA5_jfjGUaRb4wrAKd
  LwKTFdPUC5l_vWWXLmw@@
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------Boundary-00=_KMDYLUVFA5V8W92RKAQ8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


1) Summary:=20
'include/linux/irqflags.h' contains incorrect code
 (at least for x86_64) in sections where
 TRACE_IRQFLAGS_SUPPORT is not defined.

i.e.) when 'arch/x86/Kconfig.debug' contains:
config TRACE_IRQFLAGS_SUPPORT
        def_bool n


2) Full Description:=20
patch 'include/linux/irqflags.h' as per attached file=20
 (also duplicated below in text).


3) Keywords:=20
irqflags, irqflags.h, Kconfig.debug


7.1) scripts/ver_linux:
Linux localhost 2.6.31.6 =232 Mon Dec 14 15:25:35 EST 2009 x86_64 x86_64 =
x86_64 GNU/Linux

Gnu C                  4.4.2
Gnu make               3.81
binutils               2.19.51.0.14
util-linux             2.16
mount                  support
module-init-tools      3.9
e2fsprogs              1.41.9
xfsprogs               3.0.3
quota-tools            3.17.
PPP                    2.4.4
Linux C Library        2.11
Dynamic linker (ldd)   2.11
Procps                 3.2.8
Net-tools              1.60
Kbd                    1.15
oprofile               0.9.5
Sh-utils               7.6
Modules Loaded         vboxnetadp vboxnetflt vboxdrv dm_multipath nvidia =
snd_via82xx snd_ac97_codec ac97_bus snd_mpu401_uart snd_rawmidi via_rhine =
sg sr_mod cdrom usb_storage mii ata_generic sd_mod

=20
7.2) Cpuinfo:
processor=09: 0
vendor_id=09: AuthenticAMD
cpu family=09: 15
model=09=09: 44
model name=09: AMD Sempron(tm) Processor 3100+
stepping=09: 2
cpu MHz=09=09: 1808.299
cache size=09: 256 KB
fpu=09=09: yes
fpu_exception=09: yes
cpuid level=09: 1
wp=09=09: yes
flags=09=09: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov =
pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext =
3dnow rep_good pni lahf_lm
bogomips=09: 3616.59
TLB size=09: 1024 4K pages
clflush size=09: 64
cache_alignment=09: 64
address sizes=09: 40 bits physical, 48 bits virtual
power management: ts fid vid ttp tm stc


X) Patched 'include/linux/irqflags.h'
(tested and works under AMD K8 fc12 2.6.31):

/*
 * include/linux/irqflags.h
 *
 * IRQ flags tracing: follow the state of the hardirq and softirq flags and
 * provide callbacks for transitions between ON and OFF states.
 *
 * This file gets included from lowlevel asm headers too, to provide
 * wrapped versions of the local_irq_*() APIs, based on the
 * raw_local_irq_*() macros from the lowlevel headers.
 */
=23ifndef _LINUX_TRACE_IRQFLAGS_H
=23define _LINUX_TRACE_IRQFLAGS_H

=23include <linux/typecheck.h>

=23ifdef CONFIG_TRACE_IRQFLAGS
  extern void trace_softirqs_on(unsigned long ip);
  extern void trace_softirqs_off(unsigned long ip);
  extern void trace_hardirqs_on(void);
  extern void trace_hardirqs_off(void);
=23 define trace_hardirq_context(p)=09((p)->hardirq_context)
=23 define trace_softirq_context(p)=09((p)->softirq_context)
=23 define trace_hardirqs_enabled(p)=09((p)->hardirqs_enabled)
=23 define trace_softirqs_enabled(p)=09((p)->softirqs_enabled)
=23 define trace_hardirq_enter()=09do =7B current->hardirq_context++; =7D =
while (0)
=23 define trace_hardirq_exit()=09do =7B current->hardirq_context--; =7D =
while (0)
=23 define lockdep_softirq_enter()=09do =7B current->softirq_context++; =
=7D while (0)
=23 define lockdep_softirq_exit()=09do =7B current->softirq_context--; =7D =
while (0)
=23 define INIT_TRACE_IRQFLAGS=09.softirqs_enabled =3D 1,
=23else
=23 define trace_hardirqs_on()=09=09do =7B =7D while (0)
=23 define trace_hardirqs_off()=09=09do =7B =7D while (0)
=23 define trace_softirqs_on(ip)=09=09do =7B =7D while (0)
=23 define trace_softirqs_off(ip)=09=09do =7B =7D while (0)
=23 define trace_hardirq_context(p)=090
=23 define trace_softirq_context(p)=090
=23 define trace_hardirqs_enabled(p)=090
=23 define trace_softirqs_enabled(p)=090
=23 define trace_hardirq_enter()=09=09do =7B =7D while (0)
=23 define trace_hardirq_exit()=09=09do =7B =7D while (0)
=23 define lockdep_softirq_enter()=09do =7B =7D while (0)
=23 define lockdep_softirq_exit()=09=09do =7B =7D while (0)
=23 define INIT_TRACE_IRQFLAGS
=23endif

=23if defined(CONFIG_IRQSOFF_TRACER) =7C=7C =5C
=09defined(CONFIG_PREEMPT_TRACER)
 extern void stop_critical_timings(void);
 extern void start_critical_timings(void);
=23else
=23 define stop_critical_timings() do =7B =7D while (0)
=23 define start_critical_timings() do =7B =7D while (0)
=23endif

=23ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT

=23include <asm/irqflags.h>

=23define local_irq_enable() =5C
=09do =7B trace_hardirqs_on(); raw_local_irq_enable(); =7D while (0)
=23define local_irq_disable() =5C
=09do =7B raw_local_irq_disable(); trace_hardirqs_off(); =7D while (0)
=23define local_irq_save(flags)=09=09=09=09=5C
=09do =7B=09=09=09=09=09=09=5C
=09=09typecheck(unsigned long, flags);=09=5C
=09=09raw_local_irq_save(flags);=09=09=5C
=09=09trace_hardirqs_off();=09=09=09=5C
=09=7D while (0)


=23define local_irq_restore(flags)=09=09=09=5C
=09do =7B=09=09=09=09=09=09=5C
=09=09typecheck(unsigned long, flags);=09=5C
=09=09if (raw_irqs_disabled_flags(flags)) =7B=09=5C
=09=09=09raw_local_irq_restore(flags);=09=5C
=09=09=09trace_hardirqs_off();=09=09=5C
=09=09=7D else =7B=09=09=09=09=5C
=09=09=09trace_hardirqs_on();=09=09=5C
=09=09=09raw_local_irq_restore(flags);=09=5C
=09=09=7D=09=09=09=09=09=5C
=09=7D while (0)
=23else /* =21CONFIG_TRACE_IRQFLAGS_SUPPORT */
/*
 * The local_irq_*() APIs are equal to the raw_local_irq*()
 * if =21TRACE_IRQFLAGS.
 */

=23include <asm/irqflags.h>

=23 define local_irq_disable()            raw_local_irq_disable()=20
=23 define local_irq_enable()             raw_local_irq_enable()
=23 define local_irq_save(flags)          raw_local_irq_save(flags)
=23 define local_irq_restore(flags)       raw_local_irq_restore(flags)   =20

=23endif /* CONFIG_TRACE_IRQFLAGS_SUPPORT */




=23ifdef CONFIG_TRACE_IRQFLAGS_SUPPORT
=23define safe_halt()=09=09=09=09=09=09=5C
=09do =7B=09=09=09=09=09=09=09=5C
=09=09trace_hardirqs_on();=09=09=09=09=5C
=09=09raw_safe_halt();=09=09=09=09=5C
=09=7D while (0)

=23define local_save_flags(flags)=09=09=09=09=5C
=09do =7B=09=09=09=09=09=09=5C
=09=09typecheck(unsigned long, flags);=09=5C
=09=09raw_local_save_flags(flags);=09=09=5C
=09=7D while (0)

=23define irqs_disabled()=09=09=09=09=09=09=5C
(=7B=09=09=09=09=09=09=09=09=5C
=09unsigned long _flags;=09=09=09=09=09=5C
=09=09=09=09=09=09=09=09=5C
=09raw_local_save_flags(_flags);=09=09=09=09=5C
=09raw_irqs_disabled_flags(_flags);=09=09=09=5C
=7D)

=23define irqs_disabled_flags(flags)=09=09=5C
(=7B=09=09=09=09=09=09=5C
=09typecheck(unsigned long, flags);=09=5C
=09raw_irqs_disabled_flags(flags);=09=09=5C
=7D)

=23else

=23define safe_halt()                     raw_safe_halt()

=23define local_save_flags(flags)         raw_local_save_flags(flags)

=23define irqs_disabled()                                         =5C
(=7B                                                              =5C
        unsigned long _flags;                                   =5C
                                                                =5C
        raw_local_save_flags(_flags);                           =5C
        raw_irqs_disabled_flags(_flags);                        =5C
=7D)

=23define irqs_disabled_flags(flags)              =5C
(=7B                                              =5C
        typecheck(unsigned long, flags);        =5C
        raw_irqs_disabled_flags(flags);         =5C
=7D)

=23endif          /* CONFIG_TRACE_IRQFLAGS_SUPPORT */

=23endif          /*_LINUX_TRACE_IRQFLAGS_H */

____________________________________________________________
GET FREE 5GB EMAIL - Check out spam free email with many cool features=21
Visit http://www.inbox.com/email to find out more=21

--------------Boundary-00=_KMDYLUVFA5V8W92RKAQ8
Content-Type: text/plain
Content-Disposition: attachment; filename=include--linux--irqflags.h
Content-Transfer-Encoding: base64

LyoKICogaW5jbHVkZS9saW51eC9pcnFmbGFncy5oCiAqCiAqIElSUSBmbGFncyB0cmFjaW5n
OiBmb2xsb3cgdGhlIHN0YXRlIG9mIHRoZSBoYXJkaXJxIGFuZCBzb2Z0aXJxIGZsYWdzIGFu
ZAogKiBwcm92aWRlIGNhbGxiYWNrcyBmb3IgdHJhbnNpdGlvbnMgYmV0d2VlbiBPTiBhbmQg
T0ZGIHN0YXRlcy4KICoKICogVGhpcyBmaWxlIGdldHMgaW5jbHVkZWQgZnJvbSBsb3dsZXZl
bCBhc20gaGVhZGVycyB0b28sIHRvIHByb3ZpZGUKICogd3JhcHBlZCB2ZXJzaW9ucyBvZiB0
aGUgbG9jYWxfaXJxXyooKSBBUElzLCBiYXNlZCBvbiB0aGUKICogcmF3X2xvY2FsX2lycV8q
KCkgbWFjcm9zIGZyb20gdGhlIGxvd2xldmVsIGhlYWRlcnMuCiAqLwojaWZuZGVmIF9MSU5V
WF9UUkFDRV9JUlFGTEFHU19ICiNkZWZpbmUgX0xJTlVYX1RSQUNFX0lSUUZMQUdTX0gKCiNp
bmNsdWRlIDxsaW51eC90eXBlY2hlY2suaD4KCiNpZmRlZiBDT05GSUdfVFJBQ0VfSVJRRkxB
R1MKICBleHRlcm4gdm9pZCB0cmFjZV9zb2Z0aXJxc19vbih1bnNpZ25lZCBsb25nIGlwKTsK
ICBleHRlcm4gdm9pZCB0cmFjZV9zb2Z0aXJxc19vZmYodW5zaWduZWQgbG9uZyBpcCk7CiAg
ZXh0ZXJuIHZvaWQgdHJhY2VfaGFyZGlycXNfb24odm9pZCk7CiAgZXh0ZXJuIHZvaWQgdHJh
Y2VfaGFyZGlycXNfb2ZmKHZvaWQpOwojIGRlZmluZSB0cmFjZV9oYXJkaXJxX2NvbnRleHQo
cCkJKChwKS0+aGFyZGlycV9jb250ZXh0KQojIGRlZmluZSB0cmFjZV9zb2Z0aXJxX2NvbnRl
eHQocCkJKChwKS0+c29mdGlycV9jb250ZXh0KQojIGRlZmluZSB0cmFjZV9oYXJkaXJxc19l
bmFibGVkKHApCSgocCktPmhhcmRpcnFzX2VuYWJsZWQpCiMgZGVmaW5lIHRyYWNlX3NvZnRp
cnFzX2VuYWJsZWQocCkJKChwKS0+c29mdGlycXNfZW5hYmxlZCkKIyBkZWZpbmUgdHJhY2Vf
aGFyZGlycV9lbnRlcigpCWRvIHsgY3VycmVudC0+aGFyZGlycV9jb250ZXh0Kys7IH0gd2hp
bGUgKDApCiMgZGVmaW5lIHRyYWNlX2hhcmRpcnFfZXhpdCgpCWRvIHsgY3VycmVudC0+aGFy
ZGlycV9jb250ZXh0LS07IH0gd2hpbGUgKDApCiMgZGVmaW5lIGxvY2tkZXBfc29mdGlycV9l
bnRlcigpCWRvIHsgY3VycmVudC0+c29mdGlycV9jb250ZXh0Kys7IH0gd2hpbGUgKDApCiMg
ZGVmaW5lIGxvY2tkZXBfc29mdGlycV9leGl0KCkJZG8geyBjdXJyZW50LT5zb2Z0aXJxX2Nv
bnRleHQtLTsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgSU5JVF9UUkFDRV9JUlFGTEFHUwkuc29m
dGlycXNfZW5hYmxlZCA9IDEsCiNlbHNlCiMgZGVmaW5lIHRyYWNlX2hhcmRpcnFzX29uKCkJ
CWRvIHsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgdHJhY2VfaGFyZGlycXNfb2ZmKCkJCWRvIHsg
fSB3aGlsZSAoMCkKIyBkZWZpbmUgdHJhY2Vfc29mdGlycXNfb24oaXApCQlkbyB7IH0gd2hp
bGUgKDApCiMgZGVmaW5lIHRyYWNlX3NvZnRpcnFzX29mZihpcCkJCWRvIHsgfSB3aGlsZSAo
MCkKIyBkZWZpbmUgdHJhY2VfaGFyZGlycV9jb250ZXh0KHApCTAKIyBkZWZpbmUgdHJhY2Vf
c29mdGlycV9jb250ZXh0KHApCTAKIyBkZWZpbmUgdHJhY2VfaGFyZGlycXNfZW5hYmxlZChw
KQkwCiMgZGVmaW5lIHRyYWNlX3NvZnRpcnFzX2VuYWJsZWQocCkJMAojIGRlZmluZSB0cmFj
ZV9oYXJkaXJxX2VudGVyKCkJCWRvIHsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgdHJhY2VfaGFy
ZGlycV9leGl0KCkJCWRvIHsgfSB3aGlsZSAoMCkKIyBkZWZpbmUgbG9ja2RlcF9zb2Z0aXJx
X2VudGVyKCkJZG8geyB9IHdoaWxlICgwKQojIGRlZmluZSBsb2NrZGVwX3NvZnRpcnFfZXhp
dCgpCQlkbyB7IH0gd2hpbGUgKDApCiMgZGVmaW5lIElOSVRfVFJBQ0VfSVJRRkxBR1MKI2Vu
ZGlmCgojaWYgZGVmaW5lZChDT05GSUdfSVJRU09GRl9UUkFDRVIpIHx8IFwKCWRlZmluZWQo
Q09ORklHX1BSRUVNUFRfVFJBQ0VSKQogZXh0ZXJuIHZvaWQgc3RvcF9jcml0aWNhbF90aW1p
bmdzKHZvaWQpOwogZXh0ZXJuIHZvaWQgc3RhcnRfY3JpdGljYWxfdGltaW5ncyh2b2lkKTsK
I2Vsc2UKIyBkZWZpbmUgc3RvcF9jcml0aWNhbF90aW1pbmdzKCkgZG8geyB9IHdoaWxlICgw
KQojIGRlZmluZSBzdGFydF9jcml0aWNhbF90aW1pbmdzKCkgZG8geyB9IHdoaWxlICgwKQoj
ZW5kaWYKCiNpZmRlZiBDT05GSUdfVFJBQ0VfSVJRRkxBR1NfU1VQUE9SVAoKI2luY2x1ZGUg
PGFzbS9pcnFmbGFncy5oPgoKI2RlZmluZSBsb2NhbF9pcnFfZW5hYmxlKCkgXAoJZG8geyB0
cmFjZV9oYXJkaXJxc19vbigpOyByYXdfbG9jYWxfaXJxX2VuYWJsZSgpOyB9IHdoaWxlICgw
KQojZGVmaW5lIGxvY2FsX2lycV9kaXNhYmxlKCkgXAoJZG8geyByYXdfbG9jYWxfaXJxX2Rp
c2FibGUoKTsgdHJhY2VfaGFyZGlycXNfb2ZmKCk7IH0gd2hpbGUgKDApCiNkZWZpbmUgbG9j
YWxfaXJxX3NhdmUoZmxhZ3MpCQkJCVwKCWRvIHsJCQkJCQlcCgkJdHlwZWNoZWNrKHVuc2ln
bmVkIGxvbmcsIGZsYWdzKTsJXAoJCXJhd19sb2NhbF9pcnFfc2F2ZShmbGFncyk7CQlcCgkJ
dHJhY2VfaGFyZGlycXNfb2ZmKCk7CQkJXAoJfSB3aGlsZSAoMCkKCgojZGVmaW5lIGxvY2Fs
X2lycV9yZXN0b3JlKGZsYWdzKQkJCVwKCWRvIHsJCQkJCQlcCgkJdHlwZWNoZWNrKHVuc2ln
bmVkIGxvbmcsIGZsYWdzKTsJXAoJCWlmIChyYXdfaXJxc19kaXNhYmxlZF9mbGFncyhmbGFn
cykpIHsJXAoJCQlyYXdfbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOwlcCgkJCXRyYWNlX2hh
cmRpcnFzX29mZigpOwkJXAoJCX0gZWxzZSB7CQkJCVwKCQkJdHJhY2VfaGFyZGlycXNfb24o
KTsJCVwKCQkJcmF3X2xvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsJXAoJCX0JCQkJCVwKCX0g
d2hpbGUgKDApCiNlbHNlIC8qICFDT05GSUdfVFJBQ0VfSVJRRkxBR1NfU1VQUE9SVCAqLwov
KgogKiBUaGUgbG9jYWxfaXJxXyooKSBBUElzIGFyZSBlcXVhbCB0byB0aGUgcmF3X2xvY2Fs
X2lycSooKQogKiBpZiAhVFJBQ0VfSVJRRkxBR1MuCiAqLwoKI2luY2x1ZGUgPGFzbS9pcnFm
bGFncy5oPgoKIyBkZWZpbmUgbG9jYWxfaXJxX2Rpc2FibGUoKSAgICAgICAgICAgIHJhd19s
b2NhbF9pcnFfZGlzYWJsZSgpIAojIGRlZmluZSBsb2NhbF9pcnFfZW5hYmxlKCkgICAgICAg
ICAgICAgcmF3X2xvY2FsX2lycV9lbmFibGUoKQojIGRlZmluZSBsb2NhbF9pcnFfc2F2ZShm
bGFncykgICAgICAgICAgcmF3X2xvY2FsX2lycV9zYXZlKGZsYWdzKQojIGRlZmluZSBsb2Nh
bF9pcnFfcmVzdG9yZShmbGFncykgICAgICAgcmF3X2xvY2FsX2lycV9yZXN0b3JlKGZsYWdz
KSAgICAKCgojZW5kaWYgLyogQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQgKi8KCgoK
CgoKCgojaWZkZWYgQ09ORklHX1RSQUNFX0lSUUZMQUdTX1NVUFBPUlQKI2RlZmluZSBzYWZl
X2hhbHQoKQkJCQkJCVwKCWRvIHsJCQkJCQkJXAoJCXRyYWNlX2hhcmRpcnFzX29uKCk7CQkJ
CVwKCQlyYXdfc2FmZV9oYWx0KCk7CQkJCVwKCX0gd2hpbGUgKDApCgojZGVmaW5lIGxvY2Fs
X3NhdmVfZmxhZ3MoZmxhZ3MpCQkJCVwKCWRvIHsJCQkJCQlcCgkJdHlwZWNoZWNrKHVuc2ln
bmVkIGxvbmcsIGZsYWdzKTsJXAoJCXJhd19sb2NhbF9zYXZlX2ZsYWdzKGZsYWdzKTsJCVwK
CX0gd2hpbGUgKDApCgojZGVmaW5lIGlycXNfZGlzYWJsZWQoKQkJCQkJCVwKKHsJCQkJCQkJ
CVwKCXVuc2lnbmVkIGxvbmcgX2ZsYWdzOwkJCQkJXAoJCQkJCQkJCVwKCXJhd19sb2NhbF9z
YXZlX2ZsYWdzKF9mbGFncyk7CQkJCVwKCXJhd19pcnFzX2Rpc2FibGVkX2ZsYWdzKF9mbGFn
cyk7CQkJXAp9KQoKI2RlZmluZSBpcnFzX2Rpc2FibGVkX2ZsYWdzKGZsYWdzKQkJXAooewkJ
CQkJCVwKCXR5cGVjaGVjayh1bnNpZ25lZCBsb25nLCBmbGFncyk7CVwKCXJhd19pcnFzX2Rp
c2FibGVkX2ZsYWdzKGZsYWdzKTsJCVwKfSkKCiNlbHNlCgojZGVmaW5lIHNhZmVfaGFsdCgp
ICAgICAgICAgICAgICAgICAgICAgcmF3X3NhZmVfaGFsdCgpCgojZGVmaW5lIGxvY2FsX3Nh
dmVfZmxhZ3MoZmxhZ3MpICAgICAgICAgcmF3X2xvY2FsX3NhdmVfZmxhZ3MoZmxhZ3MpCgoj
ZGVmaW5lIGlycXNfZGlzYWJsZWQoKSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgXAooeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgXAogICAgICAgIHVuc2lnbmVkIGxvbmcgX2ZsYWdzOyAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAogICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXAogICAgICAg
IHJhd19sb2NhbF9zYXZlX2ZsYWdzKF9mbGFncyk7ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXAogICAgICAgIHJhd19pcnFzX2Rpc2FibGVkX2ZsYWdzKF9mbGFncyk7ICAgICAgICAg
ICAgICAgICAgICAgICAgXAp9KQoKI2RlZmluZSBpcnFzX2Rpc2FibGVkX2ZsYWdzKGZsYWdz
KSAgICAgICAgICAgICAgXAooeyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBcCiAgICAgICAgdHlwZWNoZWNrKHVuc2lnbmVkIGxvbmcsIGZsYWdzKTsg
ICAgICAgIFwKICAgICAgICByYXdfaXJxc19kaXNhYmxlZF9mbGFncyhmbGFncyk7ICAgICAg
ICAgXAp9KQoKI2VuZGlmICAgICAgICAgIC8qIENPTkZJR19UUkFDRV9JUlFGTEFHU19TVVBQ
T1JUICovCgojZW5kaWYgICAgICAgICAgLypfTElOVVhfVFJBQ0VfSVJRRkxBR1NfSCAqLwoK

--------------Boundary-00=_KMDYLUVFA5V8W92RKAQ8--
