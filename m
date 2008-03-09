Return-Path: <linux-kernel-owner+w=401wt.eu-S1753646AbYCIL45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646AbYCIL45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2008 07:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751051AbYCIL4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Mar 2008 07:56:45 -0400
Received: from www.tglx.de ([62.245.132.106]:33821 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752896AbYCIL4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2008 07:56:37 -0400
Date: Sun, 9 Mar 2008 12:56:11 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Ingo Molnar <mingo@elte.hu>
cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: quicklists confuse meminfo
In-Reply-To: <20080309111456.GA21690@elte.hu>
Message-ID: <alpine.LFD.1.00.0803091244420.3099@apollo.tec.linutronix.de>
References: <alpine.LFD.1.00.0803090919481.3099@apollo.tec.linutronix.de> <20080309111456.GA21690@elte.hu>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Mar 2008, Ingo Molnar wrote:

> 
> * Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > Bart reported http://bugzilla.kernel.org/show_bug.cgi?id=9991. He 
> > assumed a memory leak in 32bit kernels when he analyzed the output of 
> > /proc/meminfo.
> > 
> > The leak is not a leak, it's an accounting bug. quicklists keep a 
> > large amount of pages which are accounted as used memory.
> [...]
> > Another strange observation about quicklists is the imbalance of the 
> > quicklists across CPUs. Running the above loop on a 2way machine I can 
> > observe that the quicklist pages are acuumulating on one CPU. Stopping 
> > and restarting the loop a couple of times can shift the accumulation 
> > from one to the other CPU.
> 
> hm. I think we should not let this much RAM hang around in a 
> special-purpose allocator like quicklists. Shouldnt the quicklists be 
> temporary in nature, and be trimmed much more agressively?
> 
> in fact, we have a check_pgt_cache() call in cpu_idle(), which does:
> 
>         quicklist_trim(0, pgd_dtor, 25, 16);
> 
> but it appears we dont do quicklist trimming anywhere else! So if a 
> system has no idle time, the quicklist can grow unbounded, and that's a 
> real memory leak IMO.

Right, also the quicklist_trim() in idle() is freeing at max 16 pages
in one go. According to the quicklist_trim() code we keep up to
(node_free_pages / 16) in the quicklist unconditionally, which seems
rather odd as well.

Thanks,
	tglx
