Return-Path: <linux-kernel-owner+w=401wt.eu-S1756145AbYJGISm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbYJGISm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 04:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752333AbYJGISY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 04:18:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:37055 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbYJGISX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 04:18:23 -0400
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com
In-Reply-To: <48EA8197.6080502@cosmosbay.com>
References: <20081006185026.GA10383@minyard.local>
	 <48EA8197.6080502@cosmosbay.com>
Content-Type: text/plain
Date: Tue, 07 Oct 2008 10:17:59 +0200
Message-Id: <1223367480.26330.7.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-06 at 23:22 +0200, Eric Dumazet wrote:

> Or just add SLAB_DESTROY_BY_RCU to slab creation in proto_register()
> for "struct proto udp_prot/udpv6_prot" so that kmem_cache_free() 
> done in sk_prot_free() can defer freeing to RCU...

Be careful!, SLAB_DESTROY_BY_RCU just means the slab page gets
RCU-freed, this means that slab object pointers stay pointing to valid
memory, but it does _NOT_ mean those slab objects themselves remain
valid.

The slab allocator is free to re-use those objects at any time -
irrespective of the rcu-grace period. Therefore you will have to be able
to validate that the object you point to is indeed the object you
expect, otherwise strange and wonderful things will happen.

