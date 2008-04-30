Return-Path: <linux-kernel-owner+w=401wt.eu-S1759870AbYD3PoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759870AbYD3PoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 11:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756374AbYD3PoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 11:44:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755439AbYD3PoN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 11:44:13 -0400
Date: Wed, 30 Apr 2008 08:43:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: "Bryan Wu" <cooloney@kernel.org>, pmarques@grupopie.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] kallsyms: Allow kernel symbols in L1 to be found in
 Blackfin architecture
Message-Id: <20080430084341.fbadff6c.akpm@linux-foundation.org>
In-Reply-To: <200804300951.43995.rgetz@blackfin.uclinux.org>
References: <1209119299-27894-1-git-send-email-cooloney@kernel.org>
	<1209119299-27894-2-git-send-email-cooloney@kernel.org>
	<20080429150050.72750260.akpm@linux-foundation.org>
	<200804300951.43995.rgetz@blackfin.uclinux.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Apr 2008 09:51:43 -0400 Robin Getz <rgetz@blackfin.uclinux.org> wrote:

> On Tue 29 Apr 2008 18:00, Andrew Morton pondered: 
> > That's a bit grubby.  I suppose we could pretend not to have noticed,
> > but this really isn't the preferred way of putting arch-specific hooks into
> > arch-neutral code.
> > 
> > Nicer might be to add
> > 
> > void __weak arch_is_kernel_text(unsigned long addr)
> > {
> > 	return 0;
> > }
> > 
> > with a declaration in linux/kallsyms.h and then override
> > arch_is_kernel_text() in arch/blackfin/ code.
> 
> I will refactor, and send again.
> 

Thanks.

There are of course lots of other ways of doing it, apart from __weak. 
Many involve unpleasing ARCH_HAVE_FOO things.

Possibly cleaner would be, in kallsyms.c:

#ifndef arch_is_kernel_text
static inline int arch_is_kernel_text(unsigned long addr)
{
	return 0;
}
#define arch_is_kernel_text(addr) arch_is_kernel_text(addr)	// not really needed
#endif



and then, in a blackfin header file do

extern int arch_is_kernel_text(unsigned long addr);
#define arch_is_kernel_text(addr) arch_is_kernel_text(addr)


But personally I find all these party tricks a bit unpleasant.  The
definitive approach to implementing a per-arch kernel->arch interface is to
just implement it, dammit.  That means adding

static inline int arch_is_kernel_text(unsigned long addr)
{
	return 0;
}

to every architecture's include/asm/kallsyms.h, then doing blackfin's one
differently.

Verbose, but complete.
