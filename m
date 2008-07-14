Return-Path: <linux-kernel-owner+w=401wt.eu-S1757161AbYGNJ64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161AbYGNJ64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 05:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756330AbYGNJ6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 05:58:48 -0400
Received: from web32608.mail.mud.yahoo.com ([68.142.207.235]:46730 "HELO
	web32608.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755887AbYGNJ6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 05:58:47 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Mon, 14 Jul 2008 05:58:47 EDT
X-Mailer: YahooMailRC/1042.40 YahooMailWebService/0.7.199
Date: Mon, 14 Jul 2008 02:52:07 -0700 (PDT)
From: Martin Knoblauch <spamtrap@knobisoft.de>
Reply-To: Martin Knoblauch <spamtrap@knobisoft.de>
Subject: [Patch 2.6.26] Fix prinkt timesamps for good [was: [Bug 10648] CONFIG_PRINTK_TIME broken on git HEAD ?]
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="0-1812908930-1216029127=:97482"
Message-ID: <717386.97482.qm@web32608.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0-1812908930-1216029127=:97482
Content-Type: text/plain; charset=us-ascii

----- Original Message ----

> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> To: Martin Knoblauch <spamtrap@knobisoft.de>
> Sent: Tuesday, June 10, 2008 10:08:39 AM
> Subject: Re: [Bug 10648] CONFIG_PRINTK_TIME broken on git HEAD ?
> 
> On Tue, 2008-06-10 at 01:03 -0700, Martin Knoblauch wrote:
> > ----- Original Message ----
> > 
> > > From: Peter Zijlstra 
> > > To: Martin Knoblauch 
> > > Sent: Monday, June 9, 2008 5:18:05 PM
> > > Subject: Re: [Bug 10648] CONFIG_PRINTK_TIME broken on git HEAD ?
> > > 
> > > On Mon, 2008-06-09 at 08:13 -0700, Martin Knoblauch wrote:
> > > > Hi Peter,
> > > > 
> > > >  could you please send me that patch as an attachment. My mail agent 
> mangles 
> > > the bloody thing beyond recognition ....
> > > 
> > > here goes
> > Hi Peter,
> > 
> >  the patch is for 2.6.26 correct? First I assumed it is the backport
> > to 2.6.25, but apparently that does not have kernel/sched_clock.c. In
> > any case, applying to 2.6.26-rc5 works fine and the result is great.
> > Timestamps are monotonic and correspond to the first number in
> > "/proc/uptime" much better than ever before. Great work. If this goes
> > into 2.6.26, I will [try to] prepare a patch against 2.6.25.
> 
> Hmm, the patch might be a tad to big for .26 at this point, but I'll see
> what I can do to make .26 a better kernel ;-)
> 
> Thanks for testing!
Hi Peter,

now that 2.6.26 is released you may want to push the patch to fix the print-timestamps for good. I have rebased your patch to 2.6.26 and it works as expected. printk-timestamps are now monotonic and show "uptime" within millisecond accuracy. This is IMO also material for 2.6.26-stable. To fix it for 2.6.25 seems more involved and I do not personally see the urgency

Cheers
Martin

Tested-by: Martin Knoblauch <spamtrap@knobisoft.de>

diff -urp linux-2.6.26-orig/kernel/sched.c linux-2.6.26-sched-clock/kernel/sched.c
--- linux-2.6.26-orig/kernel/sched.c    2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.26-sched-clock/kernel/sched.c     2008-07-14 10:25:15.000000000 +0200
@@ -754,8 +754,6 @@ const_debug unsigned int sysctl_sched_nr
  */
unsigned int sysctl_sched_rt_period = 1000000;

