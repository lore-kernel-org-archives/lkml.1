Return-Path: <linux-kernel-owner+w=401wt.eu-S1760121AbXFABNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760121AbXFABNV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754152AbXFABNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:13:12 -0400
Received: from tomts16.bellnexxia.net ([209.226.175.4]:57295 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752856AbXFABNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:13:12 -0400
Date: Thu, 31 May 2007 21:13:09 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: [patch 8/9] F00F bug fixup for i386 - use conditional calls
Message-ID: <20070601011309.GB4626@Krystal>
References: <200706010014.l510ErWa022252@harpo.it.uu.se> <20070531174355.544e7588.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070531174355.544e7588.akpm@linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 21:04:35 up 3 days,  9:43,  2 users,  load average: 0.20, 0.13, 0.07
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andrew Morton (akpm@linux-foundation.org) wrote:
> On Fri, 1 Jun 2007 02:14:53 +0200 (MEST)
> Mikael Pettersson <mikpe@it.uu.se> wrote:
> 
> > Andrew Morton wrote:
> > > Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:
> > > 
> > > > * Andrew Morton (akpm@linux-foundation.org) wrote:
> > > >  
> > > > > > Use the faster conditional calls for F00F bug handling in do_page_fault.
> > > > > > 
> > > > > 
> > > > > I guess this means that CONDCALL will be enabled on pretty much all i386,
> > > > > in which case making the whole feature Kconfigurable is starting to look
> > > > > marginal.
> > > > > 
> > > > > Perhaps a better approach would have to made this change dependent upon
> > > > > CONDCALL, rather than forcing it on.
> > > > > 
> > > > 
> > > > Do you mean making X86_F00F_BUG depend on COND_CALL instead of selecting
> > > > it ?
> > > 
> > > yup
> > 
> > X86_F00F_BUG needs to be enabled in all kernels capable of booting on
> > P5 class machines, whether or not some obscure CONFIG_COND_CALL thingy
> > is enabled or not. X86_F00F_BUG is not some optional optimisation, it's
> > an essential workaround for a serious hardware bug.
> > 
> > Therefore it seems select rather than depend is called for.
> 
> Nope.
> 
> CONFIG_COND_CALL=n	-> 	do f00f handling the present way
> CONFIG_COND_CALL=y	-> 	do f00f handling the new, fast-n-fancy way
> 
> 
> Because I don't think everyone will want to drag all this cond_call stuff
> into their kernel just for slightly faster f00f handling.
> 

Then I should probably leave the redundant 
if (boot_cpu_data.f00f_bug)
test in do_f00f_workaround so that configuration where cond_calls are
not enabled still behave the same way as before. The redundant test will
make the case when cond calls are present a little slower, but we still
have the improvement when the architecture does not need the workaround.
I could also wrap this test in a #ifndef CONFIG_COND_CALL, but it seems
ugly.

Also, since the default is not to set the CF_STATIC_ENABLE flag, the
workaround won't be compiled in the kernel if the conditional calls are
configured out.

The question that arises is : what should be the default behavior of a
cond_call when the cond_calls are configured out? Active, active only
if the CF_STATIC_ENABLE flags is set or inactive?


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
