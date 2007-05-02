Return-Path: <linux-kernel-owner+w=401wt.eu-S1946167AbXEBA0u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946167AbXEBA0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 20:26:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946170AbXEBA0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 20:26:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:45436 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946167AbXEBA0q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 20:26:46 -0400
Date: Wed, 2 May 2007 01:26:43 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josh@freedesktop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-sparse@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sparse -Wptr-subtraction-blows: still needed?
Message-ID: <20070502002643.GJ4095@ftp.linux.org.uk>
References: <4637AC3D.6000008@freedesktop.org> <alpine.LFD.0.98.0705011442320.3808@woody.linux-foundation.org> <4637D47D.7040203@freedesktop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4637D47D.7040203@freedesktop.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 01, 2007 at 04:59:57PM -0700, Josh Triplett wrote:
> Linus Torvalds wrote:
> > 
> > On Tue, 1 May 2007, Josh Triplett wrote:
> >> Does this still apply?  Do current versions of GCC still have this problem?
> >> If not, can the option and warning go away?
> > 
> > Even if current versions of gcc don't triple the build time (and for the 
> > kernel, I suspect it doesn't, because we've tried to clean up our header 
> > files), the generated _code_ will invariably suck.
> 
> "invariably"?
> 
> Do you know whether the current version of GCC generates poor code for pointer
> subtraction?
> 
> If so, does anything in particular make this an unfixable problem?

Just the fact that calculation itself is nasty.  In the best case you
get (on x86) something like
        sarl    $2, %eax
        imull   $-1431655765, %eax, %eax
(that one is with object size equal to 12).  On other targets it can get
considerably uglier - e.g. on alpha with -O2 the same will result in
        sra $17,2,$17
        s4subq $17,$17,$0
        s8subq $0,$0,$0
        s4addq $0,$17,$0
        sll $0,8,$1
        addq $0,$1,$0
        sll $0,16,$2
        addq $0,$2,$0
        sll $0,32,$1
        addq $0,$1,$0
        addq $0,$0,$0
        addl $0,$17,$0
With -Os it's
        ldah $1,$LC0($29)               !gprelhigh
        sra $0,2,$0
        ldq $1,$LC0($1)         !gprellow
        mull $0,$1,$0
with LC0 in rodata:
$LC0:
        .quad   -6148914691236517205

Now imagine the joy of having a bunch of such wonders in a hot path...
