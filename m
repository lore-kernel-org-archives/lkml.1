Return-Path: <linux-kernel-owner+w=401wt.eu-S1751773AbXCYQQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773AbXCYQQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 12:16:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbXCYQQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 12:16:51 -0400
Received: from smtp110.sbc.mail.mud.yahoo.com ([68.142.198.209]:32895 "HELO
	smtp110.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751773AbXCYQQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 12:16:50 -0400
X-YMail-OSG: _IbbtxIVM1m0ZNPZExj3QmZUf5A9jsaQKPZizyUERoZHc.vRziC53Qew8N2CTJKfIHXMWB_FAFmhxXxsTZFye8XIEfsvaZbZRcxFLNdeTe.d6IwnzW8pzMsZuKQCsVF45OLr4TuTuw9irpF5FrgcrfwQU_ff.Q9x5B5TFsAxYJzw294_t.6l
Date: Sun, 25 Mar 2007 11:16:47 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] utsns: fix !CONFIG_UTS_NS behavior
Message-ID: <20070325161647.GA6753@vino.hallyn.com>
References: <20070323200039.GA15775@sergelap.austin.ibm.com> <20070325010709.5d801f1c.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325010709.5d801f1c.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Andrew Morton (akpm@linux-foundation.org):
> On Fri, 23 Mar 2007 15:00:39 -0500 "Serge E. Hallyn" <serue@us.ibm.com> wrote:
> 
> > When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
> > not unshare a new uts namespace, but also does not return -EINVAL.
> > 
> > Fix this to return -EINVAL so the caller knows his request was denied.
> > 
> > Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
> > 
> > ---
> > 
> >  include/linux/utsname.h |    2 ++
> >  1 files changed, 2 insertions(+), 0 deletions(-)
> > 
> > bc350994ac67df8f1b917f9979c065d87757eabe
> > diff --git a/include/linux/utsname.h b/include/linux/utsname.h
> > index a4555fe..e10267d 100644
> > --- a/include/linux/utsname.h
> > +++ b/include/linux/utsname.h
> > @@ -70,6 +70,8 @@ static inline int unshare_utsname(unsign
> >  
> >  static inline int copy_utsname(int flags, struct task_struct *tsk)
> >  {
> > +	if (flags & CLONE_NEWUTS)
> > +		return -EINVAL;
> >  	return 0;
> >  }
> >  static inline void put_uts_ns(struct uts_namespace *ns)
> 
> I'm assuming that this is 2.6.21 material.
> 
> Please review -mm's merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
> - it probably needs to propagate this fix.

Yes it does.  Here's a patch on top of 2.6.21-rc4-mm1.  (or do you prefer
I integrate it into merge-sys_clone-sys_unshare-nsproxy-and-namespace.patch
itself?)

From: "Serge E. Hallyn" <serge@vino.hallyn.com>
Subject: [PATCH] utsns [-mm]: fix !CONFIG_UTS_NS behavior

When CONFIG_UTS_NS=n, clone(CLONE_NEWUTS) quietly refuses.  So correctly does
not unshare a new uts namespace, but also does not return -EINVAL.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 arch/s390/boot/image    |  Bin
 include/linux/utsname.h |    3 +++
 2 files changed, 3 insertions(+), 0 deletions(-)

8b4ffb8d88f89f118751f05869613ee16d5c463f
diff --git a/arch/s390/boot/image b/arch/s390/boot/image
index da5b91f..2bab55e 100755
Binary files a/arch/s390/boot/image and b/arch/s390/boot/image differ
diff --git a/include/linux/utsname.h b/include/linux/utsname.h
index 528a071..d63cdd8 100644
--- a/include/linux/utsname.h
+++ b/include/linux/utsname.h
@@ -35,6 +35,7 @@ struct new_utsname {
 #include <linux/sched.h>
 #include <linux/kref.h>
 #include <linux/nsproxy.h>
+#include <linux/err.h>
 #include <asm/atomic.h>
 
 struct uts_namespace {
@@ -60,6 +61,8 @@ static inline void put_uts_ns(struct uts
 static inline struct uts_namespace *
 copy_utsname(int flags, struct uts_namespace *ns)
 {
+	if (flags & CLONE_NEWUTS)
+		return ERR_PTR(-EINVAL);
 	return ns;
 }
 static inline void put_uts_ns(struct uts_namespace *ns)
-- 
1.1.6
