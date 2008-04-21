Return-Path: <linux-kernel-owner+w=401wt.eu-S1756357AbYDUIIH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756357AbYDUIIH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:08:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753386AbYDUIHv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:07:51 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:43893 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753205AbYDUIHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:07:50 -0400
Message-ID: <480C4B4B.8080607@bull.net>
Date: Mon, 21 Apr 2008 10:07:39 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
Cc: Peter Zijlstra <peterz@infradead.org>, efault@gmx.de,
       manfred@colorfullife.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 00/13] Re: Scalability requirements for sysv ipc
References: <20080411161702.460410000@bull.net> <1207931235.7157.0.camel@twins> <4802E93E.4090205@bull.net> <1208157359.7427.25.camel@twins> <480316D3.7070901@bull.net> <20080419232812.GF20138@linux.vnet.ibm.com>
In-Reply-To: <20080419232812.GF20138@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------020401060003050702080100"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020401060003050702080100
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Paul E. McKenney wrote:
> On Mon, Apr 14, 2008 at 10:33:23AM +0200, Nadia Derbey wrote:
> 
>>Peter Zijlstra wrote:
>>
>>>On Mon, 2008-04-14 at 07:18 +0200, Nadia Derbey wrote:
>>>
>>>
>>>>Peter Zijlstra wrote:
>>>>
>>>>
>>>>>On Fri, 2008-04-11 at 18:17 +0200, Nadia.Derbey@bull.net wrote:
>>>>>
>>>>>
>>>>>
>>>>>>Here is finally the ipc ridr-based implementation I was talking about 
>>>>>>last
>>>>>>week (see http://lkml.org/lkml/2008/4/4/208).
>>>>>>I couldn't avoid much of the code duplication, but at least made things
>>>>>>incremental.
>>>>>>
>>>>>>Does somebody now a test suite that exists for the idr API, that I could
>>>>>>run on this new api?
>>>>>>
>>>>>>Mike, can you try to run it on your victim: I had such a hard time 
>>>>>>building
>>>>>>this patch, that I couldn't re-run the test on my 8-core with this new
>>>>>>version. So the last results I have are for 2.6.25-rc3-mm1.
>>>>>>
>>>>>>Also, I think a careful review should be done to avoid introducing yet 
>>>>>>other
>>>>>>problems :-(
>>>>>
>>>>>
>>>>>Why duplicate the whole thing, when we converted the Radix tree to be
>>>>>RCU safe we did it in-place. Is there a reason this is not done for idr?
>>>>>
>>>>>
>>>>>
>>>>
>>>>I did that because I wanted to go fast and try to fix the performance 
>>>>problem we have with sysV ipc's. I didn't want to introduce (yet other) 
>>>>regressions in the code that uses idr's today and that works well ;-)
>>>>May be in the future if this rcu based api appears to be ok, we can 
>>>>replace one with the other?
>>>
>>>
>>>>From what I can see the API doesn't change at all,
>>
>>Well, 1 interface changes, 1 is added and another one went away:
>>
>>1) for the preload part (it becomes like the radix-tree preload part):
>>
>>int idr_pre_get(struct idr *, gfp_t);
>>would become
>>int idr_pre_get(gfp_t);
>>
>>2) idr_pre_get_end() is added (same as radix_tree_preload_end()).
>>
>>3) The idr_init() disappears.
>>
>>You might see that other interfaces are not provided by ridr, but this 
>>is only because I've taken those that are useful for the ipc part (so 
>>should not be a problem to make the whole thing rcu safe).
> 
> 
> Part of this is because you need to allow the caller to choose the
> locking for updates.  Mightn't it be better to have both styles of
> API, and share the bit-twiddling and tree-walking code?
> 
> 

That's what I wanted to get to. But it is very hard to do code 
factorization since
1. the routines use pointers to different structures and access to these 
piinters can be anywhere in the routines.
2. we may have rcu assignment instead of direct pointer assignements 
anywhere in these routines.

In a first try, I finally ended up with huuuuge macros that wouldn't 
have been accepted (I attached one of the patches if interested).

Regards,
Nadia


--------------020401060003050702080100
Content-Type: application/x-redhat-package-manager;
 name="ridr_get_new.patch.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ridr_get_new.patch.bz2"

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
--------------020401060003050702080100--
