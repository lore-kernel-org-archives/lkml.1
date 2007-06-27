Return-Path: <linux-kernel-owner+w=401wt.eu-S1762196AbXF0Pyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762196AbXF0Pyk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 11:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755721AbXF0Py3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 11:54:29 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47630 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755420AbXF0Py2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 11:54:28 -0400
Date: Wed, 27 Jun 2007 16:54:25 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Neil Booth <neil@daikokuya.co.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627155425.GX21478@ftp.linux.org.uk>
References: <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <20070627123031.GO21478@ftp.linux.org.uk> <20070627125958.GA16758@daikokuya.co.uk> <20070627131823.GR21478@ftp.linux.org.uk> <20070627133546.GC16758@daikokuya.co.uk> <20070627140636.GT21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627140636.GT21478@ftp.linux.org.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 03:06:36PM +0100, Al Viro wrote:
> *unprintable*
> 
> Yes, I see...  OK, null pointer constants handling (next patch in the
> queue) introduces is_zero_constant() (silent evaluation of integer
> constant expression, with division by 0/too large shift/- on lowest
> value of signed integer type leaving the branch as-is, so that later
> expand would generate a proper error on it; then checking if we'd
> reduced the sucker to EXPR_VALUE[0]).  I'll pull it into a separate
> patch, along with is_nonzero_constant(), and change rules for potential
> ICE on parser stage to
> 	maybe-ICE && y => maybe-ICE
> 	maybe-ICE || y => maybe-ICE
> 	maybe-ICE ? x : y => maybe-ICE if at least one of x and y is maybe-ICE
> 	maybe-ICE ? : y => maybe-ICE
> letting evaluate_expression() on such suckers use them if the first argument
> turns out to be ICE after its evaluate_expression()...
> 
> It really stinks, especially since we can't say "oh, parent it known to
> be non-ICE, no need to bother" - subexpression might be shared.

... or it could be done simpler, if we keep the current logics for
Int_const_expr flag at parse time and add a 'const expression' one
with rules as above.  Anyway, I'm going to get some sleep before
dealing with that crap.
