Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab0BNRhb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 12:37:31 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:34734 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0BNRha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 12:37:30 -0500
Date: Sun, 14 Feb 2010 09:37:30 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       Alexander Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH tip/core/rcu 07/13] vfs: apply lockdep-based checking
	to rcu_dereference() uses
Message-ID: <20100214173730.GM7084@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100212000016.GA25781@linux.vnet.ibm.com> <1265932839-25899-7-git-send-email-paulmck@linux.vnet.ibm.com> <1266142330.5273.414.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266142330.5273.414.camel@laptop>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 14, 2010 at 11:12:10AM +0100, Peter Zijlstra wrote:
> On Thu, 2010-02-11 at 16:00 -0800, Paul E. McKenney wrote:
> > 
> > -#define files_fdtable(files) (rcu_dereference((files)->fdt))
> > +#define files_fdtable(files) \
> > +       (rcu_dereference_check((files)->fdt, \
> > +                              rcu_read_lock_held() || \
> > +                              lockdep_is_held(&(files)->file_lock) ||
> > \
> > +                              atomic_read(&files->count) == 1))
> >  
> >  struct file_operations;
> >  struct vfsmount;
> > @@ -78,7 +82,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
> >         struct fdtable *fdt = files_fdtable(files);
> >  
> >         if (fd < fdt->max_fds)
> > -               file = rcu_dereference(fdt->fd[fd]);
> > +               file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock) || atomic_read(&files->count) == 1);
> >         return file; 
> 
> I'm almost thinking you can do something smart here and not replicate
> that condition :-)

;-)

How about like the following?  If this is agreeable, I will re-send the
patch stack with this included.

							Thanx, Paul

------------------------------------------------------------------------

vfs: abstract rcu_dereference_check for files-fdtable use

Create an rcu_dereference_check_fdtable() that encapsulates the
rcu_dereference_check() condition for fcheck_files() use.  This has
the beneficial side-effect of getting rid of a very long line.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 144412f..013dc52 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,11 +57,14 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define files_fdtable(files) \
-	(rcu_dereference_check((files)->fdt, \
+#define rcu_dereference_check_fdtable(files, fdtfd) \
+	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&files->count) == 1))
+			       atomic_read(&(files)->count) == 1))
+
+#define files_fdtable(files) \
+		(rcu_dereference_check_fdtable((files), (files)->fdt))
 
 struct file_operations;
 struct vfsmount;
@@ -82,7 +85,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock) || atomic_read(&files->count) == 1);
+		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
 	return file;
 }
 
