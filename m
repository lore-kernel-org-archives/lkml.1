Return-Path: <linux-kernel-owner+w=401wt.eu-S1759503AbYB1O3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759503AbYB1O3x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 09:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752752AbYB1O3q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 09:29:46 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:30723
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752301AbYB1O3q convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 09:29:46 -0500
Message-Id: <47C6D37F.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Thu, 28 Feb 2008 14:30:07 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Arjan van de Ven" <arjan@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: x86: potential ioremap() issues
References: <47C6BE37.76E4.0078.0@novell.com>
 <20080228132404.GB18551@elte.hu>
In-Reply-To: <20080228132404.GB18551@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> - When ioremap_page_range() fails, remove_vm_area() is used rather
>>   than vunmap() - I think this will cause a 'struct vm_struct' leak.
>
>indeed, good catch - could you check whether the patch below fixes this? 

Yes, it certainly does. You using it rather than vunmap() makes me notice
other inconsistencies (but harmless in nature): The ioremap_change_attr()
failure case should use the same function, and iounmap() could be
simplified using it, too.

Acked-by: Jan Beulich <jbeulich@novell.com>

>> - While ioremap() continues to happily map RAM pages (with a bogus
>>   [see below] WARN_ON_ONCE()), cacheability of the memory is not
>>   being restored in iounmap().
>
>correct - these are never supposed to be 'true', generally allocated RAM 
>pages - or like we do with AGP where the pages are exclusively owned we 
>restore their cacheability explicitly.

Never supposed to be doesn't mean they really aren't. I think as long as
one permits it, the other should undo its effects. Further more, it would
seem to me that you could easily ioremap() a hot-pluggable (but
unpopulated) memory range, and get into inconsistencies once that
range gets actually populated. Or am I not seeing a safeguard
preventing this?

>> - The check for RAM pages (except for the WARN_ON_ONCE())
>>   continues to be applied only to lowmem pages.
>
>yes, the biggest constraint from ioremap comes when it applies to pages 
>that are mapped by the kernel. But i guess we could extend this to all 
>things RAM ... the second patch below does this. What do you think? I've 
>queued this up in x86.git#testing as well.

Yes, that's exactly what I would have thought it should look like.

Acked-by: Jan Beulich <jbeulich@novell.com>

>> - The WARN_ON_ONCE() itself is applied to the pfn after the
>>   preceding loop finished, i.e. to a pfn that doesn't actually participate
>>   in the operation. Shouldn't it be moved inside the loop?
>
>i removed the WARN_ON_ONCE() from x86.git a few days ago, it's lined up 
>for the next push.

Great, thanks!

Jan

