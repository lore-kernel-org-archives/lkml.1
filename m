Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbXEUUso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbXEUUso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 16:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755570AbXEUUsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 16:48:36 -0400
Received: from smtp-out.google.com ([216.239.45.13]:56166 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754958AbXEUUsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 16:48:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:references;
	b=fpuMez9JRDZywBmZw5MbvrsaoKfWw1QeE7ckSz+dMtT0BpnnmUKDyY5yObEyb5HPf
	4cZ5MZZHlxQdt+vc2KA4w==
Message-ID: <b040c32a0705211348r664e37f4hf03bec6ab27a7139@mail.gmail.com>
Date: Mon, 21 May 2007 13:48:26 -0700
From: "Ken Chen" <kenchen@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Cc: "Kay Sievers" <kay.sievers@vrfy.org>, "Ray Lee" <ray-lk@madrabbit.org>,
       "Al Viro" <viro@ftp.linux.org.uk>,
       "Andrey Borzenkov" <arvidjaar@mail.ru>, "Uwe Bugla" <uwe.bugla@gmx.de>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
In-Reply-To: <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_109265_23870488.1179780506103"
References: <464F42F3.1080300@madrabbit.org>
	 <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com>
	 <20070520062816.GA4095@ftp.linux.org.uk>
	 <2c0942db0705200822j685ec3b2x399a080622b6fc05@mail.gmail.com>
	 <3ae72650705200854x6a2c829fueff3652653fc21da@mail.gmail.com>
	 <2c0942db0705200910t777214efud489f4bc94433bf5@mail.gmail.com>
	 <1179677799.3311.5.camel@lov.localdomain>
	 <alpine.LFD.0.98.0705210908170.3890@woody.linux-foundation.org>
	 <b040c32a0705210927q24e2cd8fm9f4616941fccfdea@mail.gmail.com>
	 <b040c32a0705210937x3d1b8ac6wb9c8089337f5c683@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_109265_23870488.1179780506103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 5/21/07, Ken Chen <kenchen@google.com> wrote:
> The easiest way is to reinstate max_loop and create "max_loop" device
> up front at module load time.  However, that will lose all the "fancy
> on-demand device instantiation feature".
>
> So I propose we do the following:
>
> 1. have the module honor "max_loop" parameter and create that many
> device upfront on module load (max_loop will also be a hard max) iff
> user specify the parameter.
> 2. if max_loop is not specified, default create 8 loop device.  User
> can extent more loop device by create device node themselves and have
> kernel automatically instantiate loop device on-demand.
>
> Is this acceptable?  Patch in a bit.
>

Could people who has problem with loop device please test this?  I
tested it on my Ubuntu feisty distribution and it works fine. Though I
typically don't use loop device at all.

---

The kernel on-demand loop device instantiation breaks several user
space tools as the tools are not ready to cope with the "on-demand
feature".  Fix it by instantiate default 8 loop devices and also
reinstate max_loop module parameter.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 5526ead..0aae8d8 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1354,7 +1354,7 @@ #endif
  */
 static int max_loop;
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "obsolete, loop device is created on-demand");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);

@@ -1462,34 +1462,66 @@ static struct kobject *loop_probe(dev_t
 	return kobj;
 }

-static int __init loop_init(void)
-{
-	if (register_blkdev(LOOP_MAJOR, "loop"))
-		return -EIO;
-	blk_register_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS,
-				  THIS_MODULE, loop_probe, NULL, NULL);
-
-	if (max_loop) {
-		printk(KERN_INFO "loop: the max_loop option is obsolete "
-				 "and will be removed in March 2008\n");
-
-	}
-	printk(KERN_INFO "loop: module loaded\n");
-	return 0;
-}
-
 static void __exit loop_exit(void)
 {
+	unsigned long range;
 	struct loop_device *lo, *next;

+	range = max_loop ? max_loop :  1UL << MINORBITS;
+
 	list_for_each_entry_safe(lo, next, &loop_devices, lo_list)
 		loop_del_one(lo);

-	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), 1UL << MINORBITS);
+	blk_unregister_region(MKDEV(LOOP_MAJOR, 0), range);
 	if (unregister_blkdev(LOOP_MAJOR, "loop"))
 		printk(KERN_WARNING "loop: cannot unregister blkdev\n");
 }

