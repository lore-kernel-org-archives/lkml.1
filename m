Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbXFXUi4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbXFXUi4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:38:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751526AbXFXUiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:38:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:42113 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754569AbXFXUik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:38:40 -0400
Date: Sun, 24 Jun 2007 21:38:37 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624203837.GE21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 09:40:06PM +0200, Segher Boessenkool wrote:
> >>Why?  I'd say it's not better than BUILD_BUG_ON_ZERO() use
> >>instead of that ?:
> >
> >Oh, _that_ part I have no problem with. It's more that it seems that 
> >the
> >gcc optimization is ok at least as an extension.
> 
> Sure, but it's not an extension (yet), but an implementation
> side-effect; it would have to be (semi-formally) defined in
> the manual to be an extension.  Until that happens, anyone
> using this "feature" risks haven his code broken at any time
> (or, rather, his code already was broken but he didn't know
> it).
> 
> See gcc.gnu.org/PR456 for more discussion.  Yes it's an old
> bug...

Humm...  Right, so __builtin_offsetof() needs special treatment too.
Oh, bugger.  Is
	offsetof(struct foo, a.x[n])
a documented extension?  I _know_ that it's not promised by 7.17,
but gcc eats it (and obviously that sucker requires extra treatment
in that case).

Parsing __builtin_offsetof() arguments is going to be fun ;-/  Right
now sparse has it as a predefined macro, but if we want to do that
kind of analysis, we need to really parse it.  OTOH, that's not
such a big deal...  Parser would need to accept
	ident ( \[ expr \] | . ident )*
there, typecheck would walk down, check types and find offsets of
struct members on the way down and build expression on the way
back (e.g. in form of constant + sum of stuff from [...]), doing
evaluate_expression() on each index and slapping Int_const_expr
on created nodes accordingly.  In the end, slap the Int_const_expr
on resulting expression in obvious way.  expand would work as usual,
no interesting nodes surviving by that point...

OK, that's doable and probably should be split into implementation
of __builtin_offsetof() (sans Int_const_expr logics) and Int_const_expr
parts merged into the patch that does all handling of integer constant
expressions.

Joy.  OK, folks, disregard 16/16 in the current form; everything prior
to it stands on its own.
