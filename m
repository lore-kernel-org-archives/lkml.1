Return-Path: <linux-kernel-owner+w=401wt.eu-S932921AbZKZGrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932921AbZKZGrM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 01:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758544AbZKZGrM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 01:47:12 -0500
Received: from mail-yx0-f188.google.com ([209.85.210.188]:63812 "EHLO
	mail-yx0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426AbZKZGrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 01:47:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=a/O1TB+bTKCdpkJvYDGTXf85kZvW867f//4W/gM6EEfIymtEWyeh+IdSFNsRSvqldL
         sQh/Iw+W/bsSI6i4hrN4lLZLvF4klUGUaPrQMFWG9Cd517iVIN8VrbkhF0uh8ug2PjsD
         HW1YdjLGliEi+bhmOsnfUodsfaN8AYMeaFV+w=
MIME-Version: 1.0
In-Reply-To: <fa686aa40911251415q624f3610n92cbc20437b12bf6@mail.gmail.com>
References: <20091125082603.25618.57438.sendpatchset@rxone.opensource.se>
	 <fa686aa40911251415q624f3610n92cbc20437b12bf6@mail.gmail.com>
Date: Thu, 26 Nov 2009 15:47:17 +0900
Message-ID: <aec7e5c30911252247i344f5bf3pb0240b9c23878bf5@mail.gmail.com>
Subject: Re: [PATCH] spi: Allow using spi_bitbang_setup() with custom 
	txrx_bufs()
From: Magnus Damm <magnus.damm@gmail.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: spi-devel-general@lists.sourceforge.net, dbrownell@users.sourceforge.net,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Content-Type: multipart/mixed; boundary=0016e6409812cbc8820479408b03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e6409812cbc8820479408b03
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Thu, Nov 26, 2009 at 7:15 AM, Grant Likely <grant.likely@secretlab.ca> w=
rote:
> On Wed, Nov 25, 2009 at 1:26 AM, Magnus Damm <magnus.damm@gmail.com> wrot=
e:
>> This patch modifies the shared spi bitbanging code
>> to allow using spi_bitbang_setup() even though the
>> txrx_word[] callbacks are unset. Useful for drivers
>> that want to make use of spi_bitbang_setup() but
>> have their own txrx_bufs() callback.

>> @@ -196,9 +205,11 @@ int spi_bitbang_setup(struct spi_device
>> =A0 =A0 =A0 =A0}
>>
>> =A0 =A0 =A0 =A0/* per-word shift register access, in hardware or bitbang=
ing */
>> - =A0 =A0 =A0 cs->txrx_word =3D bitbang->txrx_word[spi->mode & (SPI_CPOL=
|SPI_CPHA)];
>> - =A0 =A0 =A0 if (!cs->txrx_word)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 if (bitbang->txrx_bufs =3D=3D spi_bitbang_bufs) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cs->txrx_word =3D bitbang->txrx_word[spi->=
mode & mode_mask];
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!cs->txrx_word)
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
>> + =A0 =A0 =A0 }
>
> Hmmm... this smells like an ugly hack to me. =A0It seems to me that if
> some bitbang backend drivers don't want this code, then it should be
> encoded into a callback so it can be overridden. =A0Thoughts.

Yeah, it's far from clean. I want to make use of spi_bitbang_setup()
in my MSIOF driver, but I want to avoid dummy txtx_word[] callbacks
that will be unused since i'm using a driver specific
bitbang->txrx_bufs function.

I guess the attached patch is slightly cleaner? I like the idea of
letting bitbang drivers use shared code for
spi_bitbang_setup()/spi_bitbang_cleanup() with their private
setup_transfer() function which in turn calls
spi_bitbang_setup_transfer(). My impression is that there's quite a
bit of duplicated setup()/cleanup() code.

/ magnus

--0016e6409812cbc8820479408b03
Content-Type: application/octet-stream; 
	name="linux-2.6.33-pre-spi-word-mode-setup-20091126.patch"
Content-Disposition: attachment; 
	filename="linux-2.6.33-pre-spi-word-mode-setup-20091126.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_g2h5itpk0

