Return-Path: <linux-kernel-owner+w=401wt.eu-S1757866AbYHZIs1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757866AbYHZIs1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 04:48:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753294AbYHZIsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 04:48:18 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:42030 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962AbYHZIsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 04:48:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=RlDK49MI1NzMeAu/QwKNWCsuWaVy2bE+NXhm+l3t3ahyPj842kUW386SODwHGB/g+X
         AGZsMfQzFH8s/iBVSYvbYlaxAa1r59hx4lTDhA8TJm0W9ngoNFQxRcP3L/JBiGTgcYq+
         2rmhl6bIVXtP7P+4Lgjg7NDaVT6rlgK8GNclM=
Message-ID: <520f0cf10808260148k47368b71he2737ea1a59bbe4d@mail.gmail.com>
Date: Tue, 26 Aug 2008 10:48:13 +0200
From: "John Kacur" <jkacur@gmail.com>
To: mgross@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <1219682129.8515.81.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2193_23574022.1219740493932"
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
	 <20080812224926.GA20652@linux.intel.com>
	 <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
	 <20080814155241.GA31050@linux.intel.com>
	 <1218736137.10800.234.camel@twins>
	 <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
	 <20080825163412.GA21910@linux.intel.com>
	 <1219682129.8515.81.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2193_23574022.1219740493932
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Mon, Aug 25, 2008 at 6:35 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2008-08-25 at 09:34 -0700, mark gross wrote:
>> On Fri, Aug 15, 2008 at 12:51:11AM +0200, John Kacur wrote:
>> > On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>> > > On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
>> > >
>> > >> Keeping a lock around the different "target_value"s may not be so
>> > >> important.  Its just a 32bit scaler value, and perhaps we can make it an
>> > >> atomic type?  That way we loose the raw_spinlock.
>> > >
>> > > My suggestion was to keep the locking for the write side - so as to
>> > > avoid stuff stomping on one another, but drop the read side as:
>> > >
>> > >  spin_lock
>> > >  foo = var;
>> > >  spin_unlock
>> > >  return foo;
>> > >
>> > > is kinda useless, it doesn't actually serialize against the usage of
>> > > foo, that is, once it gets used, var might already have acquired a new
>> > > value.
>> > >
>> > > The only thing it would protect is reading var, but since that is a
>> > > machine sized read, its atomic anyway (assuming its naturally aligned).
>> > >
>> > > So no need for atomic_t (its read-side is just a read too), just drop
>> > > the whole lock usage from pq_qos_requirement().
>> > >
>> >
>> > Thanks Peter.
>> >
>> > Mark, is the following patch ok with you? This should be applied to
>> > mainline, and then after that no special patches are necessary for
>> > real-time.
>>
>> I've been thinking about this patch and I worry that the readability
>> from making the use of this lock asymmetric WRT reads and writes to the
>> storage address is bothersome.
>>
>> I would rather make the variable an atomic.  What do you think about
>> that?
>
> It would make the write side more expensive, as we already have the two
> atomic operations for the lock and unlock, this would add a third.
>
> Then again, I doubt that this is really a fast path.
>
> OTOH, a simple comment could clarify the situation for the reader.
>
> Up to you I guess ;-)
>

Personally I agree with Peter, a simple comment would clarify the
situation, it seems quite silly to me to add complexity in the name of
symmetry. This is not my definition of readability. Never-the-less I
offer up solution number 3 here if that would please everyone more.
Attached is a patch that changes the target value to an atomic
variable as suggested by Arjan. To summarize.

3 Sol'ns - all of which solve the problem.
1. Add a raw spinlock around target value only. This makes the raw
spinlock area very small, and is converted to a normal spinlock for
non-preempt-rt.
2. Remove the spinlock altogether in pm_qos_requirement since the
simple read is already atomic. Advantage - smallest patch and realtime
doesn't require a special patch once this is included in mainline. I
like this one the best.
3. make target_value atomic_t. Advantage - symmetry, some people find
this more readable. The patch is larger than the above solution but as
above, no special patch is required for realtime once this is included
in mainline. Solution three is in the attached patch. Comments are
appreciated as always.

