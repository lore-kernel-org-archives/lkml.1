Return-Path: <linux-kernel-owner+w=401wt.eu-S932253AbXCUP3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbXCUP3R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 11:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932247AbXCUP3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 11:29:17 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:49190 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932253AbXCUP3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 11:29:15 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17921.20299.7899.527765@gargle.gargle.HOWL>
Date: Wed, 21 Mar 2007 18:29:15 +0300
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
In-Reply-To: <46011EF6.3040704@redhat.com>
References: <46005B4A.6050307@redhat.com>
	<17920.61568.770999.626623@gargle.gargle.HOWL>
	<460115D9.7030806@redhat.com>
	<17921.7074.900919.784218@gargle.gargle.HOWL>
	<46011E8F.2000109@redhat.com>
	<46011EF6.3040704@redhat.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000579 c4b9fe8ba5119cc53e8acb6fa9f886e1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel writes:
 > Rik van Riel wrote:
 > > Nikita Danilov wrote:
 > > 
 > >> Probably I am missing something, but I don't see how that can help. For
 > >> example, suppose (for simplicity) that we have swappiness of 100%, and
 > >> that fraction of referenced anon pages gets slightly less than of file
 > >> pages. get_scan_ratio() increases anon_percent, and shrink_zone() starts
 > >> scanning anon queue more aggressively. As a result, pages spend less
 > >> time there, and have less chance of ever being accessed, reducing
 > >> fraction of referenced anon pages further, and triggering further
 > >> increase in the amount of scanning, etc. Doesn't this introduce positive
 > >> feed-back loop?
 > > 
 > > It's a possibility, but I don't think it will be much of an
 > > issue in practice.
 > > 
 > > If it is, we can always use refaults as a correcting
 > > mechanism - which would have the added benefit of being
 > > able to do streaming IO without putting any pressure on
 > > the active list, essentially clock-pro replacement with
 > > just some tweaks to shrink_list()...
 > 
 > As an aside, due to the use-once algorithm file pages are at a
 > natural disadvantage already.  I believe it would be really
 > hard to construct a workload where anon pages suffer the positive
 > feedback loop you describe...

That scenario works for file queues too. Of course, all this is but a
theoretical speculation at this point, but I am concerned that

 - that loop would tend to happen under various border conditions,
 making it hard to isolate, diagnose, and debug, and

 - long before it becomes explicitly visible (say, as an excessive cpu
 consumption by scanner), it would ruin global lru ordering, degrading
 overall performance.

Generally speaking, multi-queue replacement mechanisms were tried in the
past, and they all suffer from the common drawback: once scanning rate
is different for different queues, so is the notion of "hotness",
measured by scanner. As a result multi-queue scanner fails to capture
working set properly.

Nikita.


 > 
 > -- 
 > Politics is the struggle between those who want to make their country
 > the best in the world, and those who believe it already is.  Each group
 > calls the other unpatriotic.

