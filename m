Return-Path: <linux-kernel-owner+w=401wt.eu-S1756192AbZFHNfb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192AbZFHNfb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 09:35:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755211AbZFHNfW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 09:35:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:53384 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZFHNfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 09:35:20 -0400
Date: Mon, 8 Jun 2009 14:35:20 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Rik van Riel <riel@redhat.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Johannes Berg <johannes@sipsolutions.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [Bug #13319] Page allocation failures with b43 and p54usb
Message-ID: <20090608133520.GC15070@csn.ul.ie>
References: <bCxQpon4SCJ.A.RrF.yY7KKB@chimera> <D9VoutSOyXP.A.hvH.Ha7KKB@chimera> <4A2BBC30.2030300@lwfinger.net> <84144f020906070640rf5ab14nbf66d3ca7c97675f@mail.gmail.com> <4A2BCC6F.8090004@redhat.com> <84144f020906070732l31786156r5d9753a0cabfde79@mail.gmail.com> <20090608101739.GA15377@csn.ul.ie> <4A2D1017.6010308@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4A2D1017.6010308@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 08, 2009 at 09:20:23AM -0400, Rik van Riel wrote:
> Mel Gorman wrote:
>
>> We've encountered this before and the conclusion was that the current
>> adjustments for watermark calculations of high-order allocations is right,
>> or at least there is no better alternative. In other words, the page
>> allocator in this instance is behaving as expected. Do we want to
>> revisit that discussion as to whether the watermark calculations for
>> high-order allocation should change? I think we'll reach the same
>> conclusion or at least decide that allowing the order-1 atomic
>> allocation to succeed here would just postpone the problem.
>
> It would not just postpone the problem, it would also
> bring the system closer to a state where kswapd does
> something about the order-1 free areas.
>
> This might postpone the problem indefinately.
>

How do you figure it does not just postpone the problem? If there are a batch
of order-1 allocations that come in like this, it will eventually deplete
the higher-order pages and then fail because kswapd is not getting woken up.

Minimally, if we were to ignore the watermarks, there would need to be logic
that says

	"If a high-order allocation would fail due to high-order watermarks
	not being met, but the watermarks are ok from an order-0 perspective
	and the high-order page is available, then grant the allocation but
	wake up kswapd as if the order-1 allocation had failed to get the
	high-order watermarks back in shape"

> Currently the system fails early, without kswapd
> kicking in and freeing new order-1 areas.
>

If the allocation was granted, then kswapd will still not kick in.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
