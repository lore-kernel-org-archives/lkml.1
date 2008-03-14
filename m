Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYCNKRm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYCNKRm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 06:17:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752869AbYCNKRc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 06:17:32 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30294
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789AbYCNKRb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 06:17:31 -0400
Message-Id: <47DA5EF1.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Fri, 14 Mar 2008 10:18:09 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "FUJITA Tomonori" <tomof@acm.org>
Cc: <fujita.tomonori@lab.ntt.co.jp>, <akpm@linux-foundation.org>,
       <torvalds@linux-foundation.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] avoid endless loops in lib/swiotlb.c
References: <47D8FE4A.76E4.0078.0@novell.com>
 <20080314182219P.tomof@acm.org>
In-Reply-To: <20080314182219P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> FUJITA Tomonori <tomof@acm.org> 14.03.08 10:35 >>>
>On Thu, 13 Mar 2008 09:13:30 +0000
>"Jan Beulich" <jbeulich@novell.com> wrote:
>
>> Commit 681cc5cd3efbeafca6386114070e0bfb5012e249 introduced two
>> possibilities for entering an endless loop in lib/swiotlb.c:
>> 
>> - if max_slots is zero (possible if mask is ~0UL)
>
>Yeah, max_slots can not be zero. There are no drivers that have such
>mask. I'm not sure that we will have.

You mean no current, in-tree drivers do this, and you imply the code
is only used on 64-bits. Since Xen uses this file even for 32-bits, I had
run into the case, and there's nothing preventing an in-tree driver
from setting the mask to ~0UL, which would then result in a perhaps
difficult to debug hang. For that reason, it seems better to me to fix
this latent bug right away.

>...
>
>> - if the number of slots requested fits into a swiotlb segment, but is
>>   too large for the part of a segment which remains after considering
>>   offset_slots
>
>Sorry, I'm not sure what you mean. Can you give me an actual example
>numbers that leads to that?

For one part, it can happen if nslots > max_slots (which is a driver
error [except for the case above where max_slots erroneously got set
to zero], but shouldn't lead to a silent hang, especially as it didn't do so
before).

For another part, requesting e.g. a transfer of 128k with a segment
mask of 128k when the IOTLB isn't aligned to a 128k boundary would
again lead to a silent hang, as would various cases where the request
exceeds the segment size (and the segment mask is sufficiently small).
Neither of these cases got stuck in the old code.

Beyond that, maybe I was too quick in concluding this could happen
even in less unusual cases - I think I didn't pay close enough attention
to the fact that offset_slots + index gets masked by max_slots - 1.
But even then I think the code looks simpler/safer and is smaller with
the adjusted logic.

Jan

