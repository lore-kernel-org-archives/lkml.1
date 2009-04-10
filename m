Return-Path: <linux-kernel-owner+w=401wt.eu-S933275AbZDJDxm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275AbZDJDxm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 23:53:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763242AbZDJDxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 23:53:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:46500 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763100AbZDJDxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 23:53:31 -0400
Date: Thu, 9 Apr 2009 20:53:28 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
       xemul@parallels.com, linux-kernel@vger.kernel.org,
       dave@linux.vnet.ibm.com, hch@infradead.org, mingo@elte.hu,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 09/30] x86_64: ifdef out struct thread_struct::ip
Message-ID: <20090410035328.GB29496@us.ibm.com>
References: <20090410023522.GJ27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090410023522.GJ27788@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 10, 2009 at 06:35:22AM +0400, Alexey Dobriyan wrote:
> struct thread_struct::ip isn't used on x86_64, struct pt_regs::ip is used
> instead. 
> 
> kgdb should be reading 0, but I can't check it.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> ---
> 
>  arch/x86/include/asm/processor.h |    2 ++
>  arch/x86/kernel/kgdb.c           |    2 +-
>  2 files changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -421,7 +421,9 @@ struct thread_struct {
>  	unsigned short		fsindex;
>  	unsigned short		gsindex;
>  #endif
> +#ifdef CONFIG_X86_32
>  	unsigned long		ip;
> +#endif
>  #ifdef CONFIG_X86_64
>  	unsigned long		fs;
>  #endif

Do these make struct thread_struct behave better in cachelines (smaller,
less aliasing)? Can we really fit more in the slab du jour?

Otherwise it seems like we're littering these structs with #ifdefs
and not really saving anything. If these #ifdefs don't save any space why not 
just put in a comment:

>  	unsigned long		ip; /* Used only on i386 */

Or maybe even:

	union {
	  	unsigned long		ip; /* Used only on i386 */
	  	unsigned long		fs; /* Used only on x86_64 */
	};

Cheers,
	-Matt Helsley
