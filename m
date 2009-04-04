Return-Path: <linux-kernel-owner+w=401wt.eu-S1757290AbZDDLNT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757290AbZDDLNT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 07:13:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZDDLNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 07:13:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:57222 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZDDLNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 07:13:04 -0400
Subject: RE: [patch 03/20] x86, ptrace, bts: defer branch trace stopping
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Metzger, Markus T" <markus.t.metzger@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
       "hpa@zytor.com" <hpa@zytor.com>,
       "markus.t.metzger@gmail.com" <markus.t.metzger@gmail.com>,
       "roland@redhat.com" <roland@redhat.com>,
       "eranian@googlemail.com" <eranian@googlemail.com>,
       "oleg@redhat.com" <oleg@redhat.com>,
       "Villacis, Juan" <juan.villacis@intel.com>,
       "ak@linux.jf.intel.com" <ak@linux.jf.intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
References: <20090403144332.799740000@intel.com>
	 <20090403144550.712401000@intel.com> <1238770852.798.146.camel@twins>
	 <928CFBE8E7CB0040959E56B4EA41A77E9271853A@irsmsx504.ger.corp.intel.com>
Content-Type: text/plain
Date: Sat, 04 Apr 2009 13:12:31 +0200
Message-Id: <1238843551.4549.1041.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-04-04 at 08:17 +0100, Metzger, Markus T wrote:
> >-----Original Message-----
> >From: Peter Zijlstra [mailto:a.p.zijlstra@chello.nl]
> >Sent: Friday, April 03, 2009 5:01 PM
> >To: Metzger, Markus T
> 
> 
> >Also, I can't say I like the name, what about something like:
> >
> >void account_locked_buffer(struct mm_struct *mm, long pages)
> >{
> >	down_write(&mm->mmap_sem);
> >
> >	mm->total_vm += pages;
> >	mm->locked_vm += pages;
> >
> >	up_write(&mm->mmap_sem);
> >}
> >
> >but looking more closely at that alloc_locked_buffer() stuff, I really
> >hate it, who in his right mind does a multi-page kmalloc() -- that's
> >crazy.
> 
> I need a non-pageable chunk of memory to give to the cpu to store branch
> trace data in. Kmalloc() is easy to use and gives me what I need.
> 
> How would I do this correctly?

Well, how large should this buffer be and must it be physically
contiguous?

Apparently its large enough to account in pages, that would suggest you
should use the page allocator to get memory.

Furthermore, if it needs to be physically contiguous and its more than
say 8 pages worth, you're basically up shit creek.