-static __read_mostly int scheduler_running;
-
/*
  * part of the period that we allow rt tasks to run in us.
  * default: 0.95s
@@ -775,82 +773,6 @@ static inline u64 global_rt_runtime(void
        return (u64)sysctl_sched_rt_runtime * NSEC_PER_USEC;
}

-unsigned long long time_sync_thresh = 100000;
-
-static DEFINE_PER_CPU(unsigned long long, time_offset);
-static DEFINE_PER_CPU(unsigned long long, prev_cpu_time);
-
-/*
- * Global lock which we take every now and then to synchronize
- * the CPUs time. This method is not warp-safe, but it's good
- * enough to synchronize slowly diverging time sources and thus
- * it's good enough for tracing:
- */
-static DEFINE_SPINLOCK(time_sync_lock);
-static unsigned long long prev_global_time;
-
-static unsigned long long __sync_cpu_clock(unsigned long long time, int cpu)
-{
-       /*
-        * We want this inlined, to not get tracer function calls
-        * in this critical section:
-        */
-       spin_acquire(&time_sync_lock.dep_map, 0, 0, _THIS_IP_);
-       __raw_spin_lock(&time_sync_lock.raw_lock);
-
-       if (time < prev_global_time) {
-               per_cpu(time_offset, cpu) += prev_global_time - time;
-               time = prev_global_time;
-       } else {
-               prev_global_time = time;
-       }
-
-       __raw_spin_unlock(&time_sync_lock.raw_lock);
-       spin_release(&time_sync_lock.dep_map, 1, _THIS_IP_);
-
-       return time;
-}
-
-static unsigned long long __cpu_clock(int cpu)
-{
-       unsigned long long now;
-
-       /*
-        * Only call sched_clock() if the scheduler has already been
-        * initialized (some code might call cpu_clock() very early):
-        */
-       if (unlikely(!scheduler_running))
-               return 0;
-
-       now = sched_clock_cpu(cpu);
-
-       return now;
-}
-
-/*
- * For kernel-internal use: high-speed (but slightly incorrect) per-cpu
- * clock constructed from sched_clock():
- */
-unsigned long long cpu_clock(int cpu)
-{
-       unsigned long long prev_cpu_time, time, delta_time;
-       unsigned long flags;
-
-       local_irq_save(flags);
-       prev_cpu_time = per_cpu(prev_cpu_time, cpu);
-       time = __cpu_clock(cpu) + per_cpu(time_offset, cpu);
-       delta_time = time-prev_cpu_time;
-
-       if (unlikely(delta_time > time_sync_thresh)) {
-               time = __sync_cpu_clock(time, cpu);
-               per_cpu(prev_cpu_time, cpu) = time;
-       }
-       local_irq_restore(flags);
-
-       return time;
-}
-EXPORT_SYMBOL_GPL(cpu_clock);
-
#ifndef prepare_arch_switch
# define prepare_arch_switch(next)     do { } while (0)
#endif
@@ -7858,8 +7780,6 @@ void __init sched_init(void)
         * During early bootup we pretend to be a normal task:
         */
        current->sched_class = &fair_sched_class;
-
-       scheduler_running = 1;
}

#ifdef CONFIG_DEBUG_SPINLOCK_SLEEP
diff -urp linux-2.6.26-orig/kernel/sched_clock.c linux-2.6.26-sched-clock/kernel/sched_clock.c
--- linux-2.6.26-orig/kernel/sched_clock.c      2008-07-13 23:51:29.000000000 +0200
+++ linux-2.6.26-sched-clock/kernel/sched_clock.c       2008-07-14 10:25:15.000000000 +0200
@@ -244,3 +244,15 @@ unsigned long long __attribute__((weak))
{
        return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
}
+
+unsigned long long cpu_clock(int cpu)
+{
+       unsigned long long clock;
+       unsigned long flags;
+
+       raw_local_irq_save(flags);
+       clock = sched_clock_cpu(cpu);
+       raw_local_irq_restore(flags);
+
+       return clock;
+}
--0-1812908930-1216029127=:97482
Content-Type: text/x-patch; name="printk-timestamp-2.6.26.patch"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="printk-timestamp-2.6.26.patch"

