Return-Path: <linux-kernel-owner+w=401wt.eu-S1754567AbYKLRLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754567AbYKLRLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYKLRL2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:11:28 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:34931 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbYKLRL1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:11:27 -0500
Date: Wed, 12 Nov 2008 11:11:11 -0600
From: Michael Halcrow <mhalcrow@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, dustin.kirkland@gmail.com,
       sandeen@redhat.com, tchicks@us.ibm.com, shaggy@us.ibm.com
Subject: [PATCH] eCryptfs: Clean up ecryptfs_decode_from_filename()
Message-ID: <20081112171111.GE6842@halcrowt61p.austin.ibm.com>
Reply-To: Michael Halcrow <mhalcrow@us.ibm.com>
References: <20081104213754.GC6675@halcrowt61p.austin.ibm.com> <20081104214120.GC6677@halcrowt61p.austin.ibm.com> <20081106141254.ba887466.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081106141254.ba887466.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 06, 2008 at 02:12:54PM -0800, Andrew Morton wrote:
> On Tue, 4 Nov 2008 15:41:20 -0600
> Michael Halcrow <mhalcrow@us.ibm.com> wrote:
> > +static unsigned char filename_rev_map[] = {
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 31 */
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 39 */
> > +	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, /* 47 */
> > +	0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08, 0x09, /* 55 */
> > +	0x0A, 0x0B, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 63 */
> > +	0x00, 0x0C, 0x0D, 0x0E, 0x0F, 0x10, 0x11, 0x12, /* 71 */
> > +	0x13, 0x14, 0x15, 0x16, 0x17, 0x18, 0x19, 0x1A, /* 79 */
> > +	0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20, 0x21, 0x22, /* 87 */
> > +	0x23, 0x24, 0x25, 0x00, 0x00, 0x00, 0x00, 0x00, /* 95 */
> > +	0x00, 0x26, 0x27, 0x28, 0x29, 0x2A, 0x2B, 0x2C, /* 103 */
> > +	0x2D, 0x2E, 0x2F, 0x30, 0x31, 0x32, 0x33, 0x34, /* 111 */
> > +	0x35, 0x36, 0x37, 0x38, 0x39, 0x3A, 0x3B, 0x3C, /* 119 */
> > +	0x3D, 0x3E, 0x3F
> > +};
> 
> You might as well make this const also if poss.  It doesn't make much
> difference, apart from putting the table into write-protected
> memory.
> >
> > ...
> >
> > +int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
> > +				  const unsigned char *src, size_t src_size)
> > +{
> > +	u8 current_bit_offset = 0;
> > +	size_t src_byte_offset = 0;
> > +	size_t dst_byte_offset = 0;
> > +	int rc = 0;
> > +
> > +	if (dst == NULL) {
> > +		/* Not exact; conservatively long */
> > +		(*dst_size) = (((src_size + 1) * 3) / 4);
> 
> Are you sure about that?  The destination will be 0.75 times as long
> as the source?  Seems risky.
> 
> What's this code doing anyway?  At a guess, I'd say that it's a
> special mode to this function which provides the caller with an
> estimate of how much storage needs to be allocated to decode *src.
> Or maybe that guess was completely wrong.  A comment is needed,
> methinks.

Flesh out the comments for ecryptfs_decode_from_filename(). Remove the
return condition, since it is always 0.

Signed-off-by: Michael Halcrow <mhalcrow@us.ibm.com>
---
 fs/ecryptfs/crypto.c |   51 +++++++++++++++++++++++--------------------------
 1 files changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/ecryptfs/crypto.c b/fs/ecryptfs/crypto.c
index e935a22..c01e043 100644
--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1931,7 +1931,7 @@ static unsigned char *portable_filename_chars = ("-.0123456789ABCD"
 
 /* We could either offset on every reverse map or just pad some 0x00's
  * at the front here */
-static unsigned char filename_rev_map[] = {
+static const unsigned char filename_rev_map[] = {
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 7 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 15 */
 	0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, /* 23 */
@@ -2012,16 +2012,30 @@ out:
 	return;
 }
 
-int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
-				  const unsigned char *src, size_t src_size)
+/**
+ * ecryptfs_decode_from_filename
+ * @dst: If NULL, this function only sets @dst_size and returns. If
+ *       non-NULL, this function decodes the encoded octets in @src
+ *       into the memory that @dst points to.
+ * @dst_size: Set to the size of the decoded string.
+ * @src: The encoded set of octets to decode.
+ * @src_size: The size of the encoded set of octets to decode.
+ */
+static void
+ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
+			      const unsigned char *src, size_t src_size)
 {
 	u8 current_bit_offset = 0;
 	size_t src_byte_offset = 0;
 	size_t dst_byte_offset = 0;
-	int rc = 0;
 
 	if (dst == NULL) {
-		/* Not exact; conservatively long */
+		/* Not exact; conservatively long. Every block of 4
+		 * encoded characters decodes into a block of 3
+		 * decoded characters. This segment of code provides
+		 * the caller with the maximum amount of allocated
+		 * space that @dst will need to point to in a
+		 * subsequent call. */
 		(*dst_size) = (((src_size + 1) * 3) / 4);
 		goto out;
 	}
@@ -2055,7 +2069,7 @@ int ecryptfs_decode_from_filename(unsigned char *dst, size_t *dst_size,
 	}
 	(*dst_size) = dst_byte_offset;
 out:
-	return rc;
+	return;
 }
 
 /**
@@ -2208,16 +2222,8 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 
 		name += ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
 		name_size -= ECRYPTFS_FNEK_ENCRYPTED_FILENAME_PREFIX_SIZE;
-		rc = ecryptfs_decode_from_filename(NULL, &decoded_name_size,
-						   name, name_size);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to decode "
-			       "filename; rc = [%d]\n", __func__, rc);
-			rc = ecryptfs_copy_filename(plaintext_name,
-						    plaintext_name_size,
-						    orig_name, orig_name_size);
-			goto out;
-		}
+		ecryptfs_decode_from_filename(NULL, &decoded_name_size,
+					      name, name_size);
 		decoded_name = kmalloc(decoded_name_size, GFP_KERNEL);
 		if (!decoded_name) {
 			printk(KERN_ERR "%s: Out of memory whilst attempting "
@@ -2226,17 +2232,8 @@ int ecryptfs_decode_and_decrypt_filename(char **plaintext_name,
 			rc = -ENOMEM;
 			goto out;
 		}
-		rc = ecryptfs_decode_from_filename(decoded_name,
-						   &decoded_name_size,
-						   name, name_size);
-		if (rc) {
-			printk(KERN_ERR "%s: Error attempting to decode "
-			       "filename; rc = [%d]\n", __func__, rc);
-			rc = ecryptfs_copy_filename(plaintext_name,
-						    plaintext_name_size,
-						    orig_name, orig_name_size);
-			goto out_free;
-		}
+		ecryptfs_decode_from_filename(decoded_name, &decoded_name_size,
+					      name, name_size);
 		rc = ecryptfs_parse_tag_70_packet(plaintext_name,
 						  plaintext_name_size,
 						  &packet_size,
-- 
1.5.3.7

