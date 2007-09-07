Return-Path: <linux-kernel-owner+w=401wt.eu-S965684AbXIGNBz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965684AbXIGNBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2007 09:01:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965341AbXIGNBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Sep 2007 09:01:46 -0400
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:40527 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965344AbXIGNBo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2007 09:01:44 -0400
Date: Fri, 7 Sep 2007 09:01:42 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] Linux Kernel Markers - Architecture Independent Code
Message-ID: <20070907130142.GD9735@Krystal>
References: <20070906200733.194442762@polymtl.ca> <20070906200825.893834634@polymtl.ca> <20070906160001.cfe48d78.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070906160001.cfe48d78.randy.dunlap@oracle.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 08:49:02 up 39 days, 13:07,  4 users,  load average: 0.67, 0.76, 0.98
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Randy Dunlap (randy.dunlap@oracle.com) wrote:
 [snip]
> 
> > +/*
> > + * Sets the probe callback corresponding to one marker.
> > + */
> > +static int set_marker(struct marker_entry **entry,
> > +			struct __mark_marker *elem)
> > +{
> > +	int ret;
> > +	BUG_ON(strcmp((*entry)->name, elem->name) != 0);
> 
> You can't return -ENOENT here?
> 

I could, but it's really a bug: if this condition happens, there would
be an inconsistency in the hash table get_marker() function. Therefore I
prefer to yell if this happens rather than simply telling the caller
that the entry does not exist.

And actually, marker_update_probe_range ignores errors from set_marker
(there is even a comment saying that in the code) :

                if (mark_entry && mark_entry->refcount) {
                        set_marker(&mark_entry, iter);
                        /*
                         * ignore error, continue
                         */

It is done on purpose: if a marker does not have the right arguments, it
will simply be skipped and a printk warning will be emitted. I prefer
this approach rather than stopping marker activation/disactivation as
soon as a bad marker is found.

[...]
 
> > +#ifdef CONFIG_MODULES
> > +/*
> > + * Update module probes.
> > + * Must be called with markers_mutex held.
> > + */
> > +static inline void marker_update_probes_modules(struct module *probe_module,
> > +	int *refcount)
> > +{
> > +	struct module *mod;
> > +
> > +	list_for_each_entry(mod, &modules, list) {
> > +		if (!mod->taints) {
> > +			marker_update_probe_range(mod->markers,
> > +				mod->markers+mod->num_markers,
> > +				probe_module, refcount);
> > +		}
> > +	}
> > +}
> 
> hm, so if the module is tainted, markers won't be applied to it?
> That's OK IMO.

Yep, 

> However, I tend to think that something that
> modifies code on the fly (like kprobes or text edit) should set some
> flag somewhere so that when the system crashes, we can know that
> code was modified.  This could be done via taints flags or some other
> mechanism.  Has this already been discussed?
> 

I am not aware of discussions about this. But then we would have to do
the same for paravirt, alternatives, kprobes and immediate values.

As soon as the kernel code of a crashing kernel may have been modified
in memory, the image of the crashed kernel should be used instead of the
compiled image to analyze the crash. But code patching becomes so common
that we will have to start using core dumps more and more.

Yes, your idea makes sense. printking that kind of information in a OOPS
would be useful IMO.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
