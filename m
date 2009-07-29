Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbZG2S5L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbZG2S5L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 14:57:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753710AbZG2S5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 14:57:09 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46056 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753516AbZG2S5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 14:57:04 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 2/3] SELinux: call cap_file_mmap in selinux_file_mmap
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
       selinux@tycho.nsa.gov
Cc: jwcart2@tycho.nsa.gov, eparis@redhat.com, sds@tycho.nsa.gov,
       spender@grsecurity.net, dwalsh@redhat.com, cl@linux-foundation.org,
       arjan@infradead.org, alan@lxorguk.ukuu.org.uk, kees@outflux.net,
       csellers@tresys.com, penguin-kernel@i-love.sakura.ne.jp
Date: Wed, 29 Jul 2009 14:56:27 -0400
Message-ID: <20090729185627.21757.92301.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
References: <20090729185620.21757.44366.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently SELinux does not check CAP_SYS_RAWIO in the file_mmap hook.  This
means there is no DAC check on the ability to mmap low addresses in the
memory space.  This function adds the DAC check for CAP_SYS_RAWIO while
maintaining the selinux check on mmap_zero.  This means that processes
which need to mmap low memory will need CAP_SYS_RAWIO and mmap_zero but will
NOT need the SELinux sys_rawio capability.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/selinux/hooks.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e65677d..8a78f58 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3034,9 +3034,21 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	int rc = 0;
 	u32 sid = current_sid();
 
-	if (addr < mmap_min_addr)
+	/*
+	 * notice that we are intentionally putting the SELinux check before
+	 * the secondary cap_file_mmap check.  This is such a likely attempt
+	 * at bad behaviour/exploit that we always want to get the AVC, even
+	 * if DAC would have also denied the operation.
+	 */
+	if (addr < mmap_min_addr) {
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
+		if (rc)
+			return rc;
+	}
+
+	/* do DAC check on address space usage */
+	rc = cap_file_mmap(file, reqprot, prot, flags, addr, addr_only);
 	if (rc || addr_only)
 		return rc;
 

