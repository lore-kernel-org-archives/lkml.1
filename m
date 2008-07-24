Return-Path: <linux-kernel-owner+w=401wt.eu-S1755456AbYGXNbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755456AbYGXNbr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 09:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751860AbYGXNbg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 09:31:36 -0400
Received: from stinky.trash.net ([213.144.137.162]:37003 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbYGXNbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 09:31:35 -0400
Message-ID: <48888434.3030207@trash.net>
Date: Thu, 24 Jul 2008 15:31:32 +0200
From: Patrick McHardy <kaber@trash.net>
User-Agent: Mozilla-Thunderbird 2.0.0.12 (X11/20080405)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       herbert@gondor.apana.org.au, w@1wt.eu, davidn@davidnewall.com,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       stefanr@s5r6.in-berlin.de, rjw@sisk.pl, ilpo.jarvinen@helsinki.fi,
       Dave Jones <davej@redhat.com>
Subject: Re: [regression] nf_iterate(), BUG: unable to handle kernel NULL
 pointer dereference
References: <20080724060448.GA10203@elte.hu>	 <E1KLwlD-0001Ub-00@gondolin.me.apana.org.au>	 <20080724.022259.113079007.davem@davemloft.net>	 <20080724093411.GA12001@elte.hu> <20080724115625.GA23994@elte.hu>	 <20080724115957.GA25701@elte.hu> <48886FA6.6050908@trash.net>	 <84144f020807240544q507e1b7cv220d1afbae0ee0f0@mail.gmail.com>	 <48887A71.5010209@trash.net> <1216905812.5897.6.camel@penberg-laptop>
In-Reply-To: <1216905812.5897.6.camel@penberg-laptop>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg wrote:
> On Thu, 2008-07-24 at 14:49 +0200, Patrick McHardy wrote:
>> Pekka Enberg wrote:
>>> Hmm, why do you think it's related? It looks like elem->hook() is a
>>> NULL pointer but my patch shouldn't make any difference here...
>> No, its already in ipv4_confirm, so its most likely helper->help()
>> thats NULL, which is contained in an extension.
>>
>> The reason why I think its this patch is (quoting from an old
>> email that I never got a response to):
> 
> Oh, I'm really sorry about that.

No problem :)

>> ---
>> Your patch introduced a use-after-free and double-free.
>> krealloc() frees the old pointer, but it is still used
>> for the ->move operations, then freed again.
>>
>> To fix this I think we need a __krealloc() that doesn't
>> free the old memory, especially since it must not be
>> freed immediately because it may still be used in a RCU
>> read side (see the last part in the patch attached to
>> this mail (based on a kernel without your patch)).
> 
> Agreed. Something like this, perhaps?
> 
> [PATCH] netfilter: fix double-free and use-after free
> 
> As suggested by Patrick McHardy, introduce a __krealloc() that doesn't
> free the original buffer to fix a double-free and use-after-free bug
> introduced by me in netfilter that uses RCU.
> 
> Reported-by: Patrick McHardy <kaber@trash.net>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>

Looks good to me, thanks.
