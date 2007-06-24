Return-Path: <linux-kernel-owner+w=401wt.eu-S1756383AbXFXSo7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756383AbXFXSo7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 14:44:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751516AbXFXSow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 14:44:52 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:39002 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbXFXSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 14:44:51 -0400
Date: Sun, 24 Jun 2007 19:44:49 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Segher Boessenkool <segher@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070624184449.GB21478@ftp.linux.org.uk>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk> <b739fb9ad6e68bfe5d2a4b839abc8ea4@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b739fb9ad6e68bfe5d2a4b839abc8ea4@kernel.crashing.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 08:18:52PM +0200, Segher Boessenkool wrote:
> >#define _IOC_TYPECHECK(t) \
> >        ((sizeof(t) == sizeof(t[1]) && \
> >          sizeof(t) < (1 << _IOC_SIZEBITS)) ? \
> >          sizeof(t) : __invalid_size_argument_for_IOC)
> >poisoning _IOW() et.al., so those who do something like
> >
> >static const char *v4l1_ioctls[] = {
> >        [_IOC_NR(VIDIOCGCAP)]       = "VIDIOCGCAP",
> >
> >run into trouble.
> 
> >The only reason that doesn't break gcc to hell and back is
> >that gcc has unfixed bugs in that area.
> 
> If I understand correctly what bugs you are talking about,
> most (all?) of those were solved in the dark ages already
> (i.e., the 3.x series).

Alas, no.  gcc is amazingly (and inconsistently) sloppy about the
things it accepts as integer constant expressions.
 
> >It certainly is not a valid C
> 
> Why not?  Nothing in the C standard says all your externs
> have to be defined in some other translation unit you link
> with AFAIK.

It's not about externs.  It's about things like

unsigned n;
int a[] = {[n - n + n - n] = 1};

And yes, gcc does eat that.  With -pedantic -std=c99, at that.  
However, 

unsigned n;
int a[] = {[n + n - n - n] = 1};

gets you error: nonconstant array index in initializer

And that's 4.1, not 3.x...
