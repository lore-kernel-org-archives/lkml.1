Return-Path: <linux-kernel-owner+w=401wt.eu-S1751554AbZL1Ml4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbZL1Ml4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 07:41:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751261AbZL1Ml4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 07:41:56 -0500
Received: from RELAY.ANDREW.CMU.EDU ([128.2.10.212]:60169 "EHLO
	relay.andrew.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751103AbZL1Mlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 07:41:55 -0500
Date: Mon, 28 Dec 2009 07:40:30 -0500
From: Ben Blum <bblum@andrew.cmu.edu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       akpm@linux-foundation.org, Paul Menage <menage@google.com>,
       bblum@andrew.cmu.edu
Subject: Re: [PATCH 2/4] cgroups: subsystem module loading interface
Message-ID: <20091228124029.GB4824@andrew.cmu.edu>
Mail-Followup-To: Li Zefan <lizf@cn.fujitsu.com>,
	linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
	akpm@linux-foundation.org, Paul Menage <menage@google.com>
References: <20091221203253.GA5683@andrew.cmu.edu> <20091221203613.GC5683@andrew.cmu.edu> <4B3850F4.4090203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B3850F4.4090203@cn.fujitsu.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 28, 2009 at 02:32:20PM +0800, Li Zefan wrote:
> > Add interface between cgroups subsystem management and module loading
> > 
> > From: Ben Blum <bblum@andrew.cmu.edu>
> > 
> > This patch implements rudimentary module-loading support for cgroups - namely,
> > a cgroup_load_subsys (similar to cgroup_init_subsys) for use as a module
> > initcall, and a struct module pointer in struct cgroup_subsys.
> > 
> > Several functions that might be wanted by modules have had EXPORT_SYMBOL added
> > to them, but it's unclear exactly which functions want it and which won't.
> > 
> > Signed-off-by: Ben Blum <bblum@andrew.cmu.edu>
> 
> Acked-by: Li Zefan <lizf@cn.fujitsu.com>
> 
> Some small nitpicks:
> 
> > --- a/kernel/cgroup.c
> > +++ b/kernel/cgroup.c
> > @@ -2477,6 +2477,7 @@ int cgroup_add_file(struct cgroup *cgrp,
> >  		error = PTR_ERR(dentry);
> >  	return error;
> >  }
> > +EXPORT_SYMBOL_GPL(cgroup_add_file);
> 
> I got compile errors, because you forgot to include <linux/module.h>
> 
> ...
> > +	write_lock(&css_set_lock);
> > +	for (i = 0; i < CSS_SET_TABLE_SIZE; i++) {
> > +		struct css_set *cg;
> > +		struct hlist_node *node, *tmp;
> > +		struct hlist_head *bucket = &css_set_table[i], *new_bucket;
> 
> Please add a blank line between variable declaration and other code.
> 
> And elsewhere in this patchset.
> 

checkpatch.pl didn't trip on this [and the more screenspace-intensive
comment style]; are they cgroups-specific style requirements or from
somewhere higher up?

> > +		hlist_for_each_entry_safe(cg, node, tmp, bucket, hlist) {
> > +			/* skip entries that we already rehashed */
> > +			if (cg->subsys[ss->subsys_id])
> > +				continue;
> > +			/* remove existing entry */
> > +			hlist_del(&cg->hlist);
> > +			/* set new value */
> > +			cg->subsys[ss->subsys_id] = css;
> > +			/* recompute hash and restore entry */
> > +			new_bucket = css_set_hash(cg->subsys);
> > +			hlist_add_head(&cg->hlist, new_bucket);
> > +		}
> > +	}
> > +	write_unlock(&css_set_lock);
> 
> 
> 
