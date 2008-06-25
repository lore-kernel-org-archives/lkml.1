Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbYFYQFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbYFYQFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 12:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751966AbYFYQFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 12:05:35 -0400
Received: from smtp.nokia.com ([192.100.105.134]:42782 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbYFYQFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 12:05:34 -0400
Message-ID: <486269AE.7050006@nokia.com>
Date: Wed, 25 Jun 2008 18:52:14 +0300
From: Stefan Becker <Stefan.Becker@nokia.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: ext Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [REGRESSION] 2.6.24/25: random lockups when accessing external
 USB harddrive
References: <Pine.LNX.4.44L0.0806241702490.2166-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0806241702490.2166-100000@iolanthe.rowland.org>
Content-Type: multipart/mixed;
 boundary="------------060804060604040502030909"
X-OriginalArrivalTime: 25 Jun 2008 15:52:55.0758 (UTC) FILETIME=[88930EE0:01C8D6DB]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060804060604040502030909
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi,

ext Alan Stern wrote:
> On Tue, 24 Jun 2008, Stefan Becker wrote:
> 
>> So the lockup is caused by an already locked hcd_urb_list_lock. Is there 
>> a way to see the lock holder? Or any other suggestions how to proceed?
> 
> Good work!

Well, I guess I'm just lucky it didn't turn into a heisenbug with all 
those printk's in the code :-)

> The usage in usb_hcd_link_urb_to_ep() appears benign; the code doesn't 
> do anything that might hang while holding the lock.  All it does is 
> manipulate a linked list.

Unfortunately I could only run a small test today. I added some simple 
debugging code for the spinlock usage in hcd.c (see attached diff) and I 
get the following message at lockup (I tried it twice just to be sure):

HCD URB list locked by usb_hcd_link_urb_to_ep!

As far as I understand the matter this only can happen if 
usb_hcd_link_urb_to_ep() gets interrupted while holding the spinlock. 
But according to the contract at the header of the function it should be 
called with interrupts disabled!

I guess the obvious way forward from here is:

  - replace the spin_lock() in the function with the irqsave version

  - if that fixes the problem add debugging code to the function and 
panic with a stack trace when the interrupts aren't disabled one entry 
(don't know how to detect that yet, any suggestions?) That hopefully 
identifies the culprit that calls the function with interrupts enabled.

Regards,

	Stefan

---
Stefan Becker
E-Mail: Stefan.Becker@nokia.com

--------------060804060604040502030909
Content-Type: text/plain;
 name="hcd.c.debug-patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="hcd.c.debug-patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvdXNiL2NvcmUvaGNkLmMgYi9kcml2ZXJzL3VzYi9jb3Jl
L2hjZC5jCmluZGV4IDA5YTUzZTcuLjIwZGI2NTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvdXNi
L2NvcmUvaGNkLmMKKysrIGIvZHJpdmVycy91c2IvY29yZS9oY2QuYwpAQCAtNDUsNiArNDUs
MTIgQEAKICNpbmNsdWRlICJoY2QuaCIKICNpbmNsdWRlICJodWIuaCIKIAorI2lmZGVmIERF
QlVHCitjb25zdCBjaGFyICpfdXJiX2xpc3RfaG9sZGVyID0gIk5PTkUiOworI2RlZmluZSBV
UkJfTElTVF9IT0xERVIobikgX3VyYl9saXN0X2hvbGRlciA9ICNuOworI2Vsc2UKKyNkZWZp
bmUgVVJCX0xJU1RfSE9MREVSKG4pCisjZW5kaWYgIAogCiAvKi0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0qLwogCkBAIC0xMDAyLDYgKzEwMDgsNyBAQCBpbnQgdXNiX2hjZF9saW5rX3VyYl90b19l
cChzdHJ1Y3QgdXNiX2hjZCAqaGNkLCBzdHJ1Y3QgdXJiICp1cmIpCiAJaW50CQlyYyA9IDA7
CiAKIAlzcGluX2xvY2soJmhjZF91cmJfbGlzdF9sb2NrKTsKKwlVUkJfTElTVF9IT0xERVIo
dXNiX2hjZF9saW5rX3VyYl90b19lcCkKIAogCS8qIENoZWNrIHRoYXQgdGhlIFVSQiBpc24n
dCBiZWluZyBraWxsZWQgKi8KIAlpZiAodW5saWtlbHkodXJiLT5yZWplY3QpKSB7CkBAIC0x
MTA3LDcgKzExMTQsMTUgQEAgRVhQT1JUX1NZTUJPTF9HUEwodXNiX2hjZF9jaGVja191bmxp
bmtfdXJiKTsKIHZvaWQgdXNiX2hjZF91bmxpbmtfdXJiX2Zyb21fZXAoc3RydWN0IHVzYl9o
Y2QgKmhjZCwgc3RydWN0IHVyYiAqdXJiKQogewogCS8qIGNsZWFyIGFsbCBzdGF0ZSBsaW5r
aW5nIHVyYiB0byB0aGlzIGRldiAoYW5kIGhjZCkgKi8KKyNpZmRlZiBERUJVRworICAgICAg
ICBpZiAoIXNwaW5fdHJ5bG9jaygmaGNkX3VyYl9saXN0X2xvY2spKSB7CisJICBwcmludGso
S0VSTl9DUklUICJIQ0QgVVJCIGxpc3QgbG9ja2VkIGJ5ICVzIVxuIiwgX3VyYl9saXN0X2hv
bGRlcik7CisjZW5kaWYKIAlzcGluX2xvY2soJmhjZF91cmJfbGlzdF9sb2NrKTsKKwlVUkJf
TElTVF9IT0xERVIodXNiX2hjZF91bmxpbmtfdXJiX2Zyb21fZXApCisjaWZkZWYgREVCVUcK
Kwl9CisjZW5kaWYKIAlsaXN0X2RlbF9pbml0KCZ1cmItPnVyYl9saXN0KTsKIAlzcGluX3Vu
bG9jaygmaGNkX3VyYl9saXN0X2xvY2spOwogfQpAQCAtMTQ0OCw2ICsxNDYzLDcgQEAgdm9p
ZCB1c2JfaGNkX2ZsdXNoX2VuZHBvaW50KHN0cnVjdCB1c2JfZGV2aWNlICp1ZGV2LAogCiAJ
LyogTm8gbW9yZSBzdWJtaXRzIGNhbiBvY2N1ciAqLwogCXNwaW5fbG9ja19pcnEoJmhjZF91
cmJfbGlzdF9sb2NrKTsKKwlVUkJfTElTVF9IT0xERVIodXNiX2hjZF9mbHVzaF9lbmRwb2lu
dF9JTklUSUFMKQogcmVzY2FuOgogCWxpc3RfZm9yX2VhY2hfZW50cnkgKHVyYiwgJmVwLT51
cmJfbGlzdCwgdXJiX2xpc3QpIHsKIAkJaW50CWlzX2luOwpAQCAtMTQ4Miw2ICsxNDk4LDcg
QEAgcmVzY2FuOgogCiAJCS8qIGxpc3QgY29udGVudHMgbWF5IGhhdmUgY2hhbmdlZCAqLwog
CQlzcGluX2xvY2soJmhjZF91cmJfbGlzdF9sb2NrKTsKKwkJVVJCX0xJU1RfSE9MREVSKHVz
Yl9oY2RfZmx1c2hfZW5kcG9pbnRfUkVTQ0FOKQogCQlnb3RvIHJlc2NhbjsKIAl9CiAJc3Bp
bl91bmxvY2tfaXJxKCZoY2RfdXJiX2xpc3RfbG9jayk7CkBAIC0xNDg5LDYgKzE1MDYsNyBA
QCByZXNjYW46CiAJLyogV2FpdCB1bnRpbCB0aGUgZW5kcG9pbnQgcXVldWUgaXMgY29tcGxl
dGVseSBlbXB0eSAqLwogCXdoaWxlICghbGlzdF9lbXB0eSAoJmVwLT51cmJfbGlzdCkpIHsK
IAkJc3Bpbl9sb2NrX2lycSgmaGNkX3VyYl9saXN0X2xvY2spOworCQlVUkJfTElTVF9IT0xE
RVIodXNiX2hjZF9mbHVzaF9lbmRwb2ludF9MSVNUKQogCiAJCS8qIFRoZSBsaXN0IG1heSBo
YXZlIGNoYW5nZWQgd2hpbGUgd2UgYWNxdWlyZWQgdGhlIHNwaW5sb2NrICovCiAJCXVyYiA9
IE5VTEw7Cg==
--------------060804060604040502030909--
