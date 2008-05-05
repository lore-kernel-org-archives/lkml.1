Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYEEATY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYEEATY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 20:19:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbYEEATK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 20:19:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753277AbYEEATJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 20:19:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Adrian Bunk <bunk@kernel.org>
Subject: Re: s390 kvm_virtio.c build error
Date: Mon, 5 May 2008 10:19:01 +1000
User-Agent: KMail/1.9.9
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Carsten Otte <cotte@de.ibm.com>, Avi Kivity <avi@qumranet.com>,
       kvm-devel@lists.sourceforge.net, linux-s390@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <20080503174716.GM5838@cs181133002.pp.htv.fi>
In-Reply-To: <20080503174716.GM5838@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805051019.02289.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 May 2008 03:47:17 Adrian Bunk wrote:
> Commit c45a6816c19dee67b8f725e6646d428901a6dc24
> (virtio: explicit advertisement of driver features)
> and commit e976a2b997fc4ad70ccc53acfe62811c4aaec851
> (s390: KVM guest: virtio device support, and kvm hypercalls)
> don't like each other:

Yep, I broke s390.  This was kind of expected, but I didn't want to try to
fix it as I am unable to test.

It would look something like this:

virtio: Attempt to fix kvm_virtio after feature management changes

Very similar to lguest code: set and get feature are now separate callbacks.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

diff -r 219d6c116996 drivers/s390/kvm/kvm_virtio.c
--- a/drivers/s390/kvm/kvm_virtio.c	Mon May 05 10:03:16 2008 +1000
+++ b/drivers/s390/kvm/kvm_virtio.c	Mon May 05 10:17:25 2008 +1000
@@ -78,27 +78,34 @@ static unsigned desc_size(const struct k
 		+ desc->config_len;
 }
 
-/*
- * This tests (and acknowleges) a feature bit.
- */
-static bool kvm_feature(struct virtio_device *vdev, unsigned fbit)
+/* This gets the device's feature bits. */
+static u32 kvm_get_features(struct virtio_device *vdev)
 {
+	unsigned int i;
+	u32 features = 0;
 	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
-	u8 *features;
+	u8 *in_features = kvm_vq_features(desc);
 
-	if (fbit / 8 > desc->feature_len)
-		return false;
+	/* We do this the slow but generic way. */
+	for (i = 0; i < min(desc->feature_len * 8, 32); i++)
+		if (in_features[i / 8] & (1 << (i % 8)))
+			features |= (1 << i);
 
-	features = kvm_vq_features(desc);
-	if (!(features[fbit / 8] & (1 << (fbit % 8))))
-		return false;
+	return features;
+}
 
-	/*
-	 * We set the matching bit in the other half of the bitmap to tell the
-	 * Host we want to use this feature.
-	 */
-	features[desc->feature_len + fbit / 8] |= (1 << (fbit % 8));
-	return true;
+static void kvm_set_features(struct virtio_device *vdev, u32 features)
+{
+	unsigned int i;
+	struct kvm_device_desc *desc = to_kvmdev(vdev)->desc;
+	/* Second half of bitmap is features we accept. */
+	u8 *out_features = kvm_vq_features(desc) + desc->feature_len;
+
+	memset(out_features, 0, desc->feature_len);
+	for (i = 0; i < min(desc->feature_len * 8, 32); i++) {
+		if (features & (1 << i))
+			out_features[i / 8] |= (1 << (i % 8));
+	}
 }
 
 /*
@@ -221,7 +228,8 @@ static void kvm_del_vq(struct virtqueue 
  * The config ops structure as defined by virtio config
  */
 static struct virtio_config_ops kvm_vq_configspace_ops = {
-	.feature = kvm_feature,
+	.get_features = kvm_get_features,
+	.set_features = kvm_set_features,
 	.get = kvm_get,
 	.set = kvm_set,
 	.get_status = kvm_get_status,
