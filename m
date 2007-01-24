Return-Path: <linux-kernel-owner+w=401wt.eu-S965483AbXAXEDm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965483AbXAXEDm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 23:03:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965646AbXAXEDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 23:03:42 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:39228 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965483AbXAXEDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 23:03:42 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=ALCD3rHuVdEOcHaoIiC0jXMURBuVWmpc+vSl0c+gJ5dNHncQy69/nHO2Tv36hkwTVHKhEHV4i3XLyG/FloIherSIkoGaXhwslJPUetRPP2Df/SO5vdX5jxWYITcefpSuhe7gegNIWtslr6To2Kwwv7mQUg7f0lptrOb0PCYlni0=  ;
X-YMail-OSG: csQI9UcVM1kAPw7o5dsV0GZnxjHkjupnUY2kfelE48u1wfSFglASea_X_ZQeWt262rZtTePqn1hvv23emfoO9JpNLjhcYPicGOeLQ8BYd3XiPBluB2mmduz2eIlnKFqR3zBxqT4-
Message-ID: <45B6DA8B.7060004@yahoo.com.au>
Date: Wed, 24 Jan 2007 15:03:23 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Aubrey Li <aubreylee@gmail.com>
CC: Christoph Lameter <clameter@sgi.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>,
       "Hennerich, Michael" <Michael.Hennerich@analog.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com
Subject: Re: [RFC] Limit the size of the pagecache
References: <Pine.LNX.4.64.0701231645260.5239@schroedinger.engr.sgi.com>	 <45B6CBD9.80600@yahoo.com.au>	 <Pine.LNX.4.64.0701231908420.6123@schroedinger.engr.sgi.com> <6d6a94c50701231951o66487813vcd078fc25e25ffa0@mail.gmail.com>
In-Reply-To: <6d6a94c50701231951o66487813vcd078fc25e25ffa0@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Aubrey Li wrote:
> On 1/24/07, Christoph Lameter <clameter@sgi.com> wrote:
> 
>> On Wed, 24 Jan 2007, Nick Piggin wrote:
>>
>> > > 1. Insure that anonymous pages that may contain performance
>> > >    critical data is never subject to swap.
>> > >
>> > > 2. Insure rapid turnaround of pages in the cache.
>> >
>> > So if these two aren't working properly at 100%, then I want to know 
>> the
>> > reason why. Or at least see what the workload and the numbers look 
>> like.
>>
>> The reason for the anonymous page may be because data is rarely touched
>> but for some reason the pages must stay in memory. Rapid turnaround is
>> just one of the reason that I vaguely recall but I never really
>> understood what the purpose was.
>>
>> > > 3. Reserve memory for other uses? (Aubrey?)
>> >
>> > Maybe. This is still a bad hack, and I don't like to legitimise such 
>> use
>> > though. I hope Aubrey isn't relying on this alone for his device to 
>> work
>> > because his customers might end up hitting fragmentation problems 
>> sooner
>> > or later.
>>
>> I surely wish that Aubrey would give us some more clarity on
>> how this should work. Maybe the others who want this feature could also
>> speak up? I am not that clear on its purpose.
>>
> Sorry for the delay. Somehow this thread was put into the spam folder
> of my gmail box. :(
> The patch I posted several days ago works properly on my side. I'm
> working on blackfin-uclinux platform. So I'm not sure it works 100% on
> the other arch platform. From O_DIRECT threads, I know different
> people suffer from VFS pagecache issue for different reason. So I
> really hope the patch can be improved.

So we need to work out what those issues are and fix them.

> On my side, When VFS pagecache eat up all of the available memory,
> applications who want to allocate the largeish block(order =4 ?) will
> fail. So the logic is as follows:

Yeah, it will be failing at order=4, because the allocator won't try
very hard reclaim pagecache pages at that cutoff point. This needs to
be fixed in the allocator.

>> I hope Aubrey isn't relying on this alone for his device to work
>> because his customers might end up hitting fragmentation problems sooner
>> or later.
> 
> 
> That's true. I wrote a replacement of buddy system, it's here:
> http://lkml.org/lkml/2006/12/30/36.
> 
> That can improve the fragmentation problems on our platform.

That might be a good idea, but while the buddy system may not seem as
efficient and wastes space, it is actually really good for fragmentation.

Anyway, point being that you can't eliminate fragmentation, so you need
to cope with allocation failures or implement reserve pools if you want a
robust system.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
