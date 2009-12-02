Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbZLBClx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbZLBClx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 21:41:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZLBClw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 21:41:52 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39884 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbZLBClw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 21:41:52 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] high system time & lock contention running large mixed workload
Cc: kosaki.motohiro@jp.fujitsu.com, Larry Woodman <lwoodman@redhat.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       akpm@linux-foundation.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <4B15CEE0.2030503@redhat.com>
References: <1259685662.2345.11.camel@dhcp-100-19-198.bos.redhat.com> <4B15CEE0.2030503@redhat.com>
Message-Id: <20091202113809.5C4C.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  2 Dec 2009 11:41:55 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 12/01/2009 11:41 AM, Larry Woodman wrote:
> >
> > Agreed.  The attached updated patch only does a trylock in the
> > page_referenced() call from shrink_inactive_list() and only for
> > anonymous pages when the priority is either 10, 11 or
> > 12(DEF_PRIORITY-2).  I have never seen a problem like this with active
> > pagecache pages and it does not alter the existing shrink_page_list
> > behavior.  What do you think about this???
> This is reasonable, except for the fact that pages that are moved
> to the inactive list without having the referenced bit cleared are
> guaranteed to be moved back to the active list.
> 
> You'll be better off without that excess list movement, by simply
> moving pages directly back onto the active list if the trylock
> fails.
> 
> Yes, this means that page_referenced can now return 3 different
> return values (not accessed, accessed, lock contended), which
> should probably be an enum so we can test for the values
> symbolically in the calling functions.
> 
> That way only pages where we did manage to clear the referenced bit
> will be moved onto the inactive list.  This not only reduces the
> amount of excess list movement, it also makes sure that the pages
> which do get onto the inactive list get a fair chance at being
> referenced again, instead of potentially being flooded out by pages
> where the trylock failed.

Agreed.


> A minor nitpick: maybe it would be good to rename the "try" parameter
> to "noblock".  That more closely matches the requested behaviour.

Another minor nit: probably we have to rename page_referenced(). it imply test
reference bit. but we use it for clear reference bit in shrink_active_list.



