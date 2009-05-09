Return-Path: <linux-kernel-owner+w=401wt.eu-S1752604AbZEIJUH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752604AbZEIJUH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 May 2009 05:20:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbZEIJTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 May 2009 05:19:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54246 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZEIJTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 May 2009 05:19:54 -0400
Date: Sat, 9 May 2009 11:19:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Andrew Morton <akpm@linux-foundation.org>, gorcunov@openvz.org,
       kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie, cl@linux-foundation.org,
       riel@redhat.com, linux-kernel@vger.kernel.org, rientjes@google.com
Subject: Re: [PATCH 1/2] mm: Introduce GFP_PANIC for early-boot allocations
Message-ID: <20090509091911.GA13784@elte.hu>
References: <1241795428.28600.60.camel@penberg-laptop> <20090508135632.9c041339.akpm@linux-foundation.org> <4A054156.60501@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A054156.60501@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Pekka Enberg <penberg@cs.helsinki.fi> wrote:

> Hi Andrew,
>
> Andrew Morton wrote:
>> On Fri, 08 May 2009 18:10:28 +0300
>> Pekka Enberg <penberg@cs.helsinki.fi> wrote:
>>
>>> +#define GFP_PANIC	(__GFP_NOFAIL | __GFP_NORETRY)
>>
>> urgh, you have to be kidding me.  This significantly worsens complexity
>> and risk in core MM and it's just yuk.
>>
>> I think we can justify pulling such dopey party tricks to save 
>> pageframe space, or bits in page.flags and such.  But just to 
>> save a scrap of memory which would have been released during boot 
>> anwyay?  Don't think so.
>
> No, I wasn't kidding and I don't agree that it "significantly 
> worsens complexity". The point is not to save memory but to 
> clearly annotate those special call-sites that really don't need 
> to check for out-of-memory.

Frankly, i cannot believe that so many smart people dont see the 
simple, universal, un-arguable truism in the following statement:

 it is shorter, tidier, more maintainable, more reviewable to write:

	ptr = kmalloc(GFP_BOOT, size);

 than to write:

	ptr = kmalloc(GFP_KERNEL, size);
	BUG_ON(!ptr);

We have a lot of such patterns in platform code. Dozens and dozens 
of them.

There _might_ be some more nuanced second-level arguments: "yes, I 
agree in principle, but complexity elsewhere or other side-effects 
make this a net negative change."

Alas, those arguments would be wrong too:

 - we have a lot of such patterns and GFP_BOOT is unambigious 

 - post-bootup mis-use of GFP_BOOT could be warned about 
   unconditionally if used after free_initmem(), if we care enough.

 - Pekka's patch is dead simple. There's no "complexity" anywhere.

Agreeing to this and introducing this should have been a matter of 
30 seconds of thinking. Why are we still arguing about this? Dont we 
have enough bugs to worry about?

	Ingo
