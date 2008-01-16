Return-Path: <linux-kernel-owner+w=401wt.eu-S1755122AbYAPRGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122AbYAPRGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 12:06:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751446AbYAPRF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 12:05:59 -0500
Received: from gw.goop.org ([64.81.55.164]:56825 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYAPRF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 12:05:58 -0500
Message-ID: <478E396A.50707@goop.org>
Date: Wed, 16 Jan 2008 09:05:46 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jan Beulich <jbeulich@novell.com>, Andi Kleen <ak@suse.de>,
       Glauber de Oliveira Costa <glommer@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0 of 4] x86: some more patches
References: <patchbomb.1200435425@localhost> <200801161544.15884.ak@suse.de> <20080116145427.GA640@elte.hu> <200801161626.01711.ak@suse.de> <478E3411.76E4.0078.0@novell.com> <20080116154710.GA28946@elte.hu>
In-Reply-To: <20080116154710.GA28946@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jan Beulich <jbeulich@novell.com> wrote:
>
>   
>>> Yes, but if you cast to long the result will be 32bit again. Or do 
>>> you rely on it being always used in 64bit signed context with sign 
>>> extension? While that might work it would seem rather fragile to me, 
>>> just asking for similar future bugs.
>>>       
>> Even if conversion is to 64-bit unsigned, the value (being signed) 
>> will be sign-extended first (to preserve its value modulo 2**<target 
>> type width>).
>>     
>
> yes. It would be nice if Andi could test my fix instead of arguing why 
> he thinks it's unlikely to work ;-)
>
> (i've got the cleanup patch below as well ontop of today's x86.git which 
> includes the first fix, but it's an RFC as it has wider impact and might 
> break stuff.)
>
> 	Ingo
>
> --------------->
> Subject: x86: PAGE_MASK cleanup
> From: Ingo Molnar <mingo@elte.hu>
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  include/asm-x86/page.h |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> Index: linux-x86.q/include/asm-x86/page.h
> ===================================================================
> --- linux-x86.q.orig/include/asm-x86/page.h
> +++ linux-x86.q/include/asm-x86/page.h
> @@ -6,12 +6,12 @@
>  /* PAGE_SHIFT determines the page size */
>  #define PAGE_SHIFT	12
>  #define PAGE_SIZE	(_AC(1,UL) << PAGE_SHIFT)
> -#define PAGE_MASK	(~(PAGE_SIZE-1))
> +#define PAGE_MASK	(_AT(phys_addr_t, ~(PAGE_SIZE-1)))
>   

Hm, this seems fairly wide-ranging.  How about just making it signed?  
In fact, all these masks which are of the form "all high bits set, some 
low bits clear" (or perhaps "all set except some") should be signed, so 
that the "all high bits set" property is maintained when its extended to 
larger types.

Also, Andi, do you want to get rid of the PHYSICAL_MASK stuff?

    J
