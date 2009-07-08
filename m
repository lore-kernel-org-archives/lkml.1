Return-Path: <linux-kernel-owner+w=401wt.eu-S1752390AbZGHEiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752390AbZGHEiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 00:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751068AbZGHEiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 00:38:08 -0400
Received: from mail-px0-f181.google.com ([209.85.216.181]:60338 "EHLO
	mail-px0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbZGHEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 00:38:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=lFFay+MdouY8yC/UalXbILtOmWzsoGdmxLNu2jOxupoUZPZZ+Jm0WNRP48vEKp86Ro
         BlU1z3niw3I1bFYjajHsav7lvK4kFthC+gA0R+mwSx9lZgs5n0fVD9iFZdaD0QXGRo+T
         Anv8OLlbwIGx47L5KxFWoaPnIeEmauBOqhT2s=
MIME-Version: 1.0
In-Reply-To: <1247003445.5710.7.camel@pc1117.cambridge.arm.com>
References: <1246979820.9451.71.camel@pc1117.cambridge.arm.com>
	 <20090707190125.61920d00@gondolin>
	 <1247003445.5710.7.camel@pc1117.cambridge.arm.com>
Date: Wed, 8 Jul 2009 12:38:05 +0800
Message-ID: <d82e647a0907072138x106c48bdyfbc4dd884ad64b2c@mail.gmail.com>
Subject: Re: Possible memory leak in request_firmware()
From: Ming Lei <tom.leiming@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>, Sachin Sant <sachinp@in.ibm.com>
Content-Type: multipart/mixed; boundary=000e0cd2dc7627db27046e2a4e7b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd2dc7627db27046e2a4e7b
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

2009/7/8 Catalin Marinas <catalin.marinas@arm.com>:
> On Tue, 2009-07-07 at 19:01 +0200, Cornelia Huck wrote:
>
> There is one more leak in this area which I couldn't figure out where it
> should be freed:
>
> unreferenced object 0xc353e530 (size 512):
> =A0comm "cat", pid 3130, jiffies 4294903232
> =A0backtrace:
> =A0 =A0[<c01e6f6a>] create_object+0xfa/0x250
> =A0 =A0[<c01e753d>] kmemleak_alloc+0x5d/0x70
> =A0 =A0[<c01e223d>] __kmalloc+0x10d/0x210
> =A0 =A0[<c03b2d2f>] firmware_data_write+0x1df/0x270
> =A0 =A0[<c024163a>] write+0x13a/0x1b0
> =A0 =A0[<c01eae1c>] vfs_write+0x9c/0x190
> =A0 =A0[<c01eafcd>] sys_write+0x3d/0x70
> =A0 =A0[<c010319c>] sysenter_do_call+0x12/0x38
> =A0 =A0[<ffffffff>] 0xffffffff
>
> Any idea? It looks like this is the kmalloc() in fw_realloc_buffer()
> (inlined in firmware_data_write).

I guess the leak is introduced in commit :
             commit	6e03a201bbe8137487f340d26aa662110e324b20
             firmware: speed up request_firmware(), v3

The attachment patch may fix the leak, please test and verify it.
Thanks.


--=20
Lei Ming

--000e0cd2dc7627db27046e2a4e7b
Content-Type: text/x-patch; charset=US-ASCII; name="firmware_class_mem_leak.patch"
Content-Disposition: attachment; filename="firmware_class_mem_leak.patch"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fwvk34o40

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmFzZS9maXJtd2FyZV9jbGFzcy5jIGIvZHJpdmVycy9iYXNl
L2Zpcm13YXJlX2NsYXNzLmMKaW5kZXggMmRhNDgwMy4uMjcxZGM2YiAxMDA2NDQKLS0tIGEvZHJp
dmVycy9iYXNlL2Zpcm13YXJlX2NsYXNzLmMKKysrIGIvZHJpdmVycy9iYXNlL2Zpcm13YXJlX2Ns
YXNzLmMKQEAgLTE4MCw3ICsxODAsNiBAQCBzdGF0aWMgc3NpemVfdCBmaXJtd2FyZV9sb2FkaW5n
X3N0b3JlKHN0cnVjdCBkZXZpY2UgKmRldiwKIAkJCQlnb3RvIGVycjsKIAkJCX0KIAkJCS8qIFBh
Z2VzIHdpbGwgYmUgZnJlZWQgYnkgdmZyZWUoKSAqLwotCQkJZndfcHJpdi0+cGFnZXMgPSBOVUxM
OwogCQkJZndfcHJpdi0+cGFnZV9hcnJheV9zaXplID0gMDsKIAkJCWZ3X3ByaXYtPm5yX3BhZ2Vz
ID0gMDsKIAkJCWNvbXBsZXRlKCZmd19wcml2LT5jb21wbGV0aW9uKTsK
--000e0cd2dc7627db27046e2a4e7b--
