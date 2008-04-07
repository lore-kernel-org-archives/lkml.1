Return-Path: <linux-kernel-owner+w=401wt.eu-S1754493AbYDGUrG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbYDGUrG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 16:47:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbYDGUq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 16:46:58 -0400
Received: from ns2.gothnet.se ([82.193.160.251]:1183 "EHLO
	GOTHNET-SMTP2.gothnet.se" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752227AbYDGUq6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 16:46:58 -0400
Message-ID: <47FA8826.2060802@tungstengraphics.com>
Date: Mon, 07 Apr 2008 22:46:30 +0200
From: =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@tungstengraphics.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080306)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
       Dave Airlie <airlied@redhat.com>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, mingo@redhat.com
Subject: Re: [PATCH] x86: create array based interface to change page attribute
References: <1206940788.7250.13.camel@clockmaker.usersys.redhat.com> <200804071123.27411.jbarnes@virtuousgeek.org> <47FA7B58.6040907@tungstengraphics.com> <200804071259.19743.jbarnes@virtuousgeek.org>
In-Reply-To: <200804071259.19743.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
X-BitDefender-Scanner: Mail not scanned due to license constraints
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
> On Monday, April 07, 2008 12:51 pm Thomas Hellström wrote:
>   
>>> Hopefully the WC stuff will be upstream right after 2.6.25 comes out. 
>>> Any reason why we shouldn't keep the pages mapped in the kernel as WC
>>> assuming the interface is there?
>>>       
>> If the pages are unmapped, we can get reasonable speed doing
>> unbind-read-bind operations, kernel accesses to the memory will need to
>> use an iomap_atomic_prot_pfn() type of operation.
>> No IPI global tlb flushes needed for kernel mapping changes during
>> unbind-read-bind and no cache flushes needed either if we write-protect
>> the user-space mappings properly, or very limited cache flushes if we
>> keep dirty-written-while-cached flags for each page.
>>
>> If the pages are wc-d we'll need two extra IPI global tlb flushes and a
>> buffer-size cache flush every time we do unbind-read-bind, but OTOH we
>> don't need the iomap_atomic_prot_pfn() to access single pages from the
>> kernel.
>>     
>
> Why would we need to flush at all at unbind-read-bind time?  We should be able 
> to leave pages in the WC state even when we unbind them, then when we need to 
> bind them back into the GTT they'll be ready, but maybe I'm misunderstanding 
> you here...
>
>   
We want to make the user-space mapping cache-coherent after unbind 
during read, to have any serious read-speed, and the linear kernel map 
has to follow, unless it's non-present. Even if it's non present, we 
need to flush whatever was written through the user-space mapping from 
the cache when rebinding. Having the user-space mapping read-only when 
possible will help avoid this.
>>> Also, to make the API readable, we'd probably want to split the function
>>> into kernel_map_pages(..., enum memory_type type) and
>>> kernel_unmap_pages(...) (though like I said I think we really should be
>>> mapping them WC not umapping them altogether, since we do want to hit the
>>> ring buffer from the kernel with the WC type for example).
>>>       
>> I think ring-buffers are using ioremap() or vmap() already today. We can
>> use these to get WC-type access also in the future. The only time we use
>> the linear kernel mapping today is for single page access while patching
>> up command buffers.
>>     
>
> Yeah, they're ioremapped now, but that's a problem since with the PAT patches 
> they'll be mapped hard UC (right now it just happens to work).
>   
Ouch, so we'll be needing an ioremap_wc(), I guess. We probably 
shouldn't use the linear kernel map for this anyway, since that would 
require a chipset flush for each ring commit.  We can actually use 
vmap() with a wc page protection for that, but an ioremap_wc() would 
certainly save us a lot of trouble.
> Thanks,
> Jesse
>   
/Thomas




