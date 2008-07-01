Return-Path: <linux-kernel-owner+w=401wt.eu-S1757248AbYGANcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757248AbYGANcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbYGANcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:32:12 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:3846 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393AbYGANcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:32:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type;
        b=VsCND4StJPXj5tpvjU+w9l9otJMMyhnEEO/8F1FxZhcfSy4Z7Aj8TOrKFnMfJsttap
         SoNBNTSudW8/MK8uiRCX9+JsT9mP7cm3MY06GaVEoGPyg5A5C1R7QfPEUfA7OrVqKyAG
         0Mqe8/HIH0YlgQV7sfx6CLtG97T1zL2jE4VYQ=
Message-ID: <b647ffbd0807010632o64a61ab9le6039465cee85e9c@mail.gmail.com>
Date: Tue, 1 Jul 2008 15:32:09 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Gregory Haskins" <ghaskins@novell.com>
Subject: [sched-devel, patch-rfc] rework #2 of "prioritize non-migratable tasks over migratable ones"
Cc: "Ingo Molnar" <mingo@elte.hu>, "Steven Rostedt" <rostedt@goodmis.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_22511_30037367.1214919129463"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_22511_30037367.1214919129463
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,


this is a continuation of another thread:
http://www.ussg.iu.edu/hypermail/linux/kernel/0807.0/0134.html


The following patch is just an illustration, not tested even compilation wise.


