Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYKSRNZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYKSRNZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 12:13:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751917AbYKSRNQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 12:13:16 -0500
Received: from mu-out-0910.google.com ([209.85.134.191]:63569 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbYKSRNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 12:13:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:references;
        b=IUj576sMCyG1t/6/7Q7/3I86Z0TCYjctQfPj5xbPrx6FGhKWj4tlz2M02mEEvL+N/Q
         Ek5UhgiTBzDgQftKthpB/W7Su6857tebo/5Zv7cLl4s/lqwJb9+pDTHPEvyPMpABjBxx
         SeZx4x8CHa4MqMPBq6sIUZ0JIrHKV6B3bQh3c=
Message-ID: <7c86c4470811190913u743706abgafff3b0f0e3559ec@mail.gmail.com>
Date: Wed, 19 Nov 2008 18:13:11 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Subject: Re: debugctl msr
Cc: "Markus Metzger" <markus.t.metzger@googlemail.com>,
       "Ingo Molnar" <mingo@elte.hu>, "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_20957_26073426.1227114791280"
References: <7c86c4470810300753v7d377092qbcd266178d8e7338@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B1F123@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811130650j4192c63n1fa9800a0cdfb93c@mail.gmail.com>
	 <029E5BE7F699594398CA44E3DDF5544402B595A3@swsmsx413.ger.corp.intel.com>
	 <7c86c4470811141310h4fd3c5fbvc6357985cf2aed0e@mail.gmail.com>
	 <1226743286.6162.6.camel@raistlin>
	 <7c86c4470811181400r1fa56ef9o1931467ee10e4f52@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10AAA@irsmsx504.ger.corp.intel.com>
	 <7c86c4470811190459y5996f51bp24ab38c9e856c2eb@mail.gmail.com>
	 <928CFBE8E7CB0040959E56B4EA41A77E08F10CB1@irsmsx504.ger.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_20957_26073426.1227114791280
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Markus,

Speaking of locking, I also ran into another issue with ds_lock.
Perfmon sessions each have a spinlock for access serialization, but to
prevent from PMU and timers interrupts, interrupts are masked. Thus,
when perfmon
calls ds.c, interrupts are masked. That means that we lock/unlock ds_lock
with interrupts disabled. The lock checker triggered when I ran a simple perfmon
session and warned of possible lock inversion. Suppose you are coming from the
ptrace code into ds. You grab ds_lock, but the same process is also running
a perfmon session with PEBS and a counter overflows, you get into
the PMU interrupt handler which may call into ds.c and try to grab the ds_lock.
For that reason, I think you should use a
spin_lock_irqsave/spin_unlock_irqrestore
pairs to protect your ds context.

I found another issue with ds_release(). You need to skip freeing the
buffer when it
is NULL, i.e., was already allocated by caller of ds_request_pebs().

I have attached a diff for the ds.c interface. It disables
ds_validate_access(), export
the PEBS functions to modules, fixes ds_release().

As for handling the interrupt is ds.c, not clear how this could work
with current perfmon.
I don't know how this work on the BTS side. On the PMU side, that is not because
I am using PEBS, that I don't also use other counters as well. Longer
term, I think, there
needs to be a lower-level PMU interrupt service where you would
register a callback
on PMU interrupts. It would be used by NMI watchdog, perfmon,
Oprofile, ds.c. Callbacks
would be chained, just like what happens with the NMI interrupt
handler. Such service would
go hand in hand with a centralized PMU MSR allocator which would
provide safe sharing of
the PMU registers between different subsystems (there is a primitive
version of this already
today in perfctr-watchdog.c).



On Wed, Nov 19, 2008 at 4:47 PM, Metzger, Markus T
<markus.t.metzger@intel.com> wrote:
>>-----Original Message-----
>>From: stephane eranian [mailto:eranian@googlemail.com]
>>Sent: Mittwoch, 19. November 2008 14:00
>>To: Metzger, Markus T
>>Cc: Markus Metzger; Ingo Molnar; Andi Kleen; Andrew Morton;
>>linux-kernel@vger.kernel.org
>>Subject: Re: debugctl msr
>>
>
>>I had to hack ds.c some more to make forward progress with PEBS. First
>>of all my PEBS code is
>>in a kernel module, so all PEBS functions have to be exported.
>>Furhtermore, I need a
>>ds_get_pebs_thres() and ds_set_pebs_thres() calls.
>
> I'm having a deja vu. We had this discussion before. You reported those
> issues and I fixed them. Same for the PEBS size; and Andi Kleen asked
> to exclude ds.c from the build instead of guarding the .c file and to
> use the mm semaphore in ds_allocate_buffer().
>
> That thread ended in the multiplexing discussion and my fixes never got in.
> I'll send a patch covering those problems next week.
>
>
> Regarding access to the interrupt threshold, we never completed
> our discussion.
> If we look towards multiplexing, ds.c has to handle interrupts and
> copy the trace to the various users - at least for BTS.
> I will pull some of the BTS handling from ptrace into ds.c - ds.c needs
> to be able to disable BTS recording for overflow handling and we would
> not want this knowledge in two different places.
>
> I would add those functions now to proceed with the perfmon2 adaptation
> and later remove them again and put overflow handling into ds.c
>
> I'll send a separate patch for those.
>
>
>>But the one key problem is ds_validate_access(). I had to disable this
>>function.
>
> I agree that this is too ptrace centric.
>
> It works fine for the ptrace bts extenstion since ptrace has similar
> restrictions, already.
>
> A better choice would be to return an opaque handle.
>
>
> regards,
> markus.
> ---------------------------------------------------------------------
> Intel GmbH
> Dornacher Strasse 1
> 85622 Feldkirchen/Muenchen Germany
> Sitz der Gesellschaft: Feldkirchen bei Muenchen
> Geschaeftsfuehrer: Douglas Lusk, Peter Gleissner, Hannes Schwaderer
> Registergericht: Muenchen HRB 47456 Ust.-IdNr.
> VAT Registration No.: DE129385895
> Citibank Frankfurt (BLZ 502 109 00) 600119052
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
>

------=_Part_20957_26073426.1227114791280
Content-Type: application/octet-stream; name=ds.diff
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fnq83vf60
Content-Disposition: attachment; filename=ds.diff

ZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2RzLmggYi9hcmNoL3g4Ni9pbmNsdWRl
L2FzbS9kcy5oCmluZGV4IDcyYzVhMTkuLmZlZDY2NGEgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2lu
Y2x1ZGUvYXNtL2RzLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vZHMuaApAQCAtNzgsNiAr
NzgsNyBAQCBleHRlcm4gaW50IGRzX3JlbGVhc2VfcGVicyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRh
c2spOwogICovCiBleHRlcm4gaW50IGRzX2dldF9idHNfaW5kZXgoc3RydWN0IHRhc2tfc3RydWN0
ICp0YXNrLCBzaXplX3QgKnBvcyk7CiBleHRlcm4gaW50IGRzX2dldF9wZWJzX2luZGV4KHN0cnVj
dCB0YXNrX3N0cnVjdCAqdGFzaywgc2l6ZV90ICpwb3MpOworZXh0ZXJuIGludCBkc19nZXRfcGVi
c190aHJlcyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssIHNpemVfdCAqcG9zKTsKIAogLyoKICAq
IFJldHVybiB0aGUgKGFycmF5KSBpbmRleCBvbmUgcmVjb3JkIGJleW9uZCB0aGUgZW5kIG9mIHRo
ZSBhcnJheS4KZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9kcy5jIGIvYXJjaC94ODYva2Vy
bmVsL2RzLmMKaW5kZXggMmI2OTk5NC4uNTg4MjAxNCAxMDA2NDQKLS0tIGEvYXJjaC94ODYva2Vy
bmVsL2RzLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2RzLmMKQEAgLTMwLDcgKzMwLDcgQEAKICNp
bmNsdWRlIDxsaW51eC9zbGFiLmg+CiAjaW5jbHVkZSA8bGludXgvc2NoZWQuaD4KICNpbmNsdWRl
IDxsaW51eC9tbS5oPgotCisjaW5jbHVkZSA8bGludXgvbW9kdWxlLmg+CiAKIC8qCiAgKiBUaGUg
Y29uZmlndXJhdGlvbiBmb3IgYSBwYXJ0aWN1bGFyIERTIGhhcmR3YXJlIGltcGxlbWVudGF0aW9u
LgpAQCAtMTMxLDcgKzEzMSw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGRzX3ZhbGlkYXRlX2FjY2Vz
cyhzdHJ1Y3QgZHNfY29udGV4dCAqY29udGV4dCwKIHsKIAlpZiAoIWNvbnRleHQpCiAJCXJldHVy
biAtRVBFUk07Ci0KK3JldHVybiAwOwogCWlmIChjb250ZXh0LT5vd25lcltxdWFsXSA9PSBjdXJy
ZW50KQogCQlyZXR1cm4gMDsKIApAQCAtNDY3LDYgKzQ2Nyw3IEBAIGludCBkc19yZXF1ZXN0X3Bl
YnMoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCB2b2lkICpiYXNlLCBzaXplX3Qgc2l6ZSwKIHsK
IAlyZXR1cm4gZHNfcmVxdWVzdCh0YXNrLCBiYXNlLCBzaXplLCBvdmZsLCBkc19wZWJzKTsKIH0K
K0VYUE9SVF9TWU1CT0woZHNfcmVxdWVzdF9wZWJzKTsKIAogc3RhdGljIGludCBkc19yZWxlYXNl
KHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgZW51bSBkc19xdWFsaWZpZXIgcXVhbCkKIHsKQEAg
LTQ3OCwxMiArNDc5LDE0IEBAIHN0YXRpYyBpbnQgZHNfcmVsZWFzZShzdHJ1Y3QgdGFza19zdHJ1
Y3QgKnRhc2ssIGVudW0gZHNfcXVhbGlmaWVyIHF1YWwpCiAJaWYgKGVycm9yIDwgMCkKIAkJZ290
byBvdXQ7CiAKLQlrZnJlZShjb250ZXh0LT5idWZmZXJbcXVhbF0pOwotCWNvbnRleHQtPmJ1ZmZl
cltxdWFsXSA9IE5VTEw7CisJaWYgKGNvbnRleHQtPmJ1ZmZlcltxdWFsXSkgeworCQlrZnJlZShj
b250ZXh0LT5idWZmZXJbcXVhbF0pOworCQljb250ZXh0LT5idWZmZXJbcXVhbF0gPSBOVUxMOwog
Ci0JY3VycmVudC0+bW0tPnRvdGFsX3ZtICAtPSBjb250ZXh0LT5wYWdlc1txdWFsXTsKLQljdXJy
ZW50LT5tbS0+bG9ja2VkX3ZtIC09IGNvbnRleHQtPnBhZ2VzW3F1YWxdOwotCWNvbnRleHQtPnBh
Z2VzW3F1YWxdID0gMDsKKwkJY3VycmVudC0+bW0tPnRvdGFsX3ZtICAtPSBjb250ZXh0LT5wYWdl
c1txdWFsXTsKKwkJY3VycmVudC0+bW0tPmxvY2tlZF92bSAtPSBjb250ZXh0LT5wYWdlc1txdWFs
XTsKKwkJY29udGV4dC0+cGFnZXNbcXVhbF0gPSAwOworCX0KIAljb250ZXh0LT5vd25lcltxdWFs
XSA9IE5VTEw7CiAKIAkvKgpAQCAtNTA2LDYgKzUwOSw3IEBAIGludCBkc19yZWxlYXNlX3BlYnMo
c3RydWN0IHRhc2tfc3RydWN0ICp0YXNrKQogewogCXJldHVybiBkc19yZWxlYXNlKHRhc2ssIGRz
X3BlYnMpOwogfQorRVhQT1JUX1NZTUJPTChkc19yZWxlYXNlX3BlYnMpOwogCiBzdGF0aWMgaW50
IGRzX2dldF9pbmRleChzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2ssIHNpemVfdCAqcG9zLAogCQkJ
ZW51bSBkc19xdWFsaWZpZXIgcXVhbCkKQEAgLTUzOSw2ICs1NDMsMzIgQEAgaW50IGRzX2dldF9w
ZWJzX2luZGV4KHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFzaywgc2l6ZV90ICpwb3MpCiB7CiAJcmV0
dXJuIGRzX2dldF9pbmRleCh0YXNrLCBwb3MsIGRzX3BlYnMpOwogfQorRVhQT1JUX1NZTUJPTChk
c19nZXRfcGVic19pbmRleCk7CisKK2ludCBkc19nZXRfcGVic190aHJlcyhzdHJ1Y3QgdGFza19z
dHJ1Y3QgKnRhc2ssIHNpemVfdCAqcG9zKQoreworCXN0cnVjdCBkc19jb250ZXh0ICpjb250ZXh0
OworCXVuc2lnbmVkIGxvbmcgYmFzZSwgdGhyOworCWludCBlcnJvcjsKKworCWNvbnRleHQgPSBk
c19nZXRfY29udGV4dCh0YXNrKTsKKwllcnJvciA9IGRzX3ZhbGlkYXRlX2FjY2Vzcyhjb250ZXh0
LCBkc19wZWJzKTsKKwlpZiAoZXJyb3IgPCAwKQorCQlnb3RvIG91dDsKKworCWJhc2UgID0gZHNf
Z2V0KGNvbnRleHQtPmRzLCBkc19wZWJzLCBkc19idWZmZXJfYmFzZSk7CisJdGhyID0gZHNfZ2V0
KGNvbnRleHQtPmRzLCBkc19wZWJzLCBkc19pbnRlcnJ1cHRfdGhyZXNob2xkKTsKKworCWVycm9y
ID0gKCh0aHIgLSBiYXNlKSAvIGRzX2NmZy5zaXplb2ZfcmVjW2RzX3BlYnNdKTsKKwlpZiAocG9z
KQorCQkqcG9zID0gZXJyb3I7CisJcmV0dXJuIGVycm9yOworIG91dDoKKwlkc19wdXRfY29udGV4
dChjb250ZXh0KTsKKwlyZXR1cm4gZXJyb3I7Cit9CitFWFBPUlRfU1lNQk9MKGRzX2dldF9wZWJz
X3RocmVzKTsKKwogCiBzdGF0aWMgaW50IGRzX2dldF9lbmQoc3RydWN0IHRhc2tfc3RydWN0ICp0
YXNrLCBzaXplX3QgKnBvcywKIAkJICAgICAgZW51bSBkc19xdWFsaWZpZXIgcXVhbCkKQEAgLTU3
Miw2ICs2MDIsNyBAQCBpbnQgZHNfZ2V0X3BlYnNfZW5kKHN0cnVjdCB0YXNrX3N0cnVjdCAqdGFz
aywgc2l6ZV90ICpwb3MpCiB7CiAJcmV0dXJuIGRzX2dldF9lbmQodGFzaywgcG9zLCBkc19wZWJz
KTsKIH0KK0VYUE9SVF9TWU1CT0woZHNfZ2V0X3BlYnNfZW5kKTsKIAogc3RhdGljIGludCBkc19h
Y2Nlc3Moc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCBzaXplX3QgaW5kZXgsCiAJCSAgICAgY29u
c3Qgdm9pZCAqKnJlY29yZCwgZW51bSBkc19xdWFsaWZpZXIgcXVhbCkKQEAgLTc0Nyw2ICs3Nzgs
NyBAQCBpbnQgZHNfcmVzZXRfcGVicyhzdHJ1Y3QgdGFza19zdHJ1Y3QgKnRhc2spCiB7CiAJcmV0
dXJuIGRzX3Jlc2V0X29yX2NsZWFyKHRhc2ssIGRzX3BlYnMsIC8qIGNsZWFyID0gKi8gMCk7CiB9
CitFWFBPUlRfU1lNQk9MKGRzX3Jlc2V0X3BlYnMpOwogCiBpbnQgZHNfY2xlYXJfYnRzKHN0cnVj
dCB0YXNrX3N0cnVjdCAqdGFzaykKIHsKQEAgLTc5Niw2ICs4MjgsNyBAQCBpbnQgZHNfc2V0X3Bl
YnNfcmVzZXQoc3RydWN0IHRhc2tfc3RydWN0ICp0YXNrLCB1NjQgdmFsdWUpCiAJZHNfcHV0X2Nv
bnRleHQoY29udGV4dCk7CiAJcmV0dXJuIGVycm9yOwogfQorRVhQT1JUX1NZTUJPTChkc19zZXRf
cGVic19yZXNldCk7CiAKIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNfY29uZmlndXJhdGlvbiBkc19j
ZmdfdmFyID0gewogCS5zaXplb2ZfZHMgICAgPSBzaXplb2YobG9uZykgKiAxMiwKQEAgLTgwNCwx
MCArODM3LDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNfY29uZmlndXJhdGlvbiBkc19jZmdf
dmFyID0gewogCS5zaXplb2ZfcmVjW2RzX3BlYnNdICA9IHNpemVvZihsb25nKSAqIDEwCiB9Owog
c3RhdGljIGNvbnN0IHN0cnVjdCBkc19jb25maWd1cmF0aW9uIGRzX2NmZ182NCA9IHsKLQkuc2l6
ZW9mX2RzICAgID0gOCAqIDEyLAorCS5zaXplb2ZfZHMgICAgPSA4ICogOSwKIAkuc2l6ZW9mX2Zp
ZWxkID0gOCwKIAkuc2l6ZW9mX3JlY1tkc19idHNdICAgPSA4ICogMywKLQkuc2l6ZW9mX3JlY1tk
c19wZWJzXSAgPSA4ICogMTAKKwkuc2l6ZW9mX3JlY1tkc19wZWJzXSAgPSA4ICogMTgKIH07CiAK
IHN0YXRpYyBpbmxpbmUgdm9pZAo=
------=_Part_20957_26073426.1227114791280--
