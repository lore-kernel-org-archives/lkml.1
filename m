Return-Path: <linux-kernel-owner+w=401wt.eu-S1751329AbZLCFPH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751329AbZLCFPH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 00:15:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751167AbZLCFPG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 00:15:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56650 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750757AbZLCFPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 00:15:05 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH 2/9] ksm: let shared pages be swappable
Cc: kosaki.motohiro@jp.fujitsu.com, Rik van Riel <riel@redhat.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Izik Eidus <ieidus@redhat.com>, Chris Wright <chrisw@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20091202125501.GD28697@random.random>
References: <4B15F642.1080308@redhat.com> <20091202125501.GD28697@random.random>
Message-Id: <20091203134610.586E.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  3 Dec 2009 14:15:06 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Wed, Dec 02, 2009 at 12:08:18AM -0500, Rik van Riel wrote:
> > The VM needs to touch a few (but only a few) PTEs in
> > that situation, to make sure that anonymous pages get
> > moved to the inactive anon list and get to a real chance
> > at being referenced before we try to evict anonymous
> > pages.
> > 
> > Without a small amount of pre-aging, we would end up
> > essentially doing FIFO replacement of anonymous memory,
> > which has been known to be disastrous to performance
> > for over 40 years now.
> 
> So far the only kernel that hangs in fork is the newer one...
> 
> In general I cannot care less about FIFO, I care about no CPU waste on
> 100% of my systems were swap is not needed. All my unmapped cache is
> 100% garbage collectable, and there is never any reason to flush any
> tlb and walk the rmap chain. Give me a knob to disable the CPU waste
> given I know what is going on, on my systems. I am totally ok with
> slightly slower swap performance and fifo replacement in case I
> eventually hit swap for a little while, then over time if memory
> pressure stays high swap behavior will improve regardless of
> flooding ipis to clear young bit when there are hundred gigabytes of
> freeaeble cache unmapped and clean.
> 
> > Having said that - it may be beneficial to keep very heavily
> > shared pages on the active list, without ever trying to scan
> > the ptes associated with them.
> 
> Just mapped pages in general, not heavily... The other thing that is
> beneficial likely is to stop page_referenced after 64 young bit clear,
> that is referenced enough, you can enable this under my knob so that
> it won't screw your algorithm. I don't have 1 terabyte of memory, so
> you don't have to worry for me, I just want every cycle out of my cpu
> without having to use O_DIRECT all the time.

Umm?? Personally I don't like knob. If you have problematic workload,
please tell it us. I will try to make reproduce environment on my box.
If current code doesn't works on KVM or something-else, I really want
to fix it.

I think Larry's trylock idea and your 64 young bit idea can be combinate.
I only oppose the page move to inactive list without clear young bit. IOW,
if VM pressure is very low and the page have lots young bit, the page should
go back active list although trylock(ptelock) isn't contended.

But unfortunatelly I don't have problem workload as you mentioned. Anyway
we need evaluate way to your idea. We obviouslly more info.




