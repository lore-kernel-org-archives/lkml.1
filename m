Return-Path: <linux-kernel-owner+w=401wt.eu-S1759947AbXLQSQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947AbXLQSQ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 13:16:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbXLQSQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 13:16:18 -0500
Received: from spirit.analogic.com ([204.178.40.4]:2891 "EHLO
	spirit.analogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbXLQSQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 13:16:17 -0500
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C840D8.BD1D8080"
X-MimeOLE: Produced By Microsoft Exchange V6.5
X-OriginalArrivalTime: 17 Dec 2007 18:15:01.0053 (UTC) FILETIME=[BD2596D0:01C840D8]
Content-class: urn:content-classes:message
Subject: Re: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some AMD64x2 laptops, etc.
Date: Mon, 17 Dec 2007 13:14:51 -0500
Message-ID: <Pine.LNX.4.61.0712171307150.4584@chaos.analogic.com>
in-reply-to: <4763385E.9040106@reed.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] x86_64: fix problems due to use of "outb" to port 80 on some AMD64x2 laptops, etc.
thread-index: AchA2L0vR89leYCWTiG+eEZPCkrhzQ==
References: <466F0941.9060201@reed.com> <1181682498.8176.224.camel@chaos>  <469578CD.3080609@reed.com>  <1184216528.12353.203.camel@chaos>  <1184218962.12353.209.camel@chaos>  <46964352.7040301@reed.com>  <1184253339.12353.223.camel@chaos>  <469697C6.50903@reed.com> <1184274754.12353.254.camel@chaos> <4761F193.7090400@reed.com> <4762AA68.9030507@qumranet.com> <4763385E.9040106@reed.com>
From: "linux-os (Dick Johnson)" <linux-os@analogic.com>
To: "David P. Reed" <dpreed@reed.com>
Cc: "Avi Kivity" <avi@qumranet.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Linux kernel" <linux-kernel@vger.kernel.org>,
       "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       "Rene Herman" <rene.herman@keyaccess.nl>, "Pavel Machek" <pavel@ucw.cz>,
       "kvm-devel" <kvm-devel@lists.sourceforge.net>
Reply-To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C840D8.BD1D8080
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable


On Fri, 14 Dec 2007, David P. Reed wrote:

> Avi Kivity wrote:
>> kvm will forward a virtual machine's writes to port 0x80 to the real
>> port.  The reason is that the write is much faster than exiting and
>> emulating it; the difference is measurable when compiling kernels.
>>
>> Now if the cause is simply writing to port 0x80, then we must stop
>> doing that.  But if the reason is the back-to-back writes, when we can
>> keep it, since the other writes will be trapped by kvm and emulated.
>> Do you which is the case?
>>
> As for kvm, I don't have enough info to know anything about that.  Is
> there a test you'd like me to try?
>
> I think you are also asking if the crash on these laptops is caused only
> by back-to-back writes.  Actually, it doesn't seem to matter if they are
> back to back.  I can cause the crash if the writes to 80 are very much
> spread out in time - it seems only to matter how many of them get
> executed - almost as if there is a buffer overflow.  (And of course if
> you do back to back writes to other ports that are apparently fully
> unused, such as 0xED on my machine, no crash occurs).
>
> I believe (though no one seems to have confirming documentation from the
> chipset or motherboard vendor) that port 80 is actually functional for
> some unknown function on these machines.   (They do respond to "in"
> instructions faster than a bus cycle abort does - more evidence).
>
> I searched the DSDT to see if there is any evidence of an ACPI use for
> this port, but found nothing.
>
>

Attached is a patch that changes the outs to ins on port 0x80.
I did NOT let gcc decide what to do about modified registers.
Instead, the code saves/restores EAX itself so that all of the
times (whatever they are) are the same.

The code works and is running here. I also patched a very early
version (2.4.26) running on  a 400 MHz i486 with an real ISA
bus (Adaptec AHA1453). It works too.

David, will you please try it on your machine. Maybe reading
from the port is less harmful than writing.


Cheers,
Dick Johnson
Penguin : Linux version 2.6.22.1 on an i686 machine (5588.27 BogoMips).
My book : http://www.AbominableFirebug.com/
_


****************************************************************
The information transmitted in this message is confidential and may be=
 privileged.  Any review, retransmission, dissemination, or other use of=
 this information by persons or entities other than the intended recipient=
 is prohibited.  If you are not the intended recipient, please notify=
 Analogic Corporation immediately - by replying to this message or by=
 sending an email to DeliveryErrors@analogic.com - and destroy all copies=
 of this information, including any attachments, without reading or=
 disclosing them.

Thank you.
------_=_NextPart_001_01C840D8.BD1D8080
Content-Type: TEXT/PLAIN;
	name="io.h.patch"
Content-Transfer-Encoding: base64
Content-Description: io.h.patch
Content-Disposition: attachment;
	filename="io.h.patch"

LS0tIGxpbnV4LTIuNi4yMi4xL2luY2x1ZGUvYXNtLWkzODYvaW8uaC5vcmlnCTIwMDctMDctMTAg
MTQ6NTY6MzAuMDAwMDAwMDAwIC0wNDAwDQorKysgbGludXgtMi42LjIyLjEvaW5jbHVkZS9hc20t
aTM4Ni9pby5oCTIwMDctMTItMTcgMTI6MDY6MTAuMDAwMDAwMDAwIC0wNTAwDQpAQCAtMjUyLDcg
KzI1MiwxMCBAQA0KIA0KIHN0YXRpYyBpbmxpbmUgdm9pZCBuYXRpdmVfaW9fZGVsYXkodm9pZCkN
CiB7DQotCWFzbSB2b2xhdGlsZSgib3V0YiAlJWFsLCQweDgwIiA6IDogOiAibWVtb3J5Iik7DQor
CWFzbSB2b2xhdGlsZSgJInB1c2hsICUlZWF4XG5cdCINCisJCQkiaW5iICQweDgwLCAlJWFsXG5c
dCINCisJCQkicG9wbCAlJWVheFxuXHQiDQorCQkJIDogOiA6ICJtZW1vcnkiKTsNCiB9DQogDQog
I2lmIGRlZmluZWQoQ09ORklHX1BBUkFWSVJUKQ0K

------_=_NextPart_001_01C840D8.BD1D8080--

