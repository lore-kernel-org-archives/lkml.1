Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918Ab0AMXXy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab0AMXXy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 18:23:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712Ab0AMXXy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 18:23:54 -0500
Received: from smtp-out.google.com ([216.239.33.17]:43260 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab0AMXXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 18:23:53 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=BwM9rvDOEfiFqYYIRR1VUvG7rPxwS3X45B6Hk87nHi91WRnE1ompLiYu7uUG2bjQW
	fG/4tV9IPuocQFFKl7IKg==
Date: Wed, 13 Jan 2010 15:23:44 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrea Arcangeli <aarcange@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 5/7] Add /proc trigger for memory compaction
In-Reply-To: <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1001131518240.10201@chino.kir.corp.google.com>
References: <1262795169-9095-1-git-send-email-mel@csn.ul.ie> <1262795169-9095-6-git-send-email-mel@csn.ul.ie> <alpine.DEB.2.00.1001071352100.23894@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010, David Rientjes wrote:

> > diff --git a/include/linux/compaction.h b/include/linux/compaction.h
> > index 6201371..5965ef2 100644
> > --- a/include/linux/compaction.h
> > +++ b/include/linux/compaction.h
> > @@ -5,4 +5,9 @@
> >  #define COMPACT_INCOMPLETE	0
> >  #define COMPACT_COMPLETE	1
> >  
> > +#ifdef CONFIG_MIGRATION
> > +extern int sysctl_compaction_handler(struct ctl_table *table, int write,
> > +			void __user *buffer, size_t *length, loff_t *ppos);
> > +#endif /* CONFIG_MIGRATION */
> > +
> >  #endif /* _LINUX_COMPACTION_H */

This should be CONFIG_COMPACTION since mm/compaction.c won't be compiled 
without it; the later additions to this ifdef, fragmentation_index() and 
try_to_compact_pages(), can also be under CONFIG_COMPACTION since neither 
are used outside of the compaction core directly (__fragmentation_index() 
from vmstat uses its wrapped function at file scope).

> > diff --git a/kernel/sysctl.c b/kernel/sysctl.c
> > index 8a68b24..6202e95 100644
> > --- a/kernel/sysctl.c
> > +++ b/kernel/sysctl.c
> > @@ -50,6 +50,7 @@
> >  #include <linux/ftrace.h>
> >  #include <linux/slow-work.h>
> >  #include <linux/perf_event.h>
> > +#include <linux/compaction.h>
> >  
> >  #include <asm/uaccess.h>
> >  #include <asm/processor.h>
> > @@ -80,6 +81,7 @@ extern int pid_max;
> >  extern int min_free_kbytes;
> >  extern int pid_max_min, pid_max_max;
> >  extern int sysctl_drop_caches;
> > +extern int sysctl_compact_node;
> >  extern int percpu_pagelist_fraction;
> >  extern int compat_log;
> >  extern int latencytop_enabled;
> > @@ -1109,6 +1111,15 @@ static struct ctl_table vm_table[] = {
> >  		.mode		= 0644,
> >  		.proc_handler	= drop_caches_sysctl_handler,
> >  	},
> > +#ifdef CONFIG_MIGRATION
> > +	{
> > +		.procname	= "compact_node",
> > +		.data		= &sysctl_compact_node,
> > +		.maxlen		= sizeof(int),
> > +		.mode		= 0644,
> 
> This should only need 0200?
> 

This needs to be CONFIG_COMPACTION as well, we won't have the handler 
without mm/compaction.c.
