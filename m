Return-Path: <linux-kernel-owner+w=401wt.eu-S1755004AbZFQPe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbZFQPe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 11:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752821AbZFQPeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 11:34:17 -0400
Received: from stinky.trash.net ([213.144.137.162]:36782 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbZFQPeQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 11:34:16 -0400
Message-ID: <4A390CF4.7060909@trash.net>
Date: Wed, 17 Jun 2009 17:34:12 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       Thomas Gleixner <tglx@linutronix.de>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [bug] __nf_ct_refresh_acct(): WARNING: at lib/list_debug.c:30
 __list_add+0x7d/0xad()
References: <20090615.050449.144947903.davem@davemloft.net> <20090616091538.GA4184@elte.hu> <20090616.034752.226811527.davem@davemloft.net> <20090616105304.GA3579@elte.hu> <20090616122415.GA16630@elte.hu> <20090617092152.GA17449@elte.hu> <4A38C2F3.3000009@gmail.com> <4A38D5BD.2040502@trash.net> <4A38D9BE.3020403@gmail.com> <4A38DAC4.2050902@trash.net> <4A38E2AE.3030106@gmail.com> <4A38E33E.1050006@trash.net> <4A38EF40.7040106@gmail.com> <4A38EFC4.8000907@trash.net> <4A38FC5A.70500@trash.net> <4A390BC7.3030901@gmail.com>
In-Reply-To: <4A390BC7.3030901@gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet wrote:
> Patrick McHardy a écrit :
>> I'm having some trouble figuring out the exact events that would
>> lead to the timer base corruption. Ingo, could you please test
>> this patch to make sure it also fixes the problem?
> 
> ;)
> 
> Event can be described as following :
> 
> CPU1					CPU2
> 
> /* __nf_conntrack_confirm() */
> __nf_conntrack_hash_insert(ct, hash, repl_hash);
> // now 'ct' is visible by other cpus
> 					// search conntrack and find ct
> // timeout.expires becomes absolute here
> ct->timeout.expires += jiffies;
> add_timer(&ct->timeout);
> 
> 					/* __nf_ct_refresh_acct() */
> 					if (!nf_ct_is_confirmed(ct)) {
> 					// we *believe* timeout.expires 
> 					// is not yet in use by timer code
> 					// and is still a relative quantity.
> 					// We want to 'update' it but we should not !
> 						ct->timeout.expires = extra_jiffies;  << CORRUPTION >>
> 					} else {
> // too late :(
> set_bit(IPS_CONFIRMED_BIT, &ct->status);
> 
> This is how I understood the problem, but I may be wrong ?

Thats one case that can happen, but that wouldn't corrupt the
timer base AFAICS. Also the callpath shows that it actually went
into the mod_timer_pending() path *and* timer_pending() was true.


