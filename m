Return-Path: <linux-kernel-owner+w=401wt.eu-S1753323AbZKVKa5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753323AbZKVKa5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 05:30:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752206AbZKVKa4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 05:30:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19762 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZKVKaz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 05:30:55 -0500
Date: Sun, 22 Nov 2009 12:28:01 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>,
       virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vhost: Fix warnings and bad type handling
Message-ID: <20091122102801.GA13644@redhat.com>
References: <20091117154213.3683.94554.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091117154213.3683.94554.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH] vhost: fix warnings on 32 bit systems

Fix compiler warning about discarding top 32 bit
of data on 32 bit systems, and document that
dicarded bits must be 0.

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

So I think the below slightly tweaked version of
Alan's patch is a bit better. OK?

 drivers/vhost/vhost.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 97233d5..e7b4dea 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -322,6 +322,8 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EOPNOTSUPP;
 			break;
 		}
+		/* For 32bit, verify that the top 32bits of the user
+		   data are set to zero. */
 		if ((u64)(unsigned long)a.desc_user_addr != a.desc_user_addr ||
 		    (u64)(unsigned long)a.used_user_addr != a.used_user_addr ||
 		    (u64)(unsigned long)a.avail_user_addr != a.avail_user_addr) {
@@ -334,7 +336,8 @@ static long vhost_set_vring(struct vhost_dev *d, int ioctl, void __user *argp)
 			r = -EINVAL;
 			break;
 		}
-		r = init_used(vq, (struct vring_used __user *)a.used_user_addr);
+		r = init_used(vq, (struct vring_used __user *)(unsigned long)
+			      a.used_user_addr);
 		if (r)
 			break;
 		vq->log_used = !!(a.flags & (0x1 << VHOST_VRING_F_LOG));
-- 
1.6.5.2.143.g8cc62

