Return-Path: <linux-kernel-owner+w=401wt.eu-S1757710AbZCTKQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbZCTKQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 06:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752298AbZCTKQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 06:16:36 -0400
Received: from smtp-out.google.com ([216.239.33.17]:26280 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZCTKQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 06:16:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=ZhZuYU4RyZJSizJn0hTT0t2Wa+MSJ3CKjXS3h1PBk2FdTERmbx7y52JNDMU/8lfWh
	aZm9BzczRysthYRBccbjg==
Date: Fri, 20 Mar 2009 03:15:41 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [patch] vmscan: print shrink_slab symbol name on negative shrinker
 objects
In-Reply-To: <20090319163314.527687fc.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.0903200314280.10035@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0903191609040.2457@chino.kir.corp.google.com> <20090319163314.527687fc.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009, Andrew Morton wrote:

> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -40,6 +40,7 @@
> >  #include <linux/memcontrol.h>
> >  #include <linux/delayacct.h>
> >  #include <linux/sysctl.h>
> > +#include <linux/kallsyms.h>
> >  
> >  #include <asm/tlbflush.h>
> >  #include <asm/div64.h>
> > @@ -214,8 +215,12 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
> >  		do_div(delta, lru_pages + 1);
> >  		shrinker->nr += delta;
> >  		if (shrinker->nr < 0) {
> > -			printk(KERN_ERR "%s: nr=%ld\n",
> > -					__func__, shrinker->nr);
> > +			char symname[KSYM_NAME_LEN];
> > +
> > +			if (lookup_symbol_name((unsigned long)shrinker->shrink,
> > +					       symname) > 0)
> > +				printk(KERN_ERR "shrink_slab: %s nr=%ld\n",
> > +				       symname, shrinker->nr);
> >  			shrinker->nr = max_pass;
> >  		}
> 
> Can we use the new printk("%pF", ...) here?
> 

Cool, that's super convenient.


vmscan: print shrink_slab symbol name on negative shrinker objects

When a shrinker has a negative number of objects to delete, the symbol
name of the shrinker should be printed, not shrink_slab.  This also makes
the error message slightly more informative.

Cc: Ingo Molnar <mingo@elte.hu>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmscan.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -214,8 +214,9 @@ unsigned long shrink_slab(unsigned long scanned, gfp_t gfp_mask,
 		do_div(delta, lru_pages + 1);
 		shrinker->nr += delta;
 		if (shrinker->nr < 0) {
-			printk(KERN_ERR "%s: nr=%ld\n",
-					__func__, shrinker->nr);
+			printk(KERN_ERR "shrink_slab: %pF negative objects to "
+			       "delete nr=%ld\n",
+			       shrinker->shrink, shrinker->nr);
 			shrinker->nr = max_pass;
 		}
 