+static int __init loop_init(void)
+{
+	int i, nr;
+	unsigned long range;
+
+	/*
+	 * loop module now has a feature to instantiate underlying device
+	 * structure on-demand, provided that there is an access dev node.
+	 * However, this will not work well with user space tool that doesn't
+	 * know about such "feature".  In order to not break any existing
+	 * tool, we do the following:
+	 *
+	 * (1) if max_loop is specified, create that many upfront, and this
+	 *     also becomes a hard limit.
+	 * (2) if max_loop is not specified, create 8 loop device on module
+	 *     load, user can further extend loop device by create dev node
+	 *     themselves and have kernel automatically instantiate actual
+	 *     device on-demand.
+	 */
+	if (max_loop) {
+		nr = max_loop;
+		range = max_loop;
+	} else {
+		nr = 8;
+		range = 1UL << MINORBITS;
+	}
+
+	if (register_blkdev(LOOP_MAJOR, "loop"))
+		return -EIO;
+	blk_register_region(MKDEV(LOOP_MAJOR, 0), range,
+				  THIS_MODULE, loop_probe, NULL, NULL);
+
+	for (i = 0; i < nr; i++) {
+		if (!loop_init_one(i))
+			goto err;
+	}
+
+	printk(KERN_INFO "loop: module loaded\n");
+	return 0;
+err:
+	loop_exit();
+	printk(KERN_INFO "loop: out of memory\n");
+	return -ENOMEM;
+}
+
 module_init(loop_init);
 module_exit(loop_exit);

