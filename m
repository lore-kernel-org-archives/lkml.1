Return-Path: <linux-kernel-owner+w=401wt.eu-S1754880Ab0ASAwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab0ASAwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:52:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940Ab0ASAwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:52:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:42022 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753932Ab0ASAwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:52:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,299,1262592000"; 
   d="scan'208";a="588254722"
From: "Li, Shaohua" <shaohua.li@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
CC: Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       Corrado Zoccolo <czoccolo@gmail.com>,
       "jens.axboe@oracle.com" <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "jmoyer@redhat.com" <jmoyer@redhat.com>,
       "yanmin_zhang@linux.intel.com" <yanmin_zhang@linux.intel.com>
Date: Tue, 19 Jan 2010 08:52:01 +0800
Subject: RE: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Thread-Topic: [PATCH]cfq-iosched: don't stop async queue with async requests
	pending
Thread-Index: AcqVCgiTHWhC9wgzTKSZT3BI4uckmADlz8Og
Message-ID: <C8EDE645B81E5141A8C6B2F73FD926511499ACE22B@shzsmsx501.ccr.corp.intel.com>
References: <20100113074442.GA10492@sli10-desk.sh.intel.com>
 <4e5e476b1001130018n2ad9e830s4a20d922abd4c7bb@mail.gmail.com>
 <20100113082322.GA24345@sli10-desk.sh.intel.com>
 <20100113111341.GB3087@redhat.com>
 <20100114034150.GA3922@sli10-desk.sh.intel.com>
 <4B4EAB39.1070301@cn.fujitsu.com>
 <20100114061731.GA23590@sli10-desk.sh.intel.com>
 <20100114110902.GA15559@redhat.com>
In-Reply-To: <20100114110902.GA15559@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_C8EDE645B81E5141A8C6B2F73FD926511499ACE22Bshzsmsx501ccr_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_C8EDE645B81E5141A8C6B2F73FD926511499ACE22Bshzsmsx501ccr_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable



>-----Original Message-----
>From: Vivek Goyal [mailto:vgoyal@redhat.com]
>Sent: Thursday, January 14, 2010 7:09 PM
>To: Li, Shaohua
>Cc: Gui Jianfeng; Corrado Zoccolo; jens.axboe@oracle.com; linux-
>kernel@vger.kernel.org; jmoyer@redhat.com; yanmin_zhang@linux.intel.com
>Subject: Re: [PATCH]cfq-iosched: don't stop async queue with async
>requests pending
>
>On Thu, Jan 14, 2010 at 02:17:31PM +0800, Shaohua Li wrote:
>> On Thu, Jan 14, 2010 at 01:27:21PM +0800, Gui Jianfeng wrote:
>> > Shaohua Li wrote:
>> > > On Wed, Jan 13, 2010 at 07:13:41PM +0800, Vivek Goyal wrote:
>> > >> On Wed, Jan 13, 2010 at 04:23:22PM +0800, Shaohua Li wrote:
>> > >>> On Wed, Jan 13, 2010 at 04:18:47PM +0800, Corrado Zoccolo wrote:
>> > >>>> On Wed, Jan 13, 2010 at 8:44 AM, Shaohua Li <shaohua.li@intel.com=
>
>wrote:
>> > >>>>> My SSD speed of direct write is about 80m/s, while I test page
>writeback,
>> > >>>>> the speed can only go to 68m/s. Below patch fixes this.
>> > >>>>> It appears we missused cfq_should_idle in cfq_may_dispatch.
>cfq_should_idle
>> > >>>>> means a queue should idle because it's seekless sync queue or
>it's the last queue,
>> > >>>>> which is to maintain service tree time slice. So it doesn't mean
>the
>> > >>>>> last queue is always a sync queue. If the last queue is asyn
>queue,
>> > >>>>> we definitely shouldn't stop dispatch requests because of
>pending async
>> > >>>>> requests.
>> > >>>> An other option is that cfq_should_idle returns false for async
>> > >>>> queues, since cfq will never idle on them.
>> > >>> I'm considering this option too, but it appears we need make async
>queue
>> > >>> idle to maintain domain time slice.
>> > >> IMHO, we don't have to wait on async write service tree. Generally
>aysnc
>> > >> write queus contain many requests and they are not like reads where
>next
>> > >> request is expected. So idling on aysnc write service tree is waste
>of
>> > >> time and will lead to reduced throughput.
>> > > I fully agree async queue doesn't need wait. I thought the purpose
>we add the last
>> > > queue check in cfq_should_idle is we want a service tree or a group
>has dedicated
>> > > slice, because before the service tree/group slice is expired, new
>queue can jump
>> > > in and if we don't idle, the new queue can only run at next slice.
>Not sure if I
>> > > understand the code correctly.
>> >
>> > Hi Shaohua,
>> >
>> > If a cfq queue is the last one in the io group, if we expire this cfqq
>immediately,
>> > io group will be removed from service tree. When io group gets
>backlogged again, it
>> > will be put at the end of service tree, so it loses its previous share=
.
>so we add
>> > the last check here from the fairness point of view.
>> ya, this is what I'm understanding. So we can't return false for async
>queue
>> in cfq_should_idle if the queue is the last one of service tree.
>>
>
>Yes cfq_should_idle() can check for async queue and return false.
>
>Regarding group loosing fair share, currently all async queues are in root
>group and not in individual groups, so this particular change should not
>affect a lot. We will continue to idle on sync-idle and sync-noidle
>service tree. Only async service tree is the exception.
>
>Once we introduce per group async queue in future, we shall have to come
>up with something else, if need be.
>
>So keep this as a separate patch. I think in the presence of mixed
>workload, (readers and buffered writers), it might give little performance
>boost. We need to test it though.
Ok, if you thought this method doesn't break group, here is the updated
patch. I'm sorry to send the attached patch, my mailbox has trouble.

