Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYLJEFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYLJEFg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 23:05:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYLJEF1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 23:05:27 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:47052 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288AbYLJEF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 23:05:26 -0500
Date: Wed, 10 Dec 2008 12:03:40 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       nishimura@mxp.nes.nec.co.jp
Subject: Re: [RFC][PATCH 1/6] memcg: fix pre_destory handler
Message-Id: <20081210120340.dd3e7aee.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20081210115830.dd13b90b.kamezawa.hiroyu@jp.fujitsu.com>
References: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
	<20081209200647.a1fa76a9.kamezawa.hiroyu@jp.fujitsu.com>
	<20081210112815.d5098e9e.nishimura@mxp.nes.nec.co.jp>
	<20081210115830.dd13b90b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Dec 2008 11:58:30 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 10 Dec 2008 11:28:15 +0900
> Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:
> 
> > On Tue, 9 Dec 2008 20:06:47 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > better name for new flag is welcome.
> > > 
> > > ==
> > > Because pre_destroy() handler is moved out to cgroup_lock() for
> > > avoiding dead-lock, now, cgroup's rmdir() does following sequence.
> > > 
> > > 	cgroup_lock()
> > > 	check children and tasks.
> > > 	(A)
> > > 	cgroup_unlock()
> > > 	(B)
> > > 	pre_destroy() for subsys;-----(1)
> > > 	(C)
> > > 	cgroup_lock();
> > > 	(D)
> > > 	Second check:check for -EBUSY again because we released the lock.
> > > 	(E)
> > > 	mark cgroup as removed.
> > > 	(F)
> > > 	unlink from lists.
> > > 	cgroup_unlock();
> > > 	dput()
> > > 	=> when dentry's refcnt goes down to 0
> > > 		destroy() handers for subsys
> > > 
> > > memcg marks itself as "obsolete" when pre_destroy() is called at (1)
> > > But rmdir() can fail after pre_destroy(). So marking "obsolete" is bug.
> > > I'd like to fix sanity of pre_destroy() in cgroup layer.
> > > 
> > > Considering above sequence, new tasks can be added while
> > > 	(B) and (C)
> > > swap-in recored can be charged back to a cgroup after pre_destroy()
> > > 	at (C) and (D), (E)
> > > (means cgrp's refcnt not comes from task but from other persistent objects.)
> > > 
> > > This patch adds "cgroup_is_being_removed()" check. (better name is welcome)
> > > After this,
> > > 
> > > 	- cgroup is marked as CGRP_PRE_REMOVAL at (A)
> > > 	- If Second check fails, CGRP_PRE_REMOVAL flag is removed.
> > > 	- memcg's its own obsolete flag is removed.
> > > 	- While CGROUP_PRE_REMOVAL, task attach will fail by -EBUSY.
> > > 	  (task attach via clone() will not hit the case.)
> > > 
> > > By this, we can trust pre_restroy()'s result.
> > > 
> > > 
> > I agrree to the direction of this patch, but I think it would be better
> > to split this into cgroup and memcg part.
> >
> Hmm, but "showing usage" part is necessary for this kind of patches.
>  
I see.

(snip)
> > > +	if (cgroup_is_being_removed(cgrp))
> > > +		return -EBUSY;
> > > +
> > >  	for_each_subsys(root, ss) {
> > >  		if (ss->can_attach) {
> > >  			retval = ss->can_attach(ss, cgrp, tsk);
> > > @@ -2469,12 +2481,14 @@ static int cgroup_rmdir(struct inode *un
> > >  		mutex_unlock(&cgroup_mutex);
> > >  		return -EBUSY;
> > >  	}
> > > -	mutex_unlock(&cgroup_mutex);
> > >  
> > >  	/*
> > >  	 * Call pre_destroy handlers of subsys. Notify subsystems
> > >  	 * that rmdir() request comes.
> > >  	 */
> > > +	set_bit(CGRP_PRE_REMOVAL, &cgrp->flags);
> > > +	mutex_unlock(&cgroup_mutex);
> > > +
> > >  	cgroup_call_pre_destroy(cgrp);
> > >  
> > Is there any case where pre_destory is called simultaneusly ?
> > 
> I can't catch what is your concern.
> 
> AFAIK, vfs_rmdir() is done under mutex to dentry
> ==
>  mutex_lock_nested(&nd.path.dentry->d_inode->i_mutex, I_MUTEX_PARENT);
>  ...
>  vfs_rmdir()
> ==
> And calls to cgroup_rmdir() will be serialized.
> 
You're right. I missed that.
Thank you for your clarification.


Thanks,
Daisuke Nishimura.
