Return-Path: <linux-kernel-owner+w=401wt.eu-S932521AbYEVFBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932521AbYEVFBa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 01:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754200AbYEVFBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 01:01:21 -0400
Received: from twinlark.arctic.org ([208.69.40.136]:43689 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923AbYEVFBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 01:01:20 -0400
Message-ID: <4834FE1D.10909@kernel.org>
Date: Wed, 21 May 2008 22:01:17 -0700
From: "Andrew G. Morgan" <morgan@kernel.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shi Weihua <shiwh@cn.fujitsu.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       linux-security-module@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, jmorris@namei.org,
       ltp-list@lists.sourceforge.net
Subject: Re: [PATCH] fix sys_prctl() returned uninitialized value
References: <4834E639.2010209@cn.fujitsu.com> <20080521203212.ddf05254.akpm@linux-foundation.org>
In-Reply-To: <20080521203212.ddf05254.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------090207070405080804090801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090207070405080804090801
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Looks like I goofed here. :*(

Andrew Morton wrote:
| Oh dear, there are so many things wrong with this...
|
| - if security_task_prctl() is returning "fail" then why on earth
|   isn't it setting the error code?

Its not failing, as Shi points out in their patch preamble, its simply
passing-through - security_task_prctl() doesn't implement the requested
PR_* code, so it expects something else (sys_prctl() proper) to set this
value.

| - cap_task_prctl() _does_ set `error' is if returns non-zero, so it
|   must be one of the other myriad backend implementations of
|   security_task_prctl() which is busted.  Which one is it?

None of them. In this case, none of the security modules implement the
requested PRCTL.

| - With the above patch applied, sys_prctl() will return zero (ie:
|   "success") even though it just failed.

Not sure what you mean here. The switch statement only sets a non-zero
value for error on a failing path. It assumes that the error value is
initially zero.

| - Can't we remove the sixth argument to security_task_prctl() and
|   just return the result code like a sane function would do?

A bunch of capability related prctl()s will cease to work.

I'd prefer the attached patch, but I don't object to Shi's. In which case:

~   Acked-by: Andrew G. Morgan <morgan@kernel.org>

Cheers

Andrew

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.6 (GNU/Linux)

iD8DBQFINP4d+bHCR3gb8jsRAj9pAJ4g8WqzSOomhIirAdjt2nZ//mCAoACcDA+0
EKUYQcvgTgbPig1erxmglsA=
=n5ae
-----END PGP SIGNATURE-----

--------------090207070405080804090801
Content-Type: text/plain;
 name="Bug-fix-default-error-to-success.patch"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="Bug-fix-default-error-to-success.patch"

RnJvbSA1MDY0ZTUwYjRhMTBjZWYyZmU0OGE1NzE2ZmZiMzg0NTQ4OGYwYTE0IE1vbiBTZXAg
MTcgMDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVs
Lm9yZz4KRGF0ZTogV2VkLCAyMSBNYXkgMjAwOCAyMTo0NjozNSAtMDcwMApTdWJqZWN0OiBb
UEFUQ0hdIEJ1ZyBmaXg6IGRlZmF1bHQgZXJyb3IgdG8gc3VjY2VzcwoKdGhpcyBpcyB0aGUg
ZGVmYXVsdCBleHBlY3RlZCBieSB0aGUgc3Vic2VxdWVudCBzd2l0Y2ggKCkuCgpTaWduZWQt
b2ZmLWJ5OiBBbmRyZXcgRy4gTW9yZ2FuIDxtb3JnYW5Aa2VybmVsLm9yZz4KLS0tCiBrZXJu
ZWwvc3lzLmMgfCAgICAyICsrCiAxIGZpbGVzIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwg
MCBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9rZXJuZWwvc3lzLmMgYi9rZXJuZWwvc3lz
LmMKaW5kZXggODk1ZDJkNC4uY2IyNWE2NCAxMDA2NDQKLS0tIGEva2VybmVsL3N5cy5jCisr
KyBiL2tlcm5lbC9zeXMuYwpAQCAtMTY1Nyw2ICsxNjU3LDggQEAgYXNtbGlua2FnZSBsb25n
IHN5c19wcmN0bChpbnQgb3B0aW9uLCB1bnNpZ25lZCBsb25nIGFyZzIsIHVuc2lnbmVkIGxv
bmcgYXJnMywKIAlpZiAoc2VjdXJpdHlfdGFza19wcmN0bChvcHRpb24sIGFyZzIsIGFyZzMs
IGFyZzQsIGFyZzUsICZlcnJvcikpCiAJCXJldHVybiBlcnJvcjsKIAorCWVycm9yID0gMDsK
KwogCXN3aXRjaCAob3B0aW9uKSB7CiAJCWNhc2UgUFJfU0VUX1BERUFUSFNJRzoKIAkJCWlm
ICghdmFsaWRfc2lnbmFsKGFyZzIpKSB7Ci0tIAoxLjUuMy43Cgo=
--------------090207070405080804090801--
