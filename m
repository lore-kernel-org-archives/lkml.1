Return-Path: <linux-kernel-owner+w=401wt.eu-S1754696AbZAZUp7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696AbZAZUp7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 15:45:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752094AbZAZUpq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 15:45:46 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56142 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751973AbZAZUpp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 15:45:45 -0500
Date: Mon, 26 Jan 2009 12:44:27 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: npiggin@suse.de, linux-arch@vger.kernel.org, torvalds@linux-foundation.org,
       rusty@rustcorp.com.au, travis@sgi.com, linux-kernel@vger.kernel.org,
       venkatesh.pallipadi@intel.com, suresh.b.siddha@intel.com,
       arjan@infradead.org, hpa@zytor.com, tglx@linutronix.de,
       Ying Han <yinghan@google.com>, Mike Waychison <mikew@google.com>
Subject: Re: [git pull] cpus4096 tree, part 3
Message-Id: <20090126124427.6d13f341.akpm@linux-foundation.org>
In-Reply-To: <20090126200957.GB13471@elte.hu>
References: <alpine.LFD.2.00.0901021531140.3179@localhost.localdomain>
	<20090103193859.GB9805@elte.hu>
	<alpine.LFD.2.00.0901031225020.3179@localhost.localdomain>
	<20090103203621.GA2491@elte.hu>
	<20090103213856.GA24138@elte.hu>
	<alpine.LFD.2.00.0901031347570.3179@localhost.localdomain>
	<20090103223723.GA17047@elte.hu>
	<20090105011416.GG32239@wotan.suse.de>
	<20090105011630.GI32239@wotan.suse.de>
	<20090126110054.bdddbf38.akpm@linux-foundation.org>
	<20090126200957.GB13471@elte.hu>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2009 21:09:57 +0100
Ingo Molnar <mingo@elte.hu> wrote:

> ...
>
> Btw., regarding pagefault retry. The bits that are in -mm currently i 
> find a bit ugly:
> 
> > +++ a/arch/x86/mm/fault.c
> > @@ -799,7 +799,7 @@ void __kprobes do_page_fault(struct pt_r
> >  	struct vm_area_struct *vma;
> >  	int write;
> >  	int fault;
> > -	unsigned int retry_flag = FAULT_FLAG_RETRY;
> > +	int retry_flag = 1;
> >  
> >  	tsk = current;
> >  	mm = tsk->mm;
> > @@ -951,6 +951,7 @@ good_area:
> >  	}
> >  
> >  	write |= retry_flag;
> > +
> >  	/*
> >  	 * If for any reason at all we couldn't handle the fault,
> >  	 * make sure we exit gracefully rather than endlessly redo
> > @@ -969,8 +970,8 @@ good_area:
> >  	 * be removed or changed after the retry.
> >  	 */
> >  	if (fault & VM_FAULT_RETRY) {
> > -		if (write & FAULT_FLAG_RETRY) {
> > -			retry_flag &= ~FAULT_FLAG_RETRY;
> > +		if (retry_flag) {
> > +			retry_flag = 0;
> >  			goto retry;
> >  		}
> >  		BUG();
> 
> as this complicates every architecture with a 'can the fault be retried' 
> logic and open-coded retry loop.
> 
> But that logic is rather repetitive and once an architecture filters out 
> all its special in-kernel sources of faults and the hw quirks it has, the 
> handling of pte faults is rather generic and largely offloaded into 
> handle_pte_fault() already.
> 
> So when this patch was submitted a few weeks ago i suggested that retry 
> should be done purely in mm/memory.c instead, and the low level code 
> should at most be refactored to suit this method, but not complicated any 
> further.
> 
> Any deep reasons for why such a more generic approach is not desirable?
> 

Let's cc the people who wrote it.
