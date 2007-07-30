Return-Path: <linux-kernel-owner+w=401wt.eu-S1757107AbXG3IJB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757107AbXG3IJB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 04:09:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756170AbXG3IIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 04:08:49 -0400
Received: from n152-u15.estnet.bg ([89.253.152.15]:1888 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755061AbXG3IIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 04:08:47 -0400
Date: Mon, 30 Jul 2007 11:05:25 +0300 (EEST)
From: Petko Manolov <petkan@nucleusys.com>
To: Oliver Neukum <oliver@neukum.org>
cc: linux-usb-devel@lists.sourceforge.net, Jesper Juhl <jesper.juhl@gmail.com>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Greg Kroah-Hartman <greg@kroah.com>, netdev@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Petko Manolov <petkan@users.sourceforge.net>
Subject: Re: [linux-usb-devel] [PATCH] USB Pegasus driver - avoid a potential
 NULL pointer dereference.
In-Reply-To: <200707291049.26619.oliver@neukum.org>
Message-ID: <Pine.LNX.4.64.0707301053020.3113@bender.nucleusys.com>
References: <200707290019.02591.jesper.juhl@gmail.com>
 <a781481a0707281637n5b123e4aib46c4e4b009b0018@mail.gmail.com>
 <9a8748490707281655u66e50bbfqba58687b579a85fe@mail.gmail.com>
 <200707291049.26619.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811350-1278486918-1185782725=:3113"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811350-1278486918-1185782725=:3113
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

On Sun, 29 Jul 2007, Oliver Neukum wrote:

> Am Sonntag 29 Juli 2007 schrieb Jesper Juhl:
>> On 29/07/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
>>> Hi,
>>>
>>> On 7/29/07, Jesper Juhl <jesper.juhl@gmail.com> wrote:
>>>> Hello,
>>>>
>>>> This patch makes sure we don't dereference a NULL pointer in
>>>> drivers/net/usb/pegasus.c::write_bulk_callback() in the initial
>>>> struct net_device *net = pegasus->net; assignment.
>>>> The existing code checks if 'pegasus' is NULL and bails out if
>>>> it is, so we better not touch that pointer until after that check.
>>>> [...]
>>>> diff --git a/drivers/net/usb/pegasus.c b/drivers/net/usb/pegasus.c
>>>> index a05fd97..04cba6b 100644
>>>> --- a/drivers/net/usb/pegasus.c
>>>> +++ b/drivers/net/usb/pegasus.c
>>>> @@ -768,11 +768,13 @@ done:
>>>>  static void write_bulk_callback(struct urb *urb)
>>>>  {
>>>>         pegasus_t *pegasus = urb->context;
>>>> -       struct net_device *net = pegasus->net;
>>>> +       struct net_device *net;
>>>>
>>>>         if (!pegasus)
>>>>                 return;
>>>>
>>>> +       net = pegasus->net;
>>>> +
>>>>         if (!netif_device_present(net) || !netif_running(net))
>>>>                 return;
>>>
>>> Is it really possible that we're called into this function with
>>> urb->context == NULL? If not, I'd suggest let's just get rid of
>>> the check itself, instead.
>>>
>> I'm not sure. I am not very familiar with this code. I just figured
>> that moving the assignment is potentially a little safer and it is
>> certainly no worse than the current code, so that's a safe and
>> potentially benneficial change. Removing the check may be safe but I'm
>> not certain enough to make that call...
>
> pegasus == NULL there would be a kernel bug. Silently ignoring
> it, like the code now wants to do is bad. As the oops has never been
> reported, I figure turning it into an explicit debugging test is overkill,
> so removal seems to be the best option.

In the past urb->context was not guaranteed to be non-null for any 
asynchronous calls.  If this is not the case anymore then it should be 
removed from at least two more locations in the driver.

Attached you'll find the resulting patch.


 		Petko
---1463811350-1278486918-1185782725=:3113
Content-Type: TEXT/x-diff; charset=US-ASCII; name=pegasus.patch
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.64.0707301105250.3113@bender.nucleusys.com>
Content-Description: 
Content-Disposition: attachment; filename=pegasus.patch

LS0tIGRyaXZlcnMvbmV0L3VzYi9wZWdhc3VzLmMub2xkCTIwMDctMDctMTAg
MTE6Mzk6NTAuMDAwMDAwMDAwICswMzAwDQorKysgZHJpdmVycy9uZXQvdXNi
L3BlZ2FzdXMuYwkyMDA3LTA3LTMwIDExOjAyOjEwLjAwMDAwMDAwMCArMDMw
MA0KQEAgLTEwMCw5ICsxMDAsNiBAQCBzdGF0aWMgdm9pZCBjdHJsX2NhbGxi
YWNrKHN0cnVjdCB1cmIgKnVyDQogew0KIAlwZWdhc3VzX3QgKnBlZ2FzdXMg
PSB1cmItPmNvbnRleHQ7DQogDQotCWlmICghcGVnYXN1cykNCi0JCXJldHVy
bjsNCi0NCiAJc3dpdGNoICh1cmItPnN0YXR1cykgew0KIAljYXNlIDA6DQog
CQlpZiAocGVnYXN1cy0+ZmxhZ3MgJiBFVEhfUkVHU19DSEFOR0UpIHsNCkBA
IC02MDksMTUgKzYwNiwxMSBAQCBzdGF0aWMgaW5saW5lIHN0cnVjdCBza19i
dWZmICpwdWxsX3NrYihwDQogc3RhdGljIHZvaWQgcmVhZF9idWxrX2NhbGxi
YWNrKHN0cnVjdCB1cmIgKnVyYikNCiB7DQogCXBlZ2FzdXNfdCAqcGVnYXN1
cyA9IHVyYi0+Y29udGV4dDsNCi0Jc3RydWN0IG5ldF9kZXZpY2UgKm5ldDsN
CisJc3RydWN0IG5ldF9kZXZpY2UgKm5ldCA9IHBlZ2FzdXMtPm5ldDsNCiAJ
aW50IHJ4X3N0YXR1cywgY291bnQgPSB1cmItPmFjdHVhbF9sZW5ndGg7DQog
CXU4ICpidWYgPSB1cmItPnRyYW5zZmVyX2J1ZmZlcjsNCiAJX191MTYgcGt0
X2xlbjsNCiANCi0JaWYgKCFwZWdhc3VzKQ0KLQkJcmV0dXJuOw0KLQ0KLQlu
ZXQgPSBwZWdhc3VzLT5uZXQ7DQogCWlmICghbmV0aWZfZGV2aWNlX3ByZXNl
bnQobmV0KSB8fCAhbmV0aWZfcnVubmluZyhuZXQpKQ0KIAkJcmV0dXJuOw0K
IA0KQEAgLTc3MCw5ICs3NjMsNiBAQCBzdGF0aWMgdm9pZCB3cml0ZV9idWxr
X2NhbGxiYWNrKHN0cnVjdCB1DQogCXBlZ2FzdXNfdCAqcGVnYXN1cyA9IHVy
Yi0+Y29udGV4dDsNCiAJc3RydWN0IG5ldF9kZXZpY2UgKm5ldCA9IHBlZ2Fz
dXMtPm5ldDsNCiANCi0JaWYgKCFwZWdhc3VzKQ0KLQkJcmV0dXJuOw0KLQ0K
IAlpZiAoIW5ldGlmX2RldmljZV9wcmVzZW50KG5ldCkgfHwgIW5ldGlmX3J1
bm5pbmcobmV0KSkNCiAJCXJldHVybjsNCiANCkBAIC04MDUsMTMgKzc5NSw5
IEBAIHN0YXRpYyB2b2lkIHdyaXRlX2J1bGtfY2FsbGJhY2soc3RydWN0IHUN
CiBzdGF0aWMgdm9pZCBpbnRyX2NhbGxiYWNrKHN0cnVjdCB1cmIgKnVyYikN
CiB7DQogCXBlZ2FzdXNfdCAqcGVnYXN1cyA9IHVyYi0+Y29udGV4dDsNCi0J
c3RydWN0IG5ldF9kZXZpY2UgKm5ldDsNCisJc3RydWN0IG5ldF9kZXZpY2Ug
Km5ldCA9IHBlZ2FzdXMtPm5ldDsNCiAJaW50IHN0YXR1czsNCiANCi0JaWYg
KCFwZWdhc3VzKQ0KLQkJcmV0dXJuOw0KLQluZXQgPSBwZWdhc3VzLT5uZXQ7
DQotDQogCXN3aXRjaCAodXJiLT5zdGF0dXMpIHsNCiAJY2FzZSAwOg0KIAkJ
YnJlYWs7DQo=

---1463811350-1278486918-1185782725=:3113--
