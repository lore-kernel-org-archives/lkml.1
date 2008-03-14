Return-Path: <linux-kernel-owner+w=401wt.eu-S1758914AbYCNVJm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758914AbYCNVJm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 17:09:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754789AbYCNVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 17:09:33 -0400
Received: from relay2.sgi.com ([192.48.171.30]:50606 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754424AbYCNVJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 17:09:33 -0400
Date: Fri, 14 Mar 2008 14:08:36 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Kay Sievers <kay.sievers@vrfy.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: hackbench regression since 2.6.25-rc
In-Reply-To: <1205478861.3215.279.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0803141356540.28115@schroedinger.engr.sgi.com>
References: <1205394417.3215.85.camel@ymzhang>  <20080313014808.f8d25c2a.akpm@linux-foundation.org>
  <1205400538.3215.148.camel@ymzhang>  <Pine.LNX.4.64.0803131714130.22519@schroedinger.engr.sgi.com>
  <1205463842.3215.188.camel@ymzhang>  <Pine.LNX.4.64.0803132328330.24204@schroedinger.engr.sgi.com>
 <1205478861.3215.279.camel@ymzhang>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Mar 2008, Zhang, Yanmin wrote:

> > Ahhh... Okay those slabs did not change for 2.6.25-rc. Is there
> > really a difference to 2.6.24?
> As oprofile shows slub functions spend more than 80% cpu time, I would like
> to focus on optimizing SLUB before going back to 2.6.24.

I thought you wanted to address a regression vs 2.6.24?

> kmalloc-512: No NUMA information available.
> 
> Slab Perf Counter       Alloc     Free %Al %Fr
> --------------------------------------------------
> Fastpath             55039159  5006829  68   6
> Slowpath             24975754 75007769  31  93
> Page Alloc              73840    73779   0   0
> Add partial                 0 24341085   0  30
> Remove partial       24267297    73779  30   0

^^^ add partial/remove partial is likely the cause for 
trouble here. 30% is unacceptably high. The larger allocs will reduce the 
partial handling overhead. That is likely the effect that we see here.

> Refill 24975738

Duh refills at 50%? We could try to just switch to another slab instead of 
reusing the existing one. May also affect the add/remove partial 
situation.



