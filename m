Return-Path: <linux-kernel-owner+w=401wt.eu-S1762073AbXGYCbp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762073AbXGYCbp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 22:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755706AbXGYCbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 22:31:38 -0400
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:43296 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXGYCbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 22:31:38 -0400
Date: Tue, 24 Jul 2007 19:31:36 -0700 (PDT)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell4.speakeasy.net
To: Al Viro <viro@ftp.linux.org.uk>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH][RFC] getting rid of stupid loop in BUG()
In-Reply-To: <20070724153916.GS21668@ftp.linux.org.uk>
Message-ID: <Pine.LNX.4.58.0707241921470.30561@shell4.speakeasy.net>
References: <20070724153916.GS21668@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Al Viro wrote:
> 	AFAICS, the patch below should do it for i386; instead of
> using a dummy loop to tell gcc that this sucker never returns,
> we do
> static void __always_inline __noreturn __BUG(const char *file, int line);
> containing the actual asm we want to insert and define BUG() as
> __BUG(__FILE__, __LINE__).  It looks safe, but I don't claim enough
> experience with gcc __asm__ potential nastiness, so...

Sounds like it doesn't work:
http://gcc.gnu.org/ml/gcc/2007-02/msg00107.html

    [The] programmer won't get optimization he wants as after inlining this as
    after inlining this attribute information becomes completely lost.

    What about __builtin_trap?

    It results in int 6 that might not be applicable, but adding some control
    over it to i386 backend is definitly an option.

    Honza

It seems like if __BUG() is not inlined, you get the bogus noreturn does
return warning.  If it is inlined, then you lose the noreturn attribute and
un-reachable code paths aren't eliminated.  Adding __builtin_trap after the
asm might be an ok fix.  It will emit a spurious int 6, but that won't even be
reached since the asm doesn't return, and it probably be less extra code than
the loop.
