Return-Path: <linux-kernel-owner+w=401wt.eu-S1759013AbYAXUp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759013AbYAXUp6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2008 15:45:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758359AbYAXUjj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jan 2008 15:39:39 -0500
Received: from mummy.ncsc.mil ([144.51.88.129]:60671 "EHLO mummy.ncsc.mil"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758892AbYAXUji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2008 15:39:38 -0500
X-Greylist: delayed 519 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jan 2008 15:39:38 EST
Message-ID: <4798F57C.8090300@tycho.nsa.gov>
Date: Thu, 24 Jan 2008 15:30:52 -0500
From: Eamon Walsh <ewalsh@tycho.nsa.gov>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: SELinux List <selinux@tycho.nsa.gov>
CC: linux-kernel@vger.kernel.org, James Morris <jmorris@namei.org>,
       Stephen Smalley <sds@tycho.nsa.gov>
Subject: [PATCH] selinux: make mls_compute_sid always polyinstantiate
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes the requirement that the new and related object types 
differ in order to polyinstantiate by MLS level.  This allows MLS 
polyinstantiation to occur in the absence of explicit type_member rules 
or when the type has not changed.

Potential users of this support include pam_namespace.so (directory 
polyinstantiation) and the SELinux X support (property polyinstantiation).

Signed-off-by: Eamon Walsh <ewalsh@tycho.nsa.gov>
---

 mls.c |   11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)


diff --git a/security/selinux/ss/mls.c b/security/selinux/ss/mls.c
index fb5d70a..3bbcb53 100644
--- a/security/selinux/ss/mls.c
+++ b/security/selinux/ss/mls.c
@@ -537,15 +537,8 @@ int mls_compute_sid(struct context *scontext,
 			/* Use the process effective MLS attributes. */
 			return mls_context_cpy_low(newcontext, scontext);
 	case AVTAB_MEMBER:
-		/* Only polyinstantiate the MLS attributes if
-		   the type is being polyinstantiated */
-		if (newcontext->type != tcontext->type) {
-			/* Use the process effective MLS attributes. */
-			return mls_context_cpy_low(newcontext, scontext);
-		} else {
-			/* Use the related object MLS attributes. */
-			return mls_context_cpy(newcontext, tcontext);
-		}
+		/* Use the process effective MLS attributes. */
+		return mls_context_cpy_low(newcontext, scontext);
 	default:
 		return -EINVAL;
 	}



-- 
Eamon Walsh <ewalsh@tycho.nsa.gov>
National Security Agency

