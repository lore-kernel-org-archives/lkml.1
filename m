Return-Path: <linux-kernel-owner+w=401wt.eu-S1753969AbYGGQwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbYGGQwS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754540AbYGGQuH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:07 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754421AbYGGQuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:06 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 13/20] SELinux: fix off by 1 reference of class_to_string in context_struct_compute_av
Date: Tue,  8 Jul 2008 01:42:15 +0900
Message-Id: <1215448942-17581-14-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

The class_to_string array is referenced by tclass.  My code mistakenly
was using tclass - 1.  If the proceeding class is a userspace class
rather than kernel class this may cause a denial/EINVAL even if unknown
handling is set to allow.  The bug shouldn't be allowing excess
privileges since those are given based on the contents of another array
which should be correctly referenced.

At this point in time its pretty unlikely this is going to cause
problems.  The most recently added kernel classes which could be
affected are association, dccp_socket, and peer.  Its pretty unlikely
any policy with handle_unknown=allow doesn't have association and
dccp_socket undefined (they've been around longer than unknown handling)
and peer is conditionalized on a policy cap which should only be defined
if that class exists in policy.

Signed-off-by: Eric Paris <eparis@redhat.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
Signed-off-by: James Morris <jmorris@namei.org>
---
 security/selinux/ss/services.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index d06df33..f26a8ca 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -325,7 +325,7 @@ static int context_struct_compute_av(struct context *scontext,
 		goto inval_class;
 	if (unlikely(tclass > policydb.p_classes.nprim))
 		if (tclass > kdefs->cts_len ||
-		    !kdefs->class_to_string[tclass - 1] ||
+		    !kdefs->class_to_string[tclass] ||
 		    !policydb.allow_unknown)
 			goto inval_class;
 
-- 
1.5.5.1

