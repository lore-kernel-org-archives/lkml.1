Return-Path: <linux-kernel-owner+w=401wt.eu-S932491AbZHMUzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491AbZHMUzA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 16:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756220AbZHMUy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 16:54:59 -0400
Received: from mail-ew0-f214.google.com ([209.85.219.214]:43370 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbZHMUy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 16:54:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=V1PEbR/ZL/gk/31m0tLoEPzNxRmrAk/Wtn/ikhDmP1/pFLM6ik4Uet7r3Doi8nAkdj
         3sWidWDGQe+E7YVGuPX9RV0jvbkGzHWybxjjAPV03vHJx0CkwAcLYoRr3++upTep9RaA
         RpWaYkc47R/Y0Lzx2bUN3nf4fppDPIsShOf5o=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
References: <200908122007.43522.ngupta@vflare.org> <Pine.LNX.4.64.0908122312380.25501@sister.anvils> 
	<20090813151312.GA13559@linux.intel.com> <20090813162621.GB1915@phenom2.trippelsdorf.de> 
	<alpine.DEB.1.10.0908130931400.28013@asgard.lang.hm> <87f94c370908131115r680a7523w3cdbc78b9e82373c@mail.gmail.com> 
	<alpine.DEB.1.10.0908131342460.28013@asgard.lang.hm>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Thu, 13 Aug 2009 16:54:34 -0400
Message-ID: <3e8340490908131354q167840fcv124ec56c92bbb830@mail.gmail.com>
Subject: Re: Discard support (was Re: [PATCH] swap: send callback when swap 
	slot is freed)
To: david@lang.hm
Cc: Greg Freemyer <greg.freemyer@gmail.com>,
       Markus Trippelsdorf <markus@trippelsdorf.de>,
       Matthew Wilcox <willy@linux.intel.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Nitin Gupta <ngupta@vflare.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-scsi@vger.kernel.org,
       linux-ide@vger.kernel.org, Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 13, 2009 at 4:44 PM, <david@lang.hm> wrote:
> On Thu, 13 Aug 2009, Greg Freemyer wrote:
>
>> On Thu, Aug 13, 2009 at 12:33 PM, <david@lang.hm> wrote:
>>>
>>> On Thu, 13 Aug 2009, Markus Trippelsdorf wrote:
>>>
>>>> On Thu, Aug 13, 2009 at 08:13:12AM -0700, Matthew Wilcox wrote:
>>>>>
>>>>> I am planning a complete overhaul of the discard work.  Users can send
>>>>> down discard requests as frequently as they like.  The block layer will
>>>>> cache them, and invalidate them if writes come through.  Periodically,
>>>>> the block layer will send down a TRIM or an UNMAP (depending on the
>>>>> underlying device) and get rid of the blocks that have remained
>>>>> unwanted
>>>>> in the interim.
>>>>
>>>> That is a very good idea. I've tested your original TRIM implementation
>>>> on
>>>> my Vertex yesterday and it was awful ;-). The SSD needs hundreds of
>>>> milliseconds to digest a single TRIM command. And since your
>>>> implementation
>>>> sends a TRIM for each extent of each deleted file, the whole system is
>>>> unusable after a short while.
>>>> An optimal solution would be to consolidate the discard requests, bundle
>>>> them and send them to the drive as infrequent as possible.
>>>
>>> or queue them up and send them when the drive is idle (you would need to
>>> keep track to make sure the space isn't re-used)
>>>
>>> as an example, if you would consider spinning down a drive you don't hurt
>>> performance by sending accumulated trim commands.
>>>
>>> David Lang
>>
>> An alternate approach is the block layer maintain its own bitmap of
>> used unused sectors / blocks. Unmap commands from the filesystem just
>> cause the bitmap to be updated.  No other effect.
>
> how does the block layer know what blocks are unused by the filesystem?
>
> or would it be a case of the filesystem generating discard/trim requests to
> the block layer so that it can maintain it's bitmap, and then the block
> layer generating the requests to the drive below it?

Perhaps an interface (ioctl, etc) can be added to ask a filesystem to
discard all unused blocks in a certain range? (That is, have the
filesystem validate the request under any necessary locks before
passing it to the block IO layer)
