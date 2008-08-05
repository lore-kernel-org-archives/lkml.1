Return-Path: <linux-kernel-owner+w=401wt.eu-S1763435AbYHEWSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763435AbYHEWSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 18:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752307AbYHEWSM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 18:18:12 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:57760 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbYHEWSL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 18:18:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=hI1WMqsVpJfXEqmS11VqYXDxAxQk2nugUDRZBHJgCeUSGbb5rofu6C1zCM+4vmOoKG
         vn58rfcHY2k3lvLHEe5grW05dvXQEBEWGBLxuwa6WOaLDeh8/+lVBmwNRA4tCyfkOuKK
         uZ7oosrKLmhGi29gxGNczybta6XkqMBDeP6GM=
Message-ID: <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
Date: Wed, 6 Aug 2008 00:18:08 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: mgross@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_46316_13032952.1217974688790"
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217921101.3589.98.camel@twins>
	 <20080805204901.GA31132@linux.intel.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_46316_13032952.1217974688790
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Aug 5, 2008 at 11:09 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2008-08-05 at 13:49 -0700, mark gross wrote:
>> On Tue, Aug 05, 2008 at 09:25:01AM +0200, Peter Zijlstra wrote:
>> > On Mon, 2008-08-04 at 22:52 +0200, John Kacur wrote:
>> > > Even after applying some fixes posted by Chirag and Peter Z, I'm still
>> > > getting some messages in my log like this
>> >
>> > > BUG: sleeping function called from invalid context swapper(0) at
>> > > kernel/rtmutex.c:743
>> > > in_atomic():1 [00000001], irqs_disabled():1
>> > > Pid: 0, comm: swapper Tainted: G        W 2.6.26.1-rt1.jk #2
>> > >
>> > > Call Trace:
>> > >  [<ffffffff802305d3>] __might_sleep+0x12d/0x132
>> > >  [<ffffffff8046cdbe>] __rt_spin_lock+0x34/0x7d
>> > >  [<ffffffff8046ce15>] rt_spin_lock+0xe/0x10
>> > >  [<ffffffff802532e5>] pm_qos_requirement+0x1f/0x3c
>> > >  [<ffffffff803e1b7f>] menu_select+0x7b/0x9c
>> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> > >  [<ffffffff803e0b4b>] cpuidle_idle_call+0x68/0xd8
>> > >  [<ffffffff803e0ae3>] ? cpuidle_idle_call+0x0/0xd8
>> > >  [<ffffffff8020b1be>] ? default_idle+0x0/0x5a
>> > >  [<ffffffff8020b333>] cpu_idle+0xb2/0x12d
>> > >  [<ffffffff80466af0>] start_secondary+0x186/0x18b
>> > >
>> > > ---------------------------
>> > > | preempt count: 00000001 ]
>> > > | 1-level deep critical section nesting:
>> > > ----------------------------------------
>> > > ... [<ffffffff8020b39c>] .... cpu_idle+0x11b/0x12d
>> > > ......[<ffffffff80466af0>] ..   ( <= start_secondary+0x186/0x18b)
>> > >
>> > > The following simple patch makes the messages disappear - however,
>> > > there may be a better more fine grained solution, but the problem is
>> > > also that all the functions are designed to use the same lock.
>> >
>> > Hmm, I think you're right - its called from the idle routine so we can't
>> > go about sleeping there.
>> >
>> > The only trouble I have is with kernel/pm_qos_params.c:update_target()'s
>> > use of this lock - that is decidedly not O(1).
>> >
>> > Mark, would it be possible to split that lock in two, one lock
>> > protecting pm_qos_array[], and one lock protecting the
>> > requirements.list ?
>>
>> very likely, but I'm not sure how it will help.
>>
>> the fine grain locking I had initially worked out on pm_qos was to have
>> a lock per pm_qos_object, that would be used for accessing the
>> requirement_list and the target_value.  But that isn't what you are
>> asking about is it?
>>
>> Is what you want is a pm_qos_requirements_list_lock and a
>> pm_qos_target_value_lock, for each pm_qos_object instance?
>>
>> I guess it wold work but besides giving the code spinlock diarrhea would
>> it really help solve the issue you are seeing?
>
> The problem is that on -rt spinlocks turn into mutexes. And the above
> BUG tells us that the idle loop might end up scheduling due to trying to
> take this lock.
>
> Now, the way I read the code, pm_qos_lock protects multiple things:
>
>  - pm_qos_array[target]->target_value
>
>  - &pm_qos_array[pm_qos_class]->requirements.list
>
> Now, the thing is, we could turn the lock back into a real spinlock
> (raw_spinlock_t), but the loops in eg update_target() are not O(1) and
> could thus cause serious preempt-off latencies.
>
> My question was, and now having had a second look at the code I think it
> is, would it be possible to guard the list using a sleeping lock,
> protect the target_value using a (raw) spinlock.
>
> OTOH, just reading a (word aligned, word sized) value doesn't normally
> require serialization, esp if the update site is already serialized by
> other means.
>
> So could we perhaps remove the lock usage from pm_qos_requirement()? -
> that too would solve the issue.
>
>
>  - Peter
>

