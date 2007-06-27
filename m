Return-Path: <linux-kernel-owner+w=401wt.eu-S1761538AbXF0RZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761538AbXF0RZ7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 13:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757694AbXF0RZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 13:25:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52389 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158AbXF0RZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 13:25:50 -0400
Date: Wed, 27 Jun 2007 18:25:42 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Neil Booth <neil@daikokuya.co.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627172542.GA21478@ftp.linux.org.uk>
References: <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk> <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org> <1182962095.8970.87.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182962095.8970.87.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 09:34:55AM -0700, Josh Triplett wrote:

> > is actually nice code for something like the kernel, but it turns out that 
> > in order to make this work, you have to do it as
> > 
> > 	#define htons(x) (__builtin_constant_p(x) ? constant_htons(x) : __htons(x))

That's not quite right.  In principle, __builtin_choose_expr() could be
used for that kind of stuff and builtins can change the rules.
 
> Also agreed.  Same goes for other short-circuiting operations like &&,
> ||, and ?: without the center argument; if you can determine at
> compilation time that it does not need to evaluate part of the
> expression at all, go ahead and ignore that part of the expression even
> if it does not constitute an integer constant expression.  If you want
> to optionally check for this case and issue a diagnostic, put it under
> -Wstrict-constant-expressions or similar.

That actually means extra work for evaluate_expression().  Unfortunately.

The thing is, we want to typecheck all branches, even ones not taken.
_However_, we don't want to expand all of them.  Having extra places
where we have to do expansion means extra work.
