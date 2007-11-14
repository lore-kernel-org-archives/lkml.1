Return-Path: <linux-kernel-owner+w=401wt.eu-S1756794AbXKNLRx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794AbXKNLRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 06:17:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751802AbXKNLRq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 06:17:46 -0500
Received: from gir.skynet.ie ([193.1.99.77]:58567 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbXKNLRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 06:17:45 -0500
Date: Wed, 14 Nov 2007 11:17:42 +0000
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@osdl.org, torvalds@osdl.org, linux-kernel@vger.kernel.org,
       linux-mm@vger.kernel.org, apw@shadowen.org
Subject: Re: Major mke2fs slowdown (reproducable, bisected)
Message-ID: <20071114111742.GB9566@skynet.ie>
References: <20071112182526.GC11244@martell.zuzino.mipt.ru> <20071113165405.GA12837@skynet.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20071113165405.GA12837@skynet.ie>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (13/11/07 16:54), Mel Gorman didst pronounce:

> fixes your problem.... As I write this, it occurs to me that it might be
> because your compile-job has created very long free-lists and searching them
> is causing problems.

This indeed did appear to be the problem. When a basic compile-job was
run first, the mke2fs times on a vanilla kernel were

119.96 real, 0.08 user, 19.85 sys
194.91 real, 0.11 user, 24.71 sys
102.24 real, 0.08 user, 10.47 sys
104.66 real, 0.08 user, 10.45 sys
100.77 real, 0.13 user, 10.54 sys

and with the patch reverted was

121.83 real, 0.15 user, 11.16 sys
126.68 real, 0.10 user, 10.78 sys
104.47 real, 0.09 user, 10.48 sys
104.75 real, 0.10 user, 10.66 sys
106.06 real, 0.09 user, 10.55 sys

The high sys times initially are due to the number of fallbacks that
take place as creating a filesystem creates an unusually large number of
pinned pages for a short-period of time. The search times usually
unmeasurably then show up in the profiles.

Reverting the patch is still the right solution. We will find an alternative
way of biasing the placement of pages without the expensive search.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
