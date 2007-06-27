Return-Path: <linux-kernel-owner+w=401wt.eu-S1762326AbXF0QTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762326AbXF0QTn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 12:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757104AbXF0QTf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 12:19:35 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41354 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbXF0QTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 12:19:34 -0400
Date: Wed, 27 Jun 2007 09:19:17 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Neil Booth <neil@daikokuya.co.uk>
cc: Al Viro <viro@ftp.linux.org.uk>, Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
In-Reply-To: <20070627121021.GQ7590@daikokuya.co.uk>
Message-ID: <alpine.LFD.0.98.0706270910000.8675@woody.linux-foundation.org>
References: <E1I2N6V-0003g9-8H@ZenIV.linux.org.uk> <20070624174732.GZ21478@ftp.linux.org.uk>
 <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org>
 <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org>
 <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org>
 <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org>
 <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk>
 <20070627121021.GQ7590@daikokuya.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 27 Jun 2007, Neil Booth wrote:
> 
> Here are three independently invalid non-ICEs that sparse doesn't
> diagnose.
> 
> extern int f(void);
> enum { cast_to_ptr = (int) (void *) 0 };
> enum { cast_to_float = (int) (double) 1 };

Those two *really* shouldn't fail. I don't care if the C standard says so, 
that is *fine*.

In particular, "offsetof()" should be portably able to basically be the 
standard #define, which involves an integer cast from a constant pointer. 
That had *better* be a valid constant integer expression, because it's 
very useful.

And I think standards can go screw themselves, and you can make it an 
error with some "--standard-pedantic" switch or similar.

Standards are just random pieces of paper, for crying out loud! They have 
zero relevance in the end. 

> enum { fncall = 0 ? f(): 3 };

Again, I think that's a deficiency of a standard that tries to be 
acceptable to everybody rather than about a "really good language".

So I personally think we should allow it too if at all possible, and 
again, use some "--standard-pedantic" to flag it as an error.

Why? Because things like that may not look sensible when written out, but 
they are often _very_ sensible when they are the result of a macro that 
does some error checking or other thing. 

The classic example of this is "__builtin_constant_p()". It is a *great* 
way to make a macro that does different things depending on whether 
something is a compile-time constant or not, and no, it's not standard, 
but dang, it's so useful that a standard that doesn't allow sane use of it 
is basically bogus.

So look at the "ntohl()" kind of thing, and realize that it's just "Good 
Practice(tm)" to be able to make a ntohl() macro that can be used for 
initializers, including very much enum initializers. Ie

	enum { defaultport = htons(9418) };

is actually nice code for something like the kernel, but it turns out that 
in order to make this work, you have to do it as

	#define htons(x) (__builtin_constant_p(x) ? constant_htons(x) : __htons(x))

and that in turn generates *exactly* the kind of thing you talk of above.

And when you give _your_ example, it looks insane. When I give _my_ 
example, it generates exactly the same thing, but suddenly it has a great 
reason for doing so, and it's no longer insane.

			Linus
