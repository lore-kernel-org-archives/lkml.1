Return-Path: <linux-kernel-owner+w=401wt.eu-S1760085AbZCXNLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760085AbZCXNLk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 09:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755595AbZCXNLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 09:11:31 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:33704 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbZCXNLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 09:11:30 -0400
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, eduard.munteanu@linux360.ro,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090324130926.GA11358@x200.localdomain>
References: <1237884846.25315.37.camel@penberg-laptop>
	 <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop>
	 <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop>
	 <20090324091742.GB6605@elte.hu> <1237886559.25315.60.camel@penberg-laptop>
	 <20090324093103.GA19463@elte.hu> <1237887513.25315.65.camel@penberg-laptop>
	 <20090324095346.GB23208@elte.hu>  <20090324130926.GA11358@x200.localdomain>
Date: Tue, 24 Mar 2009 15:11:27 +0200
Message-Id: <1237900287.25315.86.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 16:09 +0300, Alexey Dobriyan wrote:
> On Tue, Mar 24, 2009 at 10:53:46AM +0100, Ingo Molnar wrote:
> > > -static inline char *alloc_secdata(void)
> > > -{
> > > -       return (char *)get_zeroed_page(GFP_KERNEL);
> > > -}
> > > -
> > > -static inline void free_secdata(void *secdata)
> > > -{
> > > -       free_page((unsigned long)secdata);
> > > -}
> > > +#define alloc_secdata() (char *)get_zeroed_page(GFP_KERNEL)
> > > +#define free_secdata()  free_page((unsigned long) secdata)
> > 
> > yep, that would be fine - but please add a comment about why they 
> > are macros and what would have to be done to fix it.
> 
> Nooo!
> 
> Stick it into security.h!

Something like this untested patch?

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 11fdc57..159f7b8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2230,24 +2230,6 @@ ssize_t simple_attr_read(struct file *file, char __user *buf,
 ssize_t simple_attr_write(struct file *file, const char __user *buf,
 			  size_t len, loff_t *ppos);
 
-
-#ifdef CONFIG_SECURITY
-/*
- * These need to be macros because we cannot include <linux/gfp.h> in this
- * header file.
- */
-#define alloc_secdata()       (char *)get_zeroed_page(GFP_KERNEL)
-#define free_secdata(secdata) free_page((unsigned long) secdata)
-#else
-static inline char *alloc_secdata(void)
-{
-	return (char *)1;
-}
-
-static inline void free_secdata(void *secdata)
-{ }
-#endif	/* CONFIG_SECURITY */
-
 struct ctl_table;
 int proc_nr_files(struct ctl_table *table, int write, struct file *filp,
 		  void __user *buffer, size_t *lenp, loff_t *ppos);
diff --git a/include/linux/security.h b/include/linux/security.h
index 1f2ab63..e3e2f8a 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -32,6 +32,7 @@
 #include <linux/sched.h>
 #include <linux/key.h>
 #include <linux/xfrm.h>
+#include <linux/gfp.h>
 #include <net/flow.h>
 
 /* Maximum number of letters for an LSM name string */
@@ -2966,5 +2967,28 @@ static inline void securityfs_remove(struct dentry *dentry)
 
 #endif
 
+#ifdef CONFIG_SECURITY
+
+static inline char *alloc_secdata(void)
+{
+	return (char *)get_zeroed_page(GFP_KERNEL);
+}
+
+static inline void free_secdata(void *secdata)
+{
+	free_page((unsigned long)secdata);
+}
+
+#else
+
+static inline char *alloc_secdata(void)
+{
+        return (char *)1;
+}
+
+static inline void free_secdata(void *secdata)
+{ }
+#endif /* CONFIG_SECURITY */
+
 #endif /* ! __LINUX_SECURITY_H */
 


