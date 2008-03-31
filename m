Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYCaWIY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYCaWIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 18:08:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756880AbYCaWIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 18:08:02 -0400
Received: from wr-out-0506.google.com ([64.233.184.227]:41490 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756789AbYCaWIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 18:08:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=XsHUieUnudkrfzBPJ/f458H3UFuwIanLmPK5sZWY2DKJPDOnnK6iFpWfuWlIjEhIDQ2SwnwcWaVAQGSzIvt2ZYku7yvTRiG/om4iARKbXFYdf9/9OFSDgtnErCboTl5Oi9/kR6xOeuf2NeJ3TDeUUaEGl4WEOWm9nI6a5QACZyA=
Subject: Re: Sparse Question
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080331215835.GM9785@ZenIV.linux.org.uk>
References: <1206998108.6543.74.camel@brick>
	 <1206999598.6543.76.camel@brick> <20080331215835.GM9785@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Mon, 31 Mar 2008 15:07:58 -0700
Message-Id: <1207001278.6543.78.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-03-31 at 22:58 +0100, Al Viro wrote:
> On Mon, Mar 31, 2008 at 02:39:58PM -0700, Harvey Harrison wrote:
> > On Mon, 2008-03-31 at 14:15 -0700, Harvey Harrison wrote:
> > > Hi Al,
> > > 
> > > Further to eliminating some of the trivial sparse noise in a kernel
> > > build, I just can't seem to understand what sparse is warning about:
> > > 
> > 
> > I should have mentioned, the other block of warnings comes from
> > drivers/media/video/videodev.c....again initializing arrays of IOCTLs
> 
> 1 ? 0 : x
> 
> is not valid in contexts where C requires integer constant expressions.
> Index in static array initializer is one of those.
> 
> gcc allows it, but its extensions in that area are inconsistent, to say
> the least - basically, it goes with "if optimizer can fold that into
> constant with this set of options, it will be accepted".  With very weird
> boundary between accepted and not accepted (as in "reorder arguments of +,
> and what had been recognized as constant is not recognized anymore").
> 
> sparse doesn't even try to duplicate that set of bugs.  We _could_ try
> to go for a more or less reasonable subset (e.g. ?: with integer constant
> expression as the first argument and integer constant expression as
> the second or the third resp., depending on the value of the first one,
> similar for && and ||), but I'm not all that sure that it's worth doing.
> 
> The fact is, use of what we have for _IOC in such contexts is not just
> a gccism, it's ill-defined one.  I suspect that the right solution is
> to sanitize _that_...
> 
> FWIW, why not simply put division by 0 into the branch that shouldn't
> be reached instead of using a variable that doesn't exist and would
> blow at ld(1) time?  I.e. go with
> #define _IOC_TYPECHECK(t) \
>         ((sizeof(t) == sizeof(t[1]) && \
>           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
>           sizeof(t) : 1/0)
> instead.  I'd say that trading a pretty name in linker stderr for
> compiler error that shows exact location in the source would be
> a good bargain...
> 
> Linus, would you object against that in post-2.6.25?

Sorry, maybe I'm thick, but how does _IOC_TYPECHECK get pulled
into the _IOC_NR use?

Harvey

