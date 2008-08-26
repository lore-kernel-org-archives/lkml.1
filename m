Return-Path: <linux-kernel-owner+w=401wt.eu-S1759238AbYHZRp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759238AbYHZRp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:45:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbYHZRpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:45:41 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:62536 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933AbYHZRpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:45:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=l4R1U8IumU/7Lb2SY3pof4aj4wLrQihpMU62udKFjTVwHUpDevgq0drvconsu6GmKj
         qJ2iwm1gB1BdVL5qSA0ADD9UJJPS2hN4kCHco6ks9Ql1z/loG+DJcyxyApScBphg31++
         yZDL0iCkkrlCXB3M7S5LXzXG+dkPCT2o5l/9U=
Message-ID: <520f0cf10808261045v9dddcdcnd1a86b224aa3feb0@mail.gmail.com>
Date: Tue, 26 Aug 2008 19:45:37 +0200
From: "John Kacur" <jkacur@gmail.com>
To: mgross@linux.intel.com
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <20080826161802.GB9862@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_7283_25843095.1219772737841"
References: <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <20080812224926.GA20652@linux.intel.com>
	 <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
	 <20080814155241.GA31050@linux.intel.com>
	 <1218736137.10800.234.camel@twins>
	 <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
	 <20080825163412.GA21910@linux.intel.com>
	 <1219682129.8515.81.camel@twins>
	 <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>
	 <20080826161802.GB9862@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_7283_25843095.1219772737841
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Tue, Aug 26, 2008 at 6:18 PM, mark gross <mgross@linux.intel.com> wrote:
> On Tue, Aug 26, 2008 at 10:48:13AM +0200, John Kacur wrote:
>> On Mon, Aug 25, 2008 at 6:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Mon, 2008-08-25 at 09:34 -0700, mark gross wrote:
>> >> On Fri, Aug 15, 2008 at 12:51:11AM +0200, John Kacur wrote:
>> >> > On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> >> > > On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
>> >> > >
>> >> > >> Keeping a lock around the different "target_value"s may not be so
>> >> > >> important.  Its just a 32bit scaler value, and perhaps we can make it an
>> >> > >> atomic type?  That way we loose the raw_spinlock.
>> >> > >
>> >> > > My suggestion was to keep the locking for the write side - so as to
>> >> > > avoid stuff stomping on one another, but drop the read side as:
>> >> > >
>> >> > >  spin_lock
>> >> > >  foo = var;
>> >> > >  spin_unlock
>> >> > >  return foo;
>> >> > >
>> >> > > is kinda useless, it doesn't actually serialize against the usage of
>> >> > > foo, that is, once it gets used, var might already have acquired a new
>> >> > > value.
>> >> > >
>> >> > > The only thing it would protect is reading var, but since that is a
>> >> > > machine sized read, its atomic anyway (assuming its naturally aligned).
>> >> > >
>> >> > > So no need for atomic_t (its read-side is just a read too), just drop
>> >> > > the whole lock usage from pq_qos_requirement().
>> >> > >
>> >> >
>> >> > Thanks Peter.
>> >> >
>> >> > Mark, is the following patch ok with you? This should be applied to
>> >> > mainline, and then after that no special patches are necessary for
>> >> > real-time.
>> >>
>> >> I've been thinking about this patch and I worry that the readability
>> >> from making the use of this lock asymmetric WRT reads and writes to the
>> >> storage address is bothersome.
>> >>
>> >> I would rather make the variable an atomic.  What do you think about
>> >> that?
>> >
>> > It would make the write side more expensive, as we already have the two
>> > atomic operations for the lock and unlock, this would add a third.
>> >
>> > Then again, I doubt that this is really a fast path.
>> >
>> > OTOH, a simple comment could clarify the situation for the reader.
>> >
>> > Up to you I guess ;-)
>> >
>>
>> Personally I agree with Peter, a simple comment would clarify the
>> situation, it seems quite silly to me to add complexity in the name of
>> symmetry. This is not my definition of readability. Never-the-less I
>> offer up solution number 3 here if that would please everyone more.
>> Attached is a patch that changes the target value to an atomic
>> variable as suggested by Arjan. To summarize.
>>
>> 3 Sol'ns - all of which solve the problem.
>> 1. Add a raw spinlock around target value only. This makes the raw
>> spinlock area very small, and is converted to a normal spinlock for
>> non-preempt-rt.
>> 2. Remove the spinlock altogether in pm_qos_requirement since the
>> simple read is already atomic. Advantage - smallest patch and realtime
>> doesn't require a special patch once this is included in mainline. I
>> like this one the best.
>> 3. make target_value atomic_t. Advantage - symmetry, some people find
>> this more readable. The patch is larger than the above solution but as
>> above, no special patch is required for realtime once this is included
>> in mainline. Solution three is in the attached patch. Comments are
>> appreciated as always.
>
> Thank you!  FWIW I'm really on the fence between option 2 and 3.
>
>> Remove the spinlock in pm_qos_requirement by making target_value an atomic type.
>> This is necessary for real-time since pm_qos_requirement is called by idle and
>> cannot be allowed to sleep.
>> Signed-off-by: John Kacur <jkacur at gmail dot com>
>>
>> Index: linux-2.6.26.3-rt3/kernel/pm_qos_params.c
>> ===================================================================
>> --- linux-2.6.26.3-rt3.orig/kernel/pm_qos_params.c
>> +++ linux-2.6.26.3-rt3/kernel/pm_qos_params.c
>> @@ -42,7 +42,7 @@
>>  #include <linux/uaccess.h>
>>
>>  /*
>> - * locking rule: all changes to target_value or requirements or notifiers lists
>> + * locking rule: all changes to requirements or notifiers lists
>>   * or pm_qos_object list and pm_qos_objects need to happen with pm_qos_lock
>>   * held, taken with _irqsave.  One lock to rule them all
>>   */
>> @@ -65,7 +65,7 @@ struct pm_qos_object {
>>       struct miscdevice pm_qos_power_miscdev;
>>       char *name;
>>       s32 default_value;
>> -     s32 target_value;
>> +     atomic_t target_value;
>>       s32 (*comparitor)(s32, s32);
>>  };
>>
>> @@ -76,7 +76,7 @@ static struct pm_qos_object cpu_dma_pm_q
>>       .notifiers = &cpu_dma_lat_notifier,
>>       .name = "cpu_dma_latency",
>>       .default_value = 2000 * USEC_PER_SEC,
>> -     .target_value = 2000 * USEC_PER_SEC,
>> +     .target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>>       .comparitor = min_compare
>>  };
>>
>> @@ -86,7 +86,7 @@ static struct pm_qos_object network_lat_
>>       .notifiers = &network_lat_notifier,
>>       .name = "network_latency",
>>       .default_value = 2000 * USEC_PER_SEC,
>> -     .target_value = 2000 * USEC_PER_SEC,
>> +     .target_value = ATOMIC_INIT(2000 * USEC_PER_SEC),
>>       .comparitor = min_compare
>>  };
>>
>> @@ -98,7 +98,7 @@ static struct pm_qos_object network_thro
>>       .notifiers = &network_throughput_notifier,
>>       .name = "network_throughput",
>>       .default_value = 0,
>> -     .target_value = 0,
>> +     .target_value = ATOMIC_INIT(0),
>>       .comparitor = max_compare
>>  };
>>
>> @@ -149,13 +149,14 @@ static void update_target(int target)
>>               extreme_value = pm_qos_array[target]->comparitor(
>>                               extreme_value, node->value);
>>       }
>> -     if (pm_qos_array[target]->target_value != extreme_value) {
>> +     spin_unlock_irqrestore(&pm_qos_lock, flags);
>> +
>
> do we want to move the unlock before the setting of the target_value?
> This feels wrong to me, the option 2 patch didn't do this.
>
> couldn't we have a race from 2 cpu's hitting update_target at the same
> time with different values if we drop the lock before the target_value
> is set?

I think you are right since atomicity doesn't have anything to do with
ordering, good catch, putting the the unlock back where it was before,
new patch attached. (also shortened-up pm_qos_requirement)

---SNIP----

John

------=_Part_7283_25843095.1219772737841
Content-Type: text/x-patch; name=pm_qos_requirement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkct1qgy1
Content-Disposition: attachment; filename=pm_qos_requirement.patch

UmVtb3ZlIHRoZSBzcGlubG9jayBpbiBwbV9xb3NfcmVxdWlyZW1lbnQgYnkgbWFraW5nIHRhcmdl
dF92YWx1ZSBhbiBhdG9taWMgdHlwZS4KVGhpcyBpcyBuZWNlc3NhcnkgZm9yIHJlYWwtdGltZSBz
aW5jZSBwbV9xb3NfcmVxdWlyZW1lbnQgaXMgY2FsbGVkIGJ5IGlkbGUgYW5kCmNhbm5vdCBiZSBh
bGxvd2VkIHRvIHNsZWVwLgpTaWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXIgYXQgZ21h
aWwgZG90IGNvbT4KCkluZGV4OiBsaW51eC0yLjYuMjYuMy1ydDMva2VybmVsL3BtX3Fvc19wYXJh
bXMuYwo9PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0yLjYuMjYuMy1ydDMub3JpZy9rZXJuZWwvcG1fcW9z
X3BhcmFtcy5jCisrKyBsaW51eC0yLjYuMjYuMy1ydDMva2VybmVsL3BtX3Fvc19wYXJhbXMuYwpA
QCAtNDIsNyArNDIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L3VhY2Nlc3MuaD4KIAogLyoKLSAqIGxv
Y2tpbmcgcnVsZTogYWxsIGNoYW5nZXMgdG8gdGFyZ2V0X3ZhbHVlIG9yIHJlcXVpcmVtZW50cyBv
ciBub3RpZmllcnMgbGlzdHMKKyAqIGxvY2tpbmcgcnVsZTogYWxsIGNoYW5nZXMgdG8gcmVxdWly
ZW1lbnRzIG9yIG5vdGlmaWVycyBsaXN0cwogICogb3IgcG1fcW9zX29iamVjdCBsaXN0IGFuZCBw
bV9xb3Nfb2JqZWN0cyBuZWVkIHRvIGhhcHBlbiB3aXRoIHBtX3Fvc19sb2NrCiAgKiBoZWxkLCB0
YWtlbiB3aXRoIF9pcnFzYXZlLiAgT25lIGxvY2sgdG8gcnVsZSB0aGVtIGFsbAogICovCkBAIC02
NSw3ICs2NSw3IEBAIHN0cnVjdCBwbV9xb3Nfb2JqZWN0IHsKIAlzdHJ1Y3QgbWlzY2RldmljZSBw
bV9xb3NfcG93ZXJfbWlzY2RldjsKIAljaGFyICpuYW1lOwogCXMzMiBkZWZhdWx0X3ZhbHVlOwot
CXMzMiB0YXJnZXRfdmFsdWU7CisJYXRvbWljX3QgdGFyZ2V0X3ZhbHVlOwogCXMzMiAoKmNvbXBh
cml0b3IpKHMzMiwgczMyKTsKIH07CiAKQEAgLTc2LDcgKzc2LDcgQEAgc3RhdGljIHN0cnVjdCBw
bV9xb3Nfb2JqZWN0IGNwdV9kbWFfcG1fcQogCS5ub3RpZmllcnMgPSAmY3B1X2RtYV9sYXRfbm90
aWZpZXIsCiAJLm5hbWUgPSAiY3B1X2RtYV9sYXRlbmN5IiwKIAkuZGVmYXVsdF92YWx1ZSA9IDIw
MDAgKiBVU0VDX1BFUl9TRUMsCi0JLnRhcmdldF92YWx1ZSA9IDIwMDAgKiBVU0VDX1BFUl9TRUMs
CisJLnRhcmdldF92YWx1ZSA9IEFUT01JQ19JTklUKDIwMDAgKiBVU0VDX1BFUl9TRUMpLAogCS5j
b21wYXJpdG9yID0gbWluX2NvbXBhcmUKIH07CiAKQEAgLTg2LDcgKzg2LDcgQEAgc3RhdGljIHN0
cnVjdCBwbV9xb3Nfb2JqZWN0IG5ldHdvcmtfbGF0XwogCS5ub3RpZmllcnMgPSAmbmV0d29ya19s
YXRfbm90aWZpZXIsCiAJLm5hbWUgPSAibmV0d29ya19sYXRlbmN5IiwKIAkuZGVmYXVsdF92YWx1
ZSA9IDIwMDAgKiBVU0VDX1BFUl9TRUMsCi0JLnRhcmdldF92YWx1ZSA9IDIwMDAgKiBVU0VDX1BF
Ul9TRUMsCisJLnRhcmdldF92YWx1ZSA9IEFUT01JQ19JTklUKDIwMDAgKiBVU0VDX1BFUl9TRUMp
LAogCS5jb21wYXJpdG9yID0gbWluX2NvbXBhcmUKIH07CiAKQEAgLTk4LDcgKzk4LDcgQEAgc3Rh
dGljIHN0cnVjdCBwbV9xb3Nfb2JqZWN0IG5ldHdvcmtfdGhybwogCS5ub3RpZmllcnMgPSAmbmV0
d29ya190aHJvdWdocHV0X25vdGlmaWVyLAogCS5uYW1lID0gIm5ldHdvcmtfdGhyb3VnaHB1dCIs
CiAJLmRlZmF1bHRfdmFsdWUgPSAwLAotCS50YXJnZXRfdmFsdWUgPSAwLAorCS50YXJnZXRfdmFs
dWUgPSBBVE9NSUNfSU5JVCgwKSwKIAkuY29tcGFyaXRvciA9IG1heF9jb21wYXJlCiB9OwogCkBA
IC0xNDksMTEgKzE0OSwxMSBAQCBzdGF0aWMgdm9pZCB1cGRhdGVfdGFyZ2V0KGludCB0YXJnZXQp
CiAJCWV4dHJlbWVfdmFsdWUgPSBwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+Y29tcGFyaXRvcigKIAkJ
CQlleHRyZW1lX3ZhbHVlLCBub2RlLT52YWx1ZSk7CiAJfQotCWlmIChwbV9xb3NfYXJyYXlbdGFy
Z2V0XS0+dGFyZ2V0X3ZhbHVlICE9IGV4dHJlbWVfdmFsdWUpIHsKKwlpZiAoYXRvbWljX3JlYWQo
JnBtX3Fvc19hcnJheVt0YXJnZXRdLT50YXJnZXRfdmFsdWUpICE9IGV4dHJlbWVfdmFsdWUpIHsK
IAkJY2FsbF9ub3RpZmllciA9IDE7Ci0JCXBtX3Fvc19hcnJheVt0YXJnZXRdLT50YXJnZXRfdmFs
dWUgPSBleHRyZW1lX3ZhbHVlOworCQlhdG9taWNfc2V0KCZwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+
dGFyZ2V0X3ZhbHVlLCBleHRyZW1lX3ZhbHVlKTsKIAkJcHJfZGVidWcoS0VSTl9FUlIgIm5ldyB0
YXJnZXQgZm9yIHFvcyAlZCBpcyAlZFxuIiwgdGFyZ2V0LAotCQkJcG1fcW9zX2FycmF5W3Rhcmdl
dF0tPnRhcmdldF92YWx1ZSk7CisJCQlhdG9taWNfcmVhZCgmcG1fcW9zX2FycmF5W3RhcmdldF0t
PnRhcmdldF92YWx1ZSkpOwogCX0KIAlzcGluX3VubG9ja19pcnFyZXN0b3JlKCZwbV9xb3NfbG9j
aywgZmxhZ3MpOwogCkBAIC0xOTIsMTQgKzE5Miw3IEBAIHN0YXRpYyBpbnQgZmluZF9wbV9xb3Nf
b2JqZWN0X2J5X21pbm9yKGkKICAqLwogaW50IHBtX3Fvc19yZXF1aXJlbWVudChpbnQgcG1fcW9z
X2NsYXNzKQogewotCWludCByZXRfdmFsOwotCXVuc2lnbmVkIGxvbmcgZmxhZ3M7Ci0KLQlzcGlu
X2xvY2tfaXJxc2F2ZSgmcG1fcW9zX2xvY2ssIGZsYWdzKTsKLQlyZXRfdmFsID0gcG1fcW9zX2Fy
cmF5W3BtX3Fvc19jbGFzc10tPnRhcmdldF92YWx1ZTsKLQlzcGluX3VubG9ja19pcnFyZXN0b3Jl
KCZwbV9xb3NfbG9jaywgZmxhZ3MpOwotCi0JcmV0dXJuIHJldF92YWw7CisJcmV0dXJuIGF0b21p
Y19yZWFkKCZwbV9xb3NfYXJyYXlbcG1fcW9zX2NsYXNzXS0+dGFyZ2V0X3ZhbHVlKTsKIH0KIEVY
UE9SVF9TWU1CT0xfR1BMKHBtX3Fvc19yZXF1aXJlbWVudCk7CiAK
------=_Part_7283_25843095.1219772737841--
