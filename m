Return-Path: <linux-kernel-owner+w=401wt.eu-S1752004AbZL3XpG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004AbZL3XpG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Dec 2009 18:45:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZL3XpF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Dec 2009 18:45:05 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:48347 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416AbZL3XpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Dec 2009 18:45:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=i9Y/2AB3BTe5mSYxOo3cmsLdhGpOK9LTdc27jBdGXQ7f3P/xxJ5SAY+F6pW88tW3o7
         Gs6m4oOKoAgY9JeG6wAsotRE6liEGPZbdOnm5WhN3Bf5j/7S1lE6yBLjm+d3eK87Oi3p
         mRY55JbU41I6FM6B3GLJ6FBdMiHJkGgjyZknc=
Date: Thu, 31 Dec 2009 00:45:00 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Roland McGrath <roland@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Vegard Nossum <vegardno@ifi.uio.no>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFC Patch 1/2][Bugfix][x86][hw-breakpoint] Clear reserved
	bits of DR6 in do_debug()
Message-ID: <20091230234458.GA23808@nowhere>
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182725.GB9494@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091226182725.GB9494@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 26, 2009 at 11:57:25PM +0530, K.Prasad wrote:
> Clear the reserved bits from the stored copy of debug status register (DR6).
> This will help easy bitwise operations.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  arch/x86/include/asm/debugreg.h |    3 +++
>  arch/x86/kernel/traps.c         |    3 +++
>  2 files changed, 6 insertions(+)
> 
> Index: linux-2.6-tip/arch/x86/include/asm/debugreg.h
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/include/asm/debugreg.h
> +++ linux-2.6-tip/arch/x86/include/asm/debugreg.h
> @@ -14,6 +14,9 @@
>     which debugging register was responsible for the trap.  The other bits
>     are either reserved or not of interest to us. */
>  
> +/* Define reserved bits in DR6 which are always set to 1 */
> +#define DR6_RESERVED	(0xFFFF0FF0)
> +


The 12th bit seems to be also reserved.
Shouldn't it be 0xffff1ff0 ?

What kind of bitwise operations do you think it could help?

All of the operations I can find on dr6 are simple masks
test/set/clear.



>  #define DR_TRAP0	(0x1)		/* db0 */
>  #define DR_TRAP1	(0x2)		/* db1 */
>  #define DR_TRAP2	(0x4)		/* db2 */
> Index: linux-2.6-tip/arch/x86/kernel/traps.c
> ===================================================================
> --- linux-2.6-tip.orig/arch/x86/kernel/traps.c
> +++ linux-2.6-tip/arch/x86/kernel/traps.c
> @@ -534,6 +534,9 @@ dotraplinkage void __kprobes do_debug(st
>  
>  	get_debugreg(dr6, 6);
>  
> +	/* Filter out all the reserved bits which are preset to 1 */
> +	dr6 &= ~DR6_RESERVED;
> +
>  	/* Catch kmemcheck conditions first of all! */
>  	if ((dr6 & DR_STEP) && kmemcheck_trap(regs))
>  		return;
> 

