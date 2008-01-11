Return-Path: <linux-kernel-owner+w=401wt.eu-S1761692AbYAKPrR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761692AbYAKPrR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 10:47:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759925AbYAKPrF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 10:47:05 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759762AbYAKPrD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 10:47:03 -0500
Date: Fri, 11 Jan 2008 10:46:51 -0500
From: Rik van Riel <riel@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Subject: Re: [patch 05/19] split LRU lists into anon & file sets
Message-ID: <20080111104651.3ebea5ea@bree.surriel.com>
In-Reply-To: <20080111162320.FD6A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080108205939.323955454@redhat.com>
	<20080108210002.638347207@redhat.com>
	<20080111162320.FD6A.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Jan 2008 16:35:24 +0900
KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:

> Why drop (total_swap_pages == 0 && PageAnon(page)) condition?
> in embedded sysmtem, 
> CONFIG_NORECLAIM is OFF (because almost embedded cpu is 32bit) and
> that anon move to inactive list is meaningless because it doesn't have swap.

That was a mistake, kind of.  Since all swap backed pages are on their
own LRU lists, we should not scan those lists at all any more if we are
out of swap space.

The patch that fixes get_scan_ratio() adds that test.

Having said that, with the nr_swap_pages==0 test in get_scan_ratio(),
we no longer need to test for that condition in shrink_active_list().

> below code is more good, may be.
> but I don't understand yet why ignore page_referenced() result at anon page ;-)

On modern systems, swapping out anonymous pages is a relatively rare
event.  All anonymous pages start out as active and referenced, so
testing for that condition does (1) not add any information and (2)
mean we need to scan ALL of the anonymous pages, in order to find one
candidate to swap out (since they are all referenced).

Simply deactivating a few pages and checking whether they were referenced
again while on the (smaller) inactive_anon_list means we can find candidates
to page out with a lot less CPU time used.

-- 
All rights reversed.
