Return-Path: <linux-kernel-owner+w=401wt.eu-S1755989AbXI1MIV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755989AbXI1MIV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 08:08:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXI1MIO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 08:08:14 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59065 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506AbXI1MIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 08:08:13 -0400
Message-ID: <46FCEE9A.5050806@bull.net>
Date: Fri, 28 Sep 2007 14:07:54 +0200
From: Laurent Vivier <Laurent.Vivier@bull.net>
Organization: Bull S.A.S.
User-Agent: Thunderbird 1.5.0.2 (X11/20060420)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Fengguang Wu <wfg@mail.ustc.edu.cn>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: WARNING: at arch/x86_64/kernel/smp.c:397 smp_call_function_mask()
References: <20070927022220.c76a7a6e.akpm@linux-foundation.org>	<390947257.08622@ustc.edu.cn>	<46FCC0B8.7090403@bull.net>	<20070928020950.bdcad2c2.akpm@linux-foundation.org>	<46FCC6F5.2030109@bull.net> <20070928023422.77be1e71.akpm@linux-foundation.org>
In-Reply-To: <20070928023422.77be1e71.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.0.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 14:14:12,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 28/09/2007 14:14:13,
	Serialize complete at 28/09/2007 14:14:13
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig47766A870C88F051C8EA561C"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig47766A870C88F051C8EA561C
Content-Type: multipart/mixed;
 boundary="------------080006050504030805060306"

This is a multi-part message in MIME format.
--------------080006050504030805060306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> On Fri, 28 Sep 2007 11:18:45 +0200 Laurent Vivier <Laurent.Vivier@bull.=
net> wrote:
>=20
>> Andrew Morton wrote:
>>> On Fri, 28 Sep 2007 10:52:08 +0200 Laurent Vivier <Laurent.Vivier@bul=
l.net> wrote:
>>>> Andi, is this correct ?
>>>> Andrew, should I send a patch implementing this change ?
>>> umm, I think all the smp_call_function fucntions are deadlocky if cal=
led
>>> with local interrupts disabled, regardless of whether the calling CPU=
 is in
>>> the mask.
>>>
>>> If CPU A is sending a cross-cpu call to CPU B and CPU B is sending a
>>> cross-cpu call to CPU A, and they both have local interrupts disabled=
=2E..
>> OK, so there are two errors:
>>
>> 1- one I introduce myself (without any help from anyone) where
>> smp_call_function() calls all online CPUs instead of calling all CPUs =
except itself.
>=20
> I'd be pretty surprised if one was able to write a bug like that.  You =
mean
> the CPU sends an IPI to itself and then loops around until it has servi=
ced
> that IPI?  And this works?  Wow.

In fact, it works because __smp_call_function_mask() makes :

 cpus_and(mask, mask, allbutself);

So it removes current cpu from the mask. BTW, I don't have to modify
smp_call_function(): it is correct as it is written (except from a semant=
ic
point of view... do we care about semantic ?).

> And on_each_cpu() can call the handler function twice?
>=20
> hm
>=20
>> 2- one in global_flush_tlb() which calls smp_call_function() with irqs=
 disabled.
>=20
> That would be a big bug, and surely we would already have picked it up.=

>=20
> <looks>
>=20
> argh, mainline's x86_64 smp_call_function() doesn't do the check.  We'v=
e
> had *heaps* of bugs in i386 where people were running smp_call_foo() un=
der
> local_irq_disable().  I wonder how many there are in x86_64?
>=20
>> I think I should at least correct #1 ?
>=20
> I think we should correct all bugs ;)
>=20

We don't live in a perfect world... ;-)

Moreover, I'm not able to reproduce #2 ...

Fengguang could you send me your .config and your qemu command line param=
eters ?

Laurent

PS: if semantic is important, you can apply attached patch...
--=20
------------- Laurent.Vivier@bull.net  --------------
          "Software is hard" - Donald Knuth

--------------080006050504030805060306
Content-Type: application/mbox;
 name="0001-smp_call_function-call-function-on-all-CPUs.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename*0="0001-smp_call_function-call-function-on-all-CPUs.patch"

QWNjb3JkaW5nIGNvbW1lbnQgb2Ygc21wX2NhbGxfZnVuY3Rpb24oKSwgCnNtcF9jYWxsX2Z1
bmN0aW9uKCkgInJ1biBhIGZ1bmN0aW9uIG9uIGFsbCBvdGhlciBDUFVzLiIsCm5vdCBvbiBh
bGwgb25saW5lIENQVXMuCgpTaWduZWQtb2ZmLWJ5OiBMYXVyZW50IFZpdmllciA8TGF1cmVu
dC5WaXZpZXJAYnVsbC5uZXQ+Ci0tLQogc21wLmMgfCAgICA3ICsrKysrKy0KIDEgZmlsZSBj
aGFuZ2VkLCA2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYgLS1naXQgYS9h
cmNoL3g4Nl82NC9rZXJuZWwvc21wLmMgYi9hcmNoL3g4Nl82NC9rZXJuZWwvc21wLmMKLS0t
IGEvYXJjaC94ODZfNjQva2VybmVsL3NtcC5jCisrKyBiL2FyY2gveDg2XzY0L2tlcm5lbC9z
bXAuYwpAQCAtNDU5LDcgKzQ1OSwxMiBAQCBFWFBPUlRfU1lNQk9MKHNtcF9jYWxsX2Z1bmN0
aW9uX3NpbmdsZSk7CiBpbnQgc21wX2NhbGxfZnVuY3Rpb24gKHZvaWQgKCpmdW5jKSAodm9p
ZCAqaW5mbyksIHZvaWQgKmluZm8sIGludCBub25hdG9taWMsCiAJCQlpbnQgd2FpdCkKIHsK
LQlyZXR1cm4gc21wX2NhbGxfZnVuY3Rpb25fbWFzayhjcHVfb25saW5lX21hcCwgZnVuYywg
aW5mbywgd2FpdCk7CisJY3B1bWFza190IGFsbGJ1dHNlbGY7CisKKwlhbGxidXRzZWxmID0g
Y3B1X29ubGluZV9tYXA7CisJY3B1X2NsZWFyKHNtcF9wcm9jZXNzb3JfaWQoKSwgYWxsYnV0
c2VsZik7CisKKwlyZXR1cm4gc21wX2NhbGxfZnVuY3Rpb25fbWFzayhhbGxidXRzZWxmLCBm
dW5jLCBpbmZvLCB3YWl0KTsKIH0KIEVYUE9SVF9TWU1CT0woc21wX2NhbGxfZnVuY3Rpb24p
OwogCg==
--------------080006050504030805060306--

--------------enig47766A870C88F051C8EA561C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.7 (GNU/Linux)

iD8DBQFG/O6d9Kffa9pFVzwRAqq6AJ41al1A3j1r/XAXARBGoQkAFmBAHgCfbYUp
FOtH4JqOuz5k3gie3LQzbN8=
=ZYsE
-----END PGP SIGNATURE-----

--------------enig47766A870C88F051C8EA561C--
