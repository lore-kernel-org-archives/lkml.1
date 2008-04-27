Return-Path: <linux-kernel-owner+w=401wt.eu-S1764071AbYD0VCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764071AbYD0VCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 17:02:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYD0VCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 17:02:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60126 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042AbYD0VCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 17:02:40 -0400
Date: Sun, 27 Apr 2008 22:02:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bitops: simplify generic bit finding functions
Message-ID: <20080427210235.GX5882@ZenIV.linux.org.uk>
References: <1209327591.14173.74.camel@brick> <alpine.LFD.1.10.0804271325350.3119@woody.linux-foundation.org> <1209328161.14173.77.camel@brick> <alpine.LFD.1.10.0804271335330.3119@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0804271335330.3119@woody.linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2008 at 01:38:34PM -0700, Linus Torvalds wrote:

> It happens because the warning is done as part of constant expression 
> evaluation, but then the expression isn't actually *used*, so when we 
> optimize it away - at a later date - it's too late to undo the warning.
> 
> I don't rightly know how to fix it. We do want to do the constant 
> evaluation early (since all the optimizations that may then make it a 
> non-issue depends on constants being constants!), but in order to not 
> output the warning we'd have to turn the constant into a "constant with 
> warning 'xyz' if used".
> 
> Which we have no support for in sparse yet.

It's not even a constant, really...  What we need is
	* don't fold further if that sucker would be evaluated (i.e. 0 && <...>
is folded, 0 & <...> is not)
	* don't consider an integer constant expression with value 0 for
purposes of null pointer constant handling
	* emit corresponding insn in linearize_expression() when we run into
such sucker.
	* somewhere around the call of vrfy_flow() walk through insns in
remaining bb (we'd done dead code elimination already) and spew postponed
warning on each such insn.  Probably.  Assuming that I'm not entirely
confused about what's going on in that area - which is quite possible.

Folks, could somebody familiar with the backend comment on the last part?
