Return-Path: <linux-kernel-owner+w=401wt.eu-S1754091AbYLLT1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091AbYLLT1V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 14:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752113AbYLLT05
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 14:26:57 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:55042 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYLLT0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 14:26:54 -0500
Message-ID: <4942BAB8.4050007@vlnb.net>
Date: Fri, 12 Dec 2008 22:25:44 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: Evgeniy Polyakov <zbr@ioremap.net>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net,
       Bart Van Assche <bart.vanassche@gmail.com>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>, netdev@vger.kernel.org
Subject: Re: [PATCH][RFC 23/23]: Support for zero-copy TCP transmit of user
 space data
References: <494009D7.4020602@vlnb.net> <494012C4.7090304@vlnb.net>	 <20081210214500.GA24212@ioremap.net>  <4941590F.3070705@vlnb.net> <1229022734.3266.67.camel@localhost.localdomain>
In-Reply-To: <1229022734.3266.67.camel@localhost.localdomain>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1+yMjxRnMCp5k0r9tcwjFSwz2fV22I5++Em87v
 j4iy+N761IZD+aFXxtLhW6zNDbH3xJyIdLPCM0Wa8HZmdg9TVm
 0PUQ865/lnrgtvTRyRk7g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Thu, 2008-12-11 at 21:16 +0300, Vladislav Bolkhovitin wrote:
>> Hi Evgeniy,
>>
>> Evgeniy Polyakov wrote:
>>> Hi Vladislav.
>>>
>>> On Wed, Dec 10, 2008 at 10:04:36PM +0300, Vladislav Bolkhovitin (vst@vlnb.net) wrote:
>>>> In the chosen approach new optional field void *net_priv was added to 
>>>> struct page. It is enclosed by
>>> There is a huge no-no in networking land on increasing skb.
>>> Reason is simple every skb will carry potentially unneded data as long
>>> as given option is enabled, and most of the time it will.
>>> To break this barrier one has to have (I wanted to write ego, but then
>>> decided to replace it with mojo) so huge reason to do this, that it is
>>> almost impossible to have.
>>>
>>> Something tells me that increasing page structure with 8 bytes because
>>> of zero-copy iscsi transfer is not that great idea, since basically every
>>> user out there will have it enabled in the distro config and will waste
>>> noticeble amount of ram.
>> The waste will be only 0.2% of RAM or 2MB per 1GB. Not much. Perhaps, 
>> not noticeable for an average user of distro kernels at all. Embedded 
>> people, who count each byte, almost always don't need iSCSI, so won't 
>> have any problems to disable 
>> TCP_ZERO_COPY_TRANSFER_COMPLETION_NOTIFICATION option.
> 
> Actually, there are several other considerations:
> 
>      1. struct page is a lowmem structure, so increasing its size
>         becomes problematic on x86 PAE systems.
>      2. The current 64 bit struct page seems to be exactly pushing a
>         cacheline boundary.  Increasing it so it spills over will have a
>         performance impact

This is why I suggest to have 
CONFIG_TCP_ZERO_COPY_TRANSFER_COMPLETION_NOTIFICATION disabled in 
general kernels. ISCSI-SCST will still work with almost no performance 
loss for in-kernel backend and people would better recompile kernel, 
then patch it, then recompile.

> It's the performance problems that will be most critical, I suspect, so
> you'll need mm people buy in for doing this.

I'll ask in linux-mm, thanks for the suggestion.

> One thing that leaps immediately to mind is that you could isolate this
> to the net layer by putting it in skb_frag_struct.  However, such a move
> would require a proper API for this in net ...

To have net_priv analog in skb was the first idea I was tried. But I 
quickly gave up, because it would required that all the pages in each 
skb_frag_struct be from the same originator, i.e. with the same 
net_priv. It is unpractical to change all the operations with skb's to 
forbid merging them, if they have different net_priv. There are too many 
such places in very not obvious code pieces.

> right now it looks like
> you're using the struct page addition to carry this information from
> SCSI to net, which is a bit of a layering violation.

I don't think there is any layering violation here. Just lower layer 
notifies upper layer that transmission of a page has finished. It's done 
a bit not straightforward, but still basically the same as, for 
instance, on_free_cmd() callbacks which SCST core uses to notify target 
drivers and dev handlers that the corresponding command is about to be 
freed, so they can free associated with it data as well.

Thanks,
Vlad
