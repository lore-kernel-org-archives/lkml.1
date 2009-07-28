Return-Path: <linux-kernel-owner+w=401wt.eu-S1755441AbZG1Xuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755441AbZG1Xuv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755193AbZG1Xum
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:50:42 -0400
Received: from kroah.org ([198.145.64.141]:36010 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755106AbZG1Xui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:50:38 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:42:02 2009
Message-Id: <20090728234202.673663118@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:41:40 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Ramon de Carvalho Valle <ramon@risesecurity.org>,
       Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Subject: [patch 71/71] eCryptfs: parse_tag_3_packet check tag 3 packet encrypted key size (CVE-2009-2407)
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=ecryptfs-parse_tag_3_packet-check-tag-3-packet-encrypted-key-size.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ramon de Carvalho Valle <ramon@risesecurity.org>

commit f151cd2c54ddc7714e2f740681350476cda03a28 upstream.

The parse_tag_3_packet function does not check if the tag 3 packet contains a
encrypted key size larger than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES.

Signed-off-by: Ramon de Carvalho Valle <ramon@risesecurity.org>
[tyhicks@linux.vnet.ibm.com: Added printk newline and changed goto to out_free]
Signed-off-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ecryptfs/keystore.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -1303,6 +1303,13 @@ parse_tag_3_packet(struct ecryptfs_crypt
 	}
 	(*new_auth_tok)->session_key.encrypted_key_size =
 		(body_size - (ECRYPTFS_SALT_SIZE + 5));
+	if ((*new_auth_tok)->session_key.encrypted_key_size
+	    > ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES) {
+		printk(KERN_WARNING "Tag 3 packet contains key larger "
+		       "than ECRYPTFS_MAX_ENCRYPTED_KEY_BYTES\n");
+		rc = -EINVAL;
+		goto out_free;
+	}
 	if (unlikely(data[(*packet_size)++] != 0x04)) {
 		printk(KERN_WARNING "Unknown version number [%d]\n",
 		       data[(*packet_size) - 1]);


