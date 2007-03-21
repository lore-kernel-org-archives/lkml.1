Return-Path: <linux-kernel-owner+w=401wt.eu-S1752474AbXCULsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbXCULsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 07:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752550AbXCULsy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 07:48:54 -0400
Received: from mail.clusterfs.com ([206.168.112.78]:52528 "EHLO
	mail.clusterfs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbXCULsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 07:48:53 -0400
From: Nikita Danilov <nikita@clusterfs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17921.7074.900919.784218@gargle.gargle.HOWL>
Date: Wed, 21 Mar 2007 14:48:50 +0300
To: Rik van Riel <riel@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH] split file and anonymous page queues #3
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.mm
In-Reply-To: <460115D9.7030806@redhat.com>
References: <46005B4A.6050307@redhat.com>
	<17920.61568.770999.626623@gargle.gargle.HOWL>
	<460115D9.7030806@redhat.com>
X-Mailer: VM 7.17 under 21.5 (patch 17) "chayote" (+CVS-20040321) XEmacs Lucid
X-SystemSpamProbe: GOOD 0.0000486 b8a37cc843cd7cde74b9b25d3ffa2ff3
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rik van Riel writes:
 > Nikita Danilov wrote:
 > > Rik van Riel writes:
 > >  > [ OK, I suck.  I edited yesterday's email with the new info, but forgot
 > >  >    to change the attachment to today's patch.  Here is today's patch. ]
 > >  > 
 > >  > Split the anonymous and file backed pages out onto their own pageout
 > >  > queues.  This we do not unnecessarily churn through lots of anonymous
 > >  > pages when we do not want to swap them out anyway.
 > > 
 > > Won't this re-introduce problems similar to ones due to split
 > > inactive_clean/inactive_dirty queues we had in the past?
 > > 
 > > For example, by rotating anon queues faster than file queues, kernel
 > > would end up reclaiming anon pages that are hotter (in "absolute" LRU
 > > order) than some file pages.
 > 
 > That is why we check the fraction of referenced pages in each
 > queue.  Please look at the get_scan_ratio() and shrink_zone()
 > code in my patch.

Probably I am missing something, but I don't see how that can help. For
example, suppose (for simplicity) that we have swappiness of 100%, and
that fraction of referenced anon pages gets slightly less than of file
pages. get_scan_ratio() increases anon_percent, and shrink_zone() starts
scanning anon queue more aggressively. As a result, pages spend less
time there, and have less chance of ever being accessed, reducing
fraction of referenced anon pages further, and triggering further
increase in the amount of scanning, etc. Doesn't this introduce positive
feed-back loop?

Nikita.