--_002_C8EDE645B81E5141A8C6B2F73FD926511499ACE22Bshzsmsx501ccr_
Content-Type: application/octet-stream; name="cfq-async-idle.patch"
Content-Description: cfq-async-idle.patch
Content-Disposition: attachment; filename="cfq-async-idle.patch"; size=1215;
	creation-date="Tue, 19 Jan 2010 08:51:26 GMT";
	modification-date="Tue, 19 Jan 2010 08:49:36 GMT"
Content-Transfer-Encoding: base64

RnJvbTogU2hhb2h1YSBMaSA8c2hhb2h1YS5saUBpbnRlbC5jb20+ClRpdGxlOiBjZnEtaW9zY2hl
ZDogZG9uJ3Qgc3RvcCBhc3luYyBxdWV1ZSB3aXRoIGFzeW5jIHJlcXVlc3RzIHBlbmRpbmcKCk15
IFNTRCBzcGVlZCBvZiBkaXJlY3Qgd3JpdGUgaXMgYWJvdXQgODBtL3MsIHdoaWxlIEkgdGVzdCBw
YWdlIHdyaXRlYmFjaywKdGhlIHNwZWVkIGNhbiBvbmx5IGdvIHRvIDY4bS9zLiBCZWxvdyBwYXRj
aCBmaXhlcyB0aGlzLgpjZnFfc2hvdWxkX2lkbGUgbWVhbnMgYSBxdWV1ZSBzaG91bGQgaWRsZSBi
ZWNhdXNlIGl0J3Mgc2Vla2xlc3Mgc3luYwpxdWV1ZSBvciBpdCdzIHRoZSBsYXN0IHF1ZXVlLCB3
aGljaCBpcyB0byBtYWludGFpbiBzZXJ2aWNlIHRyZWUgdGltZQpzbGljZS4gQXMgY3VycmVudGx5
IGFzeW5jIHF1ZXVlcyBhcmUgYWxsIGluIHJvb3QgZ3JvdXAsIG5vIGlkbGUgZm9yIGFzeW5jCnF1
ZXVlIGRvZXNuJ3QgbG9zZSBncm91cCBzbGljZSBmYWlybmVzcy4gSWYgdGhlIGxhc3QgcXVldWUg
aXMgYXN5biBxdWV1ZSwKd2UgZGVmaW5pdGVseSBzaG91bGRuJ3Qgc3RvcCBkaXNwYXRjaCByZXF1
ZXN0cyBiZWNhdXNlIG9mIHBlbmRpbmcgYXN5bmMKcmVxdWVzdHMsIHdoaWNoIHdpbGwgbWFrZSBj
ZnFfbWF5X2Rpc3BhdGNoIGFibGUgdG8gZGlzcGF0Y2ggbW9yZSByZXF1ZXN0cy4KClNpZ25lZC1v
ZmYtYnk6IFNoYW9odWEgTGkgPHNoYW9odWEubGlAaW50ZWwuY29tPgoKZGlmZiAtLWdpdCBhL2Js
b2NrL2NmcS1pb3NjaGVkLmMgYi9ibG9jay9jZnEtaW9zY2hlZC5jCmluZGV4IDkxOGM3ZmQuLmNl
NjA4YTAgMTAwNjQ0Ci0tLSBhL2Jsb2NrL2NmcS1pb3NjaGVkLmMKKysrIGIvYmxvY2svY2ZxLWlv
c2NoZWQuYwpAQCAtMTgwMyw3ICsxODAzLDcgQEAgc3RhdGljIGJvb2wgY2ZxX3Nob3VsZF9pZGxl
KHN0cnVjdCBjZnFfZGF0YSAqY2ZxZCwgc3RydWN0IGNmcV9xdWV1ZSAqY2ZxcSkKIAkgKiBPdGhl
cndpc2UsIHdlIGRvIG9ubHkgaWYgdGhleSBhcmUgdGhlIGxhc3Qgb25lcwogCSAqIGluIHRoZWly
IHNlcnZpY2UgdHJlZS4KIAkgKi8KLQlyZXR1cm4gc2VydmljZV90cmVlLT5jb3VudCA9PSAxOwor
CXJldHVybiBzZXJ2aWNlX3RyZWUtPmNvdW50ID09IDEgJiYgY2ZxcV90eXBlKGNmcXEpICE9IEFT
WU5DX1dPUktMT0FEOwogfQogCiBzdGF0aWMgdm9pZCBjZnFfYXJtX3NsaWNlX3RpbWVyKHN0cnVj
dCBjZnFfZGF0YSAqY2ZxZCkK

--_002_C8EDE645B81E5141A8C6B2F73FD926511499ACE22Bshzsmsx501ccr_--
