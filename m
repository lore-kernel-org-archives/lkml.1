Return-Path: <linux-kernel-owner+w=401wt.eu-S1755167AbZEEMWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167AbZEEMWe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 08:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752684AbZEEMWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 08:22:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51486 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbZEEMWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 08:22:21 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <200905051319.05806.hannes.hering@linux.vnet.ibm.com>
References: <200905051319.05806.hannes.hering@linux.vnet.ibm.com> <200905041802.30527.hannes.hering@linux.vnet.ibm.com> <25628.1241514687@redhat.com>
To: Hannes Hering <hannes.hering@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, David Miller <davem@davemloft.net>,
       themann@de.ibm.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, raisch@de.ibm.com,
       ossrosch@linux.vnet.ibm.com, linuxppc-dev@ozlabs.org,
       ossthema@de.ibm.com, osstklei@de.ibm.com
Subject: Re: [PATCH 2.6.30-rc5] ehea: fix invalid pointer access
Date: Tue, 05 May 2009 13:19:54 +0100
Message-ID: <26110.1241525994@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hannes Hering <hannes.hering@linux.vnet.ibm.com> wrote:

> this is an ehea driver problem, which is occuring when the receive queue runs
> empty. The faulting code is more specifically the following line:
> 
> 	pref = (skb_array[x]->data);

In that case, you might want to move the prefetchw() calls in the following:

		pref = skb_array[x];
	-	prefetchw(pref);
	-	prefetchw(pref + EHEA_CACHE_LINE);
	+	if (pref) {
	+		prefetchw(pref);
	+		prefetchw(pref + EHEA_CACHE_LINE);

to before the if-statement.  That way the CPU can be attempting the prefetch
whilst it's chewing over the test and branch.  prefetching shouldn't fault on
a bad address.

David
