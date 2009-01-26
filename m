Return-Path: <linux-kernel-owner+w=401wt.eu-S1752364AbZAZMa3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752364AbZAZMa3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 07:30:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbZAZMaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 07:30:19 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:39721 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbZAZMaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 07:30:18 -0500
Subject: Re: [PATCH] configfs: Silence lockdep on mkdir(), rmdir() and
 configfs_depend_item()
From: Peter Zijlstra <peterz@infradead.org>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Louis Rilling <louis.rilling@kerlabs.com>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, swhiteho <swhiteho@redhat.com>
In-Reply-To: <20081218225837.GB21870@mail.oracle.com>
References: <20081212100615.GD19128@hawkmoon.kerlabs.com>
	 <1229095751-23984-1-git-send-email-louis.rilling@kerlabs.com>
	 <20081217134020.42da55fc.akpm@linux-foundation.org>
	 <1229585208.9487.112.camel@twins> <20081218092744.GB30789@mail.oracle.com>
	 <1229601399.9487.218.camel@twins> <1229603308.9487.227.camel@twins>
	 <20081218225837.GB21870@mail.oracle.com>
Content-Type: text/plain
Date: Mon, 26 Jan 2009 13:30:09 +0100
Message-Id: <1232973009.4863.76.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-12-18 at 14:58 -0800, Joel Becker wrote:
> On Thu, Dec 18, 2008 at 01:28:28PM +0100, Peter Zijlstra wrote:
> > In fact, both (configfs) mkdir and rmdir seem to synchronize on
> > su_mutex..
> > 
> >  mkdir B/C/bar
> > 
> >    C.i_mutex
> >      su_mutex
> > 
> > vs
> > 
> >  rmdir foo
> > 
> >    parent(foo).i_mutex
> >      foo.i_mutex
> >        su_mutex
> > 
> > 
> > once holding the rmdir su_mutex you can check foo's user-content, since
> > any mkdir will be blocked. All you have to do is then re-validate in
> > mkdir's su_mutex that !IS_DEADDIR(C).
> 
> 	We explicitly do not take any i_mutex locks after taking
> su_mutex.  That's an ABBA risk.  su_mutex protects the hierarchy of
> config_items.  i_mutex protects the vfs view thereof.

I don't think I was suggesting that. All you need is to serialize any
mkdir/creat against the rmdir of the youngest non-default group, and you
can do that by holding su_mutex.

In rmdir, you already own all the i_mutex instances you need to uncouple
the whole tree, all you need to do is validate that its indeed empty --
you don't need i_mutex's for that, because you're holding su_mutex, and
any concurrent mkdir/creat will be blocking on that.

If you find it empty, just mark everybody DEAD, drop su_mutex and
decouple. All concurrent mkdir/creat thingies that were blocking will
now bail because their parent is found DEAD.

> 	If you look in mkdir, we take su_mutex, get a new item from the
> client subsystem, then drop su_mutex. 

All you need to do before dropping su_mutex again is checking
IS_DEADDIR(), if so, you just fail the whole mkdir() no extra i_mutex's
needed.

>  After that, we go about building
> our filesystem structure, using i_mutex where appropriate. 

Sure, but its ok to grow the default groups non-atomically, right? mkdir
will only need to check that everything is empty in as far as it has
been linked, and ensure the not yet linked entries won't be.

>  More
> importantly is rmdir(2), where we use i_mutex in
> configfs_detach_group(), but are not holding su_sem.  Only when
> configfs_detach_group() has successfully returned and we have torn down
> the filesystem structure do we take su_mutex and tear down the
> config_item structure.

The only thing that matters is that you can hold su_mutex inside
i_mutex.


configfs_rmdir( "foo" )
{
 /* we hold i_mutex for foo and its parent */

 mutex_lock(&subsys->su_mutex);
 if (default_tree_empty())
  mark_default_tree_dead();
 else
  ret = -EBUSY;
 mutex_unlock(&subsys->su_mutex);

 if (ret)
  return ret;

 /* do actual unlink foo */
}


configfs_mkdir( "B/A/bar" )
{
 /* we hold i_mutex for A */

 mutex_lock(&subsys->su_mutex);
 if (IS_DEADDIR(A))
  ret = -EINVAL; /* or whatever */

 /* increase A's use count, so default_tree_empty() will fail. *
 inc_A_or_subsys_use_count();
 mutex_unlock(&subsys->su_mutex);
 if (ret)
  return ret;

 /* do actual mkdir */
}


Surely something along these lines ought to work?