------=_Part_2193_23574022.1219740493932
Content-Type: text/x-patch; name=pm_qos_requirement.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fkc9pjld1
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
IC0xNDksMTMgKzE0OSwxNCBAQCBzdGF0aWMgdm9pZCB1cGRhdGVfdGFyZ2V0KGludCB0YXJnZXQp
CiAJCWV4dHJlbWVfdmFsdWUgPSBwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+Y29tcGFyaXRvcigKIAkJ
CQlleHRyZW1lX3ZhbHVlLCBub2RlLT52YWx1ZSk7CiAJfQotCWlmIChwbV9xb3NfYXJyYXlbdGFy
Z2V0XS0+dGFyZ2V0X3ZhbHVlICE9IGV4dHJlbWVfdmFsdWUpIHsKKwlzcGluX3VubG9ja19pcnFy
ZXN0b3JlKCZwbV9xb3NfbG9jaywgZmxhZ3MpOworCisJaWYgKGF0b21pY19yZWFkKCZwbV9xb3Nf
YXJyYXlbdGFyZ2V0XS0+dGFyZ2V0X3ZhbHVlKSAhPSBleHRyZW1lX3ZhbHVlKSB7CiAJCWNhbGxf
bm90aWZpZXIgPSAxOwotCQlwbV9xb3NfYXJyYXlbdGFyZ2V0XS0+dGFyZ2V0X3ZhbHVlID0gZXh0
cmVtZV92YWx1ZTsKKwkJYXRvbWljX3NldCgmcG1fcW9zX2FycmF5W3RhcmdldF0tPnRhcmdldF92
YWx1ZSwgZXh0cmVtZV92YWx1ZSk7CiAJCXByX2RlYnVnKEtFUk5fRVJSICJuZXcgdGFyZ2V0IGZv
ciBxb3MgJWQgaXMgJWRcbiIsIHRhcmdldCwKLQkJCXBtX3Fvc19hcnJheVt0YXJnZXRdLT50YXJn
ZXRfdmFsdWUpOworCQkJYXRvbWljX3JlYWQoJnBtX3Fvc19hcnJheVt0YXJnZXRdLT50YXJnZXRf
dmFsdWUpKTsKIAl9Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmcG1fcW9zX2xvY2ssIGZsYWdz
KTsKIAogCWlmIChjYWxsX25vdGlmaWVyKQogCQlibG9ja2luZ19ub3RpZmllcl9jYWxsX2NoYWlu
KHBtX3Fvc19hcnJheVt0YXJnZXRdLT5ub3RpZmllcnMsCkBAIC0xOTMsMTEgKzE5NCw4IEBAIHN0
YXRpYyBpbnQgZmluZF9wbV9xb3Nfb2JqZWN0X2J5X21pbm9yKGkKIGludCBwbV9xb3NfcmVxdWly
ZW1lbnQoaW50IHBtX3Fvc19jbGFzcykKIHsKIAlpbnQgcmV0X3ZhbDsKLQl1bnNpZ25lZCBsb25n
IGZsYWdzOwogCi0Jc3Bpbl9sb2NrX2lycXNhdmUoJnBtX3Fvc19sb2NrLCBmbGFncyk7Ci0JcmV0
X3ZhbCA9IHBtX3Fvc19hcnJheVtwbV9xb3NfY2xhc3NdLT50YXJnZXRfdmFsdWU7Ci0Jc3Bpbl91
bmxvY2tfaXJxcmVzdG9yZSgmcG1fcW9zX2xvY2ssIGZsYWdzKTsKKwlyZXRfdmFsID0gYXRvbWlj
X3JlYWQoJnBtX3Fvc19hcnJheVtwbV9xb3NfY2xhc3NdLT50YXJnZXRfdmFsdWUpOwogCiAJcmV0
dXJuIHJldF92YWw7CiB9Cg==
------=_Part_2193_23574022.1219740493932--
