Return-Path: <linux-kernel-owner+w=401wt.eu-S1758683AbYCaV6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683AbYCaV6v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 17:58:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758498AbYCaV6l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 17:58:41 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:37928 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103AbYCaV6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 17:58:40 -0400
Date: Mon, 31 Mar 2008 22:58:35 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: Sparse Question
Message-ID: <20080331215835.GM9785@ZenIV.linux.org.uk>
References: <1206998108.6543.74.camel@brick> <1206999598.6543.76.camel@brick>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206999598.6543.76.camel@brick>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2008 at 02:39:58PM -0700, Harvey Harrison wrote:
> On Mon, 2008-03-31 at 14:15 -0700, Harvey Harrison wrote:
> > Hi Al,
> > 
> > Further to eliminating some of the trivial sparse noise in a kernel
> > build, I just can't seem to understand what sparse is warning about:
> > 
> 
> I should have mentioned, the other block of warnings comes from
> drivers/media/video/videodev.c....again initializing arrays of IOCTLs

1 ? 0 : x

is not valid in contexts where C requires integer constant expressions.
Index in static array initializer is one of those.

gcc allows it, but its extensions in that area are inconsistent, to say
the least - basically, it goes with "if optimizer can fold that into
constant with this set of options, it will be accepted".  With very weird
boundary between accepted and not accepted (as in "reorder arguments of +,
and what had been recognized as constant is not recognized anymore").

sparse doesn't even try to duplicate that set of bugs.  We _could_ try
to go for a more or less reasonable subset (e.g. ?: with integer constant
expression as the first argument and integer constant expression as
the second or the third resp., depending on the value of the first one,
similar for && and ||), but I'm not all that sure that it's worth doing.

The fact is, use of what we have for _IOC in such contexts is not just
a gccism, it's ill-defined one.  I suspect that the right solution is
to sanitize _that_...

FWIW, why not simply put division by 0 into the branch that shouldn't
be reached instead of using a variable that doesn't exist and would
blow at ld(1) time?  I.e. go with
#define _IOC_TYPECHECK(t) \
        ((sizeof(t) == sizeof(t[1]) && \
          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
          sizeof(t) : 1/0)
instead.  I'd say that trading a pretty name in linker stderr for
compiler error that shows exact location in the source would be
a good bargain...

Linus, would you object against that in post-2.6.25?
