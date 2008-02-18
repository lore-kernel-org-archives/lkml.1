Return-Path: <linux-kernel-owner+w=401wt.eu-S1758751AbYBRI5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758751AbYBRI5T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 03:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755296AbYBRI5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 03:57:08 -0500
Received: from wx-out-0506.google.com ([66.249.82.225]:34598 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbYBRI5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 03:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=Td4pai8hMpv/vKncu+kPG4BAfNSXQw8v6vQvIyRh/IX839KuzWw+WrlU2L0B6oBJxdWW9LQsErZAvWaUXju/sXtrrFLg3IIs7+aBH9lkJDQh7hyqORn1SZtXNIVwm2g5ibdQrbMR1Q5fh41IpKQPmnSTqUlycZ4vGDkivMo8Eis=
Message-ID: <aec7e5c30802180057k76050c02wfe3790cf379f7d5f@mail.gmail.com>
Date: Mon, 18 Feb 2008 17:57:05 +0900
From: "Magnus Damm" <magnus.damm@gmail.com>
To: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
Subject: Re: Current git very broken on the Dreamcast
Cc: linux-sh@vger.kernel.org, "Paul Mundt" <lethal@users.sourceforge.net>,
       matsu@igel.co.jp, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1203191304.6737.5.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_2037_4515750.1203325025355"
References: <1203187080.6737.3.camel@localhost.localdomain>
	 <1203191304.6737.5.camel@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_2037_4515750.1203325025355
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Adrian,

[fixed up Matsubara-sans address]

On Feb 17, 2008 4:48 AM, Adrian McMenamin
<adrian@newgolddream.dyndns.info> wrote:
> On Sat, 2008-02-16 at 18:38 +0000, Adrian McMenamin wrote:
> > Will seek to bisect this, but I have just updated my sources to the
> > latest git and it is not booting at all on the Dreamcast.
> >
> > With early printk on, I get nothing more than this before an instant
> > reboot:
> >
> > [    0.000000] Linux version 2.6.25-rc2-10953-g52065cd
> > (adrian@bossclass) (gcc version 3.4.6) #511 PREEMPT Sat Feb 16 18:31:43
> > GMT 2008
> > [    0.000000] console [sercon0] enabled
> > [    0.000000] Booting machvec: Sega Dreamcast
>
>
> adrian@bossclass:~/gdrom-dev$ git bisect good
> e036eaa681a17f71b64f6d9040fe605555623919 is first bad commit
> commit e036eaa681a17f71b64f6d9040fe605555623919
> Author: Magnus Damm <magnus.damm@gmail.com>
> Date:   Thu Feb 14 13:52:43 2008 +0900
>
>     sh: use ctrl_in/out for on chip pci access
>
>     This patch makes sure ctrl_inN/outN are used instead of inN/outN for
> on chip
>     pci registers. Without this patch addresses may be adjusted using
> the value
>     in generic_io_base. This patch makes it possible to set
> generic_io_base and
>     have pci without reading and writing all over the place.
>
>     Signed-off-by: Magnus Damm <damm@igel.co.jp>
>     Acked-by: Katsuya MATSUBARA <matsu@igel.co.jp>
>     Signed-off-by: Paul Mundt <lethal@linux-sh.org>
>
> :040000 040000 17a9f8181301e3a082d8a1a2fdef9b13ff1185e4
> 87e4a2e912be56b0d12e8a92db9489d6615c31f7 M      arch

Thanks for tracking this down and sorry for breaking the dreamcast pci driver.

Most code for the dreamcast currently do direct register access using
ctrl_inN/outN or readN/writeN. Only a few places use inN/outN and
depend on the value of generic_io_base. Doing inN/outN is ok (but
outdated, use ioreadN/iowriteN instead) in a portable pci/isa driver,
but it doesn't make sense for any dreamcast specific code to rely on
generic_io_base. For the dreamcast we already know the address at
compile time so doing adjustment during runtime is just unnecessary
overhead.

It is of course possible to revert the dreamcast-specific bits of the
commit you pointed out, but I think the change for the dreamcast makes
sense since it makes the code both faster and more uniform.

However, at this point it is broken. Sorry about that. I just looked
through all upstream dreamcast-specific code I could find and irq.c is
now the only file that does inN/outN. I've attached a patch that makes
the irq code independent of generic_io_base. There is also another
patch attached that adjusts the addresses of the pci register.
Together they should solve the problem you are seeing. Please try them
on top of 2.6.25-rc2.

With these patches io ports count from 0 -> 8k-1 instead of being a
pointer. We currently rely on generic_io_base logic but that will be
changed in the future.

Please let me know the results. Thank you.

/ magnus

------=_Part_2037_4515750.1203325025355
Content-Type: application/octet-stream;
 name=linux-2.6.25-rc2-sh-dreamcast-irq-20080218.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcssax3n0
Content-Disposition: attachment;
 filename=linux-2.6.25-rc2-sh-dreamcast-irq-20080218.patch

LS0tIDAwMDEvYXJjaC9zaC9ib2FyZHMvZHJlYW1jYXN0L2lycS5jCisrKyB3b3JrL2FyY2gvc2gv
Ym9hcmRzL2RyZWFtY2FzdC9pcnEuYwkyMDA4LTAyLTE4IDE3OjAyOjA4LjAwMDAwMDAwMCArMDkw
MApAQCAtMTIsNiArMTIsNyBAQAogI2luY2x1ZGUgPGxpbnV4L2lycS5oPgogI2luY2x1ZGUgPGFz
bS9pby5oPgogI2luY2x1ZGUgPGFzbS9pcnEuaD4KKyNpbmNsdWRlIDxhc20vYWRkcnNwYWNlLmg+
CiAjaW5jbHVkZSA8YXNtL2RyZWFtY2FzdC9zeXNhc2ljLmg+CiAKIC8qIERyZWFtY2FzdCBTeXN0
ZW0gQVNJQyBIYXJkd2FyZSBFdmVudHMgLQpAQCAtNDAsOCArNDEsOCBAQAogCiAqLwogCi0jZGVm
aW5lIEVTUl9CQVNFIDB4MDA1ZjY5MDAgICAgLyogQmFzZSBldmVudCBzdGF0dXMgcmVnaXN0ZXIg
Ki8KLSNkZWZpbmUgRU1SX0JBU0UgMHgwMDVmNjkxMCAgICAvKiBCYXNlIGV2ZW50IG1hc2sgcmVn
aXN0ZXIgKi8KKyNkZWZpbmUgRVNSX0JBU0UgUDJTRUdBRERSKDB4MDA1ZjY5MDApICAgIC8qIEJh
c2UgZXZlbnQgc3RhdHVzIHJlZ2lzdGVyICovCisjZGVmaW5lIEVNUl9CQVNFIFAyU0VHQUREUigw
eDAwNWY2OTEwKSAgICAvKiBCYXNlIGV2ZW50IG1hc2sgcmVnaXN0ZXIgKi8KIAogLyogSGVscHMg
dXMgZGV0ZXJtaW5lIHRoZSBFTVIgZ3JvdXAgdGhhdCB0aGlzIGV2ZW50IGJlbG9uZ3MgdG86IDAg
PSAweDY5MTAsCiAgICAxID0gMHg2OTIwLCAyID0gMHg2OTMwOyBhbHNvIGRldGVybWluZSB0aGUg
ZXZlbnQgb2Zmc2V0ICovCkBAIC01OSw5ICs2MCw5IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBkaXNh
YmxlX3N5c3RlbWFzaWNfaXIKICAgICAgICAgX191MzIgZW1yID0gRU1SX0JBU0UgKyAoTEVWRUwo
aXJxKSA8PCA0KSArIChMRVZFTChpcnEpIDw8IDIpOwogICAgICAgICBfX3UzMiBtYXNrOwogCi0g
ICAgICAgIG1hc2sgPSBpbmwoZW1yKTsKKyAgICAgICAgbWFzayA9IGN0cmxfaW5sKGVtcik7CiAg
ICAgICAgIG1hc2sgJj0gfigxIDw8IEVWRU5UX0JJVChpcnEpKTsKLSAgICAgICAgb3V0bChtYXNr
LCBlbXIpOworICAgICAgICBjdHJsX291dGwobWFzaywgZW1yKTsKIH0KIAogLyogRW5hYmxlIHRo
ZSBoYXJkd2FyZSBldmVudCBieSBzZXR0aW5nIGl0cyBiaXQgaW4gaXRzIEVNUiAqLwpAQCAtNzAs
OSArNzEsOSBAQCBzdGF0aWMgaW5saW5lIHZvaWQgZW5hYmxlX3N5c3RlbWFzaWNfaXJxCiAgICAg
ICAgIF9fdTMyIGVtciA9IEVNUl9CQVNFICsgKExFVkVMKGlycSkgPDwgNCkgKyAoTEVWRUwoaXJx
KSA8PCAyKTsKICAgICAgICAgX191MzIgbWFzazsKIAotICAgICAgICBtYXNrID0gaW5sKGVtcik7
CisgICAgICAgIG1hc2sgPSBjdHJsX2lubChlbXIpOwogICAgICAgICBtYXNrIHw9ICgxIDw8IEVW
RU5UX0JJVChpcnEpKTsKLSAgICAgICAgb3V0bChtYXNrLCBlbXIpOworICAgICAgICBjdHJsX291
dGwobWFzaywgZW1yKTsKIH0KIAogLyogQWNrbm93bGVkZ2UgYSBoYXJkd2FyZSBldmVudCBieSB3
cml0aW5nIGl0cyBiaXQgYmFjayB0byBpdHMgRVNSICovCkBAIC04MCw3ICs4MSw3IEBAIHN0YXRp
YyB2b2lkIGFja19zeXN0ZW1hc2ljX2lycSh1bnNpZ25lZCAKIHsKICAgICAgICAgX191MzIgZXNy
ID0gRVNSX0JBU0UgKyAoTEVWRUwoaXJxKSA8PCAyKTsKICAgICAgICAgZGlzYWJsZV9zeXN0ZW1h
c2ljX2lycShpcnEpOwotICAgICAgICBvdXRsKCgxIDw8IEVWRU5UX0JJVChpcnEpKSwgZXNyKTsK
KyAgICAgICAgY3RybF9vdXRsKCgxIDw8IEVWRU5UX0JJVChpcnEpKSwgZXNyKTsKIH0KIAogLyog
QWZ0ZXIgYSBJUlEgaGFzIGJlZW4gYWNrJ2QgYW5kIHJlc3BvbmRlZCB0bywgaXQgbmVlZHMgdG8g
YmUgcmVuYWJsZWQgKi8KQEAgLTEzNyw4ICsxMzgsOCBAQCBpbnQgc3lzdGVtYXNpY19pcnFfZGVt
dXgoaW50IGlycSkKICAgICAgICAgZXNyID0gRVNSX0JBU0UgKyAobGV2ZWwgPDwgMik7CiAKICAg
ICAgICAgLyogTWFzayB0aGUgRVNSIHRvIGZpbHRlciBhbnkgc3B1cmlvdXMsIHVud2FudGVkIGlu
dGVycnVwdHMgKi8KLSAgICAgICAgc3RhdHVzID0gaW5sKGVzcik7Ci0gICAgICAgIHN0YXR1cyAm
PSBpbmwoZW1yKTsKKyAgICAgICAgc3RhdHVzID0gY3RybF9pbmwoZXNyKTsKKyAgICAgICAgc3Rh
dHVzICY9IGN0cmxfaW5sKGVtcik7CiAKICAgICAgICAgLyogTm93IHNjYW4gYW5kIGZpbmQgdGhl
IGZpcnN0IHNldCBiaXQgYXMgdGhlIGV2ZW50IHRvIG1hcCAqLwogICAgICAgICBmb3IgKGJpdCA9
IDEsIGogPSAwOyBqIDwgMzI7IGJpdCA8PD0gMSwgaisrKSB7Cg==
------=_Part_2037_4515750.1203325025355
Content-Type: application/octet-stream;
 name=linux-2.6.25-rc2-sh-dreamcast-pci-20080218b.patch
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fcsseaa71
Content-Disposition: attachment;
 filename=linux-2.6.25-rc2-sh-dreamcast-pci-20080218b.patch

LS0tIDAwMDEvYXJjaC9zaC9ib2FyZHMvZHJlYW1jYXN0L3NldHVwLmMKKysrIHdvcmsvYXJjaC9z
aC9ib2FyZHMvZHJlYW1jYXN0L3NldHVwLmMJMjAwOC0wMi0xOCAxNzowNTo0NS4wMDAwMDAwMDAg
KzA5MDAKQEAgLTQzLDggKzQzLDYgQEAgc3RhdGljIHZvaWQgX19pbml0IGRyZWFtY2FzdF9zZXR1
cChjaGFyIAogCS8qIEFja25vd2xlZGdlIGFueSBwcmV2aW91cyBldmVudHMgKi8KIAkvKiBYWFgg
Ki8KIAotCV9fc2V0X2lvX3BvcnRfYmFzZSgweGEwMDAwMDAwKTsKLQogCS8qIEFzc2lnbiBhbGwg
dmlydHVhbCBJUlFzIHRvIHRoZSBTeXN0ZW0gQVNJQyBpbnQuIGhhbmRsZXIgKi8KIAlmb3IgKGkg
PSBIV19FVkVOVF9JUlFfQkFTRTsgaSA8IEhXX0VWRU5UX0lSUV9NQVg7IGkrKykKIAkJaXJxX2Rl
c2NbaV0uY2hpcCA9ICZzeXN0ZW1hc2ljX2ludDsKLS0tIDAwMDEvYXJjaC9zaC9kcml2ZXJzL3Bj
aS9vcHMtZHJlYW1jYXN0LmMKKysrIHdvcmsvYXJjaC9zaC9kcml2ZXJzL3BjaS9vcHMtZHJlYW1j
YXN0LmMJMjAwOC0wMi0xOCAxNzowNjoxOS4wMDAwMDAwMDAgKzA5MDAKQEAgLTI5LDggKzI5LDgg
QEAKIAogc3RhdGljIHN0cnVjdCByZXNvdXJjZSBnYXBzcGNpX2lvX3Jlc291cmNlID0gewogCS5u
YW1lCT0gIkdBUFNQQ0kgSU8iLAotCS5zdGFydAk9IEdBUFNQQ0lfQkJBX0NPTkZJRywKLQkuZW5k
CT0gR0FQU1BDSV9CQkFfQ09ORklHICsgR0FQU1BDSV9CQkFfQ09ORklHX1NJWkUgLSAxLAorCS5z
dGFydAk9IDAsCisJLmVuZAk9IEdBUFNQQ0lfQkJBX0NPTkZJR19TSVpFIC0gMSwKIAkuZmxhZ3MJ
PSBJT1JFU09VUkNFX0lPLAogfTsKIApAQCAtMTU4LDYgKzE1OCw4IEBAIGludCBfX2luaXQgZ2Fw
c3BjaV9pbml0KHZvaWQpCiAJY3RybF9vdXRsKDB4MDAwMDIwMDEsIEdBUFNQQ0lfQkJBX0NPTkZJ
RysweDEwKTsKIAljdHJsX291dGwoMHgwMTAwMDAwMCwgR0FQU1BDSV9CQkFfQ09ORklHKzB4MTQp
OwogCisJX19zZXRfaW9fcG9ydF9iYXNlKEdBUFNQQ0lfQkJBX0NPTkZJRyk7CisKIAlyZXR1cm4g
MDsKIH0KIAotLS0gMDAwMS9pbmNsdWRlL2FzbS1zaC9kcmVhbWNhc3QvcGNpLmgKKysrIHdvcmsv
aW5jbHVkZS9hc20tc2gvZHJlYW1jYXN0L3BjaS5oCTIwMDgtMDItMTggMTc6MTg6MTAuMDAwMDAw
MDAwICswOTAwCkBAIC0xMSwxMiArMTEsMTMgQEAKICNpZm5kZWYgX19BU01fU0hfRFJFQU1DQVNU
X1BDSV9ICiAjZGVmaW5lIF9fQVNNX1NIX0RSRUFNQ0FTVF9QQ0lfSAogCisjaW5jbHVkZSA8YXNt
L2FkZHJzcGFjZS5oPgogI2luY2x1ZGUgPGFzbS9tYWNoL3N5c2FzaWMuaD4KIAotI2RlZmluZQlH
QVBTUENJX1JFR1MJCTB4MDEwMDE0MDAKLSNkZWZpbmUgR0FQU1BDSV9ETUFfQkFTRQkweDAxODQw
MDAwCisjZGVmaW5lIEdBUFNQQ0lfUkVHUwkJUDJTRUdBRERSKDB4MDEwMDE0MDApCisjZGVmaW5l
IEdBUFNQQ0lfRE1BX0JBU0UJUDJTRUdBRERSKDB4MDE4NDAwMDApCiAjZGVmaW5lIEdBUFNQQ0lf
RE1BX1NJWkUJMzI3NjgKLSNkZWZpbmUgR0FQU1BDSV9CQkFfQ09ORklHCTB4MDEwMDE2MDAKKyNk
ZWZpbmUgR0FQU1BDSV9CQkFfQ09ORklHCVAyU0VHQUREUigweDAxMDAxNjAwKQogI2RlZmluZSBH
QVBTUENJX0JCQV9DT05GSUdfU0laRQkweDIwMDAKIAogI2RlZmluZQlHQVBTUENJX0lSUQkJSFdf
RVZFTlRfRVhURVJOQUwK
------=_Part_2037_4515750.1203325025355--