How about this patch? Like Peter suggests, It adds a raw spinlock only
for the target value. I'm currently running with it, but still
testing, comments are appreciated.

Thanks

------=_Part_46316_13032952.1217974688790
Content-Type: text/x-patch; name=pm_qos_requirement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjj2klpz0
Content-Disposition: attachment; filename=pm_qos_requirement.patch

cG1fcW9zX3JlcXVpcmVtZW50LWZpeApTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXIg
YXQgZ21haWwgZG90IGNvbT4KCkFkZCBhIHJhdyBzcGlubG9jayBmb3IgdGhlIHRhcmdldCB2YWx1
ZS4KCgpJbmRleDogbGludXgtMi42LjI2LjEtcnQxLmprL2tlcm5lbC9wbV9xb3NfcGFyYW1zLmMK
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PQotLS0gbGludXgtMi42LjI2LjEtcnQxLmprLm9yaWcva2VybmVsL3BtX3Fvc19w
YXJhbXMuYworKysgbGludXgtMi42LjI2LjEtcnQxLmprL2tlcm5lbC9wbV9xb3NfcGFyYW1zLmMK
QEAgLTExMSw2ICsxMTEsNyBAQCBzdGF0aWMgc3RydWN0IHBtX3Fvc19vYmplY3QgKnBtX3Fvc19h
cnJhCiB9OwogCiBzdGF0aWMgREVGSU5FX1NQSU5MT0NLKHBtX3Fvc19sb2NrKTsKK3N0YXRpYyBE
RUZJTkVfUkFXX1NQSU5MT0NLKHBtX3Fvc19yYXdsb2NrKTsKIAogc3RhdGljIHNzaXplX3QgcG1f
cW9zX3Bvd2VyX3dyaXRlKHN0cnVjdCBmaWxlICpmaWxwLCBjb25zdCBjaGFyIF9fdXNlciAqYnVm
LAogCQlzaXplX3QgY291bnQsIGxvZmZfdCAqZl9wb3MpOwpAQCAtMTQ5LDEzICsxNTAsMTUgQEAg
c3RhdGljIHZvaWQgdXBkYXRlX3RhcmdldChpbnQgdGFyZ2V0KQogCQlleHRyZW1lX3ZhbHVlID0g
cG1fcW9zX2FycmF5W3RhcmdldF0tPmNvbXBhcml0b3IoCiAJCQkJZXh0cmVtZV92YWx1ZSwgbm9k
ZS0+dmFsdWUpOwogCX0KKwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwbV9xb3NfbG9jaywgZmxh
Z3MpOworCXNwaW5fbG9ja19pcnFzYXZlKCZwbV9xb3NfcmF3bG9jaywgZmxhZ3MpOwogCWlmIChw
bV9xb3NfYXJyYXlbdGFyZ2V0XS0+dGFyZ2V0X3ZhbHVlICE9IGV4dHJlbWVfdmFsdWUpIHsKIAkJ
Y2FsbF9ub3RpZmllciA9IDE7CiAJCXBtX3Fvc19hcnJheVt0YXJnZXRdLT50YXJnZXRfdmFsdWUg
PSBleHRyZW1lX3ZhbHVlOwogCQlwcl9kZWJ1ZyhLRVJOX0VSUiAibmV3IHRhcmdldCBmb3IgcW9z
ICVkIGlzICVkXG4iLCB0YXJnZXQsCiAJCQlwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+dGFyZ2V0X3Zh
bHVlKTsKIAl9Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG1fcW9zX2xvY2ssIGZsYWdzKTsK
KwlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwbV9xb3NfcmF3bG9jaywgZmxhZ3MpOwogCiAJaWYg
KGNhbGxfbm90aWZpZXIpCiAJCWJsb2NraW5nX25vdGlmaWVyX2NhbGxfY2hhaW4ocG1fcW9zX2Fy
cmF5W3RhcmdldF0tPm5vdGlmaWVycywKQEAgLTE5NSw5ICsxOTgsOSBAQCBpbnQgcG1fcW9zX3Jl
cXVpcmVtZW50KGludCBwbV9xb3NfY2xhc3MpCiAJaW50IHJldF92YWw7CiAJdW5zaWduZWQgbG9u
ZyBmbGFnczsKIAotCXNwaW5fbG9ja19pcnFzYXZlKCZwbV9xb3NfbG9jaywgZmxhZ3MpOworCXNw
aW5fbG9ja19pcnFzYXZlKCZwbV9xb3NfcmF3bG9jaywgZmxhZ3MpOwogCXJldF92YWwgPSBwbV9x
b3NfYXJyYXlbcG1fcW9zX2NsYXNzXS0+dGFyZ2V0X3ZhbHVlOwotCXNwaW5fdW5sb2NrX2lycXJl
c3RvcmUoJnBtX3Fvc19sb2NrLCBmbGFncyk7CisJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG1f
cW9zX3Jhd2xvY2ssIGZsYWdzKTsKIAogCXJldHVybiByZXRfdmFsOwogfQo=
------=_Part_46316_13032952.1217974688790--
