Return-Path: <linux-kernel-owner+w=401wt.eu-S1760098AbXF0QfL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760098AbXF0QfL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:35:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXF0Qe6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:34:58 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:57182 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754462AbXF0Qe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:34:57 -0400
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Neil Booth <neil@daikokuya.co.uk>, Al Viro <viro@ftp.linux.org.uk>,
       Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
In-Reply-To: <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk>
	 <20070624174732.GZ21478@ftp.linux.org.uk>
	 <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
	 <20070624183547.GA21478@ftp.linux.org.uk>
	 <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
	 <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
	 <20070624203837.GE21478@ftp.linux.org.uk>
	 <467F531A.3030702@freedesktop.org>
	 <20070626221040.GI21478@ftp.linux.org.uk>
	 <20070626221134.GA21350@ftp.linux.org.uk>
	 <20070627121021.GQ7590@daikokuya.co.uk>
	 <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
Content-Type: text/plain
Date: Wed, 27 Jun 2007 09:34:55 -0700
Message-Id: <1182962095.8970.87.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-27 at 09:19 -0700, Linus Torvalds wrote:
> 
> On Wed, 27 Jun 2007, Neil Booth wrote:
> > 
> > Here are three independently invalid non-ICEs that sparse doesn't
> > diagnose.
> > 
> > extern int f(void);
> > enum { cast_to_ptr = (int) (void *) 0 };
> > enum { cast_to_float = (int) (double) 1 };
> 
> Those two *really* shouldn't fail. I don't care if the C standard says so, 
> that is *fine*.
[...]
> And I think standards can go screw themselves, and you can make it an 
> error with some "--standard-pedantic" switch or similar.

Agreed.  Issuing a warning on these kinds of constructs does not seem
useful, but if people really want it, it should go in some warning
option that does not get turned on by default, and probably should not
get turned on by -Wall either.

> > enum { fncall = 0 ? f(): 3 };
> 
> Again, I think that's a deficiency of a standard that tries to be 
> acceptable to everybody rather than about a "really good language".
> 
> So I personally think we should allow it too if at all possible, and 
> again, use some "--standard-pedantic" to flag it as an error.
> 
> Why? Because things like that may not look sensible when written out, but 
> they are often _very_ sensible when they are the result of a macro that 
> does some error checking or other thing. 
> 
> The classic example of this is "__builtin_constant_p()". It is a *great* 
> way to make a macro that does different things depending on whether 
> something is a compile-time constant or not, and no, it's not standard, 
> but dang, it's so useful that a standard that doesn't allow sane use of it 
> is basically bogus.
> 
> So look at the "ntohl()" kind of thing, and realize that it's just "Good 
> Practice(tm)" to be able to make a ntohl() macro that can be used for 
> initializers, including very much enum initializers. Ie
> 
> 	enum { defaultport = htons(9418) };
> 
> is actually nice code for something like the kernel, but it turns out that 
> in order to make this work, you have to do it as
> 
> 	#define htons(x) (__builtin_constant_p(x) ? constant_htons(x) : __htons(x))
> 
> and that in turn generates *exactly* the kind of thing you talk of above.
> 
> And when you give _your_ example, it looks insane. When I give _my_ 
> example, it generates exactly the same thing, but suddenly it has a great 
> reason for doing so, and it's no longer insane.

Also agreed.  Same goes for other short-circuiting operations like &&,
||, and ?: without the center argument; if you can determine at
compilation time that it does not need to evaluate part of the
expression at all, go ahead and ignore that part of the expression even
if it does not constitute an integer constant expression.  If you want
to optionally check for this case and issue a diagnostic, put it under
-Wstrict-constant-expressions or similar.

- Josh Triplett