(1) handle in a generic way all cases when a newly woken-up task is
not migratable (not just a corner case when "rt_se->nr_cpus_allowed ==
1")

(2) if current is to be preempted, then make sure "p" will be picked
up by pick_next_task_rt().
i.e. move task's group at the head of its list as well.

currently, it's not a case for group-scheduling as described here:
http://www.ussg.iu.edu/hypermail/linux/kernel/0807.0/0134.html


what do you think?


(non white-space-damaged version is enclosed)


---

--- sched_rt-old.c      2008-07-01 11:42:30.000000000 +0200
+++ sched_rt.c  2008-07-01 15:00:55.000000000 +0200
@@ -599,11 +599,7 @@ static void __enqueue_rt_entity(struct s
        if (group_rq && (rt_rq_throttled(group_rq) ||
!group_rq->rt_nr_running))                return;

-       if (rt_se->nr_cpus_allowed == 1)
-               list_add(&rt_se->run_list, queue);
-       else
-               list_add_tail(&rt_se->run_list, queue);
-
+       list_add_tail(&rt_se->run_list, queue);
        __set_bit(rt_se_prio(rt_se), array->bitmap);

        inc_rt_tasks(rt_se, rt_rq);
@@ -689,31 +685,33 @@ static void dequeue_task_rt(struct rq *r
  * followed by enqueue.
  */
 static
-void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity *rt_se)
+void requeue_rt_entity(struct rt_rq *rt_rq, struct sched_rt_entity
*rt_se, int head)
 {
-       struct rt_prio_array *array = &rt_rq->active;
-
        if (on_rt_rq(rt_se)) {
-               list_del_init(&rt_se->run_list);
-               list_add_tail(&rt_se->run_list,
-                             array->queue + rt_se_prio(rt_se));
+               struct rt_prio_array *array = &rt_rq->active;
+               struct list_head *queue = array->queue + rt_se_prio(rt_se);
+
+               if (head)
+                       list_move(&rt_se->run_list, queue);
+               else
+                       list_move_tail(&rt_se->run_list, queue);
        }
 }

-static void requeue_task_rt(struct rq *rq, struct task_struct *p)
+static void requeue_task_rt(struct rq *rq, struct task_struct *p, int head)
 {
        struct sched_rt_entity *rt_se = &p->rt;
        struct rt_rq *rt_rq;

        for_each_sched_rt_entity(rt_se) {
                rt_rq = rt_rq_of_se(rt_se);
-               requeue_rt_entity(rt_rq, rt_se);
+               requeue_rt_entity(rt_rq, rt_se, head);
        }
 }

 static void yield_task_rt(struct rq *rq)
 {
-       requeue_task_rt(rq, rq->curr);
+       requeue_task_rt(rq, rq->curr, 0);
 }

 #ifdef CONFIG_SMP
@@ -753,6 +751,29 @@ static int select_task_rq_rt(struct task
         */
        return task_cpu(p);
 }
+
+static void check_preempt_equal_prio(struct rq *rq, struct task_struct *p)
+{
+       cpumask_t mask;
+
+       if (rq->curr.rt.nr_cpus_allowed == 1 || p->rt.nr_cpus_allowed == 1)
+               return;
+
+       if (cpupri_find(&rq->rd->cpupri, p, &mask))
+               return;
+
+       if (!cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
+               return;
+
+       /*
+        * There appears to be other cpus that can accept
+        * current and none to run 'p', so lets reschedule
+        * to try and push current away:
+        */
+       requeue_task_rt(rq, p, 1);
+       resched_task(rq->curr);
+}
+
 #endif /* CONFIG_SMP */

 /*
@@ -778,18 +799,8 @@ static void check_preempt_curr_rt(struct
         * to move current somewhere else, making room for our non-migratable
         * task.
         */
-       if((p->prio == rq->curr->prio)
-          && p->rt.nr_cpus_allowed == 1
-          && rq->curr->rt.nr_cpus_allowed != 1) {
-               cpumask_t mask;
-
-               if (cpupri_find(&rq->rd->cpupri, rq->curr, &mask))
-                       /*
-                        * There appears to be other cpus that can accept
-                        * current, so lets reschedule to try and push it away
-                        */
-                       resched_task(rq->curr);
-       }
+       if (p->prio == rq->curr->prio && !need_resched())
+               check_preempt_equal_prio(rq, p);
 #endif
 }

@@ -1415,7 +1426,7 @@ static void task_tick_rt(struct rq *rq,
         * on the queue:
         */
        if (p->rt.run_list.prev != p->rt.run_list.next) {
-               requeue_task_rt(rq, p);
+               requeue_task_rt(rq, p, 0);
                set_tsk_need_resched(p);
        }
 }

---



-- 
Best regards,
Dmitry Adamushko

------=_Part_22511_30037367.1214919129463
Content-Type: text/x-patch; name=resched-eqial-prio.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fi4jem1t0
Content-Disposition: attachment; filename=resched-eqial-prio.patch

LS0tIHNjaGVkX3J0LW9sZC5jCTIwMDgtMDctMDEgMTE6NDI6MzAuMDAwMDAwMDAwICswMjAwCisr
KyBzY2hlZF9ydC5jCTIwMDgtMDctMDEgMTU6MDA6NTUuMDAwMDAwMDAwICswMjAwCkBAIC01OTks
MTEgKzU5OSw3IEBAIHN0YXRpYyB2b2lkIF9fZW5xdWV1ZV9ydF9lbnRpdHkoc3RydWN0IHMKIAlp
ZiAoZ3JvdXBfcnEgJiYgKHJ0X3JxX3Rocm90dGxlZChncm91cF9ycSkgfHwgIWdyb3VwX3JxLT5y
dF9ucl9ydW5uaW5nKSkKIAkJcmV0dXJuOwogCi0JaWYgKHJ0X3NlLT5ucl9jcHVzX2FsbG93ZWQg
PT0gMSkKLQkJbGlzdF9hZGQoJnJ0X3NlLT5ydW5fbGlzdCwgcXVldWUpOwotCWVsc2UKLQkJbGlz
dF9hZGRfdGFpbCgmcnRfc2UtPnJ1bl9saXN0LCBxdWV1ZSk7Ci0KKwlsaXN0X2FkZF90YWlsKCZy
dF9zZS0+cnVuX2xpc3QsIHF1ZXVlKTsKIAlfX3NldF9iaXQocnRfc2VfcHJpbyhydF9zZSksIGFy
cmF5LT5iaXRtYXApOwogCiAJaW5jX3J0X3Rhc2tzKHJ0X3NlLCBydF9ycSk7CkBAIC02ODksMzEg
KzY4NSwzMyBAQCBzdGF0aWMgdm9pZCBkZXF1ZXVlX3Rhc2tfcnQoc3RydWN0IHJxICpyCiAgKiBm
b2xsb3dlZCBieSBlbnF1ZXVlLgogICovCiBzdGF0aWMKLXZvaWQgcmVxdWV1ZV9ydF9lbnRpdHko
c3RydWN0IHJ0X3JxICpydF9ycSwgc3RydWN0IHNjaGVkX3J0X2VudGl0eSAqcnRfc2UpCit2b2lk
IHJlcXVldWVfcnRfZW50aXR5KHN0cnVjdCBydF9ycSAqcnRfcnEsIHN0cnVjdCBzY2hlZF9ydF9l
bnRpdHkgKnJ0X3NlLCBpbnQgaGVhZCkKIHsKLQlzdHJ1Y3QgcnRfcHJpb19hcnJheSAqYXJyYXkg
PSAmcnRfcnEtPmFjdGl2ZTsKLQogCWlmIChvbl9ydF9ycShydF9zZSkpIHsKLQkJbGlzdF9kZWxf
aW5pdCgmcnRfc2UtPnJ1bl9saXN0KTsKLQkJbGlzdF9hZGRfdGFpbCgmcnRfc2UtPnJ1bl9saXN0
LAotCQkJICAgICAgYXJyYXktPnF1ZXVlICsgcnRfc2VfcHJpbyhydF9zZSkpOworCQlzdHJ1Y3Qg
cnRfcHJpb19hcnJheSAqYXJyYXkgPSAmcnRfcnEtPmFjdGl2ZTsKKwkJc3RydWN0IGxpc3RfaGVh
ZCAqcXVldWUgPSBhcnJheS0+cXVldWUgKyBydF9zZV9wcmlvKHJ0X3NlKTsKKworCQlpZiAoaGVh
ZCkKKwkJCWxpc3RfbW92ZSgmcnRfc2UtPnJ1bl9saXN0LCBxdWV1ZSk7CisJCWVsc2UKKwkJCWxp
c3RfbW92ZV90YWlsKCZydF9zZS0+cnVuX2xpc3QsIHF1ZXVlKTsKIAl9CiB9CiAKLXN0YXRpYyB2
b2lkIHJlcXVldWVfdGFza19ydChzdHJ1Y3QgcnEgKnJxLCBzdHJ1Y3QgdGFza19zdHJ1Y3QgKnAp
CitzdGF0aWMgdm9pZCByZXF1ZXVlX3Rhc2tfcnQoc3RydWN0IHJxICpycSwgc3RydWN0IHRhc2tf
c3RydWN0ICpwLCBpbnQgaGVhZCkKIHsKIAlzdHJ1Y3Qgc2NoZWRfcnRfZW50aXR5ICpydF9zZSA9
ICZwLT5ydDsKIAlzdHJ1Y3QgcnRfcnEgKnJ0X3JxOwogCiAJZm9yX2VhY2hfc2NoZWRfcnRfZW50
aXR5KHJ0X3NlKSB7CiAJCXJ0X3JxID0gcnRfcnFfb2Zfc2UocnRfc2UpOwotCQlyZXF1ZXVlX3J0
X2VudGl0eShydF9ycSwgcnRfc2UpOworCQlyZXF1ZXVlX3J0X2VudGl0eShydF9ycSwgcnRfc2Us
IGhlYWQpOwogCX0KIH0KIAogc3RhdGljIHZvaWQgeWllbGRfdGFza19ydChzdHJ1Y3QgcnEgKnJx
KQogewotCXJlcXVldWVfdGFza19ydChycSwgcnEtPmN1cnIpOworCXJlcXVldWVfdGFza19ydChy
cSwgcnEtPmN1cnIsIDApOwogfQogCiAjaWZkZWYgQ09ORklHX1NNUApAQCAtNzUzLDYgKzc1MSwy
OSBAQCBzdGF0aWMgaW50IHNlbGVjdF90YXNrX3JxX3J0KHN0cnVjdCB0YXNrCiAJICovCiAJcmV0
dXJuIHRhc2tfY3B1KHApOwogfQorCitzdGF0aWMgdm9pZCBjaGVja19wcmVlbXB0X2VxdWFsX3By
aW8oc3RydWN0IHJxICpycSwgc3RydWN0IHRhc2tfc3RydWN0ICpwKQoreworCWNwdW1hc2tfdCBt
YXNrOworCisJaWYgKHJxLT5jdXJyLnJ0Lm5yX2NwdXNfYWxsb3dlZCA9PSAxIHx8IHAtPnJ0Lm5y
X2NwdXNfYWxsb3dlZCA9PSAxKQorCQlyZXR1cm47CisKKwlpZiAoY3B1cHJpX2ZpbmQoJnJxLT5y
ZC0+Y3B1cHJpLCBwLCAmbWFzaykpCisJCXJldHVybjsKKwkKKwlpZiAoIWNwdXByaV9maW5kKCZy
cS0+cmQtPmNwdXByaSwgcnEtPmN1cnIsICZtYXNrKSkKKwkJcmV0dXJuOworCisJLyoKKwkgKiBU
aGVyZSBhcHBlYXJzIHRvIGJlIG90aGVyIGNwdXMgdGhhdCBjYW4gYWNjZXB0CisJICogY3VycmVu
dCBhbmQgbm9uZSB0byBydW4gJ3AnLCBzbyBsZXRzIHJlc2NoZWR1bGUKKwkgKiB0byB0cnkgYW5k
IHB1c2ggY3VycmVudCBhd2F5OgorCSAqLworCXJlcXVldWVfdGFza19ydChycSwgcCwgMSk7CisJ
cmVzY2hlZF90YXNrKHJxLT5jdXJyKTsKK30KKwogI2VuZGlmIC8qIENPTkZJR19TTVAgKi8KIAog
LyoKQEAgLTc3OCwxOCArNzk5LDggQEAgc3RhdGljIHZvaWQgY2hlY2tfcHJlZW1wdF9jdXJyX3J0
KHN0cnVjdAogCSAqIHRvIG1vdmUgY3VycmVudCBzb21ld2hlcmUgZWxzZSwgbWFraW5nIHJvb20g
Zm9yIG91ciBub24tbWlncmF0YWJsZQogCSAqIHRhc2suCiAJICovCi0JaWYoKHAtPnByaW8gPT0g
cnEtPmN1cnItPnByaW8pCi0JICAgJiYgcC0+cnQubnJfY3B1c19hbGxvd2VkID09IDEKLQkgICAm
JiBycS0+Y3Vyci0+cnQubnJfY3B1c19hbGxvd2VkICE9IDEpIHsKLQkJY3B1bWFza190IG1hc2s7
Ci0KLQkJaWYgKGNwdXByaV9maW5kKCZycS0+cmQtPmNwdXByaSwgcnEtPmN1cnIsICZtYXNrKSkK
LQkJCS8qCi0JCQkgKiBUaGVyZSBhcHBlYXJzIHRvIGJlIG90aGVyIGNwdXMgdGhhdCBjYW4gYWNj
ZXB0Ci0JCQkgKiBjdXJyZW50LCBzbyBsZXRzIHJlc2NoZWR1bGUgdG8gdHJ5IGFuZCBwdXNoIGl0
IGF3YXkKLQkJCSAqLwotCQkJcmVzY2hlZF90YXNrKHJxLT5jdXJyKTsKLQl9CisJaWYgKHAtPnBy
aW8gPT0gcnEtPmN1cnItPnByaW8gJiYgIW5lZWRfcmVzY2hlZCgpKQorCQljaGVja19wcmVlbXB0
X2VxdWFsX3ByaW8ocnEsIHApOwogI2VuZGlmCiB9CiAKQEAgLTE0MTUsNyArMTQyNiw3IEBAIHN0
YXRpYyB2b2lkIHRhc2tfdGlja19ydChzdHJ1Y3QgcnEgKnJxLCAKIAkgKiBvbiB0aGUgcXVldWU6
CiAJICovCiAJaWYgKHAtPnJ0LnJ1bl9saXN0LnByZXYgIT0gcC0+cnQucnVuX2xpc3QubmV4dCkg
ewotCQlyZXF1ZXVlX3Rhc2tfcnQocnEsIHApOworCQlyZXF1ZXVlX3Rhc2tfcnQocnEsIHAsIDAp
OwogCQlzZXRfdHNrX25lZWRfcmVzY2hlZChwKTsKIAl9CiB9Cg==
------=_Part_22511_30037367.1214919129463--
