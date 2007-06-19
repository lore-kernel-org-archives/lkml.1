Return-Path: <linux-kernel-owner+w=401wt.eu-S1757556AbXFSObu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757556AbXFSObu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 10:31:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754927AbXFSObl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 10:31:41 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:47423 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbXFSObk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 10:31:40 -0400
Date: Tue, 19 Jun 2007 20:01:57 +0530
From: "S. P. Prasanna" <prasanna@in.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org,
       ananth@in.ibm.com
Subject: Re: [patch 2/2] kprobes x86_64 quick fix mark-ro-data
Message-ID: <20070619143156.GB5478@in.ibm.com>
Reply-To: prasanna@in.ibm.com
References: <20070615202310.178466032@polymtl.ca> <4676D2A9.6090403@redhat.com> <20070618115632.7aca8c0f.akpm@linux-foundation.org> <200706182132.56559.ak@suse.de> <20070619100644.GA5478@in.ibm.com> <20070619100810.GA301@in.ibm.com> <1182259288.3014.7.camel@laptopd505.fenrus.org> <20070619133020.GA22368@Krystal> <1182260670.3014.10.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182260670.3014.10.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 06:44:30AM -0700, Arjan van de Ven wrote:
> On Tue, 2007-06-19 at 09:30 -0400, Mathieu Desnoyers wrote:
> > * Arjan van de Ven (arjan@infradead.org) wrote:
> > > On Tue, 2007-06-19 at 15:38 +0530, S. P. Prasanna wrote:
> > > > This patch is a quick fix for x86_64 to enable kprobes only if DEBUG_RODATA is
> > > > not configured. Since DEBUG_RODATA markes the kernel text pages as read-only.
> > > 
> > > 
> > > it does??
> > > 
> > > I don't seem to be able to find this in the source code..... 
> > > 
> 
> > See arch/x86_64/mm/init.c:mark_rodata_ro().
> 
> eh woops
> 
> 
> PATCH] x86: tighten kernel image page access rights
> author
> Jan Beulich <jbeulich@novell.com>
> 
> Wed, 2 May 2007 17:27:10 +0000
> (19:27 +0200)
> committer
> Andi Kleen <andi@basil.nowhere.org>
> 
> Wed, 2 May 2007 17:27:10 +0000
> (19:27 +0200)
> commit
> 6fb14755a676282a4e6caa05a08c92db8e45cfff
> 
> 
> changed it to include text (even though Andi vetoed that before when I
> asked for it on grounds of breaking kprobes)... sounds this really wants
> to be a 2nd config option to seperatedly do code and data.

Something like having a seperate config option and a routine
to mark kernel text as read execute only.
And call mark_rwtext_ro() if CONFIG_DEBUG_ROTEXT is enabled
below in mark_rodata_ro().

/* this code is for i386 architecture*/
static inline void mark_rwtext_ro(void)
{
	unsigned long start = PFN_ALIGN(_text);
	unsigned long size = PFN_ALIGN(_etext) - start;

#ifdef CONFIG_HOTPLUG_CPU
	/* It must still be possible to apply SMP alternatives. */
	if (num_possible_cpus() <= 1)
#endif
	{
		change_page_attr(virt_to_page(start),
		                 size >> PAGE_SHIFT, PAGE_KERNEL_RX);
		printk("Write protecting the kernel text: %luk\n", size >> 10);
	}
	/*
	 * global_flush_tlb() will be called after marking the data as readonly.
	 */
}

#ifdef CONFIG_DEBUG_RODATA

void mark_rodata_ro(void)
{
....

#ifdef CONFIG_DEBUG_ROTEXT
	mark_rwtext_ro();
#endif
....

}

Thanks
Prasanna
-- 
Prasanna S.P.
Linux Technology Center
India Software Labs, IBM Bangalore
Email: prasanna@in.ibm.com
Ph: 91-80-41776329
