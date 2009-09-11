Return-Path: <linux-kernel-owner+w=401wt.eu-S1753990AbZIKGWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753990AbZIKGWT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 02:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753833AbZIKGWS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 02:22:18 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:18670 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752602AbZIKGWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 02:22:18 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEAKOJqUqrR7O6/2dsb2JhbADEK4hGAZArBYQY
X-IronPort-AV: E=Sophos;i="4.44,369,1249257600"; 
   d="scan'208";a="386550768"
From: Roland Dreier <rdreier@cisco.com>
To: Brice Goglin <Brice.Goglin@inria.fr>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       jsquyres@cisco.com, linux-rdma@vger.kernel.org,
       general@lists.openfabrics.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] please pull ummunotify
References: <aday6omhz9d.fsf@cisco.com>
	<20090911145036.DB65.A69D9226@jp.fujitsu.com>
	<adatyzahvbm.fsf@cisco.com> <4AA9EAF7.5010401@inria.fr>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 10 Sep 2009 23:22:20 -0700
In-Reply-To: <4AA9EAF7.5010401@inria.fr> (Brice Goglin's message of "Fri, 11
	Sep 2009 08:15:19 +0200")
Message-ID: <adapr9yhug3.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.91 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Sep 2009 06:22:20.0412 (UTC) FILETIME=[37B713C0:01CA32A8]
Authentication-Results: sj-dkim-2; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim2002 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > My understanding of the code is that fork will end-up calling
 > copy_page_range() on all VMA, and copy_page_range() calls
 > mmu_notifier_invalidate_range_start() if  is_cow_mapping() is true,
 > which should be the case here. So you should get some invalidate events
 > on fork.

Yes, I agree (that's what the second half of my email tried to say).

However, that doesn't help if the parent process is actively doing RDMA
on the range being invalidated -- the MPI library or whatever will get
the invalidate event via ummunotify, but what can it do?  The event is
basically saying "your data is going to the wrong place" and I don't see
what useful thing MPI could do with that.

As I said, it does mean that MPI can invalidate cached registrations for
COWed memory, which might be useful in case a parent forks and then
touches memory it used to use for RDMA, but I think that's the easier
part of the fork/COW problem.

 - R.
