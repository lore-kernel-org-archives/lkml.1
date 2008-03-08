Return-Path: <linux-kernel-owner+w=401wt.eu-S1759260AbYCHDDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759260AbYCHDDC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 22:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752188AbYCHDCw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 22:02:52 -0500
Received: from webaccess-cl.virtdom.com ([216.240.101.25]:59754 "EHLO
	webaccess-cl.virtdom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYCHDCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 22:02:51 -0500
X-Greylist: delayed 1937 seconds by postgrey-1.27 at vger.kernel.org; Fri, 07 Mar 2008 22:02:51 EST
Date: Fri, 7 Mar 2008 16:32:38 -1000 (HST)
From: Jeff Roberson <jroberson@chesapeake.net>
X-X-Sender: jroberson@desktop
To: linux-kernel@vger.kernel.org
cc: riel@redhat.com
Subject: [PATCH] eventfd signal race in aio_complete()
Message-ID: <20080307161854.E920@desktop>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="2547152148-1254247870-1204943558=:920"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--2547152148-1254247870-1204943558=:920
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed

Hello,

I have an application that makes use of eventfd to merge socket and aio 
blocking with epoll in one thread.  Under heavy loads the application 
sometimes hangs when we receive notification from epoll that the eventfd 
has an event ready but reading the aio completions produces no results. 
Further investigation revealed that the aiocb was later ready with no 
new event and completing it based on a timer resolved the application 
hang.

This pointed to the eventfd being signaled prematurely and I verified that 
this was indeed the problem.  aio_complete() calls eventfd_signal() before 
the event is actually placed on the completion ring.  On a multi-processor 
system it is possible to read the event from epoll and return to userspace 
before aio_complete() finishes.

The enclosed patch simply moves the signaling to the bottom of the 
function.  I'm not 100% familiar with this code and it looks like it may 
be possible to have spurious wakeups now but there will be no missed 
wakeups.  An application may also race the other way now and receive aio 
completion before the signal, thus still leaving it with a signal with no 
completion.  signaling while the kioctx is locked would resolve this but I 
was hesitant to introduce further nesting of spinlocks that might have 
another order elsewhere.

Please keep me in the cc line for any necessary replies.

Thanks,
Jeff

Signed-off-by:  Jeff Roberson <jeff@freebsd.org>
--2547152148-1254247870-1204943558=:920
Content-Type: TEXT/x-diff; charset=US-ASCII; name=aiorace.diff
Content-Transfer-Encoding: BASE64
Content-ID: <20080307163238.A920@desktop>
Content-Description: 
Content-Disposition: attachment; filename=aiorace.diff

LS0tIGFpby5jLm9yaWcJMjAwOC0wMy0wOCAwMDoyMzo1MC4wMDAwMDAwMDAg
KzAwMDANCisrKyBhaW8uYwkyMDA4LTAzLTA4IDAwOjI0OjMyLjAwMDAwMDAw
MCArMDAwMA0KQEAgLTk0NiwxNCArOTQ2LDYgQEAgaW50IGZhc3RjYWxsIGFp
b19jb21wbGV0ZShzdHJ1Y3Qga2lvY2IgKg0KIAkJcmV0dXJuIDE7DQogCX0N
CiANCi0JLyoNCi0JICogQ2hlY2sgaWYgdGhlIHVzZXIgYXNrZWQgdXMgdG8g
ZGVsaXZlciB0aGUgcmVzdWx0IHRocm91Z2ggYW4NCi0JICogZXZlbnRmZC4g
VGhlIGV2ZW50ZmRfc2lnbmFsKCkgZnVuY3Rpb24gaXMgc2FmZSB0byBiZSBj
YWxsZWQNCi0JICogZnJvbSBJUlEgY29udGV4dC4NCi0JICovDQotCWlmICgh
SVNfRVJSKGlvY2ItPmtpX2V2ZW50ZmQpKQ0KLQkJZXZlbnRmZF9zaWduYWwo
aW9jYi0+a2lfZXZlbnRmZCwgMSk7DQotDQogCWluZm8gPSAmY3R4LT5yaW5n
X2luZm87DQogDQogCS8qIGFkZCBhIGNvbXBsZXRpb24gZXZlbnQgdG8gdGhl
IHJpbmcgYnVmZmVyLg0KQEAgLTEwMTAsNiArMTAwMiwxNSBAQCBwdXRfcnE6
DQogCQl3YWtlX3VwKCZjdHgtPndhaXQpOw0KIA0KIAlzcGluX3VubG9ja19p
cnFyZXN0b3JlKCZjdHgtPmN0eF9sb2NrLCBmbGFncyk7DQorDQorCS8qDQor
CSAqIENoZWNrIGlmIHRoZSB1c2VyIGFza2VkIHVzIHRvIGRlbGl2ZXIgdGhl
IHJlc3VsdCB0aHJvdWdoIGFuDQorCSAqIGV2ZW50ZmQuIFRoZSBldmVudGZk
X3NpZ25hbCgpIGZ1bmN0aW9uIGlzIHNhZmUgdG8gYmUgY2FsbGVkDQorCSAq
IGZyb20gSVJRIGNvbnRleHQuDQorCSAqLw0KKwlpZiAoIUlTX0VSUihpb2Ni
LT5raV9ldmVudGZkKSkNCisJCWV2ZW50ZmRfc2lnbmFsKGlvY2ItPmtpX2V2
ZW50ZmQsIDEpOw0KKw0KIAlyZXR1cm4gcmV0Ow0KIH0NCiANCg==

--2547152148-1254247870-1204943558=:920--
