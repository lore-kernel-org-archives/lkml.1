Return-Path: <linux-kernel-owner+w=401wt.eu-S938651AbXFHTnG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938651AbXFHTnG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 15:43:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXFHTmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 15:42:53 -0400
Received: from smtp113.sbc.mail.re2.yahoo.com ([68.142.229.92]:39387 "HELO
	smtp113.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751315AbXFHTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 15:42:52 -0400
X-YMail-OSG: SAGvk58VM1lZInkZvLwGwe7xG5YMKl3.gawT3C3hERyjoBPDRbEt0UOYItVeoAEd...VISQaLGlmNzBmtLF.jMFYF7TOie2M8MpxvhJ.HYsocLoNPCxtAT0AFPUE5w7ZX1ERvSmE.6rFuA--
Date: Fri, 8 Jun 2007 14:42:47 -0500
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Paul Menage <menage@google.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, "Serge E. Hallyn" <serge@hallyn.com>,
       Paul Jackson <pj@sgi.com>, vatsa@in.ibm.com,
       ckrm-tech@lists.sourceforge.net, balbir@in.ibm.com,
       rohitseth@google.com, haveblue@us.ibm.com, xemul@sw.ru, dev@sw.ru,
       containers@lists.osdl.org, devel@openvz.org, ebiederm@xmission.com,
       mbligh@google.com, cpw@sgi.com, svaidy@linux.vnet.ibm.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [ckrm-tech] [PATCH 00/10] Containers(V10): Generic Process Containers
Message-ID: <20070608194247.GA12671@vino.hallyn.com>
References: <20070607180158.GA936@sergelap.austin.ibm.com> <20070607122121.24fe6ff4.pj@sgi.com> <20070607201723.GA17011@sergelap.austin.ibm.com> <20070607150113.f020d8f8.pj@sgi.com> <20070608143250.GA7728@vino.hallyn.com> <6599ad830706080855n22612814u4805d34a295b165f@mail.gmail.com> <20070608160840.GA11133@vino.hallyn.com> <6599ad830706080916j477e08c0l8b142d9a0d832c76@mail.gmail.com> <20070608180837.GA5683@sergelap.austin.ibm.com> <6599ad830706081113g56e755c6vc5cd0fbd5c15697@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830706081113g56e755c6vc5cd0fbd5c15697@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Paul Menage (menage@google.com):
> On 6/8/07, Serge E. Hallyn <serue@us.ibm.com> wrote:
> >
> >I do fear that that could become a maintenance nightmare.  For instance
> >right now there's the call to fsnotify_mkdir().  Other such hooks might
> >be placed at vfs_mkdir, which we'd then likely want to have placed in
> >our container_mkdir() and container_clone() fns.  And of course
> >may_create() is static inline in fs/namei.c.  It's trivial, but still if
> >it changes we'd want to change the version in kernel/container.c as
> >well.
> 
> Do we need to actually need to respect may_create() in
> container_clone()? I guess it would provide a way for root to control
> which processes could unshare namespaces.
> 
> >
> >What would be the main advantage of doing it this way?  Do you consider
> >the extra subys->auto_setup() hook to be avoidable bloat?
> >
> 
> I was thinking that it would be nice to be able to atomically set up
> the resources in the new container at the point when it's created
> rather than later. But I guess this way can work too. Can we call it
> something like "clone()" rather than "auto_setup()"?
> 
> Paul

clone() implies it does the actual cloning, so how about post_clone()
as in the patch below?

I'm still not saying I'm entirely opposed to moving the vfs_mkdir logic
straight into container_clone() - it's more that I would expect other
people to object when they saw that.  So if you decide you don't like
the end result with this patch, let me know and I'll give that a shot.

Paul (Jackson), is this comment added in cpusets close enough to what
you were asking for?

thanks,
-serge

>From c2f1a39b231f06cb524c6e95d74de6ddee286f25 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Fri, 8 Jun 2007 15:36:59 -0400
Subject: [PATCH 4/4] containers: minor clone cleanup

rename auto_setup() to post_clone(), and comment the cpusets version.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 Documentation/containers.txt |   10 +++++-----
 include/linux/container.h    |    2 +-
 kernel/container.c           |    4 ++--
 kernel/cpuset.c              |   20 ++++++++++++++++++--
 4 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/Documentation/containers.txt b/Documentation/containers.txt
index 28c9e10..9fdb808 100644
--- a/Documentation/containers.txt
+++ b/Documentation/containers.txt
@@ -514,12 +514,12 @@ include/linux/container.h for details).  Note that although this
 method can return an error code, the error code is currently not
 always handled well.
 
