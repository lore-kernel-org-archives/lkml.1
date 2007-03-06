Return-Path: <linux-kernel-owner+w=401wt.eu-S1752938AbXCFIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752938AbXCFIf3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 03:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932978AbXCFIf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 03:35:29 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:51181 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752937AbXCFIf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 03:35:28 -0500
Date: Tue, 6 Mar 2007 09:34:49 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan Beulich <jbeulich@novell.com>
Subject: Re: [patch] paravirt: VDSO page is essential
Message-ID: <20070306083449.GA12511@elte.hu>
References: <45EC9347.9030009@goop.org> <20070305225859.236021800E5@magilla.sf.frob.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305225859.236021800E5@magilla.sf.frob.com>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> > Jan Beulich just posted a patch to do just this - relocate the 
> > vdso's ELF header.  If that's all that's really required to keep 
> > COMPAT_VDSO viable under PARAVIRT, then it seems like the way to go.
> 
> I found 
> http://marc.theaimsgroup.com/?l=xen-devel&m=117309332600075&w=2 and 
> that must be the one you meant.  The ELF-grokking form of that is 
> exactly what I had in mind.  The "find relocs with cmp" scheme is 
> pretty silly, but also works fine.  It trades tweaky ELF knowledge 
> with tweaky fragile build methods, but it's all about the same to me.

this looks good to me too in principle, the #else branch. But the actual 
implementation will have to be redone quite a bit i fear. Some details: 
relocate_vdso() needs some major coding style cleanups. This bit:

-# define VDSO_PRELINK          VDSO_HIGH_BASE
+# ifndef CONFIG_XEN
+#  define VDSO_PRELINK         VDSO_HIGH_BASE
+# else
+#  define VDSO_PRELINK         (0UL - FIX_VDSO * PAGE_SIZE)
+# endif

should be Kconfig driven, not #ifdef driven, due to cleanliness and also 
because lguest wants to have the same thing. Plus:

+#if defined(CONFIG_XEN) && defined(CONFIG_COMPAT_VDSO)

i'd just make this depend on CONFIG_COMPAT_VDSO, always. Same here:

+#if defined(CONFIG_XEN) && defined(CONFIG_COMPAT_VDSO)
+static void __init relocate_vdso

just make this driven in the normal CONFIG_COMPAT_VDSO case too - even 
though we 'prelink' the VDSO to the usual address - we better run 
through the same code all the time and reduce the number of variants as 
much as possible.

furthermore, there should be a paravirt_ops method to chose the 
relocation address, unless i'm missing something. On the native kernel 
that address will default to 0xffffe000. (if CONFIG_COMPAT_VDSO is 
selected)

this way there will only be two main variants to worry about: compat and 
modern (which is the current status quo anyway), instead of 4-5 
variants.

	Ingo
