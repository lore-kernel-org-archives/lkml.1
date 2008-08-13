Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbYHMIZN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbYHMIZN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:25:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752347AbYHMIZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:25:00 -0400
Received: from ik-out-1112.google.com ([66.249.90.182]:63592 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752202AbYHMIY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:24:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=ps+YJ3BAERMmrcezop1uZbK3zw1LzF+GYwLzU4hA5NoxKGbCm9ACNh7iGQsZBpu1Hs
         DAHY0MWzq7sC8ia7okKneOJF+AO85u+mxhQmPsG1IVHFztPaZJNMbu2lqm5aHyoYgTa6
         RPep9kMCayC7otzgwtODedtbpKjXAZ1hUPaJo=
Message-ID: <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
Date: Wed, 13 Aug 2008 10:24:54 +0200
From: "John Kacur" <jkacur@gmail.com>
To: mgross@linux.intel.com
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <20080812224926.GA20652@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_54842_3225356.1218615894326"
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217921101.3589.98.camel@twins>
	 <20080805204901.GA31132@linux.intel.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
	 <20080812224926.GA20652@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_54842_3225356.1218615894326
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Wed, Aug 13, 2008 at 12:49 AM, mark gross <mgross@linux.intel.com> wrote:
> On Wed, Aug 06, 2008 at 12:18:08AM +0200, John Kacur wrote:
>> On Tue, Aug 5, 2008 at 11:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Tue, 2008-08-05 at 13:49 -0700, mark gross wrote:
>> >> On Tue, Aug 05, 2008 at 09:25:01AM +0200, Peter Zijlstra wrote:
>> >> > On Mon, 2008-08-04 at 22:52 +0200, John Kacur wrote:
>> >> > > Even after applying some fixes posted by Chirag and Peter Z, I'm still
>> >> > > getting some messages in my log like this
>> >> >
>> >> > > BUG: sleeping function called from invalid context swapper(0) at
>> >> > > kernel/rtmutex.c:743
>> >> > > in_atomic():1 [00000001], irqs_disabled():1
>> >> > > Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2
>> >> > >
>> >> > > Call Trace:
>> >> > >  [<ffffffff802305d3>] __might_sleep+0x12d/0x132
>> >> > >  [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
>> >> > >  [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
>> >> > >  [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
>> >> > >  [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
>> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> >> > >  [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
>> >> > >  [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
>> >> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> >> > >  [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
>> >> > >  [<ffffffff80466af0>] start_secondary+0x186/0x18b
>> >> > >
>> >> > > ---------------------------
>> >> > > | preempt count: 00000001 ]
>> >> > > | 1-level deep critical section nesting:
>> >> > > ----------------------------------------
>> >> > > ... [<ffffffff8020b39c>] .... cpu_idle+0x11b/0x12d
>> >> > > ......[<ffffffff80466af0>] ..   ( <= start_secondary+0x186/0x18b)
>> >> > >
>> >> > > The following simple patch makes the messages disappear - however,
>> >> > > there may be a better more fine grained solution, but the problem is
>> >> > > also that all the functions are designed to use the same lock.
>> >> >
>> >> > Hmm, I think you're right - its called from the idle routine so we can't
>> >> > go about sleeping there.
>> >> >
>> >> > The only trouble I have is with kernel/pm_qos_params.c:update_target()'s
>> >> > use of this lock - that is decidedly not O(1).
>> >> >
>> >> > Mark, would it be possible to split that lock in two, one lock
>> >> > protecting pm_qos_array[], and one lock protecting the
>> >> > requirements.list ?
>> >>
>> >> very likely, but I'm not sure how it will help.
>> >>
>> >> the fine grain locking I had initially worked out on pm_qos was to have
>> >> a lock per pm_qos_object, that would be used for accessing the
>> >> requirement_list and the target_value.  But that isn't what you are
>> >> asking about is it?
>> >>
>> >> Is what you want is a pm_qos_requirements_list_lock and a
>> >> pm_qos_target_value_lock, for each pm_qos_object instance?
>> >>
>> >> I guess it wold work but besides giving the code spinlock diarrhea would
>> >> it really help solve the issue you are seeing?
>> >
>> > The problem is that on -rt spinlocks turn into mutexes. And the above
>> > BUG tells us that the idle loop might end up scheduling due to trying to
>> > take this lock.
>> >
>> > Now, the way I read the code, pm_qos_lock protects multiple things:
>> >
>> >  - pm_qos_array[target]->target_value
>> >
>> >  - &pm_qos_array[pm_qos_class]->requirements.list
>> >
>> > Now, the thing is, we could turn the lock back into a real spinlock
>> > (raw_spinlock_t), but the loops in eg update_target() are not O(1) and
>> > could thus cause serious preempt-off latencies.
>> >
>> > My question was, and now having had a second look at the code I think it
>> > is, would it be possible to guard the list using a sleeping lock,
>> > protect the target_value using a (raw) spinlock.
>> >
>> > OTOH, just reading a (word aligned, word sized) value doesn't normally
>> > require serialization, esp if the update site is already serialized by
>> > other means.
>> >
>> > So could we perhaps remove the lock usage from pm_qos_requirement()? -
>> > that too would solve the issue.
>> >
>> >
>> >  - Peter
>> >
>>
>> How about this patch? Like Peter suggests, It adds a raw spinlock only
>> for the target value. I'm currently running with it, but still
>> testing, comments are appreciated.
>>
>> Thanks
>
>> pm_qos_requirement-fix
>> Signed-off-by: John Kacur <jkacur at gmail dot com>
>>
>> Add a raw spinlock for the target value.
>>
>>
>> Index: linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
>> ===================================================================
>> --- linux-2.6.26.1-rt1.jk.orig/kernel/pm_qos_params.c
>> +++ linux-2.6.26.1-rt1.jk/kernel/pm_qos_params.c
>> @@ -111,6 +111,7 @@ static struct pm_qos_object *pm_qos_arra
>>  };
>>
>>  static DEFINE_SPINLOCK(pm_qos_lock);
>> +static DEFINE_RAW_SPINLOCK(pm_qos_rawlock);
>>
>>  static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
>>               size_t count, loff_t *f_pos);
>> @@ -149,13 +150,15 @@ static void update_target(int target)
>>               extreme_value = pm_qos_array[target]->comparitor(
>>                               extreme_value, node->value);
>>       }
>> +     spin_unlock_irqrestore(&pm_qos_lock, flags);
>> +     spin_lock_irqsave(&pm_qos_rawlock, flags);
>>       if (pm_qos_array[target]->target_value != extreme_value) {
>>               call_notifier = 1;
>>               pm_qos_array[target]->target_value = extreme_value;
>>               pr_debug(KERN_ERR "new target for qos %d is %d\n", target,
>>                       pm_qos_array[target]->target_value);
>>       }
>> -     spin_unlock_irqrestore(&pm_qos_lock, flags);
>> +     spin_unlock_irqrestore(&pm_qos_rawlock, flags);
>>
>>       if (call_notifier)
>>               blocking_notifier_call_chain(pm_qos_array[target]->notifiers,
>> @@ -195,9 +198,9 @@ int pm_qos_requirement(int pm_qos_class)
>>       int ret_val;
>>       unsigned long flags;
>>
>> -     spin_lock_irqsave(&pm_qos_lock, flags);
>> +     spin_lock_irqsave(&pm_qos_rawlock, flags);
>>       ret_val = pm_qos_array[pm_qos_class]->target_value;
>> -     spin_unlock_irqrestore(&pm_qos_lock, flags);
>> +     spin_unlock_irqrestore(&pm_qos_rawlock, flags);
>>
>>       return ret_val;
>>  }
>
> As long as RAW_SPINLOCK compiles to a normal spinlock for non-RT premept
> kernels I'm don't see a problem, as the change is almost a no-op for
> non-RT kernels.

Correct, kernels with the rt patch that are configured to be non-rt
change the raw_spinlock to a normal spinlock. This patch still applies
to rt kernels only.

>
> Signed-off-by: mark gross <mgross@linux.intel.com>
>
> Should I send an updated patch that includes a change to the comment
> block regarding the locking design after this patch or instead of it?
>

I've updated my patch to include changes to the comment block about
the locking design. I've also added your Signed-off-by line . (Maybe
Acked-by: would be more appropriate?)

Now that I've separated locking of the target value from the other
locks, Peter's question still remains. Could the lock protecting
target be dropped from mainline which would allow us to drop this
patch altogether from rt? For now the safe thing to do is keep it
protected, but could you explain why it is needed? (it may very well
be)

Thank You.
(updated patch attached)

------=_Part_54842_3225356.1218615894326
Content-Type: text/x-patch; name=pm_qos_requirement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjto4n6v0
Content-Disposition: attachment; filename=pm_qos_requirement.patch

cG1fcW9zX3JlcXVpcmVtZW50LWZpeApBZGQgYSByYXdfc3BpbmxvY2tfdCBmb3IgdGFyZ2V0LiB0
YXJnZXQgaXMgbW9kaWZpZWQgaW4gcG1fcW9zX3JlcXVpcmVtZW50CmNhbGxlZCBieSBpZGxlIHNv
IGl0IGNhbm5vdCBiZSBhbGxvd2VkIHRvIHNsZWVwLgoKU2lnbmVkLW9mZi1ieTogSm9obiBLYWN1
ciA8amthY3VyIGF0IGdtYWlsIGRvdCBjb20+ClNpZ25lZC1vZmYtYnk6IG1hcmsgZ3Jvc3MgPG1n
cm9zc0BsaW51eC5pbnRlbC5jb20+CgpJbmRleDogbGludXgtMi42LjI2LjEtcnQxLmprL2tlcm5l
bC9wbV9xb3NfcGFyYW1zLmMKPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQotLS0gbGludXgtMi42LjI2LjEtcnQxLmprLm9y
aWcva2VybmVsL3BtX3Fvc19wYXJhbXMuYworKysgbGludXgtMi42LjI2LjEtcnQxLmprL2tlcm5l
bC9wbV9xb3NfcGFyYW1zLmMKQEAgLTQyLDkgKzQyLDEwIEBACiAjaW5jbHVkZSA8bGludXgvdWFj
Y2Vzcy5oPgogCiAvKgotICogbG9ja2luZyBydWxlOiBhbGwgY2hhbmdlcyB0byB0YXJnZXRfdmFs
dWUgb3IgcmVxdWlyZW1lbnRzIG9yIG5vdGlmaWVycyBsaXN0cworICogbG9ja2luZyBydWxlOiBh
bGwgY2hhbmdlcyB0byByZXF1aXJlbWVudHMgb3Igbm90aWZpZXJzIGxpc3RzCiAgKiBvciBwbV9x
b3Nfb2JqZWN0IGxpc3QgYW5kIHBtX3Fvc19vYmplY3RzIG5lZWQgdG8gaGFwcGVuIHdpdGggcG1f
cW9zX2xvY2sKLSAqIGhlbGQsIHRha2VuIHdpdGggX2lycXNhdmUuICBPbmUgbG9jayB0byBydWxl
IHRoZW0gYWxsCisgKiBoZWxkLCB0YWtlbiB3aXRoIF9pcnFzYXZlLiB0YXJnZXQgaXMgbG9ja2Vk
IGJ5IHBtX3Fvc19yYXdsb2NrIGJlY2F1c2UgaXQKKyAqIGlzIG1vZGlmaWVkIGluIHBtX3Fvc19y
ZXF1aXJlbWVudCBjYWxsZWQgZnJvbSBpZGxlIGFuZCBjYW5ub3Qgc2xlZXAuCiAgKi8KIHN0cnVj
dCByZXF1aXJlbWVudF9saXN0IHsKIAlzdHJ1Y3QgbGlzdF9oZWFkIGxpc3Q7CkBAIC0xMTEsNiAr
MTEyLDcgQEAgc3RhdGljIHN0cnVjdCBwbV9xb3Nfb2JqZWN0ICpwbV9xb3NfYXJyYQogfTsKIAog
c3RhdGljIERFRklORV9TUElOTE9DSyhwbV9xb3NfbG9jayk7CitzdGF0aWMgREVGSU5FX1JBV19T
UElOTE9DSyhwbV9xb3NfcmF3bG9jayk7CiAKIHN0YXRpYyBzc2l6ZV90IHBtX3Fvc19wb3dlcl93
cml0ZShzdHJ1Y3QgZmlsZSAqZmlscCwgY29uc3QgY2hhciBfX3VzZXIgKmJ1ZiwKIAkJc2l6ZV90
IGNvdW50LCBsb2ZmX3QgKmZfcG9zKTsKQEAgLTE0OSwxMyArMTUxLDE1IEBAIHN0YXRpYyB2b2lk
IHVwZGF0ZV90YXJnZXQoaW50IHRhcmdldCkKIAkJZXh0cmVtZV92YWx1ZSA9IHBtX3Fvc19hcnJh
eVt0YXJnZXRdLT5jb21wYXJpdG9yKAogCQkJCWV4dHJlbWVfdmFsdWUsIG5vZGUtPnZhbHVlKTsK
IAl9CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG1fcW9zX2xvY2ssIGZsYWdzKTsKKwlzcGlu
X2xvY2tfaXJxc2F2ZSgmcG1fcW9zX3Jhd2xvY2ssIGZsYWdzKTsKIAlpZiAocG1fcW9zX2FycmF5
W3RhcmdldF0tPnRhcmdldF92YWx1ZSAhPSBleHRyZW1lX3ZhbHVlKSB7CiAJCWNhbGxfbm90aWZp
ZXIgPSAxOwogCQlwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+dGFyZ2V0X3ZhbHVlID0gZXh0cmVtZV92
YWx1ZTsKIAkJcHJfZGVidWcoS0VSTl9FUlIgIm5ldyB0YXJnZXQgZm9yIHFvcyAlZCBpcyAlZFxu
IiwgdGFyZ2V0LAogCQkJcG1fcW9zX2FycmF5W3RhcmdldF0tPnRhcmdldF92YWx1ZSk7CiAJfQot
CXNwaW5fdW5sb2NrX2lycXJlc3RvcmUoJnBtX3Fvc19sb2NrLCBmbGFncyk7CisJc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmcG1fcW9zX3Jhd2xvY2ssIGZsYWdzKTsKIAogCWlmIChjYWxsX25vdGlm
aWVyKQogCQlibG9ja2luZ19ub3RpZmllcl9jYWxsX2NoYWluKHBtX3Fvc19hcnJheVt0YXJnZXRd
LT5ub3RpZmllcnMsCkBAIC0xOTUsOSArMTk5LDEyIEBAIGludCBwbV9xb3NfcmVxdWlyZW1lbnQo
aW50IHBtX3Fvc19jbGFzcykKIAlpbnQgcmV0X3ZhbDsKIAl1bnNpZ25lZCBsb25nIGZsYWdzOwog
Ci0Jc3Bpbl9sb2NrX2lycXNhdmUoJnBtX3Fvc19sb2NrLCBmbGFncyk7CisJLyoKKwkgKiBwbV9x
b3NfcmVxdWlyZW1lbnQgaXMgY2FsbGVkIGZyb20gaWRsZSwgc28gaXQgY2Fubm90IHNsZWVwCisJ
ICovCisJc3Bpbl9sb2NrX2lycXNhdmUoJnBtX3Fvc19yYXdsb2NrLCBmbGFncyk7CiAJcmV0X3Zh
bCA9IHBtX3Fvc19hcnJheVtwbV9xb3NfY2xhc3NdLT50YXJnZXRfdmFsdWU7Ci0Jc3Bpbl91bmxv
Y2tfaXJxcmVzdG9yZSgmcG1fcW9zX2xvY2ssIGZsYWdzKTsKKwlzcGluX3VubG9ja19pcnFyZXN0
b3JlKCZwbV9xb3NfcmF3bG9jaywgZmxhZ3MpOwogCiAJcmV0dXJuIHJldF92YWw7CiB9Cg==
------=_Part_54842_3225356.1218615894326--
