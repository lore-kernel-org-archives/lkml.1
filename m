Return-Path: <linux-kernel-owner+w=401wt.eu-S1754927AbYHNWvY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927AbYHNWvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 18:51:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751863AbYHNWvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 18:51:14 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:61964 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYHNWvN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 18:51:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:references;
        b=h2b7XEFvQuZnkP9cKTUCFzwuQAqh3JOrahQg9rPmCxAUotdYA8A9LNjmywgJYlG+zL
         FRzEZKfYO1VRUZlIL1XjaNV2USH3vVrob5G3re2LCfRn7LJX2y5j1NxU/4SGU+8/T9Fu
         0Xc77ExnewqNZvt5YZ6eUHvegL/HY0jRyrDU8=
Message-ID: <520f0cf10808141551k283aecb8y647d0f5ae321b81f@mail.gmail.com>
Date: Fri, 15 Aug 2008 00:51:11 +0200
From: "John Kacur" <jkacur@gmail.com>
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [PATCH RFC] pm_qos_requirement might sleep
Cc: mgross@linux.intel.com, LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>, arjan <arjan@infradead.org>
In-Reply-To: <1218736137.10800.234.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_67904_18048146.1218754271922"
References: <520f0cf10808041352h78bd4319x1802f018aeffe6dc@mail.gmail.com>
	 <1217921101.3589.98.camel@twins>
	 <20080805204901.GA31132@linux.intel.com>
	 <1217970588.29415.36.camel@lappy.programming.kicks-ass.net>
	 <520f0cf10808051518h1459d353r8de78e98f79ec57c@mail.gmail.com>
	 <20080812224926.GA20652@linux.intel.com>
	 <520f0cf10808130124o301b6691ra37ac9007120b9df@mail.gmail.com>
	 <20080814155241.GA31050@linux.intel.com>
	 <1218736137.10800.234.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_67904_18048146.1218754271922
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, Aug 14, 2008 at 7:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2008-08-14 at 08:52 -0700, mark gross wrote:
>
>> Keeping a lock around the different "target_value"s may not be so
>> important.  Its just a 32bit scaler value, and perhaps we can make it an
>> atomic type?  That way we loose the raw_spinlock.
>
> My suggestion was to keep the locking for the write side - so as to
> avoid stuff stomping on one another, but drop the read side as:
>
>  spin_lock
>  foo = var;
>  spin_unlock
>  return foo;
>
> is kinda useless, it doesn't actually serialize against the usage of
> foo, that is, once it gets used, var might already have acquired a new
> value.
>
> The only thing it would protect is reading var, but since that is a
> machine sized read, its atomic anyway (assuming its naturally aligned).
>
> So no need for atomic_t (its read-side is just a read too), just drop
> the whole lock usage from pq_qos_requirement().
>

Thanks Peter.

Mark, is the following patch ok with you? This should be applied to
mainline, and then after that no special patches are necessary for
real-time.

Thanks

John Kacur

------=_Part_67904_18048146.1218754271922
Content-Type: text/x-patch; name=pm_qos_requirement_lock.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fjvvq7q70
Content-Disposition: attachment; filename=pm_qos_requirement_lock.patch

U3ViamVjdDogUmVtb3ZlIHVubmVjZXNzYXJ5IGxvY2sgaW4gcG1fcW9zX3JlcXVpcmVtZW50CgpT
aWduZWQtb2ZmLWJ5OiBKb2huIEthY3VyIDxqa2FjdXIgYXQgZ21haWwgZG90IGNvbT4KCkluZGV4
OiBsaW51eC0yLjYva2VybmVsL3BtX3Fvc19wYXJhbXMuYwo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09Ci0tLSBsaW51eC0y
LjYub3JpZy9rZXJuZWwvcG1fcW9zX3BhcmFtcy5jCisrKyBsaW51eC0yLjYva2VybmVsL3BtX3Fv
c19wYXJhbXMuYwpAQCAtMTkzLDE0ICsxOTMsNyBAQCBzdGF0aWMgaW50IGZpbmRfcG1fcW9zX29i
amVjdF9ieV9taW5vcihpCiAgKi8KIGludCBwbV9xb3NfcmVxdWlyZW1lbnQoaW50IHBtX3Fvc19j
bGFzcykKIHsKLQlpbnQgcmV0X3ZhbDsKLQl1bnNpZ25lZCBsb25nIGZsYWdzOwotCi0Jc3Bpbl9s
b2NrX2lycXNhdmUoJnBtX3Fvc19sb2NrLCBmbGFncyk7Ci0JcmV0X3ZhbCA9IHBtX3Fvc19hcnJh
eVtwbV9xb3NfY2xhc3NdLT50YXJnZXRfdmFsdWU7Ci0Jc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgm
cG1fcW9zX2xvY2ssIGZsYWdzKTsKLQotCXJldHVybiByZXRfdmFsOworCXJldHVybiBwbV9xb3Nf
YXJyYXlbcG1fcW9zX2NsYXNzXS0+dGFyZ2V0X3ZhbHVlOwogfQogRVhQT1JUX1NZTUJPTF9HUEwo
cG1fcW9zX3JlcXVpcmVtZW50KTsKIAo=
------=_Part_67904_18048146.1218754271922--
