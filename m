Return-Path: <linux-kernel-owner+w=401wt.eu-S1763673AbYFHLQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763673AbYFHLQe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758337AbYFHLQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:16:26 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:59715 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757617AbYFHLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:16:25 -0400
Date: Sun, 8 Jun 2008 13:17:07 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       linux-kbuild <linux-kbuild@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] Speed up "make headers_*"
Message-ID: <20080608111707.GB10545@uranus.ravnborg.org>
References: <20080608094730.GA30098@uranus.ravnborg.org> <19f34abd0806080312j2b09179cpa384a0460af5874e@mail.gmail.com> <20080608104122.GA10545@uranus.ravnborg.org> <1212922141.32207.495.camel@pmac.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1212922141.32207.495.camel@pmac.infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 08, 2008 at 11:49:01AM +0100, David Woodhouse wrote:
> On Sun, 2008-06-08 at 12:41 +0200, Sam Ravnborg wrote:
> > headers_install.pl looks like this now.
> > I am not happy about the way I call unifdef - can it be
> > done better?
> 
> Possibly. unifdef only actually handles "#ifdef __KERNEL__" and
> "#ifndef __KERNEL__", doesn't it? It shouldn't be too hard to recreate
> at least that much functionality in perl, surely?

Correct. A quick grep shows that we have these different
uses of __KERNEL__:

#if defined(__ARM_EABI__) && !defined(__KERNEL__)
#if !defined(CONFIG_M68K) || !defined(__KERNEL__)
#if defined(CONFIG_VIDEO_V4L1_COMPAT) || !defined (__KERNEL__)
#if defined(__GNUC__) && !defined(__STRICT_ANSI__) || defined(__KERNEL__)
#if defined(__KERNEL__)
#if defined(__KERNEL__) && !defined(__ASSEMBLY__)
#if defined(__KERNEL__) && defined(CONFIG_PPC32)
#if defined(__KERNEL__) && defined(CONFIG_SMP) && !defined(__ASSEMBLY__)
#if !defined(__KERNEL__) || defined(CONFIG_X86)
#if defined(__KERNEL__) || defined(__DEFINE_BSD_TERMIOS)
#if !defined(__KERNEL__) && !defined(DIV_ROUND_UP)
#if defined(__KERNEL__) || !defined(__GLIBC__) || (__GLIBC__ < 2)
#if (!defined(__KERNEL__) && !defined(KERNEL) && !defined(INKERNEL) && !defined(_KERNEL)) || defined(USE_SEQ_MACROS) 
#if defined(__KERNEL__) || defined(__linux__)
# if (defined(__KERNEL__) || !defined(RELOC_DEBUG)) \
#if defined(__KERNEL__) || defined(__USE_ALL)
#if defined(__KERNEL__) || defined(__WANT_POSIX1B_SIGNALS__)
#if defined(__KERNEL__) && defined(__x86_64__)
#if !defined(__STRICT_ANSI__) || defined(__KERNEL__)
#ifdef  __KERNEL__
#ifndef __KERNEL__

#else and #endif filtered away.

A script needs to take into account other preprocessor
uses too due to their nested nature.
But doable I'm sure.

And I rather have 100 lines perl than use the unifdef utility
because we then have it collected in one place and can do even
stricter validation.


> 
> Bonus points for making it handle more interesting constructs like
> "#if defined (KERNEL) || defined (FOO)", and for warning/erroring
> whenever any ifdefs on CONFIG_xxx would be visible in userspace.
> But those can come later; we don't have those yet anyway.

Agree.

	Sam
