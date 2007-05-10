Return-Path: <linux-kernel-owner+w=401wt.eu-S1762078AbXEJND6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762078AbXEJND6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755709AbXEJNDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:03:51 -0400
Received: from tomts20.bellnexxia.net ([209.226.175.74]:65133 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755629AbXEJNDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:03:50 -0400
Date: Thu, 10 May 2007 08:58:40 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 02/10] Linux Kernel Markers, architecture independent code.
Message-ID: <20070510125840.GB22424@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.609367244@polymtl.ca> <20070510051043.GA6640@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510051043.GA6640@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 08:43:47 up 97 days,  2:50,  4 users,  load average: 2.01, 2.17, 2.34
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alexey,

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Wed, May 09, 2007 at 09:55:57PM -0400, Mathieu Desnoyers wrote:
> > --- /dev/null
> > +++ linux-2.6-lttng/include/linux/marker.h
> > @@ -0,0 +1,124 @@
> 
> > +#ifdef __KERNEL__
> 
> Just don't add this file to include/linux/Kbuild and remove __KERNEL__
> ifdef.
> 
> > --- linux-2.6-lttng.orig/include/linux/module.h
> > +++ linux-2.6-lttng/include/linux/module.h
> > @@ -356,6 +356,9 @@
> >  	/* The command line arguments (may be mangled).  People like
> >  	   keeping pointers to this stuff */
> >  	char *args;
> > +
> > +	const struct __mark_marker *markers;
> > +	unsigned int num_markers;
> 
> #ifdef CONFIG_MARKERS, please.
> 

Ok, I merged the patch from SystemTAP to help them parse the markers
section, but seeing the violent objections it gets, I guess they will
have to figure out another way to parse it. Let's drop the
allow-userspace-applications-to-use-markerh-to-parse-the-markers-section-in-the-kernel-binary.patch
then.


> > --- linux-2.6-lttng.orig/kernel/module.c
> > +++ linux-2.6-lttng/kernel/module.c
> 
> > @@ -1659,6 +1884,9 @@
> >  	unsigned int unusedcrcindex;
> >  	unsigned int unusedgplindex;
> >  	unsigned int unusedgplcrcindex;
> > +	unsigned int markersindex;
> > +	unsigned int markersdataindex;
> > +	unsigned int markersstringsindex;
> 
> Bunch of underscores wouldn't hurt.
> 

Hrm, I used the exact same variable naming style already present in the
function. Do you suggest changing _every_ variable name to underscores ?

> > +void list_modules(void)
> > +{
> > +	/* Enumerate loaded modules */
> > +	struct list_head	*i;
> > +	struct module		*mod;
> > +	unsigned long refcount = 0;
> > +
> > +	mutex_lock(&module_mutex);
> > +	list_for_each(i, &modules) {
> > +		mod = list_entry(i, struct module, list);
> > +#ifdef CONFIG_MODULE_UNLOAD
> > +		refcount = local_read(&mod->ref[0].count);
> 						^
> Buy second CPU, already. ;-)
>

Good catch, will fix. I do already have more than one, don't worry ;)

> > +#endif //CONFIG_MODULE_UNLOAD
> > +		trace_mark(list_module, "%s %d %lu",
> > +				mod->name, mod->state, refcount);
> > +	}
> > +	mutex_unlock(&module_mutex);
> > +}
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
