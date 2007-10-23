Return-Path: <linux-kernel-owner+w=401wt.eu-S1753711AbXJWKYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753711AbXJWKYd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2007 06:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751684AbXJWKYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Oct 2007 06:24:24 -0400
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:2748 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751968AbXJWKYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2007 06:24:22 -0400
Message-ID: <471DCBB2.9020706@panasas.com>
Date: Tue, 23 Oct 2007 12:23:46 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>, mingo@elte.hu,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: Re: [PATCH 09/10] Change table chaining layout
References: <1193076664-13652-10-git-send-email-jens.axboe@oracle.com> <Pine.LNX.4.64.0710222137520.7105@anakin> <alpine.LFD.0.999.0710221248120.30120@woody.linux-foundation.org> <20071022211617.31f5c63d@the-village.bc.nu> <alpine.LFD.0.999.0710221343330.30120@woody.linux-foundation.org> <20071022224343.4abf3c96@the-village.bc.nu> <alpine.LFD.0.999.0710221444220.30120@woody.linux-foundation.org> <471DBEF4.4030303@panasas.com> <20071023094142.GD5059@kernel.dk> <471DC3D9.2070809@panasas.com> <20071023095507.GE5059@kernel.dk>
In-Reply-To: <20071023095507.GE5059@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Oct 2007 10:23:48.0389 (UTC) FILETIME=[CC9B2D50:01C8155E]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23 2007 at 11:55 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
> On Tue, Oct 23 2007, Boaz Harrosh wrote:
>> On Tue, Oct 23 2007 at 11:41 +0200, Jens Axboe <jens.axboe@oracle.com> wrote:
>>> On Tue, Oct 23 2007, Boaz Harrosh wrote:
>>>> On Mon, Oct 22 2007 at 23:47 +0200, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>>> On Mon, 22 Oct 2007, Alan Cox wrote:
>>>>>
>>>>>> For structures, not array elements or stack objects. Does gcc now get
>>>>>> aligned correct as an attribute on a stack object ?
>>>>> I think m68k stack layout still guarantees 4-byte-alignment, no?
>>>>>
>>>>>> Still doesn't answer the rather more important question - why not just
>>>>>> stick a NULL on the end instead of all the nutty hacks ?
>>>>> You still do need one bit for the discontiguous case, so it's not like you 
>>>>> can avoid the hacks anyway (unless you just blow up the structure 
>>>>> entirely) and make it a separate member). So once you have that 
>>>>> bit+pointer, using a separate NULL entry isn't exactly prettier. 
>>>>>
>>>>> Especially as we actally want to see the difference between 
>>>>> "end-of-allocation" and "not yet filled in", so you shouldn't use NULL 
>>>>> anyway, you should probably use something like "all-ones".
>>>>>
>>>>> 			Linus
>>>>> -
>>>> Every one is so hysterical about this sg-chaining problem. And massive
>>>> patches produced, that when a simple none intrusive solution is proposed
>>>> it is totally ignored because every one thinks, "I can not be that stupid".
>>>> Well Einstein said: "Simplicity is the ultimate sophistication". So no one
>>>> need to feel bad.
>>> It's all about the end goal - having maintainable and resilient code.
>>> And I think the sg code will be better once we get past the next day or
>>> so, and it'll be more robust. That is what matters to me, not the
>>> simplicity of the patch itself.
>>>
>> But that is exactly what his patch is. Much more robust. Because you do not
>> relay on sglist content but on outside information, that you already have.
>> Have you had an hard look at his solution? It just simply falls into place.
>> Please try it out for yourself. I did, and it works.
> 
> Sure, I looked at it, it's not exactly rocket science, I do understand
> what it achieves. I don't think the patch is bad as such, I'm merely
> trying to state that I think the end code AND interface will be much
> nicer with the current direction that the sg helpers are moving.
> 
> It does rely on outside context, because you need to pass in the sglist
> number. In my opinion, this patch would be a bandaid for the original
> chain code until we got around to fixing the PAGEALLOC crash. Which we
> did, it's now merged. The patch doesn't make the code cleaner, it makes
> it uglier. It'll work, but that still doesn't mean I have to agree it's
> a nice design.
> 
A nice design is to have an struct like BIO. That holds a pointer to the 
array of scatterlists, size, ..., and a next and prev pointers to the next
chunks. Than have all kernel code that now accepts scatterlist* and size
accept a pointer to such structure. And all is clear and defined.

But since we do not do that, and every single API in the kernel that
receives a scatterlist pointer also receives an sg_count parameter,
than I do not see what is so hacky about giving that sg_count parameter
to the one that needs it the most. sg_next();

OK I guess this is all a matter of taste so there is no point arguing
about it any more. I can see your view, and the work has been done so
I guess there is no point going back. If it all works than it's for the
best.

Thanks Jens for doing all this, The performance gain is substantial
and we will all enjoy it.

Boaz


