Return-Path: <linux-kernel-owner+w=401wt.eu-S1754140AbYJGOmY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754140AbYJGOmY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 10:42:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751373AbYJGOmM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 10:42:12 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53051 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbYJGOmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 10:42:11 -0400
Message-ID: <48EB7464.9090206@linux-foundation.org>
Date: Tue, 07 Oct 2008 09:38:28 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: Corey Minyard <minyard@acm.org>, David Miller <davem@davemloft.net>,
       dada1@cosmosbay.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, shemminger@vyatta.com,
       paulmck@linux.vnet.ibm.com, Hugh Dickins <hugh@veritas.com>
Subject: Re: [PATCH 3/3] Convert the UDP hash lock to RCU
References: <20081006185026.GA10383@minyard.local> <48EA8197.6080502@cosmosbay.com> <20081006.144002.56418911.davem@davemloft.net> <48EA9A59.1090306@acm.org> <20081007083750.GB17079@2ka.mipt.ru> <48EB6F2D.100@linux-foundation.org> <20081007142902.GA26302@2ka.mipt.ru>
In-Reply-To: <20081007142902.GA26302@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Tue, Oct 07, 2008 at 09:16:13AM -0500, Christoph Lameter (cl@linux-foundation.org) wrote:
>>> I tested skb destruction via RCU path, and got 2.5 times worse numbers
>>> with small-packets-bulk-transfer workload.
>> Was this with regular RCU freeing? This will cool down the cacheline before
>> frees. You need SLAB_DESTROY_BY_RCU to keep the objects cache hot.
> 
> I believe there were no SLAB_DESTROY_BY_RCU 2 yars ago :)

Its been awhile. Hugh created it

> It was pure call_rcu(&skb->rcu, real_skb_freeing), where
> real_skb_freeing() just did usual kfree().

Right. That results in cacheline cooldown. You'd want to recycle the object as
they are cache hot on a per cpu basis. That is screwed up by the delayed
regular rcu processing. We have seen multiple regressions due to cacheline
cooldown.

The only choice in cacheline hot sensitive areas is to deal with the
complexity that comes with SLAB_DESTROY_BY_RCU or give up on RCU.






