Return-Path: <linux-kernel-owner+w=401wt.eu-S1756728AbZF1VGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728AbZF1VGI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 17:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754021AbZF1VF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 17:05:57 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:58456 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZF1VF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 17:05:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=qda9iCOru5LBsHeFQuaJ/KKa6Wj93XbfNAfrNaH1PO67GiZhuiMqKNBwBBvTFIZ/tR
         x75oXbQgFmrHor0LKWAgC6KBQlglLn0Yu+jRVus9qVYCBj1JcC0Kw+ocyGwypBCv6ReN
         C67MErnEP+wtvNwSdz5Yg9m3U8v6wQMxqSooI=
Date: Sun, 28 Jun 2009 23:05:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH 0/2] perfcounter: callchains with perf report
Message-ID: <20090628210554.GA6267@nowhere>
References: <1246026481-8314-1-git-send-email-fweisbec@gmail.com> <19013.29199.123045.531291@cargo.ozlabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19013.29199.123045.531291@cargo.ozlabs.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 27, 2009 at 11:12:47AM +1000, Paul Mackerras wrote:
> Frederic Weisbecker writes:
> 
> > Here is a first shot for the sorted callchains per entries handling
> > with per report.
> > 
> > I'll continue to improve it:
> > 
> > - symbol resolution
> > - profit we have a tree to display a better graph hierarchy
> > - let the user provide a limit for hit percentage, depth, number of
> >   backtraces, etc...
> > - better output
> > - colors
> > - and so on....
> 
> Nice!
> 
> I have just about finished doing the kernel piece of callchain support
> on powerpc.  Because of the way function calls and returns work on
> powerpc, working out the first one or two return addresses can be
> tricky.  We potentially have a valid return address in the link
> register (LR), or in the LR save area in the second stack frame, or
> both, and you need extra information such as DWARF unwind tables to
> work out which of those three possibilities you have, in general.
> This is the case at each point where an interrupt or signal has
> occurred.
> 
> Because I didn't want to go trawling through CFI tables at interrupt
> time, particularly for user code, I made the kernel save both possible
> return addresses in the callchain.  For the kernel part of the
> callchain, I check those two addresses to see if they're valid kernel
> addresses and set them to 0 if not, or if they're equal.
> 
> That means I need to make some changes to builtin-report.c to ignore
> zero addresses.  I may need to add stuff to look for and use unwind
> tables as well, if we want completely accurate call chains.


Well, I guess I can ignore them in my further patches.
But wouldn't it be better to discard them from the kernel?
Unless it's somewhat useful to know we had an unknown entry?

 
> The other thing I did is to put PERF_CONTEXT_KERNEL markers in the
> callchain every time we find an interrupt frame, and PERF_CONTEXT_USER
> markers every time we find a signal frame, so that userspace knows
> when it needs to do the unwinding.
> 
> Oh, and a third point is that on powerpc the sampled IP recorded if
> you ask for PERF_SAMPLE_IP won't in general be the same as the first
> IP in the callchain.  The reason is that the PERF_SAMPLE_IP value
> points to the instruction that caused the counter overflow whereas the
> first IP in the callchain tells you where the CPU took the interrupt.
> That is almost always a few instructions further on, and can be quite
> a way further on if interrupts were disabled when the counter overflow
> occur.  In fact we regularly see the PERF_SAMPLE_IP value being in the
> hypervisor but the first IP in the callchain being in the kernel.


Ok.

> 
> Paul.

