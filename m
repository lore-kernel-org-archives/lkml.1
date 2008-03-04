Return-Path: <linux-kernel-owner+w=401wt.eu-S1763308AbYCDBhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763308AbYCDBhF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 20:37:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755651AbYCDBgy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 20:36:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:10391 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755442AbYCDBgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 20:36:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,441,1199692800"; 
   d="scan'208";a="303461698"
Date: Mon, 3 Mar 2008 17:36:49 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v3
Message-ID: <20080304013649.GB28006@linux-os.sc.intel.com>
References: <20080303230335.892214000@linux-os.sc.intel.com> <20080304011849.GA22431@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304011849.GA22431@infradead.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 03, 2008 at 08:18:49PM -0500, Christoph Hellwig wrote:
> On Mon, Mar 03, 2008 at 03:02:45PM -0800, Suresh Siddha wrote:
> > +void __attribute__((weak)) arch_task_cache_init(void)
> > +{
> > +}
> > +
> >  void __init fork_init(unsigned long mempages)
> >  {
> >  #ifndef __HAVE_ARCH_TASK_STRUCT_ALLOCATOR
> > @@ -144,6 +148,9 @@
> >  			ARCH_MIN_TASKALIGN, SLAB_PANIC | SLAB_NOTRACK, NULL);
> >  #endif
> >  
> > +	/* do the arch specific task caches init */
> > +	arch_task_cache_init();
> 
> Why can't this just be a normal initcall (with the right level)?

This is sort of an extension to the per-task area. And this needs to be done
before any task starts using this state. Thought this is the nice place to
initialize the extension caches along with the main task_struct init.

> 
> > +int __attribute__((weak)) arch_dup_task_struct(struct task_struct *dst,
> > +					       struct task_struct *src)
> > +{
> > +	*dst = *src;
> > +	return 0;
> > +}
> > +
> >  static struct task_struct *dup_task_struct(struct task_struct *orig)
> >  {
> >  	struct task_struct *tsk;
> > @@ -181,15 +195,15 @@
> >  		return NULL;
> >  	}
> >  
> > -	*tsk = *orig;
> > + 	err = arch_dup_task_struct(tsk, orig);
> > +	if (err)
> > +		goto out;
> > +
> 
> You're still adding a second hook instead of re-using or re-naming
> setup_thread_stack.  Did I miss a good explanation for that
> or was this just an oversight?

Not an oversight. setup_thread_stack comes with its own baggage called
__HAVE_THREAD_FUNCTIONS. Thought of keeping this simple and separate
by using an inline or weak linkage.

> Also this weak linkage stuff creaping in is really ugly.

hmm.. any better suggestion?

thanks,
suresh
