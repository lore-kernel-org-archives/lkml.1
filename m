Return-Path: <linux-kernel-owner+w=401wt.eu-S1754984AbZGUOnO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbZGUOnO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 10:43:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZGUOnM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 10:43:12 -0400
Received: from mx2.redhat.com ([66.187.237.31]:47444 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752857AbZGUOnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 10:43:02 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/2] SELinux: selinux_file_mmap always enforce mapping the 0
	page
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org
Cc: sds@tycho.nsa.gov, jmorris@namei.org, spender@grsecurity.net,
       dwalsh@redhat.com, cl@linux-foundation.org, arjan@infradead.org,
       alan@lxorguk.ukuu.org.uk, kyle@mcmartin.ca, cpardy@redhat.com,
       arnd@arndb.de
Date: Tue, 21 Jul 2009 10:42:04 -0400
Message-ID: <20090721144204.14159.30971.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
References: <20090721144157.14159.23439.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently SELinux enforcement of controls on the ability to map the 0 page
is determined by the mmap_min_addr tunable.  This patch causes SELinux to
ignore the tunable and to always (but ONLY) protect the 0 page.

The tunable will now only control the need for CAP_SYS_RAWIO and SELinux
permissions will always protect the 0 page based on it's mmap_zero
permission.

This allows users who need to disable the mmap_min_addr controls (usual reason
being they run WINE as a non-root user) to do so and still have SELinux
controls preventing confined domains (like a web server) from being able to
map the 0 page.

Note: the additional SELinux restriction will now ONLY protect the 0 page.
CAP_SYS_RAWIO will protect anything between 0 and mmap_min_addr, but SELinux
will only protect between 0 and PAGE_SIZE.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/security.h |    1 -
 security/selinux/hooks.c |    2 +-
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/security.h b/include/linux/security.h
index f7d198a..de774f7 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -91,7 +91,6 @@ struct seq_file;
 extern int cap_netlink_send(struct sock *sk, struct sk_buff *skb);
 extern int cap_netlink_recv(struct sk_buff *skb, int cap);
 
-extern unsigned long mmap_min_addr;
 /*
  * Values used in the task_security_ops calls
  */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index e65677d..7bbac1d 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -3034,7 +3034,7 @@ static int selinux_file_mmap(struct file *file, unsigned long reqprot,
 	int rc = 0;
 	u32 sid = current_sid();
 
-	if (addr < mmap_min_addr)
+	if (addr < PAGE_SIZE)
 		rc = avc_has_perm(sid, sid, SECCLASS_MEMPROTECT,
 				  MEMPROTECT__MMAP_ZERO, NULL);
 	if (rc || addr_only)

