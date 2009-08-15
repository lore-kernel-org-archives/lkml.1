Return-Path: <linux-kernel-owner+w=401wt.eu-S1755320AbZHOQaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbZHOQaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 12:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755047AbZHOQaq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 12:30:46 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:46412 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755028AbZHOQap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 12:30:45 -0400
Message-ID: <4A86E30E.8030208@colorfullife.com>
Date: Sat, 15 Aug 2009 18:32:14 +0200
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Nick Piggin <npiggin@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Nadia Derbey <Nadia.Derbey@bull.net>,
       Pierre Peiffer <peifferp@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [patch 4a/4] ipc: sem optimise simple operations
References: <200908141946.n7EJkh7B018160@mail.q-ag.de> <20090815045237.GC19195@wotan.suse.de> <4A86899A.6050502@colorfullife.com> <20090815103820.GC8954@wotan.suse.de> <4A86ABF0.2070207@colorfullife.com> <20090815144908.GA30951@wotan.suse.de>
In-Reply-To: <20090815144908.GA30951@wotan.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2009 04:49 PM, Nick Piggin wrote:
>
> I don't see how you've argued that yours is better.
>
>    
Lower number of new code lines,
Lower total code size increase.
Lower number of seperate codepaths.
Lower runtime memory consumption.
Two seperate patches for the two algorithm improvements.

The main advantage of your version is that you optimize more cases.
> If you are worried about memory consumption, we can add _rcu variants
> to hlists and use them.
There is no need for _rcu, the whole code runs under a spinlock.
Thus the wait_for_zero queue could be converted to a hlist immediately.

Hmm: Did you track my proposals for your version?

- exit_sem() is not a hot path.
I would propose to tread every exit_sem as update_queue, not an 
update_queue_simple for every individual UNDO.

- create an unlink_queue() helper that contains the updates to q->lists 
and sma->complex_count.
Three copies ask for errors.

- now: use a hlist for the zero queue.

>   And if you are worried about text size, then
> I would bet my version actually uses less icache in the case of
> simple ops being used.
>    
It depends. After disabling inlining, including all helper functions 
that differ:

My proposal: 301 bytes for update_queue.

"simple", only negv: 226 bytes
"simple, negv+zero: 354 bytes
simple+complex: 526 bytes.

Thus with only +-1 simple ops, your version uses less icache. If both 
+-1 and 0 ops are used, your version uses more icache.

Could you please send me your benchmark app?

--
     Manfred
