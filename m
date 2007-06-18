Return-Path: <linux-kernel-owner+w=401wt.eu-S933562AbXFRXF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbXFRXF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 19:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764671AbXFRXFU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 19:05:20 -0400
Received: from tomts10-srv.bellnexxia.net ([209.226.175.54]:37557 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764571AbXFRXFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 19:05:20 -0400
Date: Mon, 18 Jun 2007 19:05:12 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Chuck Ebbert <cebbert@redhat.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       prasanna@in.ibm.com, ananth@in.ibm.com, jkenisto@us.ibm.com, ak@suse.de
Subject: Re: [patch 1/3] Text Edit Lock - i386
Message-ID: <20070618230511.GA26598@Krystal>
References: <20070618215846.247539382@polymtl.ca> <20070618220458.888939232@polymtl.ca> <46770CA9.4070304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <46770CA9.4070304@redhat.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:57:09 up 21 days,  7:35,  1 user,  load average: 0.29, 0.61, 0.70
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Chuck Ebbert (cebbert@redhat.com) wrote:
> On 06/18/2007 05:58 PM, Mathieu Desnoyers wrote:
> > Interface to use for code patching : uses a mutex to insure mutual edit
> > exclusion and makes sure the page is writable.
> > 
> ... 
> > +/* Mutex protecting text section modification (dynamic code patching) */
> > +static DEFINE_MUTEX(text_mutex);
> > +
> 
> Probably should be a spinlock.
> 
> And it just occurred to me, how does smp_alternatives deal with this?
> Is it broken now when the text section is read-only?

(note that the implementation I just posted is a proof of concept: I
just noticed that I need to keep track of wether or not I am called
before or after the mark_rodata is done, so the apply alternatives does
not crash at early boot because of the global_flush_tlb().)

A spinlock it will be then :)

SMP alternatives deals with this by simply disabling the whole
protection:

mark_rodata_ro():

#ifdef CONFIG_HOTPLUG_CPU
        /* It must still be possible to apply SMP alternatives. */
        if (num_possible_cpus() <= 1)
#endif
        {
                change_page_attr(virt_to_page(start),
                                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
                printk("Write protecting the kernel text: %luk\n", size >> 10);
        }

So it's ok if no CPU can be hotplugged, since the CPUs are brought up
before the mark_rodata_ro is done, but not if HOTPLUG is selected.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
