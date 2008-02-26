Return-Path: <linux-kernel-owner+w=401wt.eu-S1762668AbYBZJ1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762668AbYBZJ1B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 04:27:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762479AbYBZJ0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 04:26:42 -0500
Received: from hqemgate04.nvidia.com ([216.228.112.152]:8145 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762447AbYBZJ0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 04:26:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp04.nvidia.com on Tue, 26 Feb 2008 01:26:38 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
MIME-Version: 1.0
Subject: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma. 
Date: Tue, 26 Feb 2008 17:24:41 +0800
Message-ID: <15F501D1A78BD343BE8F4D8DB854566B1BFE2AE5@hkemmail01.nvidia.com>
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] sata_nv: fix nmi intr or system hanging in rhel4u6 adma. 
thread-index: Ach4WWpvpZDheBYESMiB1nDPYPNzLg==
From: "Kuan Luo" <kluo@nvidia.com>
To: "Robert Hancock" <hancockr@shaw.ca>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "Tejun Heo" <htejun@gmail.com>, "Jeff Garzik" <jeff@garzik.org>,
       "Peer Chen" <pchen@nvidia.com>
X-OriginalArrivalTime: 26 Feb 2008 09:24:42.0501 (UTC) FILETIME=[6B241B50:01C87859]
Content-class: urn:content-classes:message
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C87859.6A9E1530"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C87859.6A9E1530
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi, robert=20

One customer reported that their system received a nmi interrupt after
issuing "dd if=3D/dev/sdb of=3D/dev/null" on a defective disk in rhel4u6.=

I tested it and found  that my system hung both in rhel4u6(2.6.9-67) and
2.6.24-rc7.
The patch can work well,  but I am not sure if the patch has other
potential effect on adma.
I attached a  file in case of lines breaked.

The below info comes from Gunther Mayer to reproduce the issue.
"
used a Seagate ST3500841NS 3.AE for my test; probably other=20
seagate drives are also capable of creating media errors with=20
the new hdparm-8.1:=20

- compile hdparm-8.1=20
- hdparm -- yes-i-know-what-i-am-doing --make-bad-sector 60000 /dev/sdb=20

Unfortunately this does not succeed for nvidia sata controller (timeouts
et al.), but it worked fine on AHCI machine (e.g. FSC R640).=20

When I insert this newly created defective disk in Ultra 20,=20
it reboots within seconds after issueing "dd if=3D/dev/sdb of=3D/dev/null=
".=20
"

Signed-off-by: kluo@nvidia.com

---
=20
drivers/ata/sata_nv.c |    5 +++--
=201 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index ed5473b..e824260 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -837,9 +837,10 @@ static void nv_adma_tf_read(struct ata_port *ap,
struct ata_taskfile *tf)
=20	   all shortly be aborted anyway. We assume that NCQ commands
are not
=20	   issued via passthrough, which is the only way that switching
into
=20	   ADMA mode could abort outstanding commands. */
-	nv_adma_register_mode(ap);
+	struct nv_adma_port_priv *pp =3D ap->private_data;
=20
-	ata_tf_read(ap, tf);
+	if (pp->flags & NV_ADMA_PORT_REGISTER_MODE)
+		ata_tf_read(ap, tf);
=20}
=20
=20static unsigned int nv_adma_tf_to_cpb(struct ata_taskfile *tf, __le16
*cpb)

-

Best regards,
Kuan Luo

-------------------------------------------------------------------------=
----------
This email message is for the sole use of the intended recipient(s) and m=
ay contain
confidential information.  Any unauthorized review, use, disclosure or di=
stribution
is prohibited.  If you are not the intended recipient, please contact the=
=20sender by
reply email and destroy all copies of the original message.
-------------------------------------------------------------------------=
----------

------_=_NextPart_001_01C87859.6A9E1530
Content-Type: application/octet-stream;
	name="nmi-patch2"
Content-Transfer-Encoding: base64
Content-Description: nmi-patch2
Content-Disposition: attachment;
	filename="nmi-patch2"

ClNpZ25lZC1vZmYtYnk6IGtsdW9AbnZpZGlhLmNvbQoKIGRyaXZlcnMvYXRhL3NhdGFfbnYuYyB8
ICAgIDUgKysrLS0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9hdGEvc2F0YV9udi5jIGIvZHJpdmVycy9hdGEvc2F0
YV9udi5jCmluZGV4IGVkNTQ3M2IuLmU4MjQyNjAgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvYXRhL3Nh
dGFfbnYuYworKysgYi9kcml2ZXJzL2F0YS9zYXRhX252LmMKQEAgLTgzNyw5ICs4MzcsMTAgQEAg
c3RhdGljIHZvaWQgbnZfYWRtYV90Zl9yZWFkKHN0cnVjdCBhdGFfcG9ydCAqYXAsIHN0cnVjdCBh
dGFfdGFza2ZpbGUgKnRmKQogCSAgIGFsbCBzaG9ydGx5IGJlIGFib3J0ZWQgYW55d2F5LiBXZSBh
c3N1bWUgdGhhdCBOQ1EgY29tbWFuZHMgYXJlIG5vdAogCSAgIGlzc3VlZCB2aWEgcGFzc3Rocm91
Z2gsIHdoaWNoIGlzIHRoZSBvbmx5IHdheSB0aGF0IHN3aXRjaGluZyBpbnRvCiAJICAgQURNQSBt
b2RlIGNvdWxkIGFib3J0IG91dHN0YW5kaW5nIGNvbW1hbmRzLiAqLwotCW52X2FkbWFfcmVnaXN0
ZXJfbW9kZShhcCk7CisJc3RydWN0IG52X2FkbWFfcG9ydF9wcml2ICpwcCA9IGFwLT5wcml2YXRl
X2RhdGE7CiAKLQlhdGFfdGZfcmVhZChhcCwgdGYpOworCWlmIChwcC0+ZmxhZ3MgJiBOVl9BRE1B
X1BPUlRfUkVHSVNURVJfTU9ERSkKKwkJYXRhX3RmX3JlYWQoYXAsIHRmKTsKIH0KIAogc3RhdGlj
IHVuc2lnbmVkIGludCBudl9hZG1hX3RmX3RvX2NwYihzdHJ1Y3QgYXRhX3Rhc2tmaWxlICp0Ziwg
X19sZTE2ICpjcGIpCg==

------_=_NextPart_001_01C87859.6A9E1530--
