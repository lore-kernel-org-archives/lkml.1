Return-Path: <linux-kernel-owner+w=401wt.eu-S1751892AbYHKGi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751892AbYHKGi4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 02:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751078AbYHKGit
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 02:38:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:61663 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbYHKGis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 02:38:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.31,341,1215414000"; 
   d="scan'208";a="325067283"
Subject: Re: [PATCH] lockdep: handle chains involving classes defined in
	modules
From: Huang Ying <ying.huang@intel.com>
To: Rabin Vincent <rabin@rab.in>
Cc: Eric Sesterhenn <snakebyte@gmx.de>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, mingo@redhat.com
In-Reply-To: <20080808222555.GA10656@debian>
References: <20080806121650.GA3119@alice> <20080806124134.GA3615@alice>
	 <20080807205340.GA1747@debian> <20080807205729.GB1747@debian>
	 <1218165877.22039.23.camel@caritas-dev.intel.com>
	 <20080808222555.GA10656@debian>
Content-Type: text/plain
Date: Mon, 11 Aug 2008 14:38:45 +0800
Message-Id: <1218436725.30464.52.camel@caritas-dev.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-08-09 at 03:55 +0530, Rabin Vincent wrote:
> On Fri, Aug 08, 2008 at 11:24:37AM +0800, Huang Ying wrote:
> > On Fri, 2008-08-08 at 02:27 +0530, Rabin Vincent wrote:
> > > /proc/lockdep_chains currently oopses after any module which creates and
> > > uses a lock is unloaded.  This is because one of the chains involves a
> > > class which was defined in the module just unloaded.
> > > 
> > > The classes are already correctly taken care of using the
> > > all_lock_classes which keeps track of all active lock classses.  Add a
> > > similar all_lock_chains list and use it for keeping track of chains.
> > > 
> [...]
> > 
> > I think there is a simpler method to deal with this.
> 
> Yes.  I went with the all_lock_chains list approach because there was
> similar code already being used to keep track of lock_class structures.
> 
> > - Mark class as useless during zap_class()
> > - When output lock_chain, if some classes are useless, do not output the
> > class.
> 
> Like the patch below?  I set ->key to NULL after zapping the class and
> use that as a condition to not print the class' information.  The only
> issue is that with this patch there will be some chains output with no
> locks listed under them.
> 
> ---
>     lockdep: handle chains involving classes defined in modules
>     
>     /proc/lockdep_chains currently oopses after any module which creates and
>     uses a lock is unloaded.  This is because one of the chains involves a
>     class which was defined in the module just unloaded.
>     
>     Solve this by marking the classes as unused and not printing information
>     about the unused classes.
>     
>     Reported-by: Eric Sesterhenn <snakebyte@gmx.de>
>     Signed-off-by: Rabin Vincent <rabin@rab.in>
> 
> diff --git a/kernel/lockdep.c b/kernel/lockdep.c
> index d38a643..8ade874 100644
> --- a/kernel/lockdep.c
> +++ b/kernel/lockdep.c
> @@ -2988,6 +2988,7 @@ static void zap_class(struct lock_class *class)
>  	list_del_rcu(&class->hash_entry);
>  	list_del_rcu(&class->lock_entry);
>  
> +	class->key = NULL;
>  }
>  
>  static inline int within(const void *addr, void *start, unsigned long size)
> diff --git a/kernel/lockdep_proc.c b/kernel/lockdep_proc.c
> index 9b0e940..f09b6c7 100644
> --- a/kernel/lockdep_proc.c
> +++ b/kernel/lockdep_proc.c
> @@ -229,6 +229,9 @@ static int lc_show(struct seq_file *m, void *v)
>  
>  	for (i = 0; i < chain->depth; i++) {
>  		class = lock_chain_get_class(chain, i);
> +		if (!class->key)
> +			continue;
> +
>  		seq_printf(m, "[%p] ", class->key);
>  		print_name(m, class);
>  		seq_puts(m, "\n");

I think this patch is OK.

Acked-by: Huang Ying <ying.huang@intel.com>

Best Regards,
Huang Ying


