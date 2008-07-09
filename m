Return-Path: <linux-kernel-owner+w=401wt.eu-S1755459AbYGIOOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755459AbYGIOOG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 10:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754559AbYGIONw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 10:13:52 -0400
Received: from mail.av.it.pt ([193.136.92.53]:60490 "EHLO av.it.pt"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751648AbYGIONv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 10:13:51 -0400
X-Greylist: delayed 3602 seconds by postgrey-1.27 at vger.kernel.org; Wed, 09 Jul 2008 10:13:49 EDT
X-TFF-CGPSA-Version: 1.5
X-TFF-CGPSA-Filter: Scanned
Message-ID: <4874B979.4020608@av.it.pt>
Date: Wed, 09 Jul 2008 14:13:29 +0100
From: Bruno Santos <bsantos@av.it.pt>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: bsantos@av.it.pt
Subject: Re: semaphore: lockless fastpath using atomic_{inc,dec}_return
Content-Type: multipart/mixed;
 boundary="------------000606070704050508000407"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000606070704050508000407
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

So far the machine I'm testing this (Core2 Duo) it's been up to almost 24H.

It seems the patch got screwed by the mailer, so I'm posting it again.


 From 343d08a5d172d103e49c77e5580a45f02fab2b5e Mon Sep 17 00:00:00 2001
From: Bruno Santos <bsantos@av.it.pt>
Date: Tue, 8 Jul 2008 23:40:53 +0100
Subject: [PATCH] semaphore lockless fastpath


Signed-off-by: Bruno Santos <bsantos@av.it.pt>
---
 include/linux/semaphore.h |    4 +-
 kernel/semaphore.c        |  131 
+++++++++++++++++++++++++--------------------
 2 files changed, 75 insertions(+), 60 deletions(-)

diff --git a/include/linux/semaphore.h b/include/linux/semaphore.h
index 9cae64b..d7850f0 100644
--- a/include/linux/semaphore.h
+++ b/include/linux/semaphore.h
@@ -14,15 +14,15 @@
 
 /* Please don't access any members of this structure directly */
 struct semaphore {
+    atomic_t        count;
     spinlock_t        lock;
-    unsigned int        count;
     struct list_head    wait_list;
 };
 
 #define __SEMAPHORE_INITIALIZER(name, n)                \
 {                                    \
+    .count        = ATOMIC_INIT(n),                \
     .lock        = __SPIN_LOCK_UNLOCKED((name).lock),        \
-    .count        = n,                        \
     .wait_list    = LIST_HEAD_INIT((name).wait_list),        \
 }
 
diff --git a/kernel/semaphore.c b/kernel/semaphore.c
index 5c2942e..2815980 100644
--- a/kernel/semaphore.c
+++ b/kernel/semaphore.c
@@ -8,6 +8,8 @@
  * A counting semaphore may be acquired 'n' times before sleeping.
  * See mutex.c for single-acquisition sleeping locks which enforce
  * rules which allow code to be debugged more easily.
+ *
+ * Lockless fastpath by Bruno Santos <bsantos@av.it.pt>
  */
 
 /*
@@ -22,7 +24,7 @@
  * too.
  *
  * The ->count variable represents how many more tasks can acquire this
- * semaphore.  If it's zero, there may be tasks waiting on the wait_list.
+ * semaphore.  If it's negative, there may be tasks waiting on the 
wait_list.
  */
 
 #include <linux/compiler.h>
@@ -51,14 +53,10 @@ static noinline void __up(struct semaphore *sem);
  */
 void down(struct semaphore *sem)
 {
-    unsigned long flags;
+    if (likely(atomic_dec_return(&sem->count) >= 0))
+        return;
 
-    spin_lock_irqsave(&sem->lock, flags);
-    if (likely(sem->count > 0))
-        sem->count--;
-    else
-        __down(sem);
-    spin_unlock_irqrestore(&sem->lock, flags);
+    __down(sem);
 }
 EXPORT_SYMBOL(down);
 
@@ -73,17 +71,10 @@ EXPORT_SYMBOL(down);
  */
 int down_interruptible(struct semaphore *sem)
 {
-    unsigned long flags;
-    int result = 0;
+    if (likely(atomic_dec_return(&sem->count) >= 0))
+        return 0;
 
-    spin_lock_irqsave(&sem->lock, flags);
-    if (likely(sem->count > 0))
-        sem->count--;
-    else
-        result = __down_interruptible(sem);
-    spin_unlock_irqrestore(&sem->lock, flags);
-
-    return result;
+    return __down_interruptible(sem);
 }
 EXPORT_SYMBOL(down_interruptible);
 
@@ -99,17 +90,10 @@ EXPORT_SYMBOL(down_interruptible);
  */
 int down_killable(struct semaphore *sem)
 {
-    unsigned long flags;
-    int result = 0;
+    if (likely(atomic_dec_return(&sem->count) >= 0))
+        return 0;
 
-    spin_lock_irqsave(&sem->lock, flags);
-    if (likely(sem->count > 0))
-        sem->count--;
-    else
-        result = __down_killable(sem);
-    spin_unlock_irqrestore(&sem->lock, flags);
-
-    return result;
+    return __down_killable(sem);
 }
 EXPORT_SYMBOL(down_killable);
 
@@ -128,16 +112,21 @@ EXPORT_SYMBOL(down_killable);
  */
 int down_trylock(struct semaphore *sem)
 {
-    unsigned long flags;
-    int count;
+    int old, cmp;
 
-    spin_lock_irqsave(&sem->lock, flags);
-    count = sem->count - 1;
-    if (likely(count >= 0))
-        sem->count = count;
-    spin_unlock_irqrestore(&sem->lock, flags);
+    /*
+     * The down_trylock fastpath is not very optimal compared to the
+     * down and up fastpath's, but it should be used less frequently.
+     */
+    old = atomic_read(&sem->count);
+    while (old > 0) {
+        cmp = old;
+        old = atomic_cmpxchg(&sem->count, cmp, old - 1);
+        if (old == cmp)
+            return 0;
+    }
 
-    return (count < 0);
+    return 1;
 }
 EXPORT_SYMBOL(down_trylock);
 
@@ -153,17 +142,10 @@ EXPORT_SYMBOL(down_trylock);
  */
 int down_timeout(struct semaphore *sem, long jiffies)
 {
-    unsigned long flags;
-    int result = 0;
-
-    spin_lock_irqsave(&sem->lock, flags);
-    if (likely(sem->count > 0))
-        sem->count--;
-    else
-        result = __down_timeout(sem, jiffies);
-    spin_unlock_irqrestore(&sem->lock, flags);
+    if (likely(atomic_dec_return(&sem->count) >= 0))
+        return 0;
 
-    return result;
+    return __down_timeout(sem, jiffies);
 }
 EXPORT_SYMBOL(down_timeout);
 
@@ -176,14 +158,10 @@ EXPORT_SYMBOL(down_timeout);
  */
 void up(struct semaphore *sem)
 {
-    unsigned long flags;
+    if (likely(atomic_inc_return(&sem->count) > 0))
+        return;
 
-    spin_lock_irqsave(&sem->lock, flags);
-    if (likely(list_empty(&sem->wait_list)))
-        sem->count++;
-    else
-        __up(sem);
-    spin_unlock_irqrestore(&sem->lock, flags);
+    __up(sem);
 }
 EXPORT_SYMBOL(up);
 
@@ -205,6 +183,15 @@ static inline int __sched __down_common(struct 
semaphore *sem, long state,
 {
     struct task_struct *task = current;
     struct semaphore_waiter waiter;
+    unsigned long flags;
+
+    spin_lock_irqsave(&sem->lock, flags);
+    /*
+     * Someone may have incremented the count and failed to wake
+     * us before we acquired the spinlock.
+     */
+    if (atomic_dec_return(&sem->count) >= 0)
+        goto done;
 
     list_add_tail(&waiter.list, &sem->wait_list);
     waiter.task = task;
@@ -222,16 +209,22 @@ static inline int __sched __down_common(struct 
semaphore *sem, long state,
         timeout = schedule_timeout(timeout);
         spin_lock_irq(&sem->lock);
         if (waiter.up)
-            return 0;
+            goto done;
     }
 
  timed_out:
     list_del(&waiter.list);
+    spin_unlock_irqrestore(&sem->lock, flags);
     return -ETIME;
 
  interrupted:
     list_del(&waiter.list);
+    spin_unlock_irqrestore(&sem->lock, flags);
     return -EINTR;
+
+ done:
+    spin_unlock_irqrestore(&sem->lock, flags);
+    return 0;
 }
 
 static noinline void __sched __down(struct semaphore *sem)
@@ -256,9 +249,31 @@ static noinline int __sched __down_timeout(struct 
semaphore *sem, long jiffies)
 
 static noinline void __sched __up(struct semaphore *sem)
 {
-    struct semaphore_waiter *waiter = list_first_entry(&sem->wait_list,
+    struct semaphore_waiter *waiter;
+    unsigned long flags;
+    int old, cmp;
+
+    spin_lock_irqsave(&sem->lock, flags);
+    /*
+     * If the wait list is empty, it means either we acquired the spinlock
+     * faster than a possible waiter or the possible waiter abandoned the
+     * wait because it got interrupted or timed out. In such case we have
+     * to increment the count to a value that is greater or equal than 1.
+     */
+    if (list_empty(&sem->wait_list)) {
+        old = atomic_read(&sem->count);
+        do {
+            cmp = old;
+            old = (old > 0) ? old + 1 : 1;
+            old = atomic_cmpxchg(&sem->count, cmp, old);
+        } while (cmp != old);
+
+    } else {
+        waiter = list_first_entry(&sem->wait_list,
                         struct semaphore_waiter, list);
-    list_del(&waiter->list);
-    waiter->up = 1;
-    wake_up_process(waiter->task);
+        list_del(&waiter->list);
+        waiter->up = 1;
+        wake_up_process(waiter->task);
+    }
+    spin_unlock_irqrestore(&sem->lock, flags);
 }
-- 
1.5.2.5


--------------000606070704050508000407
Content-Type: text/plain;
 name="semaphore-lockless-fastpath.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="semaphore-lockless-fastpath.patch"

RnJvbSAzNDNkMDhhNWQxNzJkMTAzZTQ5Yzc3ZTU1ODBhNDVmMDJmYWIyYjVlIE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBCcnVubyBTYW50b3MgPGJzYW50b3NAYXYuaXQucHQ+
CkRhdGU6IFR1ZSwgOCBKdWwgMjAwOCAyMzo0MDo1MyArMDEwMApTdWJqZWN0OiBbUEFUQ0hd
IHNlbWFwaG9yZSBsb2NrbGVzcyBmYXN0cGF0aAoKClNpZ25lZC1vZmYtYnk6IEJydW5vIFNh
bnRvcyA8YnNhbnRvc0Bhdi5pdC5wdD4KLS0tCiBpbmNsdWRlL2xpbnV4L3NlbWFwaG9yZS5o
IHwgICAgNCArLQoga2VybmVsL3NlbWFwaG9yZS5jICAgICAgICB8ICAxMzEgKysrKysrKysr
KysrKysrKysrKysrKysrKy0tLS0tLS0tLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQs
IDc1IGluc2VydGlvbnMoKyksIDYwIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvc2VtYXBob3JlLmggYi9pbmNsdWRlL2xpbnV4L3NlbWFwaG9yZS5oCmluZGV4
IDljYWU2NGIuLmQ3ODUwZjAgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgvc2VtYXBob3Jl
LmgKKysrIGIvaW5jbHVkZS9saW51eC9zZW1hcGhvcmUuaApAQCAtMTQsMTUgKzE0LDE1IEBA
CiAKIC8qIFBsZWFzZSBkb24ndCBhY2Nlc3MgYW55IG1lbWJlcnMgb2YgdGhpcyBzdHJ1Y3R1
cmUgZGlyZWN0bHkgKi8KIHN0cnVjdCBzZW1hcGhvcmUgeworCWF0b21pY190CQljb3VudDsK
IAlzcGlubG9ja190CQlsb2NrOwotCXVuc2lnbmVkIGludAkJY291bnQ7CiAJc3RydWN0IGxp
c3RfaGVhZAl3YWl0X2xpc3Q7CiB9OwogCiAjZGVmaW5lIF9fU0VNQVBIT1JFX0lOSVRJQUxJ
WkVSKG5hbWUsIG4pCQkJCVwKIHsJCQkJCQkJCQlcCisJLmNvdW50CQk9IEFUT01JQ19JTklU
KG4pLAkJCQlcCiAJLmxvY2sJCT0gX19TUElOX0xPQ0tfVU5MT0NLRUQoKG5hbWUpLmxvY2sp
LAkJXAotCS5jb3VudAkJPSBuLAkJCQkJCVwKIAkud2FpdF9saXN0CT0gTElTVF9IRUFEX0lO
SVQoKG5hbWUpLndhaXRfbGlzdCksCQlcCiB9CiAKZGlmZiAtLWdpdCBhL2tlcm5lbC9zZW1h
cGhvcmUuYyBiL2tlcm5lbC9zZW1hcGhvcmUuYwppbmRleCA1YzI5NDJlLi4yODE1OTgwIDEw
MDY0NAotLS0gYS9rZXJuZWwvc2VtYXBob3JlLmMKKysrIGIva2VybmVsL3NlbWFwaG9yZS5j
CkBAIC04LDYgKzgsOCBAQAogICogQSBjb3VudGluZyBzZW1hcGhvcmUgbWF5IGJlIGFjcXVp
cmVkICduJyB0aW1lcyBiZWZvcmUgc2xlZXBpbmcuCiAgKiBTZWUgbXV0ZXguYyBmb3Igc2lu
Z2xlLWFjcXVpc2l0aW9uIHNsZWVwaW5nIGxvY2tzIHdoaWNoIGVuZm9yY2UKICAqIHJ1bGVz
IHdoaWNoIGFsbG93IGNvZGUgdG8gYmUgZGVidWdnZWQgbW9yZSBlYXNpbHkuCisgKgorICog
TG9ja2xlc3MgZmFzdHBhdGggYnkgQnJ1bm8gU2FudG9zIDxic2FudG9zQGF2Lml0LnB0Pgog
ICovCiAKIC8qCkBAIC0yMiw3ICsyNCw3IEBACiAgKiB0b28uCiAgKgogICogVGhlIC0+Y291
bnQgdmFyaWFibGUgcmVwcmVzZW50cyBob3cgbWFueSBtb3JlIHRhc2tzIGNhbiBhY3F1aXJl
IHRoaXMKLSAqIHNlbWFwaG9yZS4gIElmIGl0J3MgemVybywgdGhlcmUgbWF5IGJlIHRhc2tz
IHdhaXRpbmcgb24gdGhlIHdhaXRfbGlzdC4KKyAqIHNlbWFwaG9yZS4gIElmIGl0J3MgbmVn
YXRpdmUsIHRoZXJlIG1heSBiZSB0YXNrcyB3YWl0aW5nIG9uIHRoZSB3YWl0X2xpc3QuCiAg
Ki8KIAogI2luY2x1ZGUgPGxpbnV4L2NvbXBpbGVyLmg+CkBAIC01MSwxNCArNTMsMTAgQEAg
c3RhdGljIG5vaW5saW5lIHZvaWQgX191cChzdHJ1Y3Qgc2VtYXBob3JlICpzZW0pOwogICov
CiB2b2lkIGRvd24oc3RydWN0IHNlbWFwaG9yZSAqc2VtKQogewotCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7CisJaWYgKGxpa2VseShhdG9taWNfZGVjX3JldHVybigmc2VtLT5jb3VudCkgPj0g
MCkpCisJCXJldHVybjsKIAotCXNwaW5fbG9ja19pcnFzYXZlKCZzZW0tPmxvY2ssIGZsYWdz
KTsKLQlpZiAobGlrZWx5KHNlbS0+Y291bnQgPiAwKSkKLQkJc2VtLT5jb3VudC0tOwotCWVs
c2UKLQkJX19kb3duKHNlbSk7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VtLT5sb2Nr
LCBmbGFncyk7CisJX19kb3duKHNlbSk7CiB9CiBFWFBPUlRfU1lNQk9MKGRvd24pOwogCkBA
IC03MywxNyArNzEsMTAgQEAgRVhQT1JUX1NZTUJPTChkb3duKTsKICAqLwogaW50IGRvd25f
aW50ZXJydXB0aWJsZShzdHJ1Y3Qgc2VtYXBob3JlICpzZW0pCiB7Ci0JdW5zaWduZWQgbG9u
ZyBmbGFnczsKLQlpbnQgcmVzdWx0ID0gMDsKKwlpZiAobGlrZWx5KGF0b21pY19kZWNfcmV0
dXJuKCZzZW0tPmNvdW50KSA+PSAwKSkKKwkJcmV0dXJuIDA7CiAKLQlzcGluX2xvY2tfaXJx
c2F2ZSgmc2VtLT5sb2NrLCBmbGFncyk7Ci0JaWYgKGxpa2VseShzZW0tPmNvdW50ID4gMCkp
Ci0JCXNlbS0+Y291bnQtLTsKLQllbHNlCi0JCXJlc3VsdCA9IF9fZG93bl9pbnRlcnJ1cHRp
YmxlKHNlbSk7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VtLT5sb2NrLCBmbGFncyk7
Ci0KLQlyZXR1cm4gcmVzdWx0OworCXJldHVybiBfX2Rvd25faW50ZXJydXB0aWJsZShzZW0p
OwogfQogRVhQT1JUX1NZTUJPTChkb3duX2ludGVycnVwdGlibGUpOwogCkBAIC05OSwxNyAr
OTAsMTAgQEAgRVhQT1JUX1NZTUJPTChkb3duX2ludGVycnVwdGlibGUpOwogICovCiBpbnQg
ZG93bl9raWxsYWJsZShzdHJ1Y3Qgc2VtYXBob3JlICpzZW0pCiB7Ci0JdW5zaWduZWQgbG9u
ZyBmbGFnczsKLQlpbnQgcmVzdWx0ID0gMDsKKwlpZiAobGlrZWx5KGF0b21pY19kZWNfcmV0
dXJuKCZzZW0tPmNvdW50KSA+PSAwKSkKKwkJcmV0dXJuIDA7CiAKLQlzcGluX2xvY2tfaXJx
c2F2ZSgmc2VtLT5sb2NrLCBmbGFncyk7Ci0JaWYgKGxpa2VseShzZW0tPmNvdW50ID4gMCkp
Ci0JCXNlbS0+Y291bnQtLTsKLQllbHNlCi0JCXJlc3VsdCA9IF9fZG93bl9raWxsYWJsZShz
ZW0pOwotCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNlbS0+bG9jaywgZmxhZ3MpOwotCi0J
cmV0dXJuIHJlc3VsdDsKKwlyZXR1cm4gX19kb3duX2tpbGxhYmxlKHNlbSk7CiB9CiBFWFBP
UlRfU1lNQk9MKGRvd25fa2lsbGFibGUpOwogCkBAIC0xMjgsMTYgKzExMiwyMSBAQCBFWFBP
UlRfU1lNQk9MKGRvd25fa2lsbGFibGUpOwogICovCiBpbnQgZG93bl90cnlsb2NrKHN0cnVj
dCBzZW1hcGhvcmUgKnNlbSkKIHsKLQl1bnNpZ25lZCBsb25nIGZsYWdzOwotCWludCBjb3Vu
dDsKKwlpbnQgb2xkLCBjbXA7CiAKLQlzcGluX2xvY2tfaXJxc2F2ZSgmc2VtLT5sb2NrLCBm
bGFncyk7Ci0JY291bnQgPSBzZW0tPmNvdW50IC0gMTsKLQlpZiAobGlrZWx5KGNvdW50ID49
IDApKQotCQlzZW0tPmNvdW50ID0gY291bnQ7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
c2VtLT5sb2NrLCBmbGFncyk7CisJLyoKKwkgKiBUaGUgZG93bl90cnlsb2NrIGZhc3RwYXRo
IGlzIG5vdCB2ZXJ5IG9wdGltYWwgY29tcGFyZWQgdG8gdGhlCisJICogZG93biBhbmQgdXAg
ZmFzdHBhdGgncywgYnV0IGl0IHNob3VsZCBiZSB1c2VkIGxlc3MgZnJlcXVlbnRseS4KKwkg
Ki8KKwlvbGQgPSBhdG9taWNfcmVhZCgmc2VtLT5jb3VudCk7CisJd2hpbGUgKG9sZCA+IDAp
IHsKKwkJY21wID0gb2xkOworCQlvbGQgPSBhdG9taWNfY21weGNoZygmc2VtLT5jb3VudCwg
Y21wLCBvbGQgLSAxKTsKKwkJaWYgKG9sZCA9PSBjbXApCisJCQlyZXR1cm4gMDsKKwl9CiAK
LQlyZXR1cm4gKGNvdW50IDwgMCk7CisJcmV0dXJuIDE7CiB9CiBFWFBPUlRfU1lNQk9MKGRv
d25fdHJ5bG9jayk7CiAKQEAgLTE1MywxNyArMTQyLDEwIEBAIEVYUE9SVF9TWU1CT0woZG93
bl90cnlsb2NrKTsKICAqLwogaW50IGRvd25fdGltZW91dChzdHJ1Y3Qgc2VtYXBob3JlICpz
ZW0sIGxvbmcgamlmZmllcykKIHsKLQl1bnNpZ25lZCBsb25nIGZsYWdzOwotCWludCByZXN1
bHQgPSAwOwotCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJnNlbS0+bG9jaywgZmxhZ3MpOwotCWlm
IChsaWtlbHkoc2VtLT5jb3VudCA+IDApKQotCQlzZW0tPmNvdW50LS07Ci0JZWxzZQotCQly
ZXN1bHQgPSBfX2Rvd25fdGltZW91dChzZW0sIGppZmZpZXMpOwotCXNwaW5fdW5sb2NrX2ly
cXJlc3RvcmUoJnNlbS0+bG9jaywgZmxhZ3MpOworCWlmIChsaWtlbHkoYXRvbWljX2RlY19y
ZXR1cm4oJnNlbS0+Y291bnQpID49IDApKQorCQlyZXR1cm4gMDsKIAotCXJldHVybiByZXN1
bHQ7CisJcmV0dXJuIF9fZG93bl90aW1lb3V0KHNlbSwgamlmZmllcyk7CiB9CiBFWFBPUlRf
U1lNQk9MKGRvd25fdGltZW91dCk7CiAKQEAgLTE3NiwxNCArMTU4LDEwIEBAIEVYUE9SVF9T
WU1CT0woZG93bl90aW1lb3V0KTsKICAqLwogdm9pZCB1cChzdHJ1Y3Qgc2VtYXBob3JlICpz
ZW0pCiB7Ci0JdW5zaWduZWQgbG9uZyBmbGFnczsKKwlpZiAobGlrZWx5KGF0b21pY19pbmNf
cmV0dXJuKCZzZW0tPmNvdW50KSA+IDApKQorCQlyZXR1cm47CiAKLQlzcGluX2xvY2tfaXJx
c2F2ZSgmc2VtLT5sb2NrLCBmbGFncyk7Ci0JaWYgKGxpa2VseShsaXN0X2VtcHR5KCZzZW0t
PndhaXRfbGlzdCkpKQotCQlzZW0tPmNvdW50Kys7Ci0JZWxzZQotCQlfX3VwKHNlbSk7Ci0J
c3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VtLT5sb2NrLCBmbGFncyk7CisJX191cChzZW0p
OwogfQogRVhQT1JUX1NZTUJPTCh1cCk7CiAKQEAgLTIwNSw2ICsxODMsMTUgQEAgc3RhdGlj
IGlubGluZSBpbnQgX19zY2hlZCBfX2Rvd25fY29tbW9uKHN0cnVjdCBzZW1hcGhvcmUgKnNl
bSwgbG9uZyBzdGF0ZSwKIHsKIAlzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2sgPSBjdXJyZW50
OwogCXN0cnVjdCBzZW1hcGhvcmVfd2FpdGVyIHdhaXRlcjsKKwl1bnNpZ25lZCBsb25nIGZs
YWdzOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJnNlbS0+bG9jaywgZmxhZ3MpOworCS8qCisJ
ICogU29tZW9uZSBtYXkgaGF2ZSBpbmNyZW1lbnRlZCB0aGUgY291bnQgYW5kIGZhaWxlZCB0
byB3YWtlCisJICogdXMgYmVmb3JlIHdlIGFjcXVpcmVkIHRoZSBzcGlubG9jay4KKwkgKi8K
KwlpZiAoYXRvbWljX2RlY19yZXR1cm4oJnNlbS0+Y291bnQpID49IDApCisJCWdvdG8gZG9u
ZTsKIAogCWxpc3RfYWRkX3RhaWwoJndhaXRlci5saXN0LCAmc2VtLT53YWl0X2xpc3QpOwog
CXdhaXRlci50YXNrID0gdGFzazsKQEAgLTIyMiwxNiArMjA5LDIyIEBAIHN0YXRpYyBpbmxp
bmUgaW50IF9fc2NoZWQgX19kb3duX2NvbW1vbihzdHJ1Y3Qgc2VtYXBob3JlICpzZW0sIGxv
bmcgc3RhdGUsCiAJCXRpbWVvdXQgPSBzY2hlZHVsZV90aW1lb3V0KHRpbWVvdXQpOwogCQlz
cGluX2xvY2tfaXJxKCZzZW0tPmxvY2spOwogCQlpZiAod2FpdGVyLnVwKQotCQkJcmV0dXJu
IDA7CisJCQlnb3RvIGRvbmU7CiAJfQogCiAgdGltZWRfb3V0OgogCWxpc3RfZGVsKCZ3YWl0
ZXIubGlzdCk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VtLT5sb2NrLCBmbGFncyk7
CiAJcmV0dXJuIC1FVElNRTsKIAogIGludGVycnVwdGVkOgogCWxpc3RfZGVsKCZ3YWl0ZXIu
bGlzdCk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2VtLT5sb2NrLCBmbGFncyk7CiAJ
cmV0dXJuIC1FSU5UUjsKKworIGRvbmU6CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmc2Vt
LT5sb2NrLCBmbGFncyk7CisJcmV0dXJuIDA7CiB9CiAKIHN0YXRpYyBub2lubGluZSB2b2lk
IF9fc2NoZWQgX19kb3duKHN0cnVjdCBzZW1hcGhvcmUgKnNlbSkKQEAgLTI1Niw5ICsyNDks
MzEgQEAgc3RhdGljIG5vaW5saW5lIGludCBfX3NjaGVkIF9fZG93bl90aW1lb3V0KHN0cnVj
dCBzZW1hcGhvcmUgKnNlbSwgbG9uZyBqaWZmaWVzKQogCiBzdGF0aWMgbm9pbmxpbmUgdm9p
ZCBfX3NjaGVkIF9fdXAoc3RydWN0IHNlbWFwaG9yZSAqc2VtKQogewotCXN0cnVjdCBzZW1h
cGhvcmVfd2FpdGVyICp3YWl0ZXIgPSBsaXN0X2ZpcnN0X2VudHJ5KCZzZW0tPndhaXRfbGlz
dCwKKwlzdHJ1Y3Qgc2VtYXBob3JlX3dhaXRlciAqd2FpdGVyOworCXVuc2lnbmVkIGxvbmcg
ZmxhZ3M7CisJaW50IG9sZCwgY21wOworCisJc3Bpbl9sb2NrX2lycXNhdmUoJnNlbS0+bG9j
aywgZmxhZ3MpOworCS8qCisJICogSWYgdGhlIHdhaXQgbGlzdCBpcyBlbXB0eSwgaXQgbWVh
bnMgZWl0aGVyIHdlIGFjcXVpcmVkIHRoZSBzcGlubG9jaworCSAqIGZhc3RlciB0aGFuIGEg
cG9zc2libGUgd2FpdGVyIG9yIHRoZSBwb3NzaWJsZSB3YWl0ZXIgYWJhbmRvbmVkIHRoZQor
CSAqIHdhaXQgYmVjYXVzZSBpdCBnb3QgaW50ZXJydXB0ZWQgb3IgdGltZWQgb3V0LiBJbiBz
dWNoIGNhc2Ugd2UgaGF2ZQorCSAqIHRvIGluY3JlbWVudCB0aGUgY291bnQgdG8gYSB2YWx1
ZSB0aGF0IGlzIGdyZWF0ZXIgb3IgZXF1YWwgdGhhbiAxLgorCSAqLworCWlmIChsaXN0X2Vt
cHR5KCZzZW0tPndhaXRfbGlzdCkpIHsKKwkJb2xkID0gYXRvbWljX3JlYWQoJnNlbS0+Y291
bnQpOworCQlkbyB7CisJCQljbXAgPSBvbGQ7CisJCQlvbGQgPSAob2xkID4gMCkgPyBvbGQg
KyAxIDogMTsKKwkJCW9sZCA9IGF0b21pY19jbXB4Y2hnKCZzZW0tPmNvdW50LCBjbXAsIG9s
ZCk7CisJCX0gd2hpbGUgKGNtcCAhPSBvbGQpOworCisJfSBlbHNlIHsKKwkJd2FpdGVyID0g
bGlzdF9maXJzdF9lbnRyeSgmc2VtLT53YWl0X2xpc3QsCiAJCQkJCQlzdHJ1Y3Qgc2VtYXBo
b3JlX3dhaXRlciwgbGlzdCk7Ci0JbGlzdF9kZWwoJndhaXRlci0+bGlzdCk7Ci0Jd2FpdGVy
LT51cCA9IDE7Ci0Jd2FrZV91cF9wcm9jZXNzKHdhaXRlci0+dGFzayk7CisJCWxpc3RfZGVs
KCZ3YWl0ZXItPmxpc3QpOworCQl3YWl0ZXItPnVwID0gMTsKKwkJd2FrZV91cF9wcm9jZXNz
KHdhaXRlci0+dGFzayk7CisJfQorCXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnNlbS0+bG9j
aywgZmxhZ3MpOwogfQotLSAKMS41LjIuNQoK
--------------000606070704050508000407--
