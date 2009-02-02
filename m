Return-Path: <linux-kernel-owner+w=401wt.eu-S1756479AbZBBOSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479AbZBBOSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbZBBOSH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:18:07 -0500
Received: from h155.mvista.com ([63.81.120.155]:15372 "EHLO imap.sh.mvista.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752727AbZBBOSG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:18:06 -0500
Message-ID: <49870094.2010101@ru.mvista.com>
Date: Mon, 02 Feb 2009 17:17:56 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Hugh Dickins <hugh@veritas.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils> <20090126191151.18b094e6@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0902012050190.16351@blonde.anvils> <4986DDA9.6010903@ru.mvista.com> <Pine.LNX.4.64.0902021152220.17261@blonde.anvils>
In-Reply-To: <Pine.LNX.4.64.0902021152220.17261@blonde.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Hugh Dickins wrote:

>>> (though much more verbose: please simplify if you see a better way).
>>>       
>>   How about the following?
>>
>> 		unsigned char *tail = buf + buflen - slop;
>> 		unsigned char pad[4];
>>
>> 		if (rw == READ) {
>> 			if (slop <= 2)
>> 				ioread16_rep(data_addr, pad, 1);
>> 			else
>> 				ioread32_rep(data_addr, pad, 1);
>> 					memcpy(tail, pad, slop);
>>     
>
> Too many tabs on the memcpy.
>   

   Hey, this is not a patch, and I was using Thunderbird's msg editor -- 
which isn;t really good to tabs. :-)

>> 		} else {
>> 			memcpy(pad, tail, slop);
>> 			memset(pad + slop, 0, 4 - slop);
>>     
>
> And we could make that line even more complicated!
>   

   We could use memzero() but memset() should boil down to it anyway.

> But I think unsigned char pad[4] = {0, 0, 0, 0} would be better.
>   

   Not really, we don't need to waste time initiazlizing it on reads -- 
I hope you understand that it will require real code to write all those 
zeros?). Besides, only {0} should be enough as other entries should be 
implitly zeroed).

> Though Alan didn't have it initialized at all: I don't know if
> that was oversight or superior knowledge.  In Alan's case, one
> should usually assume the latter.

   These bytes can be anything actually as a device should just ignore them.

>> 		if (slop <= 2)
>> 				iowrite16_rep(data_addr, pad, 1);
>> 			else
>> 				iowrite32_rep(data_addr, pad, 1);
>> 		}
>>     
>
> Well, I don't know.

   I do. :-)

> I felt really pleased with using ioread16_rep
> and the char array in my original patch, where slop might be 1 or 2
> or 3; but once it comes down to always one single PIO op, I felt
> it too lazy to be using the _rep form.
>   

   It should do the Right Thing WRT the byte reordering (which is a lack 
thereof ;-) while your code had to muck with it explicitly. And of 
course it's shorter -- because of that.

> I really don't care, whatever works and best satisfies Alan.
>   

  I thought we should care about general user satisfaction, not just 
Alan's... :-)

>>> -	return words << 2;
>>> +
>>> +	return buflen + (buflen & 1);
>>>   
>>>       
>>    return (buflen + 1) & ~1;
>>
>>   Well, I guess I could just have posted my own patch... :-)
>>     
>
> Yes, do go ahead, I'm not desperate to get my name in there!
>   

   I'm not actually very enthusiastic in getting blamed for the 
breakage, given the Alan's example. ;-)

> Hugh
>   

MBR, Sergei


