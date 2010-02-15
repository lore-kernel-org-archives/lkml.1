Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab0BOAQa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 19:16:30 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:42145 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754869Ab0BOANX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 19:13:23 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 15 Feb 2010 09:09:49 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, Lubos Lunak <l.lunak@suse.cz>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch 6/7 -mm] oom: avoid oom killer for lowmem allocations
Message-Id: <20100215090949.169f2819.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.DEB.2.00.1002120200050.22883@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1002100224210.8001@chino.kir.corp.google.com>
	<alpine.DEB.2.00.1002100229410.8001@chino.kir.corp.google.com>
	<20100212102841.fa148baf.kamezawa.hiroyu@jp.fujitsu.com>
	<alpine.DEB.2.00.1002120200050.22883@chino.kir.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Feb 2010 02:06:49 -0800 (PST)
David Rientjes <rientjes@google.com> wrote:

> On Fri, 12 Feb 2010, KAMEZAWA Hiroyuki wrote:
> 
> > From viewpoint of panic-on-oom lover, this patch seems to cause regression.
> > please do this check after sysctl_panic_on_oom == 2 test.
> > I think it's easy. So, temporary Nack to this patch itself.
> > 
> > 
> > And I think calling notifier is not very bad in the situation.
> > ==
> > void out_of_memory()
> >  ..snip..
> >   blocking_notifier_call_chain(&oom_notify_list, 0, &freed);
> > 
> > 
> > So,
> > 
> >         if (sysctl_panic_on_oom == 2) {
> >                 dump_header(NULL, gfp_mask, order, NULL);
> >                 panic("out of memory. Compulsory panic_on_oom is selected.\n");
> >         }
> > 
> > 	if (gfp_zone(gfp_mask) < ZONE_NORMAL) /* oom-kill is useless if lowmem is exhausted. */
> > 		return;
> > 
> > is better. I think.
> > 
> 
> I can't agree with that assessment, I don't think it's a desired result to 
> ever panic the machine regardless of what /proc/sys/vm/panic_on_oom is set 
> to because a lowmem page allocation fails especially considering, as 
> mentioned in the changelog, these allocations are never __GFP_NOFAIL and 
> returning NULL is acceptable.
> 
please add
  WARN_ON((high_zoneidx < ZONE_NORMAL) && (gfp_mask & __GFP_NOFAIL))
somewhere. Then, it seems your patch makes sense.

I don't like the "possibility" of inifinte loops.

Thanks,
-Kame



