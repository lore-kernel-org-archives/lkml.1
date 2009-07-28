Return-Path: <linux-kernel-owner+w=401wt.eu-S1755751AbZG1XvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751AbZG1XvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370AbZG1XvO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:51:14 -0400
Received: from kroah.org ([198.145.64.141]:36004 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062AbZG1Xuh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:37 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:02 2009
Message-Id: <20090728234202.514493230@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [patch 70/71] eCryptfs: Check Tag 11 literal data buffer size (CVE-2009-2406)
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-check-tag-11-literal-data-buffer-size.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>

commit 6352a29305373ae6196491e6d4669f301e26492e upstream.

Tag 11 packets are stored in the metadata section of an eCryptfs file to
store the key signature(s) used to encrypt the file encryption key.
After extracting the packet length field to determine the key signature
length, a check is not performed to see if the length would exceed the
key signature buffer size that was passed into parse_tag_11_packet().

Thanks to Ramon de Carvalho Valle for finding this bug using fsfuzzer.

Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1449,6 +1449,12 @@ parse_tag_11_packet(unsigned char *data,
 		rc = -EINVAL;
 		goto out;
 	}
+	if (unlikely((*tag_11_contents_size) > max_contents_bytes)) {
+		printk(KERN_ERR "Literal data section in tag 11 packet exceeds "
+		       "expected size\n");
+		rc = -EINVAL;
+		goto out;
+	}
 	if (data[(*packet_size)++] != 0x62) {
 		printk(KERN_WARNING "Unrecognizable packet\n");
 		rc = -EINVAL;


