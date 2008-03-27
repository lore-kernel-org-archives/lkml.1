Return-Path: <linux-kernel-owner+w=401wt.eu-S1760900AbYC0Ut1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760900AbYC0Ut1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 16:49:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758633AbYC0UtS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 16:49:18 -0400
Received: from hu-out-0506.google.com ([72.14.214.235]:4621 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758597AbYC0UtR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 16:49:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=jqfBtgbVfffq37lptH/IcAWZBe4HYHWCfT8mxWe2iSeC/yt5G6dZQc1D23jzLisbm5pB4rFC8C1FGwJyf3qPKpwGSrqCCFmAalWFDTM9f/K5F2KwJHGjc3a2+ZUHZWUyesWTS5P/XCYSNFNnPz7BBdNItHcJX+seqFcsu9Liuj0=
Subject: Re: [git pull] x86 fixes
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
References: <20080327200309.GA18550@elte.hu>
	 <alpine.LFD.1.00.0803271325430.14670@woody.linux-foundation.org>
Content-Type: text/plain
Date: Thu, 27 Mar 2008 13:48:59 -0700
Message-Id: <1206650939.24940.43.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-03-27 at 13:31 -0700, Linus Torvalds wrote:
> 
> On Thu, 27 Mar 2008, Ingo Molnar wrote:
> >
> > Ingo Molnar (1):
> >       x86: fix prefetch workaround
> ...
> > diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> > index fdc6674..c0c82bc 100644
> > --- a/arch/x86/mm/fault.c
> > +++ b/arch/x86/mm/fault.c
> > @@ -92,7 +92,8 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
> >  	unsigned char *max_instr;
> >  
> >  #ifdef CONFIG_X86_32
> > -	if (!(__supported_pte_mask & _PAGE_NX))
> > +	/* Catch an obscure case of prefetch inside an NX page: */
> > +	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
> >  		return 0;
> >  #endif
> 
> Ingo, this patch makes no sense.
> 
> Two reasons:
> 
>  - "error_code & 16" is senseless. Use PF_INSTR instead, which actually 
>    tells the reader something.
> 
>  - this piece of crap code is immediately followed by
> 
> 	/* If it was a exec fault on NX page, ignore */
> 	if (error_code & PF_INSTR)
> 		return 0;
> 
>    which uses that *right* and readable PF_INSTR #define, and also shows 
>    that the newly modified code is totally insane (ie: if the new code 
>    triggers, then it would have returned 0 later _anyway_)
> 
> So I think it's just crap. I think it's duplication from the merging of 
> the x86 code, and I think that the fact that the new code didn't use the 
> right #define helper means that people didn't see that it was crap.
> 
> I pulled it, but this needs some resolution. The code makes no sense. 
> Should that #ifdef and the code inside of it just be removed entirely?
> 

Sorry, this was my fault, I eliminated the ifdef within the X86_32 block
but didn't go further.  Think the below is correct:

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index c0c82bc..6f5df93 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -91,14 +91,8 @@ static int is_prefetch(struct pt_regs *regs, unsigned long addr,
 	int prefetch = 0;
 	unsigned char *max_instr;
 
-#ifdef CONFIG_X86_32
 	/* Catch an obscure case of prefetch inside an NX page: */
-	if ((__supported_pte_mask & _PAGE_NX) && (error_code & 16))
-		return 0;
-#endif
-
-	/* If it was a exec fault on NX page, ignore */
-	if (error_code & PF_INSTR)
+	if ((__supported_pte_mask & _PAGE_NX) && (error_code & PF_INSTR))
 		return 0;
 
 	instr = (unsigned char *)convert_ip_to_linear(current, regs);



