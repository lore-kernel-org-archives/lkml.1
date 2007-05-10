Return-Path: <linux-kernel-owner+w=401wt.eu-S1761051AbXEJTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761051AbXEJTqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992AbXEJTql
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:46:41 -0400
Received: from tomts40.bellnexxia.net ([209.226.175.97]:52257 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755326AbXEJTqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:46:40 -0400
Date: Thu, 10 May 2007 15:46:38 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       Adrian Bunk <bunk@stusta.de>
Subject: Re: [patch 02/10] Linux Kernel Markers, architecture independent code.
Message-ID: <20070510194638.GC6320@Krystal>
References: <20070510015555.973107048@polymtl.ca> <20070510020915.609367244@polymtl.ca> <20070510051043.GA6640@martell.zuzino.mipt.ru> <20070510131240.GD22424@Krystal> <20070510190027.GA5709@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070510190027.GA5709@martell.zuzino.mipt.ru>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 15:46:27 up 97 days,  9:53,  4 users,  load average: 2.17, 2.40, 2.63
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Alexey Dobriyan (adobriyan@gmail.com) wrote:
> On Thu, May 10, 2007 at 09:12:41AM -0400, Mathieu Desnoyers wrote:
> > Linux Kernel Markers - Architecture Independant Code fix 2
> >
> > Fix trivial SMP bug in list_modules.
> 
> > --- linux-2.6-lttng.orig/kernel/module.c	2007-05-10 08:51:02.000000000 -0400
> > +++ linux-2.6-lttng/kernel/module.c	2007-05-10 08:51:06.000000000 -0400
> > @@ -2657,13 +2657,16 @@
> >  	/* Enumerate loaded modules */
> >  	struct list_head	*i;
> >  	struct module		*mod;
> > -	unsigned long refcount = 0;
> > +	unsigned long refcount;
> > +	int cpu;
> >
> >  	mutex_lock(&module_mutex);
> >  	list_for_each(i, &modules) {
> >  		mod = list_entry(i, struct module, list);
> > +		refcount = 0;
> >  #ifdef CONFIG_MODULE_UNLOAD
> > -		refcount = local_read(&mod->ref[0].count);
> > +		for_each_online_cpu(cpu)
> > +			refcount += local_read(&mod->ref[cpu].count);
> >  #endif //CONFIG_MODULE_UNLOAD
> 
> Still wrong: module_get on cpu X, cpu X hot unplugged. There is
> module_refcount() for you.

Ok, fixing. thanks.

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
