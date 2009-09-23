Return-Path: <linux-kernel-owner+w=401wt.eu-S1753691AbZIWA5B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbZIWA5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 20:57:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZIWA5A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 20:57:00 -0400
Received: from ozlabs.org ([203.10.76.45]:37844 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZIWA5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 20:57:00 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH] fix BUILD_BUG_ON() and a couple of bogus uses of it
Date: Wed, 23 Sep 2009 10:27:00 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
In-Reply-To: <4A8AEBFD0200007800010580@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909231027.01006.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Aug 2009 01:29:25 am Jan Beulich wrote:
> gcc permitting variable length arrays makes the current construct
> used for BUILD_BUG_ON() useless, as that doesn't produce any diagnostic
> if the controlling expression isn't really constant. Instead, this
> patch makes it so that a bit field gets used here. Consequently, those
> uses where the condition isn't really constant now also need fixing.
> 
> Note that in the gfp.h, kmemcheck.h, and virtio_config.h cases
> MAYBE_BUILD_BUG_ON() really just serves documentation purposes - even
> if the expression is compile time constant (__builtin_constant_p()
> yields true), the array is still deemed of variable length by gcc, and
> hence the whole expression doesn't have the intended effect.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>

We used to use an undefined symbol here; diagnostics are worse but it catches
more stuff.

Perhaps a hybrid is the way to go?

#ifndef __OPTIMIZE__
#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
#else
/* If it's a constant, catch it at compile time, otherwise at link time. */
extern int __build_bug_on_failed;
#define BUILD_BUG_ON(condition) \
	do { 								\
		((void)sizeof(char[1 - 2*!!(condition)]));		\
		if (condition) __build_bug_on_failed = 1;		\
	} while(0)
#endif

Thanks,
Rusty.
