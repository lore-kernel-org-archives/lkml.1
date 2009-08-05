Return-Path: <linux-kernel-owner+w=401wt.eu-S934672AbZHEQgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934672AbZHEQgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 12:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934642AbZHEQgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 12:36:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48220 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934643AbZHEQgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 12:36:12 -0400
Date: Wed, 5 Aug 2009 18:35:37 +0200
From: Andrea Arcangeli <aarcange@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Wu Fengguang <fengguang.wu@intel.com>,
       "Dike, Jeffrey G" <jeffrey.g.dike@intel.com>,
       "Yu, Wilfred" <wilfred.yu@intel.com>,
       "Kleen, Andi" <andi.kleen@intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Mel Gorman <mel@csn.ul.ie>, LKML <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC] respect the referenced bit of KVM guest pages?
Message-ID: <20090805163537.GG23385@random.random>
References: <20090805024058.GA8886@localhost>
 <4A793B92.9040204@redhat.com>
 <4A7993F4.9020008@redhat.com>
 <4A79A16A.1050401@redhat.com>
 <4A79A1FB.6010406@redhat.com>
 <4A79A468.2020200@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A79A468.2020200@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 05, 2009 at 06:25:28PM +0300, Avi Kivity wrote:
> On 08/05/2009 06:15 PM, Rik van Riel wrote:
> > Avi Kivity wrote:
> >
> >>> If so, we could unmap them when they get moved from the
> >>> active to the inactive list, and soft fault them back in
> >>> on access, emulating the referenced bit for EPT pages and
> >>> making page replacement on them work like it should.
> >>
> >> It should be easy to implement via the mmu notifier callback: when 
> >> the mm calls clear_flush_young(), mark it as young, and unmap it from 
> >> the EPT pagetable.
> >
> > You mean "mark it as old"?
> 
> I meant 'return young, and drop it from the EPT pagetable'.
> 
> If we use the present bit as a replacement for the accessed bit, present 
> means young, and clear_flush_young means "if present, return young and 
> unmap, otherwise return old'.

This is the only way to provide accurate information, and it's still a
minor fault so not very different than return young first time around
and old second time around without invalidating the spte... but the
only reason I like it more is that it is done at the right time, like
for the ptes, so probably it's best to implement it this way to ensure
total fairness of the VM regardless if it's guest or qemu-kvm touching
the virtual memory.
