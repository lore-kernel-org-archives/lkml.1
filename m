Return-Path: <linux-kernel-owner+w=401wt.eu-S933612AbYD1L5f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612AbYD1L5f (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 07:57:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763455AbYD1L52
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 07:57:28 -0400
Received: from guard.arkoon.net ([62.161.237.193]:44682 "EHLO
	akguard.arkoon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763424AbYD1L51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 07:57:27 -0400
To: linux-kernel@vger.kernel.org
Subject: Unsuccessful access to the last blocks of a device [2.4/2.6 PATCH] (repost)
MIME-Version: 1.0
X-Mailer: Lotus Notes Release 7.0.2 September 26, 2006
Message-ID: <OF245A8A21.FA33AF87-ONC1257439.004183C5-C1257439.0041A901@arkoon.net>
Date: Mon, 28 Apr 2008 13:57:16 +0200
X-MIMETrack: S/MIME Sign by Notes Client on mathieu lafon/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 13:57:11,
	Serialize by Notes Client on mathieu lafon/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 13:57:11,
	Serialize complete at 28/04/2008 13:57:11,
	S/MIME Sign failed at 28/04/2008 13:57:11: Cl? chiffr?e introuvable,
	Serialize by Router on arkoon-mail.arkoon.net/Arkoon(Release 7.0.2|September
 26, 2006) at 28/04/2008 13:57:17
From: "Mathieu Lafon" <mlafon@arkoon.net>
Content-Type: multipart/mixed; boundary="=_mixed 0041A8FBC1257439_="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=_mixed 0041A8FBC1257439_=
Content-Type: text/plain; charset="US-ASCII"

[Reposted with the patch...]


I have encountered a problem where I wasn't able to access to the last 
blocks
of a partition.

By example, using dd:

# dd if=/dev/hda1 of=/dev/null
dd: /dev/hda1: Input/output error

In the kernel logs:

03:01: rw=0, want=28864, limit=28863 
attempt to access beyond end of device 

After having investigated this issue, I have found the following 
explanation:

- A getblk() call is done to read one of the last block of my partition.
  The block is located in the last PAGE_SIZE (4kB) of the partition.
  In my case, the getblk() call is done by the e2compr patch
  (e2compr.sourceforge.net) but I don't think it is the problem (correct
  me if I'm wrong).

- The block is not in the page cache so a new page is created by 
grow_buffers()
  with 4 buffers of 1kB.

- When the page is created, hash_page_buffers() is called to initialize 
the
  buffers. The buffers are initialized by simply incrementing the block
  number without any check.

  In my case, the last buffer is initialized with a block number outside 
of
  the partition.

- When dd try to access to one of the last block, the (invalid) cached 
page
  is found and trigger the previous error (attempt to access beyond end of
  device) because one buffer of the page is really beyond end of device.

- If I manage to get the cache flushed, I can read the whole partition
  because the (invalid) cached page is not found and 
block_read_full_page()
  correctly initialize the new page by checking the last block.

I have made a patch for 2.4.32 to test for the last block in 
grow_buffers()
and hash_page_buffers() in the same way it is done in 
block_read_full_page().

Regarding the 2.6 branch, I have looked at the source code and the problem
seems to be the same in init_page_buffers() which is called by __getblk().

-- 
Mathieu Lafon - Arkoon Network Security

--=_mixed 0041A8FBC1257439_=
Content-Type: application/octet-stream; name="linux-2.4.32-getblk-fix.diff"
Content-Disposition: attachment; filename="linux-2.4.32-getblk-fix.diff"
Content-Transfer-Encoding: base64

ZGlmZiAtcnVOIGxpbnV4LTIuNC4zMi9mcy9idWZmZXIuYyBsaW51eC0yLjQuMzItZml4L2ZzL2J1
ZmZlci5jCi0tLSBsaW51eC0yLjQuMzIvZnMvYnVmZmVyLmMJMjAwNS0xMS0xNiAyMDoxMjo1NC4w
MDAwMDAwMDAgKzAxMDAKKysrIGxpbnV4LTIuNC4zMi1maXgvZnMvYnVmZmVyLmMJMjAwOC0wNC0y
OCAxMDo0MTo0OC4wMDAwMDAwMDAgKzAyMDAKQEAgLTI1NjQsMTEgKzI1NjQsMTIgQEAKIAlyZXR1
cm4gTlVMTDsKIH0KIAotc3RhdGljIHZvaWQgaGFzaF9wYWdlX2J1ZmZlcnMoc3RydWN0IHBhZ2Ug
KnBhZ2UsIGtkZXZfdCBkZXYsIGludCBibG9jaywgaW50IHNpemUpCitzdGF0aWMgdm9pZCBoYXNo
X3BhZ2VfYnVmZmVycyhzdHJ1Y3QgcGFnZSAqcGFnZSwga2Rldl90IGRldiwgaW50IGJsb2NrLCBp
bnQgc2l6ZSwgaW50IG1heCkKIHsKIAlzdHJ1Y3QgYnVmZmVyX2hlYWQgKmhlYWQgPSBwYWdlLT5i
dWZmZXJzOwogCXN0cnVjdCBidWZmZXJfaGVhZCAqYmggPSBoZWFkOwogCXVuc2lnbmVkIGludCB1
cHRvZGF0ZTsKKwlpbnQgaSA9IDA7CiAKIAl1cHRvZGF0ZSA9IDEgPDwgQkhfTWFwcGVkOwogCWlm
IChQYWdlX1VwdG9kYXRlKHBhZ2UpKQpAQCAtMjU3OSwxNSArMjU4MCwzMCBAQAogCQlpZiAoIShi
aC0+Yl9zdGF0ZSAmICgxIDw8IEJIX01hcHBlZCkpKSB7CiAJCQlpbml0X2J1ZmZlcihiaCwgTlVM
TCwgTlVMTCk7CiAJCQliaC0+Yl9kZXYgPSBkZXY7Ci0JCQliaC0+Yl9ibG9ja25yID0gYmxvY2s7
Ci0JCQliaC0+Yl9zdGF0ZSA9IHVwdG9kYXRlOworCQkJaWYgKChtYXggIT0gMCkgJiYgKGJsb2Nr
ID49IG1heCkpIHsKKwkJCQkvKioKKwkJCQkgKiBEbyBub3QgbWFwIGJ1ZmZlcl9oZWFkIGlmIHRo
ZSBibG9jayBuYiBpcyBiaWdnZXIgdGhhbiBtYXguCisJCQkJICogSW5zdGVhZCwgY2xlYXIgdGhl
IGJ1ZmZlciBhbmQgc2V0IGJoIHN0YXRlIGFzIHVwLXRvLWRhdGUuCisJCQkJICogVGhpcyBpcyB3
aGF0IGlzIGRvbmUgaW4gYmxvY2tfcmVhZF9mdWxsX3BhZ2UoKS4KKwkJCQkgKi8KKwkJCQliaC0+
Yl9ibG9ja25yID0gMDsKKwkJCQltZW1zZXQoa21hcChwYWdlKSArIGkqc2l6ZSwgMCwgc2l6ZSk7
CisJCQkJZmx1c2hfZGNhY2hlX3BhZ2UocGFnZSk7CisJCQkJa3VubWFwKHBhZ2UpOworCQkJCXNl
dF9iaXQoQkhfVXB0b2RhdGUsICZiaC0+Yl9zdGF0ZSk7CisJCQl9CisJCQllbHNlIHsKKwkJCQli
aC0+Yl9ibG9ja25yID0gYmxvY2s7CisJCQkJYmgtPmJfc3RhdGUgPSB1cHRvZGF0ZTsKKwkJCX0K
IAkJfQogCiAJCS8qIEluc2VydCB0aGUgYnVmZmVyIGludG8gdGhlIGhhc2ggbGlzdHMgaWYgbmVj
ZXNzYXJ5ICovCi0JCWlmICghYmgtPmJfcHByZXYpCisJCWlmICgoYnVmZmVyX21hcHBlZChiaCkp
ICYmICghYmgtPmJfcHByZXYpKQogCQkJX19pbnNlcnRfaW50b19oYXNoX2xpc3QoYmgpOwogCiAJ
CWJsb2NrKys7CisJCWkrKzsKIAkJYmggPSBiaC0+Yl90aGlzX3BhZ2U7CiAJfSB3aGlsZSAoYmgg
IT0gaGVhZCk7CiAJd3JpdGVfdW5sb2NrKCZoYXNoX3RhYmxlX2xvY2spOwpAQCAtMjYwMyw2ICsy
NjE5LDcgQEAKIAlzdHJ1Y3QgYmxvY2tfZGV2aWNlICpiZGV2OwogCXVuc2lnbmVkIGxvbmcgaW5k
ZXg7CiAJaW50IHNpemViaXRzOworCXVuc2lnbmVkIGxvbmcgbWF4ID0gMDsKIAogCS8qIFNpemUg
bXVzdCBiZSBtdWx0aXBsZSBvZiBoYXJkIHNlY3RvcnNpemUgKi8KIAlpZiAoc2l6ZSAmIChnZXRf
aGFyZHNlY3Rfc2l6ZShkZXYpLTEpKQpAQCAtMjYxOSw2ICsyNjM2LDE5IEBACiAJaW5kZXggPSBi
bG9jayA+PiBzaXplYml0czsKIAlibG9jayA9IGluZGV4IDw8IHNpemViaXRzOwogCisJLyogc3Rv
bGVuIGZyb20gbWF4X2Jsb2NrKCkgW2ZzL2Jsb2NrX2Rldi5jXSAqLworCWlmIChibGtfc2l6ZVtN
QUpPUihkZXYpXSkgeworCQl1bnNpZ25lZCBpbnQgYmxvY2tzID0gYmxrX3NpemVbTUFKT1IoZGV2
KV1bTUlOT1IoZGV2KV07CisJCWlmIChibG9ja3MpIHsKKwkJCXVuc2lnbmVkIGludCBfc2l6ZSA9
IGJsb2NrX3NpemUoZGV2KTsKKwkJCXVuc2lnbmVkIGludCBfc2l6ZWJpdHMgPSBibGtzaXplX2Jp
dHMoX3NpemUpOworCQkJYmxvY2tzICs9IChfc2l6ZS0xKSA+PiBCTE9DS19TSVpFX0JJVFM7CisJ
CQltYXggPSBibG9ja3MgPDwgKEJMT0NLX1NJWkVfQklUUyAtIF9zaXplYml0cyk7CisJCQlpZiAo
X3NpemViaXRzID4gQkxPQ0tfU0laRV9CSVRTKQorCQkJCW1heCA9IGJsb2NrcyA+PiAoX3NpemVi
aXRzIC0gQkxPQ0tfU0laRV9CSVRTKTsKKwkJfQorCX0KKwogCWJkZXYgPSBiZGdldChrZGV2X3Rf
dG9fbnIoZGV2KSk7CiAJaWYgKCFiZGV2KSB7CiAJCXByaW50aygiTm8gYmxvY2sgZGV2aWNlIGZv
ciAlc1xuIiwga2Rldm5hbWUoZGV2KSk7CkBAIC0yNjM0LDcgKzI2NjQsNyBAQAogCQlyZXR1cm4g
MDsKIAogCS8qIEhhc2ggaW4gdGhlIGJ1ZmZlcnMgb24gdGhlIGhhc2ggbGlzdCAqLwotCWhhc2hf
cGFnZV9idWZmZXJzKHBhZ2UsIGRldiwgYmxvY2ssIHNpemUpOworCWhhc2hfcGFnZV9idWZmZXJz
KHBhZ2UsIGRldiwgYmxvY2ssIHNpemUsIG1heCk7CiAJVW5sb2NrUGFnZShwYWdlKTsKIAlwYWdl
X2NhY2hlX3JlbGVhc2UocGFnZSk7CiAK

--=_mixed 0041A8FBC1257439_=--
