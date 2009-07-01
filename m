Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbZGAODW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbZGAODW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 10:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752704AbZGAODK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 10:03:10 -0400
Received: from smtp-out.google.com ([216.239.45.13]:42552 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529AbZGAODI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 10:03:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=qliebZRZknGQfEFlGaHMeVTwhc6v78iIz6fN0BBQ4lNOgGWkUiWIp2jIQ2oXabU7c
	KhkBvqDZqFuqd3p8QQ2uw==
MIME-Version: 1.0
In-Reply-To: <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
References: <20cbb9450906112259m176153c9ucfa7a4d14642949f@mail.gmail.com>
	 <1244817141.3401.7.camel@dyn9002018117.watson.ibm.com>
	 <4A3474BD.4000804@linux.vnet.ibm.com>
	 <b8394ab90906140015h793aaf51rb9b105910e61fa1@mail.gmail.com>
Date: Wed, 1 Jul 2009 23:03:06 +0900
Message-ID: <b8394ab90907010703u7cf887cfs206fd24adf4e3872@mail.gmail.com>
Subject: Fwd: [tpmdd-devel] TPM drivers support and Linux Integrity Module for 
	2.6.30
From: =?UTF-8?B?ZGRzICjimJUp?= <dds@google.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: seiji.munetoh@gmail.com, tpmdd-devel@lists.sourceforge.net,
       Mimi Zohar <zohar@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Shahbaz Khan <shaz.linux@gmail.com>
Content-Type: multipart/mixed; boundary=000e0cd14690ee20a7046da561dd
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd14690ee20a7046da561dd
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Rajiv. I'm resending this since it is not in the archives (my bad).


---------- Forwarded message ----------
From: dds (=E2=98=95) <dds@google.com>
Date: Sun, Jun 14, 2009 at 4:15 PM
Subject: Re: [tpmdd-devel] TPM drivers support and Linux Integrity
Module for 2.6.30
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
tpmdd-devel@lists.sourceforge.net, linux-kernel
<linux-kernel@vger.kernel.org>, Shahbaz Khan <shaz.linux@gmail.com>


Hello, I'd been meaning to write about this.


On Sun, Jun 14, 2009 at 12:55 PM, Rajiv Andrade
<srajiv@linux.vnet.ibm.com> wrote:
>
> Hi Mimi, thanks for copying us.
>
> Shaz,
>
> If this is the same chip we find in the GM45 boards, iTPM, the upstream
> driver won't work properly with it.
> Mainly because this iTPM returns the wrong status code when the driver
> didn't finish sending all bytes required for a specific command.
> As suggested by Seiji Munetoh in the tpmdd-devel sf mailing list, you
> can modify line 263 of tpm_tis.c as below:
>
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((status & TPM_STS_=
DATA_EXPECT) =3D=3D 0) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if ((status & TPM_STS_=
VALID) =3D=3D 0) {
>

This isn't unreasonable. In the block that should be executing there,
it's proper to check both, since VALID is an override for DATA_EXPECT.
See first patch.

>
> Then, after compiling it, since it also seems to not support PNP, load
> it with force option on:
>
> modprobe tpm_tis force=3D1

The problem here is acpi pnp but the fix is really simple. The current
pnpacpi/core.c routine that looks for isapnp devices enumerated in
acpi enforces that the acpi hid be a valid isapnp id (the formats are
slightly different). But that's broken: it shoudl be enforcing that
either the acpi hid or any acpi cids be valid isapnp ids. It's a
one-line change to do this, see patch 2.


>
> If modprobe fails the first time, try the second and then it will work.

This is fixed by changing the order in the code of setting default
timeouts and requesting locality. See patch 3.

>
> I'm going to submit a patch to make the upstream driver work with it,
> making this line depend on a module param too..
>
> Thanks,
> Rajiv
>
> Mimi Zohar wrote:
> > On Fri, 2009-06-12 at 11:59 +0600, Shahbaz Khan wrote:
> >
> >> Hi,
> >>
> >> I am using Intel Q45 Express chipset with TPM version 1.2 specs of
> >> TCG. The kernel version is 2.6.30. Problem is that the TPM drivers
> >> cannot provide functionality to the TCG TSS giving error message:
> >>
> >> "TCSD TDDL ERROR: Could not find a device to open!"
> >>
> >> The device node in /dev is also not being created which should be
> >> "/dev/tpm". If created manually then still it does not work.
> >>
> >> What should be done?
> >>
> >> Thanks.
> >>
> >> --
> >> Shaz
> >>
> >
> > This is a device driver issue. Copying the TPM maintainers and the
> > forum.
> >
> > Mimi
> >
> >
>
>
> -------------------------------------------------------------------------=
-----
> Crystal Reports - New Free Runtime and 30 Day Trial
> Check out the new simplified licensing option that enables unlimited
> royalty-free distribution of the report engine for externally facing
> server and web deployment.
> http://p.sf.net/sfu/businessobjects
> _______________________________________________
> tpmdd-devel mailing list
> tpmdd-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/tpmdd-devel

--000e0cd14690ee20a7046da561dd
Content-Type: text/x-diff; charset=US-ASCII; name="01-either_dataexpect_or_valid.patch"
Content-Disposition: attachment; 
	filename="01-either_dataexpect_or_valid.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvxf8fi10

Y29tbWl0IGNjYTU2ZDdiNTUwYmFjMGEwMGQ2MzIyYjIyNWY0ZDBhOGQzZTZiODgKQXV0aG9yOiBE
YXZpZCBTbWl0aCA8ZGRzQGdvb2dsZS5jb20+CkRhdGU6ICAgVHVlIEFwciAyOCAxODo1NjozOSAy
MDA5ICswOTAwCgogICAgRml4IHRwbV90aXMgZHJpdmVyIHRvIHN1cHBvcnQgZWl0aGVyIERBVEFf
RVhQRUNUIG9yIFZBTElEIHN0YXR1cyB3aGVuIHVwbG9hZGluZyBjb21tYW5kIGRhdGEuCiAgICAK
ICAgIFRoZSBUQ0cgc3BlYyBzYXlzIHRoYXQgYSBWQUxJRCBzdGF0dXMgaW1wbGllcyB0aGF0IGEg
REFUQV9FWFBFQ1QKICAgIHN0YXR1cy4gVGhpcyBvY2N1cnMgaW4gdGhlIHJlYWwgd29ybGQgd2l0
aCB0aGUgaVRQTSBpbiBJbnRlbCdzIE1vYmlsZSA0CiAgICBwbGF0Zm9ybSB3aGljaCBuZXZlciBz
ZXRzIERBVEFfRVhQRUNULCBidXQgc2V0cyBWQUxJRCB3aGVuIGV4cGVjdGluZyBtb3JlCiAgICBk
YXRhLgogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZpZCBTbWl0aCA8ZGRzQGdvb2dsZS5jb20+
CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9jaGFyL3RwbS90cG1fdGlzLmMgYi9kcml2ZXJzL2NoYXIv
dHBtL3RwbV90aXMuYwppbmRleCBhZWMxOTMxLi5iZTExMmVmIDEwMDY0NAotLS0gYS9kcml2ZXJz
L2NoYXIvdHBtL3RwbV90aXMuYworKysgYi9kcml2ZXJzL2NoYXIvdHBtL3RwbV90aXMuYwpAQCAt
MjkzLDcgKzI5Myw4IEBAIHN0YXRpYyBpbnQgdHBtX3Rpc19zZW5kKHN0cnVjdCB0cG1fY2hpcCAq
Y2hpcCwgdTggKmJ1Ziwgc2l6ZV90IGxlbikKIAkJd2FpdF9mb3Jfc3RhdChjaGlwLCBUUE1fU1RT
X1ZBTElELCBjaGlwLT52ZW5kb3IudGltZW91dF9jLAogCQkJICAgICAgJmNoaXAtPnZlbmRvci5p
bnRfcXVldWUpOwogCQlzdGF0dXMgPSB0cG1fdGlzX3N0YXR1cyhjaGlwKTsKLQkJaWYgKChzdGF0
dXMgJiBUUE1fU1RTX0RBVEFfRVhQRUNUKSA9PSAwKSB7CisJCWlmICgoc3RhdHVzICYgVFBNX1NU
U19EQVRBX0VYUEVDVCkgPT0gMCAmJgorICAgICAgICAgICAgICAgICAgICAoc3RhdHVzICYgVFBN
X1NUU19WQUxJRCkgPT0gMCkgewogCQkJcmMgPSAtRUlPOwogCQkJZ290byBvdXRfZXJyOwogCQl9
CkBAIC0zMDYsNyArMzA3LDggQEAgc3RhdGljIGludCB0cG1fdGlzX3NlbmQoc3RydWN0IHRwbV9j
aGlwICpjaGlwLCB1OCAqYnVmLCBzaXplX3QgbGVuKQogCXdhaXRfZm9yX3N0YXQoY2hpcCwgVFBN
X1NUU19WQUxJRCwgY2hpcC0+dmVuZG9yLnRpbWVvdXRfYywKIAkJICAgICAgJmNoaXAtPnZlbmRv
ci5pbnRfcXVldWUpOwogCXN0YXR1cyA9IHRwbV90aXNfc3RhdHVzKGNoaXApOwotCWlmICgoc3Rh
dHVzICYgVFBNX1NUU19EQVRBX0VYUEVDVCkgIT0gMCkgeworCWlmICgoc3RhdHVzICYgVFBNX1NU
U19EQVRBX0VYUEVDVCkgIT0gMCAmJgorICAgICAgICAgICAgKHN0YXR1cyAmIFRQTV9TVFNfVkFM
SUQpID09IDEpIHsKIAkJcmMgPSAtRUlPOwogCQlnb3RvIG91dF9lcnI7CiAJfQo=
--000e0cd14690ee20a7046da561dd
Content-Type: text/x-diff; charset=US-ASCII; name="02-fix_acpipnp.patch"
Content-Disposition: attachment; filename="02-fix_acpipnp.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvxf8m0e1

Y29tbWl0IDdhNTUzYjRlNzQzOWFkMDczM2RhN2RhODY2M2QzMmFhNDg2NWFhOWUKQXV0aG9yOiBE
YXZpZCBTbWl0aCA8ZGRzQGdvb2dsZS5jb20+CkRhdGU6ICAgVHVlIEFwciAyOCAxODo1MjowMiAy
MDA5ICswOTAwCgogICAgVXBkYXRlIEFDUEkgUE5QIHRvIHN1cHBvcnQgZGV2aWNlcyB3aXRoIEVJ
U0EgUE5QIENJRHMgYnV0IG5vbi1QTlAgSElEcwogICAgCiAgICBTaWduZWQtb2ZmLWJ5OiBEYXZp
ZCBTbWl0aCA8ZGRzQGdvb2dsZS5jb20+CgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9wbnAvcG5wYWNw
aS9jb3JlLmMgYi9kcml2ZXJzL3BucC9wbnBhY3BpL2NvcmUuYwppbmRleCA5NDk2NDk0Li44YmZk
ZGZiIDEwMDY0NAotLS0gYS9kcml2ZXJzL3BucC9wbnBhY3BpL2NvcmUuYworKysgYi9kcml2ZXJz
L3BucC9wbnBhY3BpL2NvcmUuYwpAQCAtMTU5LDggKzE1OSw4IEBAIHN0YXRpYyBpbnQgX19pbml0
IHBucGFjcGlfYWRkX2RldmljZShzdHJ1Y3QgYWNwaV9kZXZpY2UgKmRldmljZSkKIAkgKiBkcml2
ZXIgc2hvdWxkIG5vdCBiZSBsb2FkZWQuCiAJICovCiAJc3RhdHVzID0gYWNwaV9nZXRfaGFuZGxl
KGRldmljZS0+aGFuZGxlLCAiX0NSUyIsICZ0ZW1wKTsKLQlpZiAoQUNQSV9GQUlMVVJFKHN0YXR1
cykgfHwgIWlzcG5waWRhY3BpKGFjcGlfZGV2aWNlX2hpZChkZXZpY2UpKSB8fAotCSAgICBpc19l
eGNsdXNpdmVfZGV2aWNlKGRldmljZSkgfHwgKCFkZXZpY2UtPnN0YXR1cy5wcmVzZW50KSkKKwlp
ZiAoQUNQSV9GQUlMVVJFKHN0YXR1cykgfHwgaXNfZXhjbHVzaXZlX2RldmljZShkZXZpY2UpIHx8
CisgICAgICAgICAgICAoIWRldmljZS0+c3RhdHVzLnByZXNlbnQpKQogCQlyZXR1cm4gMDsKIAog
CWRldiA9IHBucF9hbGxvY19kZXYoJnBucGFjcGlfcHJvdG9jb2wsIG51bSwgYWNwaV9kZXZpY2Vf
aGlkKGRldmljZSkpOwo=
--000e0cd14690ee20a7046da561dd
Content-Type: text/x-diff; charset=US-ASCII; 
	name="03-reorder_locality_to_after_timeouts.patch"
Content-Disposition: attachment; 
	filename="03-reorder_locality_to_after_timeouts.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fvxf8q6g2

Y29tbWl0IDIxMTdhMDYwZDA0YjEwNjNmMjZiYWU2NDUwYmRkMjFiZTQwMGI3OTkKQXV0aG9yOiBE
YXZpZCBTbWl0aCA8ZGRzQGdvb2dsZS5jb20+CkRhdGU6ICAgVGh1IEp1biAxMSAwODozNDoxNiAy
MDA5ICswOTAwCgogICAgUmVvcmRlciBzZXR0aW5nIGNoaXAgdGltZW91dHMgdG8gYmVmb3JlIGxv
Y2FsaXR5IGlzIHJlcXVlc3RlZC4KICAgIFRoaXMgc3RvcHMgYSBmYWlsdXJlIHRvIGxvYWQgcm91
Z2hseSBoYWxmIHRoZSB0aW1lIG9mIHRoZSBtb2R1bGUuCiAgICAKICAgIFNpZ25lZC1vZmYtYnk6
IERhdmlkIFNtaXRoIDxkZHNAZ29vZ2xlLmNvbT4KCmRpZmYgLS1naXQgYS9kcml2ZXJzL2NoYXIv
dHBtL3RwbV90aXMuYyBiL2RyaXZlcnMvY2hhci90cG0vdHBtX3Rpcy5jCmluZGV4IGJlMTEyZWYu
LmVlYTVkNGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvY2hhci90cG0vdHBtX3Rpcy5jCisrKyBiL2Ry
aXZlcnMvY2hhci90cG0vdHBtX3Rpcy5jCkBAIC00NTIsNiArNDUyLDEyIEBAIHN0YXRpYyBpbnQg
dHBtX3Rpc19pbml0KHN0cnVjdCBkZXZpY2UgKmRldiwgcmVzb3VyY2Vfc2l6ZV90IHN0YXJ0LAog
CQlnb3RvIG91dF9lcnI7CiAJfQogCisJLyogRGVmYXVsdCB0aW1lb3V0cyAqLworCWNoaXAtPnZl
bmRvci50aW1lb3V0X2EgPSBtc2Vjc190b19qaWZmaWVzKFRJU19TSE9SVF9USU1FT1VUKTsKKwlj
aGlwLT52ZW5kb3IudGltZW91dF9iID0gbXNlY3NfdG9famlmZmllcyhUSVNfTE9OR19USU1FT1VU
KTsKKwljaGlwLT52ZW5kb3IudGltZW91dF9jID0gbXNlY3NfdG9famlmZmllcyhUSVNfU0hPUlRf
VElNRU9VVCk7CisJY2hpcC0+dmVuZG9yLnRpbWVvdXRfZCA9IG1zZWNzX3RvX2ppZmZpZXMoVElT
X1NIT1JUX1RJTUVPVVQpOworCiAJaWYgKHJlcXVlc3RfbG9jYWxpdHkoY2hpcCwgMCkgIT0gMCkg
ewogCQlyYyA9IC1FTk9ERVY7CiAJCWdvdG8gb3V0X2VycjsKQEAgLTQ1OSwxMiArNDY1LDYgQEAg
c3RhdGljIGludCB0cG1fdGlzX2luaXQoc3RydWN0IGRldmljZSAqZGV2LCByZXNvdXJjZV9zaXpl
X3Qgc3RhcnQsCiAKIAl2ZW5kb3IgPSBpb3JlYWQzMihjaGlwLT52ZW5kb3IuaW9iYXNlICsgVFBN
X0RJRF9WSUQoMCkpOwogCi0JLyogRGVmYXVsdCB0aW1lb3V0cyAqLwotCWNoaXAtPnZlbmRvci50
aW1lb3V0X2EgPSBtc2Vjc190b19qaWZmaWVzKFRJU19TSE9SVF9USU1FT1VUKTsKLQljaGlwLT52
ZW5kb3IudGltZW91dF9iID0gbXNlY3NfdG9famlmZmllcyhUSVNfTE9OR19USU1FT1VUKTsKLQlj
aGlwLT52ZW5kb3IudGltZW91dF9jID0gbXNlY3NfdG9famlmZmllcyhUSVNfU0hPUlRfVElNRU9V
VCk7Ci0JY2hpcC0+dmVuZG9yLnRpbWVvdXRfZCA9IG1zZWNzX3RvX2ppZmZpZXMoVElTX1NIT1JU
X1RJTUVPVVQpOwotCiAJZGV2X2luZm8oZGV2LAogCQkgIjEuMiBUUE0gKGRldmljZS1pZCAweCVY
LCByZXYtaWQgJWQpXG4iLAogCQkgdmVuZG9yID4+IDE2LCBpb3JlYWQ4KGNoaXAtPnZlbmRvci5p
b2Jhc2UgKyBUUE1fUklEKDApKSk7Cg==
--000e0cd14690ee20a7046da561dd--
