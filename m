Return-Path: <linux-kernel-owner+w=401wt.eu-S932860AbXGYPe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbXGYPe3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 11:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757263AbXGYPeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 11:34:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39355 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708AbXGYPeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 11:34:21 -0400
Message-ID: <46A76D58.40604@redhat.com>
Date: Wed, 25 Jul 2007 11:33:44 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Eric St-Laurent <ericstl34@sympatico.ca>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Fengguang Wu <fengguang.wu@gmail.com>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
References: <20070721210005.000228000@chello.nl>	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>	 <20070722081010.GA6317@mail.ustc.edu.cn>	 <1185093236.6344.87.camel@localhost.localdomain>	 <46A46E4B.7050007@yahoo.com.au> <1185338106.7105.44.camel@perkele>	 <46A6DD7F.1050505@yahoo.com.au> <1185344325.7105.91.camel@perkele> <46A6F732.3080905@yahoo.com.au>
In-Reply-To: <46A6F732.3080905@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Eric St-Laurent wrote:
>> On Wed, 2007-25-07 at 15:19 +1000, Nick Piggin wrote:
>>
>>
>>> What *I* think is supposed to happen is that newly read in pages get
>>> put on the inactive list, and unless they get accessed againbefore
>>> being reclaimed, they are allowed to fall off the end of the list
>>> without disturbing active data too much.
>>>
>>> I think there is a missing piece here, that we used to ease the reclaim
>>> pressure off the active list when the inactive list grows relatively
>>> much larger than it (which could indicate a lot of use-once pages in
>>> the system).
>>
>>
>> Maybe a new list should be added to put newly read pages in it. If they
>> are not used or used once after a certain period, they can be moved to
>> the inactive list (or whatever).
>>
>> Newly read pages...
>>
>> - ... not used after this period are excessive readahead, we discard
>> immediately.
>> - ... used only once after this period, we discard soon.
>> - ... used many/frequently are moved to active list.
>>
>> Surely the scan rate (do I make sense?) should be different for this
>> newly-read list and the inactive list. 
> 
> A new list could be a possibility. One problem with adding lists is just
> trying to work out how to balance scanning rates between them, another
> problem is CPU overhead of moving pages from one to another... but don't
> let me stop you if you want to jump in and try something :)
> 
> 
>> I also remember your split mapped/unmapped active list patches from a
>> while ago.
>>
>> Can someone point me to a up-to-date documentation about the Linux VM?
>> The books and documents I've seen are outdated.
> 
> If you just want to play with page reclaim algorithms, try reading over
> mm/vmscan.c. If you don't know much about the Linux VM internals before,
> don't worry too much about the fine details and start by getting an idea
> of how pages move between the active and inactive lists.

I've got a nice list of problems with the VM at
http://linux-mm.org/PageoutFailureModes :)

I should post my latest version of the split LRU
lists code.  I'm still working on SEQ replacement
for the anonymous pages...

> OK here is one which just changes the rate that the active and inactive
> lists get scanned. Data corruption bugs should be minimal ;)

I had something like that in mind for the file
pages.  I am a bit nervous about introducing
such a change while file and anonymous pages
share the same LRU, though...

-- 
Politics is the struggle between those who want to make their country
the best in the world, and those who believe it already is.  Each group
calls the other unpatriotic.
