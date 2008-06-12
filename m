Return-Path: <linux-kernel-owner+w=401wt.eu-S1754858AbYFLPnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858AbYFLPnw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 11:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753268AbYFLPnl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 11:43:41 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:42365 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971AbYFLPnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 11:43:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lhfsX+dhcUZFKCIAEHtn5foBo96pY/12XthcEnHu0ov3SFjtvKd2lL4MAdmXVtZWdz
         7Oc/o9pr14ap+JqFjMbyVSmrGYhtXpVHcsn9wJ7674U+2ishrOr1XdJL9iorRziY/DS+
         AbIKDpRY7PNeVgoUIbP2+Kww8xAfOjRaU/gcc=
Message-ID: <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
Date: Thu, 12 Jun 2008 18:43:37 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
Cc: "Rik van Riel" <riel@redhat.com>,
       "Zdenek Kabelac" <zdenek.kabelac@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1213278884.3936.15.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 4:54 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2008-06-12 at 09:38 -0400, Rik van Riel wrote:
>> On Thu, 12 Jun 2008 12:07:34 +0200
>> "Zdenek Kabelac" <zdenek.kabelac@gmail.com> wrote:
>>
>> > It looks like while there was a huge amount of buffers and caches -
>> > system was unable to allocate few pages for kmalloc in iwl3945 driver
>> > after resume.
>>
>> It looks like this is because it wants to allocate 2**5 contiguous
>> pages, which is 128kB of contiguous kernel memory.
>
> 64-bit system I assume?
> The allocation should be 256 * 20 * sizeof(struct sk_buff *).

> Try the patch below. It should improve code generation too.
>
> I discussed this with Tomas previously and he says the hw is capable of
> doing 20 fragments per frame (wonder why, Broadcom can do an unlimited
> number...) but he complained about the networking stack not being able
> to.

This is scatter gather buffers that can be kicked in one DMA transaction.

Well, the hardware needs to support IP checksumming for that, hence,
> afaik, only two fragments can ever be used (one for hw header, one for
> frame)
This I still don't understand why but everybody is already tired to
explaining me why.. :) Just need to find time to dig into it.

> This cuts the allocation to 10%, or (under) a page in all cases.

Probably. it would be safe to use vmalloc for allocating txb anyway.
I'll give it a try.

There was already discussion on LKML about memory allocation problems
on X86_64, which might explain this regression. This didn't happen
before.

Tomas
