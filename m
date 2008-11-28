Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbYK1Bgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbYK1Bgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 20:36:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbYK1BgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 20:36:25 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:45206 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbYK1BgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 20:36:24 -0500
Date: Fri, 28 Nov 2008 10:35:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "menage@google.com" <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       taka@valinux.co.jp
Subject: Re: [RFC][PATCH 1/2] CGROUP ID and Hierarchy Code
Message-Id: <20081128103533.049f0b7b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <492F4941.2030707@cn.fujitsu.com>
References: <20081127160548.3274c8e6.kamezawa.hiroyu@jp.fujitsu.com>
	<492F4941.2030707@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2008 09:28:33 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > Patches for CGROUP ID and Hierarchy Code.
> > (based on mmotm Nov/24...I'll update later.)
> > 
> > CGROUP ID is a unique value for each cgroup (struct cgroup)
> > Hierarchy Code is array of CGROUP ID which contains all ID od ancestors.
> > and tries to remove cgroup_lock() to walk tree.
> > 
> > This is just an example-level patch but I'm now testing/refleshing this.
> > Works well with memcg's hierarchy relcaim.
> > Any comment is welcome.
> > 
> > -Kame
> > 
> > ==
> > A toy patch for Cgroup ID and hierarchy code.
> > 
> > This patch tries to assing a ID to each cgroup. Attach unique ID to each
> > cgroup and provides following functions.
> > 
> >  - cgroup_lookup(id)
> >    returns cgroup of id.
> >  - cgroup_get_next(id, root, foundid)
> >    returns the next cgroup under "root" by scanning bitmap (not by tree-walk)
> >  - cgroup_is_ancestor(cgroup, root)
> >    returns true if "root" is ancestor of cgroup.
> > 
> > There is several reasons to develop this.
> > 
> > 	- While trying to implement hierarchy in memory cgroup, we had to
> > 	  implement "walk under hierarchy" code.
> > 	  Now it's consists of cgroup_lock and tree up-down code.
> > 	  But taking "cgroup_lock" in walking tree can cause deadlocks.
> >           cgroup_lock() is too big. Easier way is helpful.
> > 
> >  	- SwapCgroup uses array of "pointer" to record the owner of swaps.
> > 	  By ID, we can reduce this to "short" or "int". This means ID is 
> > 	  useful for reducing space consumption by pointer if the access cost
> > 	  is not problem.
> > 	  (I hear bio-cgroup will use the same kind of...)
> > 
> > Example) OOM-Killer under hierarchy.
> > 	do {
> > 		rcu_read_lock();
> > 		next = cgroup_get_next(id, root, nextid);
> > 		/* check sanity of next here */
> > 		/* increment refcnt to "next" */
> > 		rcu_read_unlock();
> > 		if (!next)
> > 			break;
> 
> It's not safe to use the cgroup returned by cgroup_get_next() outside rcu lock.
> 
> ---------------------------------------------
> cgroup_rmdir()
>   (check refcnt == 0)
> 			rcu_read_lock();
> 			cgrp = cgroup_get_next()
> 			(inc refcnt)
> 			rcu_read_unlock();
>   cgroup_id_detach()
> cgroup_diput();
>   kfree(cgrp);
> 			use cgrp
> ---------------------------------------------
> 
> I think the safe way is:
> 
> rcu_read_lock();
> cgrp = cgroup_get_next()
> if (!inc_not_zero(cgrp) {
> 	rcu_read_unlock();
> 	return NULL;
> }
> rcu_read_unlock();
> return cgrp;
> 
> But it's also safe to use cgrp = list_entry(&parent->children.next) for the above
> scenario, seems you don't have to invent this cgroup_get_next().
> 
But list-walk can't provide us view of hierarchy. Up-Down list walk is better ?
please see memcg's code. it met some troubles.
I'll make kfree(cgrp) to be called by RCU.

Thanks,
-Kame


> > 		cgroup_scan_tasks(select_bad_process);
> > 	} while (1);
> > 
> > 
> > Characteristics: 
> > 	- Each cgroup get new ID when created.
> > 	- cgroup ID contains "ID" and "Depth in tree" and hierarchy code.
> > 	- hierarchy code is array of IDs of ancestors.
> > 
> > Consideration:
> > 	- gang lookup if necessary.
> > 	- I'd like to use  "(unsigned)short" to cgroup_id for saving space...
> > 	- MAX_DEPTH is bad ?
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> >  include/linux/cgroup.h |   42 +++++++++++
> >  include/linux/idr.h    |    1 
> >  kernel/cgroup.c        |  180 ++++++++++++++++++++++++++++++++++++++++++++++++-
> >  lib/idr.c              |   46 ++++++++++++
> >  4 files changed, 266 insertions(+), 3 deletions(-)
> > 
> > Index: mmotm-2.6.28-Nov24/include/linux/cgroup.h
> > ===================================================================
> > --- mmotm-2.6.28-Nov24.orig/include/linux/cgroup.h
> > +++ mmotm-2.6.28-Nov24/include/linux/cgroup.h
> > @@ -61,6 +61,20 @@ struct cgroup_subsys_state {
> >  	unsigned long flags;
> >  };
> >  
> > +/*
> > + * Cgroup ID for *internal* identification and lookup. For user-land,"path"
> > + * of cgroup works well.
> > + */
> > +#define MAX_CGROUP_DEPTH	(10)
> > +struct cgroup_id {
> > +	struct cgroup *myself;
> > +	unsigned int  id;
> > +	atomic_t      refcnt;
> > +	unsigned int  depth;
> > +	unsigned int  hierarchy_code[MAX_CGROUP_DEPTH];
> > +	struct list_head list;
> > +};
> > +
> >  /* bits in struct cgroup_subsys_state flags field */
> >  enum {
> >  	CSS_ROOT, /* This CSS is the root of the subsystem */
> > @@ -145,6 +159,9 @@ struct cgroup {
> >  	int pids_use_count;
> >  	/* Length of the current tasks_pids array */
> >  	int pids_length;
> > +
> > +	/* Cgroup ID */
> > +	struct cgroup_id	*id;
> >  };
> >  
> >  /* A css_set is a structure holding pointers to a set of
> > @@ -393,6 +410,31 @@ void cgroup_iter_end(struct cgroup *cgrp
> >  int cgroup_scan_tasks(struct cgroup_scanner *scan);
> >  int cgroup_attach_task(struct cgroup *, struct task_struct *);
> >  
> > +/*
> > + * For supporting cgroup lookup and hierarchy management.
> > + * Giving Flat view of cgroup hierarchy rather than tree.
> > + */
> > +/* An interface for usual lookup */
> > +struct cgroup *cgroup_lookup(int id);
> > +/* get next cgroup under tree (for scan) */
> > +struct cgroup *cgroup_get_next(int id, struct cgroup *root, int *foundid);
> > +
> > +static inline bool
> > +cgroup_is_ancestor(struct cgroup *cur, struct cgroup *root)
> > +{
> > +	struct cgroup_id *curid = cur->id;
> > +	struct cgroup_id *rootid = root->id;
> > +
> > +	return (curid->hierarchy_code[rootid->depth] = rootid->id);
> > +}
> > +
> > +static inline int cgroup_myid(struct cgroup *cgrp)
> > +{
> > +	return cgrp->id->id;
> > +}
> > +
> > +/* TODO: gang lookup should be */
> > +
> >  #else /* !CONFIG_CGROUPS */
> >  
> >  static inline int cgroup_init_early(void) { return 0; }
> > Index: mmotm-2.6.28-Nov24/kernel/cgroup.c
> > ===================================================================
> > --- mmotm-2.6.28-Nov24.orig/kernel/cgroup.c
> > +++ mmotm-2.6.28-Nov24/kernel/cgroup.c
> > @@ -46,7 +46,7 @@
> >  #include <linux/cgroupstats.h>
> >  #include <linux/hash.h>
> >  #include <linux/namei.h>
> > -
> > +#include <linux/idr.h>
> >  #include <asm/atomic.h>
> >  
> >  static DEFINE_MUTEX(cgroup_mutex);
> > @@ -547,6 +547,162 @@ void cgroup_unlock(void)
> >  	mutex_unlock(&cgroup_mutex);
> >  }
> >  
> > +
> > +/*
> > + * Cgroup ID and lookup functions.
> > + * cgid->myself pointer is safe under rcu_read_lock() because d_put() of
> > + * cgroup, which finally frees cgroup pointer, uses rcu_synchronize().
> > + */
> > +
> > +static DEFINE_IDR(cgroup_idr);
> > +static DEFINE_SPINLOCK(cgroup_idr_lock);
> > +
> > +static int cgroup_prepare_id(struct cgroup *parent, struct cgroup_id **id)
> > +{
> > +	struct cgroup_id *newid;
> > +	int myid, error;
> > +
> > +	/* check depth */
> > +	if (parent && parent->id->depth + 1 >= MAX_CGROUP_DEPTH)
> > +		return -ENOSPC;
> > +	newid = kzalloc(sizeof(*newid), GFP_KERNEL);
> > +	if (!newid)
> > +		return -ENOMEM;
> > +	/* get id */
> > +	if (unlikely(!idr_pre_get(&cgroup_idr, GFP_KERNEL))) {
> > +		error = -ENOMEM;
> > +		goto err_out;
> > +	}
> > +	spin_lock_irq(&cgroup_idr_lock);
> > +	error = idr_get_new(&cgroup_idr, newid, &myid);
> > +	spin_unlock_irq(&cgroup_idr_lock);
> > +	if (error)
> > +		goto err_out;
> > +
> > +	newid->id = myid;
> > +	atomic_set(&newid->refcnt, 1);
> > +	INIT_LIST_HEAD(&newid->list);
> > +	*id = newid;
> > +	return 0;
> > +err_out:
> > +	kfree(newid);
> > +	return error;
> > +}
> > +
> > +static void cgroup_id_put(struct cgroup_id *cgid)
> > +{
> > +	unsigned long flags;
> > +
> > +	if (atomic_dec_and_test(&cgid->refcnt)) {
> > +		spin_lock_irqsave(&cgroup_idr_lock, flags);
> > +		idr_remove(&cgroup_idr, cgid->id);
> > +		spin_unlock_irqrestore(&cgroup_idr_lock, flags);
> > +		kfree(cgid);
> > +	}
> > +}
> > +
> > +static void cgroup_id_attach(struct cgroup_id *cgid,
> > +			     struct cgroup *cg, struct cgroup *parent)
> > +{
> > +	if (parent) {
> > +		struct cgroup_id *parent_id = parent->id;
> > +		int i;
> > +
> > +		cgid->depth = parent_id->depth + 1;
> > +		/* Inherit hierarchy code from parent */
> > +		for (i = 0; i < cgid->depth; i++) {
> > +			cgid->hierarchy_code[i] =
> > +				parent_id->hierarchy_code[i];
> > +			cgid->hierarchy_code[cgid->depth] = cgid->id;
> > +		}
> > +	} else {
> > +		cgid->depth = 0;
> > +		cgid->hierarchy_code[0] = cgid->id;
> > +	}
> > +	rcu_assign_pointer(cgid->myself, cg);
> > +	cg->id = cgid;
> > +
> > +	return;
> > +}
> > +
> > +static void cgroup_id_detach(struct cgroup *cg)
> > +{
> > +	struct cgroup_id *id = cg->id;
> > +
> > +	rcu_assign_pointer(id->myself, NULL);
> > +	cgroup_id_put(id);
> > +}
> > +
> > +/**
> > + * cgroup_lookup - lookup cgroup by id
> > + * @id: the id of cgroup to be looked up
> > + *
> > + * Retruns pointer to cgroup if there is vald cgroup with id, NULL if not.
> > + * Should be called under rcu_read_lock() or cgroup_lock().
> > + */
> > +
> > +struct cgroup *cgroup_lookup(int id)
> > +{
> > +	struct cgroup *cgrp;
> > +	struct cgroup_id *cgid;
> > +
> > +	rcu_read_lock();
> > +	cgid = idr_find(&cgroup_idr, id);
> > +	rcu_read_unlock();
> > +
> > +	if (unlikely(!cgid))
> > +		return NULL;
> > +
> > +	cgrp = rcu_dereference(cgid->myself);
> > +	if (unlikely(!cgrp || test_bit(CGRP_REMOVED, &cgrp->flags)))
> > +		return NULL;
> > +
> > +	return cgrp;
> > +}
> > +
> > +/**
> > + * cgroup_get_next - lookup next cgroup under specified hierarchy.
> > + * @id: current position of iteration.
> > + * @root: search tree under this. .
> > + * @foundid: position of found object.
> > + *
> > + * Search next cgroup under the specified hierarchy. If "cur" is NULL,
> > + * start from root cgroup. Called under rcu_read_lock() or cgroup_lock()
> > + * is necessary (to access a found cgroup.).
> > + */
> > +struct cgroup *cgroup_get_next(int id, struct cgroup *root, int *foundid)
> > +{
> > +	struct cgroup *ret = NULL;
> > +	struct cgroup_id *tmp, *rootid;
> > +	int tmpid, depth, targetid;
> > +	unsigned long flags;
> > +
> > +	rootid = root->id;
> > +	depth = rootid->depth;
> > +	targetid = rootid->id;
> > +	tmpid = id;
> > +
> > +	do {
> > +		/* scan next entry from bitmap(tree) */
> > +		spin_lock_irqsave(&cgroup_idr_lock, flags);
> > +		tmp = idr_get_next(&cgroup_idr, &tmpid);
> > +		spin_unlock_irqrestore(&cgroup_idr_lock, flags);
> > +
> > +		if (tmp) {
> > +			ret = rcu_dereference(tmp->myself);
> > +			/* Sanity check and check hierarchy */
> > +			if (ret && !test_bit(CGRP_REMOVED, &ret->flags)
> > +			    && tmp->hierarchy_code[depth] == targetid)
> > +				break;
> > +			tmpid = tmpid + 1;
> > +		} else
> > +			tmpid = 0;
> > +	} while (1);
> > +
> > +	*foundid = tmpid;
> > +	return ret;
> > +}
> > +
> >  /*
> >   * A couple of forward declarations required, due to cyclic reference loop:
> >   * cgroup_mkdir -> cgroup_create -> cgroup_populate_dir ->
> > @@ -991,6 +1147,7 @@ static int cgroup_get_sb(struct file_sys
> >  		/* New superblock */
> >  		struct cgroup *cgrp = &root->top_cgroup;
> >  		struct inode *inode;
> > +		struct cgroup_id *newid;
> >  		int i;
> >  
> >  		BUG_ON(sb->s_root != NULL);
> > @@ -998,6 +1155,11 @@ static int cgroup_get_sb(struct file_sys
> >  		ret = cgroup_get_rootdir(sb);
> >  		if (ret)
> >  			goto drop_new_super;
> > +
> > +		ret = cgroup_prepare_id(NULL, &newid);
> > +		if (ret)
> > +			goto drop_new_super;
> > +
> >  		inode = sb->s_root->d_inode;
> >  
> >  		mutex_lock(&inode->i_mutex);
> > @@ -1062,7 +1224,7 @@ static int cgroup_get_sb(struct file_sys
> >  		BUG_ON(!list_empty(&cgrp->sibling));
> >  		BUG_ON(!list_empty(&cgrp->children));
> >  		BUG_ON(root->number_of_cgroups != 1);
> > -
> > +		cgroup_id_attach(newid, cgrp, NULL);
> >  		cgroup_populate_dir(cgrp);
> >  		mutex_unlock(&inode->i_mutex);
> >  		mutex_unlock(&cgroup_mutex);
> > @@ -1997,6 +2159,7 @@ int cgroup_scan_tasks(struct cgroup_scan
> >  	return 0;
> >  }
> >  
> > +
> >  /*
> >   * Stuff for reading the 'tasks' file.
> >   *
> > @@ -2349,11 +2512,18 @@ static long cgroup_create(struct cgroup 
> >  	int err = 0;
> >  	struct cgroup_subsys *ss;
> >  	struct super_block *sb = root->sb;
> > +	struct cgroup_id *cgid = NULL;
> >  
> >  	cgrp = kzalloc(sizeof(*cgrp), GFP_KERNEL);
> >  	if (!cgrp)
> >  		return -ENOMEM;
> >  
> > +	err = cgroup_prepare_id(parent, &cgid);
> > +	if (err) {
> > +		kfree(cgrp);
> > +		return err;
> > +	}
> > +
> >  	/* Grab a reference on the superblock so the hierarchy doesn't
> >  	 * get deleted on unmount if there are child cgroups.  This
> >  	 * can be done outside cgroup_mutex, since the sb can't
> > @@ -2394,6 +2564,8 @@ static long cgroup_create(struct cgroup 
> >  	err = cgroup_populate_dir(cgrp);
> >  	/* If err < 0, we have a half-filled directory - oh well ;) */
> >  
> > +	cgroup_id_attach(cgid, cgrp, parent);
> > +
> >  	mutex_unlock(&cgroup_mutex);
> >  	mutex_unlock(&cgrp->dentry->d_inode->i_mutex);
> >  
> > @@ -2415,7 +2587,7 @@ static long cgroup_create(struct cgroup 
> >  
> >  	/* Release the reference count that we took on the superblock */
> >  	deactivate_super(sb);
> > -
> > +	cgroup_id_put(cgid);
> >  	kfree(cgrp);
> >  	return err;
> >  }
> > @@ -2494,6 +2666,8 @@ static int cgroup_rmdir(struct inode *un
> >  		return -EBUSY;
> >  	}
> >  
> > +	cgroup_id_detach(cgrp);
> > +
> >  	spin_lock(&release_list_lock);
> >  	set_bit(CGRP_REMOVED, &cgrp->flags);
> >  	if (!list_empty(&cgrp->release_list))
> > Index: mmotm-2.6.28-Nov24/include/linux/idr.h
> > ===================================================================
> > --- mmotm-2.6.28-Nov24.orig/include/linux/idr.h
> > +++ mmotm-2.6.28-Nov24/include/linux/idr.h
> > @@ -106,6 +106,7 @@ int idr_get_new(struct idr *idp, void *p
> >  int idr_get_new_above(struct idr *idp, void *ptr, int starting_id, int *id);
> >  int idr_for_each(struct idr *idp,
> >  		 int (*fn)(int id, void *p, void *data), void *data);
> > +void *idr_get_next(struct idr *idp, int *nextid);
> >  void *idr_replace(struct idr *idp, void *ptr, int id);
> >  void idr_remove(struct idr *idp, int id);
> >  void idr_remove_all(struct idr *idp);
> > Index: mmotm-2.6.28-Nov24/lib/idr.c
> > ===================================================================
> > --- mmotm-2.6.28-Nov24.orig/lib/idr.c
> > +++ mmotm-2.6.28-Nov24/lib/idr.c
> > @@ -573,6 +573,52 @@ int idr_for_each(struct idr *idp,
> >  EXPORT_SYMBOL(idr_for_each);
> >  
> >  /**
> > + * idr_get_next - lookup next opbject of id to given id.
> > + * @idp: idr handle
> > + * @id:  pointer to lookup key
> > + *
> > + * Retruns pointer to registered object with id, which is next number to
> > + * given id.
> > + */
> > +
> > +void *idr_get_next(struct idr *idp, int *nextidp)
> > +{
> > +	struct idr_layer *p, *pa[MAX_LEVEL];
> > +	struct idr_layer **paa = &pa[0];
> > +	int id = *nextidp;
> > +	int n, max;
> > +
> > +	/* find first ent */
> > +	n = idp->layers * IDR_BITS;
> > +	max = 1 << n;
> > +	p = rcu_dereference(idp->top);
> > +	if (!p)
> > +		return NULL;
> > +
> > +	while (id < max) {
> > +		while (n > 0 && p) {
> > +			n -= IDR_BITS;
> > +			*paa++ = p;
> > +			p = rcu_dereference(p->ary[(id >> n) & IDR_MASK]);
> > +		}
> > +
> > +		if (p) {
> > +			*nextidp = id;
> > +			return p;
> > +		}
> > +
> > +		id += 1 << n;
> > +		while (n < fls(id)) {
> > +			n += IDR_BITS;
> > +			p = *--paa;
> > +		}
> > +	}
> > +	return NULL;
> > +}
> > +
> > +
> > +
> > +/**
> >   * idr_replace - replace pointer for given id
> >   * @idp: idr handle
> >   * @ptr: pointer you want associated with the id
> > 
> > 
> 

