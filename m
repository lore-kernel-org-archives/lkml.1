Return-Path: <linux-kernel-owner+w=401wt.eu-S1758026AbYDDBdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026AbYDDBdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2008 21:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbYDDBdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Apr 2008 21:33:08 -0400
Received: from gw.goop.org ([64.81.55.164]:56373 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754215AbYDDBdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2008 21:33:07 -0400
Message-ID: <47F58519.1060109@goop.org>
Date: Thu, 03 Apr 2008 18:32:09 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080315)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [PATCH 1 of 6] hotplug-memory: refactor online_pages to	separate
 zone growth from page onlining
References: <5a397e7f3c1aeb7648b9.1207267541@localhost> <1207271371.943.43.camel@nimitz.home.sr71.net>
In-Reply-To: <1207271371.943.43.camel@nimitz.home.sr71.net>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Hansen wrote:
> On Thu, 2008-04-03 at 17:05 -0700, Jeremy Fitzhardinge wrote:
>   
>> +int prepare_online_pages(unsigned long pfn, unsigned long nr_pages)
>> +{
>> +       int ret = notify_going_online(pfn, nr_pages);
>> +       if (ret)
>> +               return ret;
>> +
>> +       grow_zone_span(pfn, pfn+nr_pages);
>>         return 0;
>> +}
>>     
>
> OK, after seeing this used in the Xen driver, I'm even less a fan of the
> name.  Mostly because it doesn't actually prepare *pages* to be onlined.
> It prepares the zones/pgdats and notifies that pages might soon be
> online.  Can you think of any better names?
>
> grow_and_notify...??
>   

Does it even need to be a separately visible function?  Could it just be 
part of add_memory()?  Is there any reason delay doing it until 
online_pages()?

That way online_pages() can return to being the one-stop function to 
online all the pages, making mark_pages_online() redundant.

> It's also a bit funky because you're calling the online notifiers, but
> you're not actually onlining the pages, yet.  Does that have any
> repercussions?

No.  It will always call the GOING_ONLINE notifier, but it will only 
call the ONLINE notifier if it actually bulk-onlines all the pages.  In 
my page-by-page case, it will never end up calling the ONLINE notifier.  
I could call it repeatedly for each page, but I'm not sure how useful 
that is (the lack of any users of the ONLINE notifier makes it hard to 
judge).

    J