-void auto_setup(struct container_subsys *ss, struct container *cont)
+void post_clone(struct container_subsys *ss, struct container *cont)
 
-Called at container_clone() to do any paramater initialization
-which might be required before a task could attach.  For example
-in cpusets, no task may attach before 'cpus' and 'mems' are
-set up.
+Called at the end of container_clone() to do any paramater
+initialization which might be required before a task could attach.  For
+example in cpusets, no task may attach before 'cpus' and 'mems' are set
+up.
 
 void bind(struct container_subsys *ss, struct container *root)
 LL=callback_mutex
diff --git a/include/linux/container.h b/include/linux/container.h
index d809b41..1a83913 100644
--- a/include/linux/container.h
+++ b/include/linux/container.h
@@ -213,7 +213,7 @@ struct container_subsys {
 	void (*exit)(struct container_subsys *ss, struct task_struct *task);
 	int (*populate)(struct container_subsys *ss,
 			struct container *cont);
-	void (*auto_setup)(struct container_subsys *ss, struct container *cont);
+	void (*post_clone)(struct container_subsys *ss, struct container *cont);
 	void (*bind)(struct container_subsys *ss, struct container *root);
 	int subsys_id;
 	int active;
diff --git a/kernel/container.c b/kernel/container.c
index e0793f4..11e326a 100644
--- a/kernel/container.c
+++ b/kernel/container.c
@@ -2400,8 +2400,8 @@ int container_clone(struct task_struct *tsk, struct container_subsys *subsys)
 
 	/* do any required auto-setup */
 	for_each_subsys(root, ss) {
-		if (ss->auto_setup)
-			ss->auto_setup(ss, child);
+		if (ss->post_clone)
+			ss->post_clone(ss, child);
 	}
 
 	/* All seems fine. Finish by moving the task into the new container */
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index ff01aaa..ecefb1d 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1189,7 +1189,23 @@ int cpuset_populate(struct container_subsys *ss, struct container *cont)
 	return 0;
 }
 
-void cpuset_auto_setup(struct container_subsys *ss,
+/*
+ * post_clone() is called at the end of container_clone().
+ * 'container' was just created automatically as a result of
+ * a container_clone(), and the current task is about to
+ * be moved into 'container'.
+ *
+ * Currently we refuse to set up the container - thereby
+ * refusing the task to be entered, and as a result refusing
+ * the sys_unshare() or clone() which initiated it - if any
+ * sibling cpusets have exclusive cpus or mem.
+ *
+ * If this becomes a problem for some users who wish to
+ * allow that scenario, then cpuset_post_clone() could be
+ * changed to grant parent->cpus_allowed-sibling_cpus_exclusive
+ * (and likewise for mems) to the new container.
+ */
+void cpuset_post_clone(struct container_subsys *ss,
 		struct container *container)
 {
 	struct container *parent, *child;
@@ -1269,7 +1285,7 @@ struct container_subsys cpuset_subsys = {
 	.can_attach = cpuset_can_attach,
 	.attach = cpuset_attach,
 	.populate = cpuset_populate,
-	.auto_setup = cpuset_auto_setup,
+	.post_clone = cpuset_post_clone,
 	.subsys_id = cpuset_subsys_id,
 	.early_init = 1,
 };
-- 
1.5.1.1.GIT

