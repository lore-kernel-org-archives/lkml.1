Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbYJOQYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbYJOQYN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2008 12:24:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbYJOQX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Oct 2008 12:23:58 -0400
Received: from gw.goop.org ([64.81.55.164]:33670 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751970AbYJOQX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2008 12:23:57 -0400
Message-ID: <48F61919.2050005@goop.org>
Date: Wed, 15 Oct 2008 09:23:53 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: Chris Lalancette <clalance@redhat.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched	 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com>
In-Reply-To: <48F6274D.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Chris Lalancette <clalance@redhat.com> 15.10.08 13:03 >>>
>>>>         
>> The right thing to do is to use arbitrary_virt_to_machine, so that we can be
>> sure we are modifying the right pfn.  This unfortunately introduces a
>> performance penalty because of a full page-table-walk, but we can avoid that
>> penalty for pages in the p2m list by checking if virt_addr_valid is true, and if
>> so, just doing the lookup in the p2m table.
>>     
>
> Could you explain how virt_addr_valid() can validly be used here? Looking
> at its implementation
>
> #define virt_addr_valid(kaddr)	pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
>
> a kaddr in kmap space (i.e. above high_memory) would return a bogus
> physical address, and hence pfn_valid() on the resulting pfn is meaningless.
>   

virt_addr_valid() is supposed to be usable in this circumstace.  The 
comment says "virt_to_page(kaddr) returns a valid pointer if and only if 
virt_addr_valid(kaddr) returns true", which implies that 
virt_addr_valid() returns a meaningful result on all addresses - and if 
not, it should be fixed.

> I'd instead simply compare the address in question against high_memory,
> and perhaps instead of in arbitrary_virt_to_machine() in
> ptep_modify_prot_commit() under an #ifdef CONFIG_HIGHPTE.

I suppose, but I don't think there's much cost in making it generally 
robust.

>  But
> performance-wise, CONFIG_HIGHPTE sucks under Xen anyway, so you'd
> better not turn this on in the first place. We may want/need to provide
> a means to disable this at run time so the same kernel when run natively
> could still make use of it, but without impacting performance under Xen.
>   

That's a secondary issue.  What's the source of the performance hit?  
Just all the extra kmap_atomic operations?

    J
