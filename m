Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYHWULX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYHWULX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 16:11:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753735AbYHWULO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 16:11:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44708 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753781AbYHWULN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 16:11:13 -0400
Date: Sat, 23 Aug 2008 13:10:45 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Alan D. Brunelle" <Alan.Brunelle@hp.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Bug #11342] Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c -
 bisected
In-Reply-To: <VSpL6AnBTS.A.q9H.6aGsIB@albercik>
Message-ID: <alpine.LFD.1.10.0808231257310.3363@nehalem.linux-foundation.org>
References: <mzBsPw3QUOF.A.87F.wZGsIB@albercik> <VSpL6AnBTS.A.q9H.6aGsIB@albercik>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Rafael J. Wysocki wrote:
> 
> The following bug entry is on the current list of known regressions
> from 2.6.26.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11342
> Subject		: Linux 2.6.27-rc3: kernel BUG at mm/vmalloc.c - bisected
> Submitter	: Alan D. Brunelle <Alan.Brunelle@hp.com>
> Date		: 2008-08-13 23:03 (11 days old)
> References	: http://marc.info/?l=linux-kernel&m=121866876027629&w=4
> Handled-By	: Andrew Morton <akpm@linux-foundation.org>

This one makes no sense. It's triggering a BUG_ON(in_interrupt()), but 
then the call chain shows that there is no interrupt going on.

Also, the bisection is senseless - there's a trivial change wrt 
"do_one_initcall()" that got merged, but everything else is trivial about 
lguest and has nothing to do with the whole CPU-init thing. But if it was 
that initcall one, then "git bisect" woul have pointed to it, not the 
merge. And the merge itself had no conflicts or anything else going on..

The fact that it came and went later also implies that it's probably just 
some timing-dependent thing or some subtle memory corruption, making the 
bisection result even less likely to be exact.

But I'm adding Arjan and Rusty to the Cc, because that merge was takign 
Rusty's branch, and the "do_one_initcall()" is Arjan's commit. Since 
undoing that merge apparently does fix it, I'm wondering if something 
there just does end up triggering the problem.

The do_one_commit() thing _is_ in the path of sys_init_module(), so it 
_is_ at least somewhat relevant from an oops standpoint. 

One thing the "do_one_commit()" thing does is to put more pressure on the 
stack due to that whole buffer for the printk's going on.

Alan, can you try 
 - seeing how consistent it is with one kernel (ie boot a known-bad kernel 
   a few times just to see if it really is 100% consistent)
 - try enabling 'initcall_debug' on the kernel command line, to (a) see 
   the new code actually do something and (b) see what it is actually 
   calling just before.

Hmm..

			Linus
