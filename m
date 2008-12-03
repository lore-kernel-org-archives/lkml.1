Return-Path: <linux-kernel-owner+w=401wt.eu-S1753546AbYLCTRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbYLCTRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754656AbYLCTRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:17:39 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:60863 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbYLCTRh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:17:37 -0500
Date: Wed, 3 Dec 2008 13:17:33 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       David Howells <dhowells@redhat.com>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       James Morris <jmorris@namei.org>
Subject: [PATCH 2/2] user namespaces: require cap_set{ug}id for
	CLONE_NEWUSER
Message-ID: <20081203191733.GA16652@us.ibm.com>
References: <20081203191706.GA16433@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081203191706.GA16433@us.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While ideally CLONE_NEWUSER will eventually require no
privilege, the required permission checks are currently
not there.  As a result, CLONE_NEWUSER has the same effect
as a setuid(0)+setgroups(1,"0").  While we already require
CAP_SYS_ADMIN, requiring CAP_SETUID and CAP_SETGID seems
appropriate.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 kernel/fork.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 1dd8945..e3a85b3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1344,7 +1344,8 @@ long do_fork(unsigned long clone_flags,
 		/* hopefully this check will go away when userns support is
 		 * complete
 		 */
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SETUID) ||
+				!capable(CAP_SETGID))
 			return -EPERM;
 	}
 
-- 
1.5.4.3

