Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbXGIKSv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbXGIKSv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 06:18:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751686AbXGIKSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 06:18:43 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:42772 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751634AbXGIKSm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 06:18:42 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=lDKuCSsEHnTlYOC+wVuolyP+sba45Jop++XTRita+YHXlNWAOOOgAggiQ3o5nprppNVVMp5/FNOIEAFVwvBPRDysAokWPfBVHGY3drnLGizjqqcI5Ex8Q0eeek/xSn6kiKQWN1MByg4pSjzn8qSkT/YOfiA7Z2IQXUZoWUmkGbA=  ;
X-YMail-OSG: 8_uulQUVM1kriYd.k4Dq0VhJeVzPI9OD1M0ilBu1PCpmFGEZjvNTA81CnfZq7UNL5wXaeKhvVw--
Message-ID: <46920B7D.5090100@yahoo.com.au>
Date: Mon, 09 Jul 2007 20:18:37 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC/PATCH] Use mmu_gather for fork() instead of flush_tlb_mm()
References: <1183952874.3388.349.camel@localhost.localdomain>	 <1183962981.5961.3.camel@localhost.localdomain>	 <1183963544.5961.6.camel@localhost.localdomain>	 <4691E64F.5070506@yahoo.com.au>	 <1183972349.5961.25.camel@localhost.localdomain>	 <4691FFDC.5020808@yahoo.com.au> <1183974458.5961.42.camel@localhost.localdomain> <46920A0C.3040400@yahoo.com.au>
In-Reply-To: <46920A0C.3040400@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Benjamin Herrenschmidt wrote:
> 
>> On Mon, 2007-07-09 at 19:29 +1000, Nick Piggin wrote:
>>
>>> They could just #define one to the other though, there are only a
>>> small
>>> number of them. Is there a downside to not making them distinct? i386
>>> for example probably would just keep doing a tlb flush for fork and
>>> not
>>> want to worry about touching the tlb gather stuff.
>>
>>
>>
>> But the tlb gather stuff just does ... a flush_tlb_mm() on x86 :-)
> 
> 
> But it still does the get_cpu of the mmu gather data structure and

To elaborate on this one... I realise for this one that in the kernel
where this is currently used everything is non-preemptible anyway
because of the ptl. And I also realise that -rt kernel issues don't
really have a bearing on mainline kernel.. but the generic
implementation of this API is fundamentally used to operate on a
per-cpu data structure that is only required when tearing down page
tables. That makes this necessarily non-preemptible.

Which shows that it adds more restrictions that may not otherwise be
required.


> has to look in there and touch the cacheline. You're also having to
> do more work when unlocking/relocking the ptl etc.
> 
> 
>> I really think it's the right API

OK, the *form* of the API is fine, I have no arguments. I just don't
know why you have to reuse the same thing. If you provided a new set of
names then you can trivially do a generic implementation which compiles
to exactly the same code for all architectures right now. That seems to
me like the right way to go...

-- 
SUSE Labs, Novell Inc.

