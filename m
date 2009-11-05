Return-Path: <linux-kernel-owner+w=401wt.eu-S1753780AbZKEG2e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780AbZKEG2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:28:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbZKEG2d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:28:33 -0500
Received: from ozlabs.org ([203.10.76.45]:35545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750714AbZKEG2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:28:33 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH] BUILD_BUG_ON: make it handle more cases
Date: Thu, 5 Nov 2009 16:58:36 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: Hollis Blanchard <hollisb@us.ibm.com>, Jan Beulich <JBeulich@novell.com>,
       akpm@linux-foundation.org, linuxppc-dev@lists.ozlabs.org,
       kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org
References: <4AC1E15502000078000516B5@vpn.id2.novell.com> <200910201415.34361.rusty@rustcorp.com.au> <20091105112020.33f02552.sfr@canb.auug.org.au>
In-Reply-To: <20091105112020.33f02552.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051658.36265.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Nov 2009 10:50:20 am Stephen Rothwell wrote:
> Hi Rusty,
> 
> On Tue, 20 Oct 2009 14:15:33 +1030 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > +#ifndef __OPTIMIZE__
> > +#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
> > +#else
> > +extern int __build_bug_on_failed;
> > +#define BUILD_BUG_ON(condition)					\
> > +	do {							\
> > +		((void)sizeof(char[1 - 2*!!(condition)]));	\
> > +		if (condition) __build_bug_on_failed = 1;	\
> > +	} while(0)
> > +#endif
> > +#define MAYBE_BUILD_BUG_ON(condition) BUILD_BUG_ON(condition)
> > +
> 
> I decided to try this in linux-next, but an x86_64 allmodconfig build
> gave this (gcc 4.4.0):
> 
> ERROR: "__build_bug_on_failed" [drivers/net/virtio_net.ko] undefined!
> ERROR: "__build_bug_on_failed" [drivers/block/virtio_blk.ko] undefined!
> 
> I assume that this is caused by the "MAYBE_BUILD_BUG_ON(fbit >= 32)" in
> virtio_has_feature() (in include/linux/virtio_config.h) which is called
> all over the place.  Unfortunately, virtio_has_feature() gets uninlined
> in those two files ...

Huh?  virtio_has_feature does:

	if (__builtin_constant_p(fbit))
		BUILD_BUG_ON(fbit >= 32);
	else
		BUG_ON(fbit >= 32);

So, if it's not a constant, gcc should throw away that first branch.  If it
is, it should optimize it away (and no, these are not real bugs AFAICT).

I did a 4.3.3 allmodconfig with this patch on 64-bit a few days back and all
was fine.  Will try 4.4.0 now.

Thanks,
Rusty.
