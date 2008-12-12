Return-Path: <linux-kernel-owner+w=401wt.eu-S1758266AbYLLLgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbYLLLgq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 06:36:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752344AbYLLLgh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 06:36:37 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:47493 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751391AbYLLLgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 06:36:36 -0500
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
From: Catalin Marinas <catalin.marinas@arm.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <84144f020812111401n78f980a3v101b3518ab5a3b20@mail.gmail.com>
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
	 <84144f020812111401n78f980a3v101b3518ab5a3b20@mail.gmail.com>
Content-Type: text/plain
Organization: ARM Ltd
Date: Fri, 12 Dec 2008 11:36:17 +0000
Message-Id: <1229081777.15045.8.camel@pc1117.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Dec 2008 11:36:18.0022 (UTC) FILETIME=[D9088060:01C95C4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-12-12 at 00:01 +0200, Pekka Enberg wrote:
> On Wed, Dec 10, 2008 at 8:26 PM, Catalin Marinas
> <catalin.marinas@arm.com> wrote:
> > +static void put_object(struct memleak_object *object)
> > +{
> > +       if (!atomic_dec_and_test(&object->use_count))
> > +               return;
> > +
> > +       /* should only get here after delete_object was called */
> > +       BUG_ON(object->flags & OBJECT_ALLOCATED);
> 
> This could be
> 
>     if (WARN_ON(object->flags & OBJECT_ALLOCATED))
>             return;

I'm not sure just warning would be enough. If this happens, its a severe
bug in kmemleak and the tool is no longer useful (it could even leak
memory or free already freed blocks). I could change it to a
memleak_panic call but if the object use_count isn't reliable, the
memleak_disable call wouldn't work properly either.

> > +static void create_object(unsigned long ptr, size_t size, int min_count,
> > +                         gfp_t gfp)
> > +{
> > +       unsigned long flags;
> > +       struct memleak_object *object;
> > +       struct prio_tree_node *node;
> > +       struct stack_trace trace;
> > +
> > +       object = kmem_cache_alloc(object_cache, gfp);
> > +       if (!object)
> > +               memleak_panic("kmemleak: Cannot allocate a memleak_object "
> > +                             "structure\n");
> 
> Don't you want to exit early here if object == NULL?

Yes, indeed. That omission was caused by s/panic/memleak_panic/

> > +       if (node != &object->tree_node) {
> > +               unsigned long flags;
> > +
> > +               pr_warning("kmemleak: Existing pointer\n");
> > +               dump_stack();
> 
> How come you don't dump_stack() or even WARN_ON() unconditionally in
> kmemleak_panic() which is called bit later so you can remove this kind
> of ad hoc logging?

Yes, I'll unify these via the memleak_panic() macro.

> > +static void delete_object(unsigned long ptr)
> > +{
> > +       unsigned long flags;
> > +       struct memleak_object *object;
> > +
> > +       write_lock_irqsave(&memleak_lock, flags);
> > +       object = lookup_object(ptr, 0);
> > +       if (!object) {
> > +               pr_warning("kmemleak: Freeing unknown object at 0x%08lx\n",
> > +                          ptr);
> > +               dump_stack();
> 
> Hmm, dump_stack() is called in quite a few places. Might make sense to
> add a memleak_report() function that does this in an uniform way.

Yes.

> > +               write_unlock_irqrestore(&memleak_lock, flags);
> > +               return;
> > +       }
> > +       prio_tree_remove(&object_tree_root, &object->tree_node);
> > +       list_del_rcu(&object->object_list);
> > +       write_unlock_irqrestore(&memleak_lock, flags);
> > +
> > +       BUG_ON(!(object->flags & OBJECT_ALLOCATED));
> > +       BUG_ON(atomic_read(&object->use_count) < 1);
> 
> These could be converted to WARN_ON() calls, I think?

See my comment above, these are genuine kmemleak bugs and it shouldn't
just warn. Hopefully they will never happen unless a get/put_object is
missing.

Thanks.

-- 
Catalin