------=_Part_109265_23870488.1179780506103
Content-Type: text/x-patch; name=loop_default_8.patch; 
	charset=ANSI_X3.4-1968
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1zetcjg
Content-Disposition: attachment; filename="loop_default_8.patch"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2svbG9vcC5jIGIvZHJpdmVycy9ibG9jay9sb29wLmMK
aW5kZXggNTUyNmVhZC4uMGFhZThkOCAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9sb29wLmMK
KysrIGIvZHJpdmVycy9ibG9jay9sb29wLmMKQEAgLTEzNTQsNyArMTM1NCw3IEBAICNlbmRpZgog
ICovCiBzdGF0aWMgaW50IG1heF9sb29wOwogbW9kdWxlX3BhcmFtKG1heF9sb29wLCBpbnQsIDAp
OwotTU9EVUxFX1BBUk1fREVTQyhtYXhfbG9vcCwgIm9ic29sZXRlLCBsb29wIGRldmljZSBpcyBj
cmVhdGVkIG9uLWRlbWFuZCIpOworTU9EVUxFX1BBUk1fREVTQyhtYXhfbG9vcCwgIk1heGltdW0g
bnVtYmVyIG9mIGxvb3AgZGV2aWNlcyIpOwogTU9EVUxFX0xJQ0VOU0UoIkdQTCIpOwogTU9EVUxF
X0FMSUFTX0JMT0NLREVWX01BSk9SKExPT1BfTUFKT1IpOwogCkBAIC0xNDYyLDM0ICsxNDYyLDY2
IEBAIHN0YXRpYyBzdHJ1Y3Qga29iamVjdCAqbG9vcF9wcm9iZShkZXZfdCAKIAlyZXR1cm4ga29i
ajsKIH0KIAotc3RhdGljIGludCBfX2luaXQgbG9vcF9pbml0KHZvaWQpCi17Ci0JaWYgKHJlZ2lz
dGVyX2Jsa2RldihMT09QX01BSk9SLCAibG9vcCIpKQotCQlyZXR1cm4gLUVJTzsKLQlibGtfcmVn
aXN0ZXJfcmVnaW9uKE1LREVWKExPT1BfTUFKT1IsIDApLCAxVUwgPDwgTUlOT1JCSVRTLAotCQkJ
CSAgVEhJU19NT0RVTEUsIGxvb3BfcHJvYmUsIE5VTEwsIE5VTEwpOwotCi0JaWYgKG1heF9sb29w
KSB7Ci0JCXByaW50ayhLRVJOX0lORk8gImxvb3A6IHRoZSBtYXhfbG9vcCBvcHRpb24gaXMgb2Jz
b2xldGUgIgotCQkJCSAiYW5kIHdpbGwgYmUgcmVtb3ZlZCBpbiBNYXJjaCAyMDA4XG4iKTsKLQot
CX0KLQlwcmludGsoS0VSTl9JTkZPICJsb29wOiBtb2R1bGUgbG9hZGVkXG4iKTsKLQlyZXR1cm4g
MDsKLX0KLQogc3RhdGljIHZvaWQgX19leGl0IGxvb3BfZXhpdCh2b2lkKQogeworCXVuc2lnbmVk
IGxvbmcgcmFuZ2U7CiAJc3RydWN0IGxvb3BfZGV2aWNlICpsbywgKm5leHQ7CiAKKwlyYW5nZSA9
IG1heF9sb29wID8gbWF4X2xvb3AgOiAgMVVMIDw8IE1JTk9SQklUUzsKKwogCWxpc3RfZm9yX2Vh
Y2hfZW50cnlfc2FmZShsbywgbmV4dCwgJmxvb3BfZGV2aWNlcywgbG9fbGlzdCkKIAkJbG9vcF9k
ZWxfb25lKGxvKTsKIAotCWJsa191bnJlZ2lzdGVyX3JlZ2lvbihNS0RFVihMT09QX01BSk9SLCAw
KSwgMVVMIDw8IE1JTk9SQklUUyk7CisJYmxrX3VucmVnaXN0ZXJfcmVnaW9uKE1LREVWKExPT1Bf
TUFKT1IsIDApLCByYW5nZSk7CiAJaWYgKHVucmVnaXN0ZXJfYmxrZGV2KExPT1BfTUFKT1IsICJs
b29wIikpCiAJCXByaW50ayhLRVJOX1dBUk5JTkcgImxvb3A6IGNhbm5vdCB1bnJlZ2lzdGVyIGJs
a2RldlxuIik7CiB9CiAKK3N0YXRpYyBpbnQgX19pbml0IGxvb3BfaW5pdCh2b2lkKQoreworCWlu
dCBpLCBucjsKKwl1bnNpZ25lZCBsb25nIHJhbmdlOworCisJLyoKKwkgKiBsb29wIG1vZHVsZSBu
b3cgaGFzIGEgZmVhdHVyZSB0byBpbnN0YW50aWF0ZSB1bmRlcmx5aW5nIGRldmljZQorCSAqIHN0
cnVjdHVyZSBvbi1kZW1hbmQsIHByb3ZpZGVkIHRoYXQgdGhlcmUgaXMgYW4gYWNjZXNzIGRldiBu
b2RlLgorCSAqIEhvd2V2ZXIsIHRoaXMgd2lsbCBub3Qgd29yayB3ZWxsIHdpdGggdXNlciBzcGFj
ZSB0b29sIHRoYXQgZG9lc24ndAorCSAqIGtub3cgYWJvdXQgc3VjaCAiZmVhdHVyZSIuICBJbiBv
cmRlciB0byBub3QgYnJlYWsgYW55IGV4aXN0aW5nCisJICogdG9vbCwgd2UgZG8gdGhlIGZvbGxv
d2luZzoKKwkgKgorCSAqICgxKSBpZiBtYXhfbG9vcCBpcyBzcGVjaWZpZWQsIGNyZWF0ZSB0aGF0
IG1hbnkgdXBmcm9udCwgYW5kIHRoaXMKKwkgKiAgICAgYWxzbyBiZWNvbWVzIGEgaGFyZCBsaW1p
dC4KKwkgKiAoMikgaWYgbWF4X2xvb3AgaXMgbm90IHNwZWNpZmllZCwgY3JlYXRlIDggbG9vcCBk
ZXZpY2Ugb24gbW9kdWxlCisJICogICAgIGxvYWQsIHVzZXIgY2FuIGZ1cnRoZXIgZXh0ZW5kIGxv
b3AgZGV2aWNlIGJ5IGNyZWF0ZSBkZXYgbm9kZQorCSAqICAgICB0aGVtc2VsdmVzIGFuZCBoYXZl
IGtlcm5lbCBhdXRvbWF0aWNhbGx5IGluc3RhbnRpYXRlIGFjdHVhbAorCSAqICAgICBkZXZpY2Ug
b24tZGVtYW5kLgorCSAqLworCWlmIChtYXhfbG9vcCkgeworCQluciA9IG1heF9sb29wOworCQly
YW5nZSA9IG1heF9sb29wOworCX0gZWxzZSB7CisJCW5yID0gODsKKwkJcmFuZ2UgPSAxVUwgPDwg
TUlOT1JCSVRTOworCX0KKworCWlmIChyZWdpc3Rlcl9ibGtkZXYoTE9PUF9NQUpPUiwgImxvb3Ai
KSkKKwkJcmV0dXJuIC1FSU87CisJYmxrX3JlZ2lzdGVyX3JlZ2lvbihNS0RFVihMT09QX01BSk9S
LCAwKSwgcmFuZ2UsCisJCQkJICBUSElTX01PRFVMRSwgbG9vcF9wcm9iZSwgTlVMTCwgTlVMTCk7
CisKKwlmb3IgKGkgPSAwOyBpIDwgbnI7IGkrKykgeworCQlpZiAoIWxvb3BfaW5pdF9vbmUoaSkp
CisJCQlnb3RvIGVycjsKKwl9CisKKwlwcmludGsoS0VSTl9JTkZPICJsb29wOiBtb2R1bGUgbG9h
ZGVkXG4iKTsKKwlyZXR1cm4gMDsKK2VycjoKKwlsb29wX2V4aXQoKTsKKwlwcmludGsoS0VSTl9J
TkZPICJsb29wOiBvdXQgb2YgbWVtb3J5XG4iKTsKKwlyZXR1cm4gLUVOT01FTTsKK30KKwogbW9k
dWxlX2luaXQobG9vcF9pbml0KTsKIG1vZHVsZV9leGl0KGxvb3BfZXhpdCk7CiAK
------=_Part_109265_23870488.1179780506103--
