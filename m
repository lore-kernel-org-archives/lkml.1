Return-Path: <linux-kernel-owner+w=401wt.eu-S1756804AbYJQPTc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbYJQPTc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 11:19:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755068AbYJQPTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 11:19:23 -0400
Received: from gw.goop.org ([64.81.55.164]:33387 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754830AbYJQPTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 11:19:22 -0400
Message-ID: <48F8ACF7.6050905@goop.org>
Date: Fri, 17 Oct 2008 08:19:19 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20081009)
MIME-Version: 1.0
To: Jan Beulich <jbeulich@novell.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Chris Lalancette <clalance@redhat.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Xen-devel] [PATCH]: Fix Xen domU boot with batched			 mprotect
References: <48F5CE10.3060403@redhat.com> <48F6274D.76E4.0078.0@novell.com> <48F61919.2050005@goop.org> <48F72C7A.76E4.0078.0@novell.com> <48F76773.2090700@goop.org> <48F85711.76E4.0078.0@novell.com>
In-Reply-To: <48F85711.76E4.0078.0@novell.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
>>>> Jeremy Fitzhardinge <jeremy@goop.org> 16.10.08 18:10 >>>
>>>>         
>> The current x86-64 implementation is:
>>
>> bool __virt_addr_valid(unsigned long x)
>> {
>> 	if (x >= __START_KERNEL_map) {
>> 		x -= __START_KERNEL_map;
>> 		if (x >= KERNEL_IMAGE_SIZE)
>> 			return false;
>>     
>
> This, imo, is still broken (i.e. the name of the function still isn't matched
> by the implementation): KERNEL_IMAGE_SIZE is a constant and doesn't
> account for the fact that only the real kernel image can be relied upon
> to be mapped.
>   

Perhaps, but I don't think it matters too much.  Unless you have a tiny 
amount of physical memory, locations in the kernel mapping beyond the 
actual kernel will still resolve to proper locations in the linear map.

>> and 32-bit is similar (but simpler, since it doesn't need to worry about a separate kernel mapping).
>>     
>
> This continues to be broken, but not as badly as it used to be - while it
> now covers user space and the vmalloc area (I'm unclear why this is
> excluded only after booting completed, though), hypervisor space
> continues to not be considered here.
>
> But as mentioned before - excluding the vmalloc area seems bogus wrt
> the name of the function, but as I take it the confusion here is intended.
>   

I think a strictly correct name for the function would be 
can_i_use___pa_on_this_address(vaddr).  It isn't 
is_this_really_an_addressable_location(vaddr).

    J
