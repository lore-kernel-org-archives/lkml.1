Return-Path: <linux-kernel-owner+w=401wt.eu-S1161177AbXAZS6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161177AbXAZS6c (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 13:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161180AbXAZS6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 13:58:32 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:55203 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161177AbXAZS6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 13:58:30 -0500
Date: Fri, 26 Jan 2007 12:58:22 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, clg@fr.ibm.com, herbert@13thfloor.at,
       oleg@tv-sign.ru, daniel@hozac.com
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
Message-ID: <20070126185822.GA18361@sergelap.austin.ibm.com>
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <45BA3A8C.5020802@googlemail.com> <20070126181437.GA28927@sergelap.austin.ibm.com> <6bffcb0e0701261022m5996540cyb75a2214328116fe@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bffcb0e0701261022m5996540cyb75a2214328116fe@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Michal Piotrowski (michal.k.k.piotrowski@gmail.com):
> On 26/01/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >Can you send me your series file for broken-out-2007-01-26-00-36.tar.gz,
> >and I'll try to iron these out?  This is due to an older patch of
> >Cedric's being applied at the same time as the preexit_task_namespaces
> >one, and I just need to properly integrate them.
> 
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-2007-01-26-00-36.tar.gz
> 
> Series file is in the archive, but not in broken-out dir as usually.

Ah!  Sorry.

Ok, this patch should hopefully resolve the conflict between the two
patches, however I can't compile due to some noisy atomic64_xchg
problem and a few other failures.

-serge

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] namespaces: resolve conflicts between two patches

Two patches affecting nsproxy conflicted preventing compilation.
Hopefully this resolves all the problems.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/nsproxy.h |    8 ++------
 kernel/nsproxy.c        |    5 +++++
 2 files changed, 7 insertions(+), 6 deletions(-)

300377d87b9889b5c2f5822bfb458f00ef3addd5
diff --git a/include/linux/nsproxy.h b/include/linux/nsproxy.h
index 45f68de..d519290 100644
--- a/include/linux/nsproxy.h
+++ b/include/linux/nsproxy.h
@@ -51,11 +51,7 @@ static inline void put_and_finalize_nspr
 	finalize_put_nsproxy(put_nsproxy(ns));
 }
 
-static inline struct nsproxy *preexit_task_namespaces(struct task_struct *p)
-{
-	return put_nsproxy(p->nsproxy);
-}
-
-extern void exit_task_namespaces(struct task_struct *p);
+extern struct nsproxy *preexit_task_namespaces(struct task_struct *p);
+extern void exit_task_namespaces(struct task_struct *p, struct nsproxy *ns);
 
 #endif
diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index afdb9fb..bbe94df 100644
--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -167,6 +167,11 @@ struct nsproxy *put_nsproxy(struct nspro
 	return NULL;
 }
 
+struct nsproxy *preexit_task_namespaces(struct task_struct *p)
+{
+	return put_nsproxy(p->nsproxy);
+}
+
 void free_nsproxy(struct nsproxy *ns)
 {
 	if (ns->mnt_ns)
-- 
1.1.6
