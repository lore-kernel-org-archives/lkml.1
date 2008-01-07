Return-Path: <linux-kernel-owner+w=401wt.eu-S1757867AbYAGNGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867AbYAGNGr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 08:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbYAGNGS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 08:06:18 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33162 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757270AbYAGNGR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 08:06:17 -0500
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: lguest@ozlabs.org
Cc: glommer@gmail.com, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, rusty@rustcorp.com.au,
       rostedt@goodmis.org, Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: [PATCH 03/16] initialize vcpu
Date: Mon,  7 Jan 2008 11:05:24 -0200
Message-Id: <11997111523234-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <11997111481113-git-send-email-gcosta@redhat.com>
References: 11981576363806-git-send-email-gcosta@redhat.com <1199711137195-git-send-email-gcosta@redhat.com> <11997111432356-git-send-email-gcosta@redhat.com> <11997111481113-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch initializes the first vcpu in the initialize() routing,
which is responsible for starting the process of putting the guest up.
right now, as much of the fields are still not per-vcpu, it does not
do much.

Signed-off-by: Glauber de Oliveira Costa <gcosta@redhat.com>
---
 drivers/lguest/lguest_user.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/lguest/lguest_user.c b/drivers/lguest/lguest_user.c
index 3b92a61..34be8e7 100644
--- a/drivers/lguest/lguest_user.c
+++ b/drivers/lguest/lguest_user.c
@@ -88,6 +88,20 @@ static ssize_t read(struct file *file, char __user *user, size_t size,loff_t*o)
 	return run_guest(lg, (unsigned long __user *)user);
 }
 
+static int vcpu_start(struct lg_vcpu *vcpu, int vcpu_id,
+		      unsigned long start_ip)
+{
+	if (vcpu_id > NR_CPUS)
+		return -EINVAL;
+
+	vcpu->vcpu_id = vcpu_id;
+
+	vcpu->lg = container_of((vcpu - vcpu_id), struct lguest, vcpus[0]);
+	vcpu->lg->nr_vcpus++;
+
+	return 0;
+}
+
 /*L:020 The initialization write supplies 4 pointer sized (32 or 64 bit)
  * values (in addition to the LHREQ_INITIALIZE value).  These are:
  *
@@ -134,6 +148,12 @@ static int initialize(struct file *file, const unsigned long __user *input)
 	lg->mem_base = (void __user *)(long)args[0];
 	lg->pfn_limit = args[1];
 
+	/* This is the first cpu */
+	lg->nr_vcpus = 0;
+	err = vcpu_start(&lg->vcpus[0], 0, args[3]);
+	if (err)
+		goto release_guest;
+
 	/* We need a complete page for the Guest registers: they are accessible
 	 * to the Guest and we can only grant it access to whole pages. */
 	lg->regs_page = get_zeroed_page(GFP_KERNEL);
-- 
1.5.0.6

