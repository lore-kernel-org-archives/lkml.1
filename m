Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbYDBSxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbYDBSxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 14:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbYDBSxJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 14:53:09 -0400
Received: from gw.goop.org ([64.81.55.164]:60626 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754801AbYDBSxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 14:53:08 -0400
Message-ID: <47F3D5D9.1010301@goop.org>
Date: Wed, 02 Apr 2008 11:52:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>,
       Christoph Lameter <clameter@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anthony Liguori <anthony@codemonkey.ws>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH RFC] hotplug-memory: refactor online_pages to separate
 zone growth from page onlining
References: <47ED8685.9040409@goop.org>	 <1206751622.27091.20.camel@nimitz.home.sr71.net>	 <47EDA4B9.6030801@goop.org>	 <1206806774.31896.27.camel@nimitz.home.sr71.net>	 <47EED683.5030200@goop.org>	 <1206981741.31896.51.camel@nimitz.home.sr71.net>	 <47F1282E.3020503@goop.org> <1207161962.23710.23.camel@nimitz.home.sr71.net>
In-Reply-To: <1207161962.23710.23.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
>>>  and a flat sparsemem map, you're only looking at
>>> ~500k of overhead for the sparsemem storage.  Less if you use vmemmap.  
>>>   
>>>       
>> At the moment my concern is 32-bit x86, which doesn't support vmemmap or 
>> sections smaller than 512MB because of the shortage of page flags bits.
>>     
>
> Yeah, I forgot that we didn't have vmemmap on x86-32.  Ugh.
>
> OK, here's another idea: Xen (and the balloon driver) already handle a
> case where a guest boots up with 2GB of memory but only needs 1GB,
> right?  It will balloon the guest down to 1GB from 2GB.
>   

Right.

> Why don't we just have hotplug work that way?  When we want to take a
> guest from 1GB to 1GB+1 page (or whatever), we just hotplug the entire
> section (512MB or 1GB or whatever), actually online the whole thing,
> then make the balloon driver take it back to where it *should* be.  That
> way we're completely reusing existing components that have do be able to
> handle this case anyway.
>
> Yeah, this is suboptimal, an it has a possibility of fragmenting the
> memory, but it will only be used for the x86-32 case.
>   

It also requires you actually have the memory on hand to populate the 
whole area.  512MB is still a significant chunk on a 2GB server; you may 
end up generating significant overall system memory pressure to scrape 
together the memory, only to immediately discard it again.

    J
