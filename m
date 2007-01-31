Return-Path: <linux-kernel-owner+w=401wt.eu-S1752190AbXAaFwB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbXAaFwB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 00:52:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932758AbXAaFwB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 00:52:01 -0500
Received: from smtp103.mail.mud.yahoo.com ([209.191.85.213]:38692 "HELO
	smtp103.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752190AbXAaFwA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 00:52:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=xrYg5EubXyfcFZ/z+2yNS0Ide4kWmgnqF4CjQXsiZew0hIa6CIOeg9nXtDJlL9kJc+2mXKhyhfqxGYYAuYVCpcajvWVAJAeBaJSERjIKoAmrx62ZqeYNRVB7wommnlIRgCw2li2CneUl2YQX258izUtKctB84sMghR+zYESGzRw=  ;
X-YMail-OSG: 3K3aIWYVM1m7fFnRk8dOQf_Y3obETJCEzNqomtjCYqY88KtDYZJg4IciyRGHQSGEofV25GC3zQ--
Message-ID: <45C02E74.2050401@yahoo.com.au>
Date: Wed, 31 Jan 2007 16:51:48 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-aio@kvack.org, Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0 of 4] Generic AIO by scheduling stacks
References: <patchbomb.1170193181@tetsuo.zabbo.net> <1170209044.26655.364.camel@localhost.localdomain> <Pine.LNX.4.64.0701301838110.3611@woody.linux-foundation.org> <45C02AFA.4080501@yahoo.com.au>
In-Reply-To: <45C02AFA.4080501@yahoo.com.au>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> Linus Torvalds wrote:
> 
>>
>> On Wed, 31 Jan 2007, Benjamin Herrenschmidt wrote:
>>
>>
>>>> - We would now have some measure of task_struct concurrency.  Read 
>>>> that twice,
>>>> it's scary.  As two fibrils execute and block in turn they'll each be
>>>> referencing current->.  It means that we need to audit task_struct 
>>>> to make sure
>>>> that paths can handle racing as its scheduled away.  The current 
>>>> implementation
>>>> *does not* let preemption trigger a fibril switch.  So one only has 
>>>> to worry
>>>> about racing with voluntary scheduling of the fibril paths.  This 
>>>> can mean
>>>> moving some task_struct members under an accessor that hides them in 
>>>> a struct
>>>> in task_struct so they're switched along with the fibril.  I think 
>>>> this is a
>>>> manageable burden.
>>>
>>>
>>> That's the one scaring me in fact ... Maybe it will end up being an easy
>>> one but I don't feel too comfortable...
>>
>>
>>
>> We actually have almost zero "interesting" data in the task-struct.
>>
>> All the real meat of a task has long since been split up into 
>> structures that can be shared for threading anyway (ie 
>> signal/files/mm/etc).
>>
>> Which is why I'm personally very comfy with just re-using task_struct 
>> as-is.
>>
>> NOTE! This is with the understanding that we *never* do any 
>> preemption. The whole point of the microthreading as far as I'm 
>> concerned is exactly that it is cooperative. It's not preemptive, and 
>> it's emphatically *not* concurrent (ie you'd never have two fibrils 
>> running at the same time on separate CPU's).
> 
> 
> So using stacks to hold state is (IMO) the logical choice to do async
> syscalls, especially once you have a look at some of the other AIO
> stuff going around.
> 
> I always thought that the AIO people didn't do this because they wanted
> to avoid context switch overhead.
> 
> So now if we introduce the context switch overhead back, why do we need
> just another scheduling primitive? What's so bad about using threads? The
> upside is that almost everything is already there and working, and also
> they don't have any of these preemption or concurrency restrictions.

In other words, while I share the appreciation for this clever trick of
using cooperative switching between these little thriblets, I don't
actually feel it is very elegant to then have to change the kernel so
much in order to handle them.

I would be fascinated to see where such a big advantage comes from using
these rather than threads. Maybe we can then improve threads not to suck
so much and everybody wins.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
