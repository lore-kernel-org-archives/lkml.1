Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbXFXSf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbXFXSf6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbXFXSft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:35:49 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39256 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbXFXSfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:35:48 -0400
Date: Sun, 24 Jun 2007 19:35:47 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624183547.GA21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 11:04:57AM -0700, Linus Torvalds wrote:
> 
> 
> On Sun, 24 Jun 2007, Al Viro wrote:
> > 
> > Heh...  The first catches are lovely:
> >                  struct fxsrAlignAssert {
> >                          int _:!(offsetof(struct task_struct,
> >                                          thread.i387.fxsave) & 15);
> 
> Ok, that's a bit odd.
> 
> > as an idiotic way to do BUILD_BUG() and
> > #define _IOC_TYPECHECK(t) \
> >         ((sizeof(t) == sizeof(t[1]) && \
> >           sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> >           sizeof(t) : __invalid_size_argument_for_IOC)
> > poisoning _IOW() et.al., so those who do something like
> > 
> > static const char *v4l1_ioctls[] = {
> >         [_IOC_NR(VIDIOCGCAP)]       = "VIDIOCGCAP",
> 
> On the other hand, this one really does seem to be "nice".

Why?  I'd say it's not better than BUILD_BUG_ON_ZERO() use
instead of that ?:.   This code would remain unchanged; the
entire reason why we run into problems is that a way to
force an error at build time had produced something that
was not a constant expression.  It's not a matter of having
to change something in the users of that sucker (or _IOC_NR(), or
_IOR(), or _IO()).  The code in question is there for one thing -
to give (constant) sizeof(t) or an error if t doesn't look good for
us.  That's all.  And we have a perfectly good way to do that...

> I don't think it's a misfeature to be able to do "obvious compile-time 
> constant optimizations" on initializer indexes. The bitfield size thing in 
> some ways does do the same thing - it's clearly _odd_, but if I had my  
> choice, I'd prefer a language that allows it over one that doesn't.

Er...  That's nice, assuming you don't suddenly run into "code with
convoluted bunch of macros breaks on a different version of compiler
and/or different CFLAGS".

IOW, having the optimizer strength define the boundary between the programs
that compile and ones that give an error is not a good idea, IMO.

Where do you place that boundary?  Is 0 && n good?  How about 0 & n?
Or 0 * n?  Or n - n?  Or (n+1)-(n+1) from macro expansion?  Note that
gcc does _not_ take the last one as integer constant expression, but
happens to deal with the earlier ones.  OTOH, it does deal with n * m - n * m.

And I would not bet a dime on gcc versions being consistent with each other
in that area.

Now, there is one possible answer that makes some sense - allow removal
of unevaluated parts in &&, || and ?:.  I can do that, but I'm not
sure if it's actually worth doing.  The only case in the kernel tree
become more readable with use of BUILD_BUG_ON_ZERO() anyway and I would
be very surprised to find any real code where something of that kind
would be a problem.

> > Objections?  The only reason that doesn't break gcc to hell and back is
> > that gcc has unfixed bugs in that area.  It certainly is not a valid C
> > or even a remotely sane one.
> 
> I agree that it's obviously not "valid C", but I don't agree that it's not 
> remotely sane. Why not allow that extension? 

Because it's not well-defined and because having "let me check if this
version of compiler will eat that" as the only way to tell if construct
would be OK is not a good thing...