ZGlmZiAtdXJwIGxpbnV4LTIuNi4yNi1vcmlnL2tlcm5lbC9zY2hlZC5jIGxp
bnV4LTIuNi4yNi1zY2hlZC1jbG9jay9rZXJuZWwvc2NoZWQuYwotLS0gbGlu
dXgtMi42LjI2LW9yaWcva2VybmVsL3NjaGVkLmMJMjAwOC0wNy0xMyAyMzo1
MToyOS4wMDAwMDAwMDAgKzAyMDAKKysrIGxpbnV4LTIuNi4yNi1zY2hlZC1j
bG9jay9rZXJuZWwvc2NoZWQuYwkyMDA4LTA3LTE0IDEwOjI1OjE1LjAwMDAw
MDAwMCArMDIwMApAQCAtNzU0LDggKzc1NCw2IEBAIGNvbnN0X2RlYnVnIHVu
c2lnbmVkIGludCBzeXNjdGxfc2NoZWRfbnIKICAqLwogdW5zaWduZWQgaW50
IHN5c2N0bF9zY2hlZF9ydF9wZXJpb2QgPSAxMDAwMDAwOwogCi1zdGF0aWMg
X19yZWFkX21vc3RseSBpbnQgc2NoZWR1bGVyX3J1bm5pbmc7Ci0KIC8qCiAg
KiBwYXJ0IG9mIHRoZSBwZXJpb2QgdGhhdCB3ZSBhbGxvdyBydCB0YXNrcyB0
byBydW4gaW4gdXMuCiAgKiBkZWZhdWx0OiAwLjk1cwpAQCAtNzc1LDgyICs3
NzMsNiBAQCBzdGF0aWMgaW5saW5lIHU2NCBnbG9iYWxfcnRfcnVudGltZSh2
b2lkCiAJcmV0dXJuICh1NjQpc3lzY3RsX3NjaGVkX3J0X3J1bnRpbWUgKiBO
U0VDX1BFUl9VU0VDOwogfQogCi11bnNpZ25lZCBsb25nIGxvbmcgdGltZV9z
eW5jX3RocmVzaCA9IDEwMDAwMDsKLQotc3RhdGljIERFRklORV9QRVJfQ1BV
KHVuc2lnbmVkIGxvbmcgbG9uZywgdGltZV9vZmZzZXQpOwotc3RhdGljIERF
RklORV9QRVJfQ1BVKHVuc2lnbmVkIGxvbmcgbG9uZywgcHJldl9jcHVfdGlt
ZSk7Ci0KLS8qCi0gKiBHbG9iYWwgbG9jayB3aGljaCB3ZSB0YWtlIGV2ZXJ5
IG5vdyBhbmQgdGhlbiB0byBzeW5jaHJvbml6ZQotICogdGhlIENQVXMgdGlt
ZS4gVGhpcyBtZXRob2QgaXMgbm90IHdhcnAtc2FmZSwgYnV0IGl0J3MgZ29v
ZAotICogZW5vdWdoIHRvIHN5bmNocm9uaXplIHNsb3dseSBkaXZlcmdpbmcg
dGltZSBzb3VyY2VzIGFuZCB0aHVzCi0gKiBpdCdzIGdvb2QgZW5vdWdoIGZv
ciB0cmFjaW5nOgotICovCi1zdGF0aWMgREVGSU5FX1NQSU5MT0NLKHRpbWVf
c3luY19sb2NrKTsKLXN0YXRpYyB1bnNpZ25lZCBsb25nIGxvbmcgcHJldl9n
bG9iYWxfdGltZTsKLQotc3RhdGljIHVuc2lnbmVkIGxvbmcgbG9uZyBfX3N5
bmNfY3B1X2Nsb2NrKHVuc2lnbmVkIGxvbmcgbG9uZyB0aW1lLCBpbnQgY3B1
KQotewotCS8qCi0JICogV2Ugd2FudCB0aGlzIGlubGluZWQsIHRvIG5vdCBn
ZXQgdHJhY2VyIGZ1bmN0aW9uIGNhbGxzCi0JICogaW4gdGhpcyBjcml0aWNh
bCBzZWN0aW9uOgotCSAqLwotCXNwaW5fYWNxdWlyZSgmdGltZV9zeW5jX2xv
Y2suZGVwX21hcCwgMCwgMCwgX1RISVNfSVBfKTsKLQlfX3Jhd19zcGluX2xv
Y2soJnRpbWVfc3luY19sb2NrLnJhd19sb2NrKTsKLQotCWlmICh0aW1lIDwg
cHJldl9nbG9iYWxfdGltZSkgewotCQlwZXJfY3B1KHRpbWVfb2Zmc2V0LCBj
cHUpICs9IHByZXZfZ2xvYmFsX3RpbWUgLSB0aW1lOwotCQl0aW1lID0gcHJl
dl9nbG9iYWxfdGltZTsKLQl9IGVsc2UgewotCQlwcmV2X2dsb2JhbF90aW1l
ID0gdGltZTsKLQl9Ci0KLQlfX3Jhd19zcGluX3VubG9jaygmdGltZV9zeW5j
X2xvY2sucmF3X2xvY2spOwotCXNwaW5fcmVsZWFzZSgmdGltZV9zeW5jX2xv
Y2suZGVwX21hcCwgMSwgX1RISVNfSVBfKTsKLQotCXJldHVybiB0aW1lOwot
fQotCi1zdGF0aWMgdW5zaWduZWQgbG9uZyBsb25nIF9fY3B1X2Nsb2NrKGlu
dCBjcHUpCi17Ci0JdW5zaWduZWQgbG9uZyBsb25nIG5vdzsKLQotCS8qCi0J
ICogT25seSBjYWxsIHNjaGVkX2Nsb2NrKCkgaWYgdGhlIHNjaGVkdWxlciBo
YXMgYWxyZWFkeSBiZWVuCi0JICogaW5pdGlhbGl6ZWQgKHNvbWUgY29kZSBt
aWdodCBjYWxsIGNwdV9jbG9jaygpIHZlcnkgZWFybHkpOgotCSAqLwotCWlm
ICh1bmxpa2VseSghc2NoZWR1bGVyX3J1bm5pbmcpKQotCQlyZXR1cm4gMDsK
LQotCW5vdyA9IHNjaGVkX2Nsb2NrX2NwdShjcHUpOwotCi0JcmV0dXJuIG5v
dzsKLX0KLQotLyoKLSAqIEZvciBrZXJuZWwtaW50ZXJuYWwgdXNlOiBoaWdo
LXNwZWVkIChidXQgc2xpZ2h0bHkgaW5jb3JyZWN0KSBwZXItY3B1Ci0gKiBj
bG9jayBjb25zdHJ1Y3RlZCBmcm9tIHNjaGVkX2Nsb2NrKCk6Ci0gKi8KLXVu
c2lnbmVkIGxvbmcgbG9uZyBjcHVfY2xvY2soaW50IGNwdSkKLXsKLQl1bnNp
Z25lZCBsb25nIGxvbmcgcHJldl9jcHVfdGltZSwgdGltZSwgZGVsdGFfdGlt
ZTsKLQl1bnNpZ25lZCBsb25nIGZsYWdzOwotCi0JbG9jYWxfaXJxX3NhdmUo
ZmxhZ3MpOwotCXByZXZfY3B1X3RpbWUgPSBwZXJfY3B1KHByZXZfY3B1X3Rp
bWUsIGNwdSk7Ci0JdGltZSA9IF9fY3B1X2Nsb2NrKGNwdSkgKyBwZXJfY3B1
KHRpbWVfb2Zmc2V0LCBjcHUpOwotCWRlbHRhX3RpbWUgPSB0aW1lLXByZXZf
Y3B1X3RpbWU7Ci0KLQlpZiAodW5saWtlbHkoZGVsdGFfdGltZSA+IHRpbWVf
c3luY190aHJlc2gpKSB7Ci0JCXRpbWUgPSBfX3N5bmNfY3B1X2Nsb2NrKHRp
bWUsIGNwdSk7Ci0JCXBlcl9jcHUocHJldl9jcHVfdGltZSwgY3B1KSA9IHRp
bWU7Ci0JfQotCWxvY2FsX2lycV9yZXN0b3JlKGZsYWdzKTsKLQotCXJldHVy
biB0aW1lOwotfQotRVhQT1JUX1NZTUJPTF9HUEwoY3B1X2Nsb2NrKTsKLQog
I2lmbmRlZiBwcmVwYXJlX2FyY2hfc3dpdGNoCiAjIGRlZmluZSBwcmVwYXJl
X2FyY2hfc3dpdGNoKG5leHQpCWRvIHsgfSB3aGlsZSAoMCkKICNlbmRpZgpA
QCAtNzg1OCw4ICs3NzgwLDYgQEAgdm9pZCBfX2luaXQgc2NoZWRfaW5pdCh2
b2lkKQogCSAqIER1cmluZyBlYXJseSBib290dXAgd2UgcHJldGVuZCB0byBi
ZSBhIG5vcm1hbCB0YXNrOgogCSAqLwogCWN1cnJlbnQtPnNjaGVkX2NsYXNz
ID0gJmZhaXJfc2NoZWRfY2xhc3M7Ci0KLQlzY2hlZHVsZXJfcnVubmluZyA9
IDE7CiB9CiAKICNpZmRlZiBDT05GSUdfREVCVUdfU1BJTkxPQ0tfU0xFRVAK
ZGlmZiAtdXJwIGxpbnV4LTIuNi4yNi1vcmlnL2tlcm5lbC9zY2hlZF9jbG9j
ay5jIGxpbnV4LTIuNi4yNi1zY2hlZC1jbG9jay9rZXJuZWwvc2NoZWRfY2xv
Y2suYwotLS0gbGludXgtMi42LjI2LW9yaWcva2VybmVsL3NjaGVkX2Nsb2Nr
LmMJMjAwOC0wNy0xMyAyMzo1MToyOS4wMDAwMDAwMDAgKzAyMDAKKysrIGxp
bnV4LTIuNi4yNi1zY2hlZC1jbG9jay9rZXJuZWwvc2NoZWRfY2xvY2suYwky
MDA4LTA3LTE0IDEwOjI1OjE1LjAwMDAwMDAwMCArMDIwMApAQCAtMjQ0LDMg
KzI0NCwxNSBAQCB1bnNpZ25lZCBsb25nIGxvbmcgX19hdHRyaWJ1dGVfXygo
d2VhaykpCiB7CiAJcmV0dXJuICh1bnNpZ25lZCBsb25nIGxvbmcpamlmZmll
cyAqIChOU0VDX1BFUl9TRUMgLyBIWik7CiB9CisKK3Vuc2lnbmVkIGxvbmcg
bG9uZyBjcHVfY2xvY2soaW50IGNwdSkKK3sKKwl1bnNpZ25lZCBsb25nIGxv
bmcgY2xvY2s7CisJdW5zaWduZWQgbG9uZyBmbGFnczsKKworCXJhd19sb2Nh
bF9pcnFfc2F2ZShmbGFncyk7CisJY2xvY2sgPSBzY2hlZF9jbG9ja19jcHUo
Y3B1KTsKKwlyYXdfbG9jYWxfaXJxX3Jlc3RvcmUoZmxhZ3MpOworCisJcmV0
dXJuIGNsb2NrOworfQpPbmx5IGluIGxpbnV4LTIuNi4yNi1zY2hlZC1jbG9j
ay9rZXJuZWw6IHNjaGVkLmMub3JpZwo=

--0-1812908930-1216029127=:97482--
