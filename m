Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbXLTNgD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbXLTNgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:36:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762007AbXLTNe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:34:28 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58936 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761867AbXLTNe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:34:27 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 05/16] make write() operation smp aware
Date: Thu, 20 Dec 2007 11:33:45 -0200
Message-Id: <11981576632726-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11981576581695-git-send-email-gcosta@redhat.com>
References: <11981576363806-git-send-email-gcosta@redhat.com> <11981576442148-git-send-email-gcosta@redhat.com> <11981576492807-git-send-email-gcosta@redhat.com> <1198157654189-git-send-email-gcosta@redhat.com> <11981576581695-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the write() file operation smp aware. Which means, receiving
the vcpu_id value through the offset parameter, and being well aware to which
vcpu we're talking to.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lguest_user.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 894d530..ae5bf4c 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -223,14 +223,21 @@ static ssize_t write(struct file *file, const char __user *in,
 	struct lguest *lg = file->private_data;
 	const unsigned long __user *input = (const unsigned long __user *)in;
 	unsigned long req;
+	struct lguest_vcpu *vcpu = NULL;
+	int vcpu_id = *off;
 
 	if (get_user(req, input) != 0)
 		return -EFAULT;
 	input++;
 
 	/* If you haven't initialized, you must do that first. */
-	if (req != LHREQ_INITIALIZE && !lg)
-		return -EINVAL;
+	if (req != LHREQ_INITIALIZE) {
+		if (!lg)
+			return -EINVAL;
+		vcpu = &lg->vcpus[vcpu_id];
+		if (!vcpu)
+			return -EINVAL;
+	}
 
 	/* Once the Guest is dead, all you can do is read() why it died. */
 	if (lg && lg->dead)
-- 
1.5.0.6

