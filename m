Return-Path: <linux-kernel-owner+w=401wt.eu-S1764101AbXF1Pky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764101AbXF1Pky (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 11:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757903AbXF1Pkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 11:40:43 -0400
Received: from mail6.sea5.speakeasy.net ([69.17.117.8]:33526 "EHLO
	mail6.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289AbXF1Pkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 11:40:43 -0400
Date: Thu, 28 Jun 2007 11:40:39 -0400 (EDT)
From: James Morris <jmorris@namei.org>
X-X-Sender: jmorris@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] selinux: don't enable minimum mmap checking by default
In-Reply-To: <20070628012749.caf450f6.akpm@linux-foundation.org>
Message-ID: <Line.LNX.4.64.0706281139010.13114@localhost.localdomain>
References: <20070622203822.GA22807@linux-os.sc.intel.com>
 <20070628001221.364438ce.akpm@linux-foundation.org>
 <20070628012749.caf450f6.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Don't enable minimum mmap checking by default in SELinux, as it may break
existing applications which do not have updated policy.

We will be able to enable it by default later, once we have code to handle
new permissions which are not present in the user's policy.

Signed-off-by: James Morris <jmorris@namei.org>
---

This is an updated version of the patch, essentially a reverting an 
earlier patch which I'll drop once this are settles down.


 security/selinux/hooks.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 4b0ecfd..8575555 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -112,9 +112,6 @@ int selinux_enabled = 1;
 /* Original (dummy) security module. */
 static struct security_operations *original_ops = NULL;
 
-/* Did we enable minimum mmap address checking? */
-static int enabled_mmap_min_addr;
-
 /* Minimal support for a secondary security module,
    just to allow the use of the dummy or capability modules.
    The owlsm module can alternatively be used as a secondary
@@ -4917,15 +4914,6 @@ static __init int selinux_init(void)
 					    sizeof(struct inode_security_struct),
 					    0, SLAB_PANIC, NULL, NULL);
 
-	/*
-	 * Tasks cannot mmap below this without the mmap_zero permission.
-	 * If not enabled already, do so by setting it to 64KB.
-	 */
-	if (mmap_min_addr == 0) {
-		enabled_mmap_min_addr = 1;
-		mmap_min_addr = 65536;
-	}
-
 	avc_init();
 
 	original_ops = secondary_ops = security_ops;
@@ -5076,10 +5064,6 @@ int selinux_disable(void)
 	selinux_disabled = 1;
 	selinux_enabled = 0;
 
-	/* Disable minimum mmap address check only if we enabled it */
-	if (enabled_mmap_min_addr)
-		mmap_min_addr = 0;
-
 	/* Reset security_ops to the secondary module, dummy or capability. */
 	security_ops = secondary_ops;
 
-- 
1.5.0.6