RnJvbTogTWFnbnVzIERhbW0gPGRhbW1Ab3BlbnNvdXJjZS5zZT4KClNpZ25lZC1vZmYtYnk6IE1h
Z251cyBEYW1tIDxkYW1tQG9wZW5zb3VyY2Uuc2U+Ci0tLQoKIGRyaXZlcnMvc3BpL3NwaV9iaXRi
YW5nLmMgICAgICAgfCAgIDM3ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0K
IGRyaXZlcnMvc3BpL3NwaV9ncGlvLmMgICAgICAgICAgfCAgICAyICstCiBpbmNsdWRlL2xpbnV4
L3NwaS9zcGlfYml0YmFuZy5oIHwgICAgMSArCiAzIGZpbGVzIGNoYW5nZWQsIDMyIGluc2VydGlv
bnMoKyksIDggZGVsZXRpb25zKC0pCgotLS0gMDAwMS9kcml2ZXJzL3NwaS9zcGlfYml0YmFuZy5j
CisrKyB3b3JrL2RyaXZlcnMvc3BpL3NwaV9iaXRiYW5nLmMJMjAwOS0xMS0yNiAxNDo1OTo1My4w
MDAwMDAwMDAgKzA5MDAKQEAgLTE3Nyw3ICsxNzcsNyBAQCBpbnQgc3BpX2JpdGJhbmdfc2V0dXBf
dHJhbnNmZXIoc3RydWN0IHNwCiBFWFBPUlRfU1lNQk9MX0dQTChzcGlfYml0YmFuZ19zZXR1cF90
cmFuc2Zlcik7CiAKIC8qKgotICogc3BpX2JpdGJhbmdfc2V0dXAgLSBkZWZhdWx0IHNldHVwIGZv
ciBwZXItd29yZCBJL08gbG9vcHMKKyAqIHNwaV9iaXRiYW5nX3NldHVwIC0gc2V0dXAgZnVuY3Rp
b24gd2hlbiBiaXRiYW5nLT50eHJ4X3dvcmRbXSBhcmUgdW51c2VkCiAgKi8KIGludCBzcGlfYml0
YmFuZ19zZXR1cChzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpKQogewpAQCAtMTk1LDExICsxOTUsNiBA
QCBpbnQgc3BpX2JpdGJhbmdfc2V0dXAoc3RydWN0IHNwaV9kZXZpY2UgCiAJCXNwaS0+Y29udHJv
bGxlcl9zdGF0ZSA9IGNzOwogCX0KIAotCS8qIHBlci13b3JkIHNoaWZ0IHJlZ2lzdGVyIGFjY2Vz
cywgaW4gaGFyZHdhcmUgb3IgYml0YmFuZ2luZyAqLwotCWNzLT50eHJ4X3dvcmQgPSBiaXRiYW5n
LT50eHJ4X3dvcmRbc3BpLT5tb2RlICYgKFNQSV9DUE9MfFNQSV9DUEhBKV07Ci0JaWYgKCFjcy0+
dHhyeF93b3JkKQotCQlyZXR1cm4gLUVJTlZBTDsKLQogCXJldHZhbCA9IGJpdGJhbmctPnNldHVw
X3RyYW5zZmVyKHNwaSwgTlVMTCk7CiAJaWYgKHJldHZhbCA8IDApCiAJCXJldHVybiByZXR2YWw7
CkBAIC0yMjQsNiArMjE5LDMyIEBAIGludCBzcGlfYml0YmFuZ19zZXR1cChzdHJ1Y3Qgc3BpX2Rl
dmljZSAKIEVYUE9SVF9TWU1CT0xfR1BMKHNwaV9iaXRiYW5nX3NldHVwKTsKIAogLyoqCisgKiBz
cGlfYml0YmFuZ19zZXR1cF93b3JkX21vZGUgLSBkZWZhdWx0IHNldHVwIGZvciBwZXItd29yZCBJ
L08gbG9vcHMKKyAqLworaW50IHNwaV9iaXRiYW5nX3NldHVwX3dvcmRfbW9kZShzdHJ1Y3Qgc3Bp
X2RldmljZSAqc3BpKQoreworCXN0cnVjdCBzcGlfYml0YmFuZ19jcwkqY3M7CisJc3RydWN0IHNw
aV9iaXRiYW5nCSpiaXRiYW5nOworCXZvaWQJCQkqdHhyeF93b3JkOworCWludAkJCXJldHZhbDsK
KworCWJpdGJhbmcgPSBzcGlfbWFzdGVyX2dldF9kZXZkYXRhKHNwaS0+bWFzdGVyKTsKKworCS8q
IHBlci13b3JkIHNoaWZ0IHJlZ2lzdGVyIGFjY2VzcywgaW4gaGFyZHdhcmUgb3IgYml0YmFuZ2lu
ZyAqLworCXR4cnhfd29yZCA9IGJpdGJhbmctPnR4cnhfd29yZFtzcGktPm1vZGUgJiAoU1BJX0NQ
T0wgfCBTUElfQ1BIQSldOworCWlmICghdHhyeF93b3JkKQorCQlyZXR1cm4gLUVJTlZBTDsKKwor
CXJldHZhbCA9IHNwaV9iaXRiYW5nX3NldHVwKHNwaSk7CisJaWYgKCFyZXR2YWwpIHsKKwkJY3Mg
PSBzcGktPmNvbnRyb2xsZXJfc3RhdGU7CisJCWNzLT50eHJ4X3dvcmQgPSB0eHJ4X3dvcmQ7CisJ
fQorCXJldHVybiByZXR2YWw7Cit9CitFWFBPUlRfU1lNQk9MX0dQTChzcGlfYml0YmFuZ19zZXR1
cF93b3JkX21vZGUpOworCisvKioKICAqIHNwaV9iaXRiYW5nX2NsZWFudXAgLSBkZWZhdWx0IGNs
ZWFudXAgZm9yIHBlci13b3JkIEkvTyBsb29wcwogICovCiB2b2lkIHNwaV9iaXRiYW5nX2NsZWFu
dXAoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSkKQEAgLTQ1NSw2ICs0NzYsOCBAQCBpbnQgc3BpX2Jp
dGJhbmdfc3RhcnQoc3RydWN0IHNwaV9iaXRiYW5nCiAKIAlpZiAoIWJpdGJhbmctPm1hc3Rlci0+
dHJhbnNmZXIpCiAJCWJpdGJhbmctPm1hc3Rlci0+dHJhbnNmZXIgPSBzcGlfYml0YmFuZ190cmFu
c2ZlcjsKKworCS8qICJ3b3JkIG1vZGUiIHdoZW4gc3BpX2JpdGJhbmdfYnVmcygpIGFyZSB1c2Vk
ICovCiAJaWYgKCFiaXRiYW5nLT50eHJ4X2J1ZnMpIHsKIAkJYml0YmFuZy0+dXNlX2RtYSA9IDA7
CiAJCWJpdGJhbmctPnR4cnhfYnVmcyA9IHNwaV9iaXRiYW5nX2J1ZnM7CkBAIC00NjIsNyArNDg1
LDcgQEAgaW50IHNwaV9iaXRiYW5nX3N0YXJ0KHN0cnVjdCBzcGlfYml0YmFuZwogCQkJaWYgKCFi
aXRiYW5nLT5zZXR1cF90cmFuc2ZlcikKIAkJCQliaXRiYW5nLT5zZXR1cF90cmFuc2ZlciA9CiAJ
CQkJCSBzcGlfYml0YmFuZ19zZXR1cF90cmFuc2ZlcjsKLQkJCWJpdGJhbmctPm1hc3Rlci0+c2V0
dXAgPSBzcGlfYml0YmFuZ19zZXR1cDsKKwkJCWJpdGJhbmctPm1hc3Rlci0+c2V0dXAgPSBzcGlf
Yml0YmFuZ19zZXR1cF93b3JkX21vZGU7CiAJCQliaXRiYW5nLT5tYXN0ZXItPmNsZWFudXAgPSBz
cGlfYml0YmFuZ19jbGVhbnVwOwogCQl9CiAJfSBlbHNlIGlmICghYml0YmFuZy0+bWFzdGVyLT5z
ZXR1cCkKLS0tIDAwMDEvZHJpdmVycy9zcGkvc3BpX2dwaW8uYworKysgd29yay9kcml2ZXJzL3Nw
aS9zcGlfZ3Bpby5jCTIwMDktMTEtMjYgMTQ6NTM6MzcuMDAwMDAwMDAwICswOTAwCkBAIC0yMDEs
NyArMjAxLDcgQEAgc3RhdGljIGludCBzcGlfZ3Bpb19zZXR1cChzdHJ1Y3Qgc3BpX2RldgogCQl9
CiAJfQogCWlmICghc3RhdHVzKQotCQlzdGF0dXMgPSBzcGlfYml0YmFuZ19zZXR1cChzcGkpOwor
CQlzdGF0dXMgPSBzcGlfYml0YmFuZ19zZXR1cF93b3JkX21vZGUoc3BpKTsKIAlpZiAoc3RhdHVz
KSB7CiAJCWlmICghc3BpLT5jb250cm9sbGVyX3N0YXRlICYmIGNzICE9IFNQSV9HUElPX05PX0NI
SVBTRUxFQ1QpCiAJCQlncGlvX2ZyZWUoY3MpOwotLS0gMDAwMS9pbmNsdWRlL2xpbnV4L3NwaS9z
cGlfYml0YmFuZy5oCisrKyB3b3JrL2luY2x1ZGUvbGludXgvc3BpL3NwaV9iaXRiYW5nLmgJMjAw
OS0xMS0yNiAxNDo1NDowOC4wMDAwMDAwMDAgKzA5MDAKQEAgLTU4LDYgKzU4LDcgQEAgc3RydWN0
IHNwaV9iaXRiYW5nIHsKICAqIG1ldGhvZHMsIGlmIHlvdSBsaWtlLgogICovCiBleHRlcm4gaW50
IHNwaV9iaXRiYW5nX3NldHVwKHN0cnVjdCBzcGlfZGV2aWNlICpzcGkpOworZXh0ZXJuIGludCBz
cGlfYml0YmFuZ19zZXR1cF93b3JkX21vZGUoc3RydWN0IHNwaV9kZXZpY2UgKnNwaSk7CiBleHRl
cm4gdm9pZCBzcGlfYml0YmFuZ19jbGVhbnVwKHN0cnVjdCBzcGlfZGV2aWNlICpzcGkpOwogZXh0
ZXJuIGludCBzcGlfYml0YmFuZ190cmFuc2ZlcihzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpLCBzdHJ1
Y3Qgc3BpX21lc3NhZ2UgKm0pOwogZXh0ZXJuIGludCBzcGlfYml0YmFuZ19zZXR1cF90cmFuc2Zl
cihzdHJ1Y3Qgc3BpX2RldmljZSAqc3BpLAo=
--0016e6409812cbc8820479408b03--
