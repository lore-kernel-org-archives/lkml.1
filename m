Return-Path: <linux-kernel-owner+w=401wt.eu-S1758747AbYGAPnu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758747AbYGAPnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:43:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754925AbYGAPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:43:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751820AbYGAPnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:43:40 -0400
Date: Tue, 1 Jul 2008 08:43:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Paul Mundt <lethal@linux-sh.org>
cc: Hideo Saito <saito@densan.co.jp>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: follow_page() performance regressions
In-Reply-To: <20080701052543.GA4726@linux-sh.org>
Message-ID: <alpine.LFD.1.10.0807010837510.20870@hp.linux-foundation.org>
References: <20080701.132439.68562265.saito@densan.co.jp> <20080701052543.GA4726@linux-sh.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 1 Jul 2008, Paul Mundt wrote:
> 
> So yes, the ZERO_PAGE handling in follow_page() is causing the slow-down here.

I suspect it could be any of:

 - actual code generation differences in follow_page() (some SH person 
   needs to check that)

 - some cache issue on SH. ZERO_PAGE is a single page at a fixed virtual 
   address, while it used to populate the page tables with individual 
   pages. Normally, this should be *better* for caching, but maybe there 
   is some conflict? What kind of caches does SH have (virtually indexed?)

 - hackbench relying on follow_page() to populate the page tables, which 
   it no longer does for anonymous areas (using ZERO_PAGE directly 
   instead).

   Again, normally this would speed things up (fewer TLB misses etc), but 
   if it then causes a new page fault that used to have been covered by 
   follow_page(), who knows?

What does hackbench actually do? Anybody?

			Linus
