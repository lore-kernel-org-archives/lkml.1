Return-Path: <linux-kernel-owner+w=401wt.eu-S1757951AbYFQAGT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757951AbYFQAGT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 20:06:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751050AbYFQAGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 20:06:05 -0400
Received: from calf.ext.ti.com ([198.47.26.144]:33744 "EHLO calf.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbYFQAGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 20:06:04 -0400
From: "Woodruff, Richard" <r-woodruff2@ti.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jun 2008 19:05:47 -0500
Subject: [PATCH] suppress needless timer reprogramming {tick-sched.c}
Thread-Topic: [PATCH] suppress needless timer reprogramming {tick-sched.c}
Thread-Index: AcjOwhiJnEmvsDvRRoGUt3AbpTmgXQAMqYQwAEUO2eA=
Message-ID: <13B9B4C6EF24D648824FF11BE8967162035B8F807C@dlee02.ent.ti.com>
References: <3B6D69C3A9EBCA4BA5DA60D91302742904554EE1@dlee13.ent.ti.com>
 <200805161055.17252.david-b@pacbell.net>
 <13B9B4C6EF24D648824FF11BE8967162035B87F9B8@dlee02.ent.ti.com>
 <200806150130.32901.david-b@pacbell.net> 
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: multipart/mixed;
	boundary="_002_13B9B4C6EF24D648824FF11BE8967162035B8F807Cdlee02enttico_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_13B9B4C6EF24D648824FF11BE8967162035B8F807Cdlee02enttico_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Thomas,

Does this patch look ok?

It simply does a check to see if the about to be reprogrammed 1 shot alread=
y is the last event programmed in the hardware.  If it is it skips calling =
the hardware.

In my device I get many interrupts from a high speed USB device in a very s=
hort period of time.  The system spends a lot of time reprogramming the har=
dware timer which is in a slower timing domain as compared to the CPU.  Thi=
s results in the CPU spending a huge amount of time waiting for the timer p=
osting to be done.  All of this reprogramming is useless as the wake up tim=
e has not changed.

As measured using ETM trace this drops my reprogramming penalty from almost=
 60% CPU load down to 15% during high interrupt rate.  If you like I can se=
nd traces to show this.

Regards,
Richard W.

BTW:
I can much the other 15% by keeping the ticker on by using a function like =
there is for rcu today in tick-sched.c. Something like an irq_needs_cpu() b=
y the rcu_needs_cpu() check.  Where return =3D 1 if (curr_irq_ts - last_irq=
_ts < min_delta_ns).  A time stamp is taken in irq code at entry.


--_002_13B9B4C6EF24D648824FF11BE8967162035B8F807Cdlee02enttico_
Content-Type: application/octet-stream;
	name="suppress_reprogram_2626-rc5.diff"
Content-Description: suppress_reprogram_2626-rc5.diff
Content-Disposition: attachment;
	filename="suppress_reprogram_2626-rc5.diff"; size=1454;
	creation-date="Mon, 16 Jun 2008 19:02:08 GMT";
	modification-date="Mon, 16 Jun 2008 19:02:08 GMT"
Content-Transfer-Encoding: base64

U3VwcHJlc3Mgc2V0dGluZyBvZiBkdXBsaWNhdGUgdGltZXIgZXZlbnQgd2hlbiB0aW1lciBhbHJl
YWR5IHN0b3BwZWQuClRpbWVyIHByb2dyYW1taW5nIGNhbiBiZSB2ZXJ5IGNvc3RseSBhbmQgY2Fu
IHJlc3VsdCBpbiBsb25nIGNwdSAKc3RhbGwvd2FpdCB0aW1lcy4KClNpZ25lZC1vZmYtYnk6IFJp
Y2hhcmQgV29vZHJ1ZmYgPHItd29vZHJ1ZmYyQHRpLmNvbT4KCmRpZmYgLS1naXQgYS9rZXJuZWwv
dGltZS90aWNrLXNjaGVkLmMgYi9rZXJuZWwvdGltZS90aWNrLXNjaGVkLmMKaW5kZXggYjg1NGE4
OS4uZmY2Yjk2NyAxMDA2NDQKLS0tIGEva2VybmVsL3RpbWUvdGljay1zY2hlZC5jCisrKyBiL2tl
cm5lbC90aW1lL3RpY2stc2NoZWQuYwpAQCAtMjU0LDYgKzI1NCwxNyBAQCB2b2lkIHRpY2tfbm9o
el9zdG9wX3NjaGVkX3RpY2sodm9pZCkKIAkvKiBTY2hlZHVsZSB0aGUgdGljaywgaWYgd2UgYXJl
IGF0IGxlYXN0IG9uZSBqaWZmaWUgb2ZmICovCiAJaWYgKChsb25nKWRlbHRhX2ppZmZpZXMgPj0g
MSkgewogCisJCS8qCisJCSogY2FsY3VsYXRlIHRoZSBleHBpcnkgdGltZSBmb3IgdGhlIG5leHQg
dGltZXIgd2hlZWwKKwkJKiB0aW1lcgorCQkqLworCQlleHBpcmVzID0ga3RpbWVfYWRkX25zKGxh
c3RfdXBkYXRlLCB0aWNrX3BlcmlvZC50djY0ICoKKwkJCQkgICBkZWx0YV9qaWZmaWVzKTsKKwor
CQkvKiBTa2lwIHJlcHJvZ3JhbSBvZiBldmVudCBpZiBpdHMgbm90IGNoYW5nZWQgKi8KKwkJaWYo
dHMtPnRpY2tfc3RvcHBlZCAmJiBrdGltZV9lcXVhbChleHBpcmVzLCBkZXYtPm5leHRfZXZlbnQp
KQorCQkJZ290byBvdXQyOworCiAJCWlmIChkZWx0YV9qaWZmaWVzID4gMSkKIAkJCWNwdV9zZXQo
Y3B1LCBub2h6X2NwdV9tYXNrKTsKIAkJLyoKQEAgLTMwNCwxMiArMzE1LDcgQEAgdm9pZCB0aWNr
X25vaHpfc3RvcF9zY2hlZF90aWNrKHZvaWQpCiAJCQlnb3RvIG91dDsKIAkJfQogCi0JCS8qCi0J
CSAqIGNhbGN1bGF0ZSB0aGUgZXhwaXJ5IHRpbWUgZm9yIHRoZSBuZXh0IHRpbWVyIHdoZWVsCi0J
CSAqIHRpbWVyCi0JCSAqLwotCQlleHBpcmVzID0ga3RpbWVfYWRkX25zKGxhc3RfdXBkYXRlLCB0
aWNrX3BlcmlvZC50djY0ICoKLQkJCQkgICAgICAgZGVsdGFfamlmZmllcyk7CisJCS8qIE1hcmsg
ZXhwaXJpZXMgKi8KIAkJdHMtPmlkbGVfZXhwaXJlcyA9IGV4cGlyZXM7CiAKIAkJaWYgKHRzLT5u
b2h6X21vZGUgPT0gTk9IWl9NT0RFX0hJR0hSRVMpIHsKQEAgLTMyOCw2ICszMzQsNyBAQCB2b2lk
IHRpY2tfbm9oel9zdG9wX3NjaGVkX3RpY2sodm9pZCkKIAkJdGlja19kb191cGRhdGVfamlmZmll
czY0KGt0aW1lX2dldCgpKTsKIAkJY3B1X2NsZWFyKGNwdSwgbm9oel9jcHVfbWFzayk7CiAJfQor
b3V0MjoKIAlyYWlzZV9zb2Z0aXJxX2lycW9mZihUSU1FUl9TT0ZUSVJRKTsKIG91dDoKIAl0cy0+
bmV4dF9qaWZmaWVzID0gbmV4dF9qaWZmaWVzOwo=

--_002_13B9B4C6EF24D648824FF11BE8967162035B8F807Cdlee02enttico_--
