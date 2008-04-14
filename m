Return-Path: <linux-kernel-owner+w=401wt.eu-S1758743AbYDNIlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758743AbYDNIlO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 04:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754085AbYDNIk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 04:40:59 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:55750 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753405AbYDNIk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 04:40:58 -0400
Date: Mon, 14 Apr 2008 10:41:27 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Jacek Luczak <difrost.kernel@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: pgtable_32.h - prototype and section mismatch fixes
Message-ID: <20080414084127.GA11372@uranus.ravnborg.org>
References: <48022990.3060104@gmail.com> <20080414072645.GG16163@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080414072645.GG16163@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2008 at 09:26:45AM +0200, Ingo Molnar wrote:
> 
> * Jacek Luczak <difrost.kernel@gmail.com> wrote:
> 
> > paravirt_pagetable_setup_[start,done]() is used by __init 
> > pagetable_init(). Annotate both functions with __init.
> 
> >  #ifndef CONFIG_PARAVIRT
> > -static inline void paravirt_pagetable_setup_start(pgd_t *base)
> > +static inline void __init paravirt_pagetable_setup_start(pgd_t *base)
> >  {
> >  	native_pagetable_setup_start(base);
> >  }
> 
> hm, that's an interesting case: we need those annotations probably 
> because gcc decided to not inline those functions. (this is possible via 
> the new CONFIG_OPTIMIZE_INLINING=y option) Sam, what's your take on 
> that?

gcc uses different heuristics for inlining between the different
versions. Therefore to achieve somehow predictable results I
added -fno-inline-functions-called-once when CONFIG_DEBUG_SECTION_MISMATCH
is enabled.

So in the above case for any normal kernel build we would see that
gcc inlined the above and everything is fine.
But for the CONFIG_DEBUG_SECTION_MISMTCH cases we do not inline and
thus we see that we have a section mismatch.

The rationale was that it is better to annotate a few more functions and
reliable results across gcc versions than it is to see section
mismatch warnings only with older but not newer gcc versions.

	Sam
