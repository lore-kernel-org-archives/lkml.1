Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbZKJPu6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbZKJPu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 10:50:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756728AbZKJPu5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 10:50:57 -0500
Received: from smtp.outflux.net ([198.145.64.163]:34657 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690AbZKJPu5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 10:50:57 -0500
Date: Tue, 10 Nov 2009 07:49:56 -0800
From: Kees Cook <kees.cook@canonical.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>,
       Jan Beulich <jbeulich@novell.com>, Vegard Nossum <vegardno@ifi.uio.no>,
       Yinghai Lu <yinghai@kernel.org>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] [x86] detect and report lack of NX protections
Message-ID: <20091110154956.GF5129@outflux.net>
References: <4ADD1E03.4070200@zytor.com>
 <20091020045513.GU5394@outflux.net>
 <20091109221015.GB5129@outflux.net>
 <4AF8A2C0.5080700@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AF8A2C0.5080700@zytor.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 09, 2009 at 03:16:16PM -0800, H. Peter Anvin wrote:
> On 11/09/2009 02:10 PM, Kees Cook wrote:
> > diff --git a/arch/x86/mm/setup_nx.c b/arch/x86/mm/setup_nx.c
> > index 513d8ed..1b93231 100644
> > --- a/arch/x86/mm/setup_nx.c
> > +++ b/arch/x86/mm/setup_nx.c
> > @@ -53,6 +53,9 @@ void __init set_nx(void)
> >  #else
> >  void set_nx(void)
> >  {
> > +	/* notice if _PAGE_NX exists and was removed during check_efer() */
> > +	if (_PAGE_NX && ((__supported_pte_mask & _PAGE_NX) == _PAGE_NX))
> > +		nx_enabled = 1;
> >  }
> >  #endif
> >  
> 
> The second clause can only get executed if CONFIG_X86_PAE is unset,
> which in turn means _PAGE_NX == 0... so that piece of code is meaningless.

CONFIG_X86_PAE is unset for x86_64, where _PAGE_NX is valid.  (This was
the main situation I was trying to address.)  So that chunk runs for
non-pae 32bit, and all 64bit:

config X86_PAE
        bool "PAE (Physical Address Extension) Support"
        depends on X86_32 && !HIGHMEM4G

> It also looks to me that there is no message distinguishing the case
> when nx_enabled == 1 but disable_nx == 1, and instead we say NX is
> "active" when in fact it is disabled in the kernel.

That's true -- I had overlooked that part.  New patch on the way...

-Kees

-- 
Kees Cook
Ubuntu Security Team
