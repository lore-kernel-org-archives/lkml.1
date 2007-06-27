Return-Path: <linux-kernel-owner+w=401wt.eu-S1760577AbXF0Mam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760577AbXF0Mam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 08:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757467AbXF0Maf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 08:30:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41049 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757028AbXF0Mae (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 08:30:34 -0400
Date: Wed, 27 Jun 2007 13:30:31 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Neil Booth <neil@daikokuya.co.uk>
Cc: Josh Triplett <josh@freedesktop.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-sparse@vger.kernel.org
Subject: Re: [PATCH 16/16] fix handling of integer constant expressions
Message-ID: <20070627123031.GO21478@ftp.linux.org.uk>
References: <20070624174732.GZ21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241102160.3593@woody.linux-foundation.org> <20070624183547.GA21478@ftp.linux.org.uk> <alpine.LFD.0.98.0706241203530.3593@woody.linux-foundation.org> <1a25667a20e43a072f733a3ec2b8e79d@kernel.crashing.org> <20070624203837.GE21478@ftp.linux.org.uk> <467F531A.3030702@freedesktop.org> <20070626221040.GI21478@ftp.linux.org.uk> <20070626221134.GA21350@ftp.linux.org.uk> <20070627121021.GQ7590@daikokuya.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070627121021.GQ7590@daikokuya.co.uk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 27, 2007 at 09:10:21PM +0900, Neil Booth wrote:
> Al Viro wrote:-
> 
> > Hopefully correct handling of integer constant expressions.  Please, review.
> 
> Here are three independently invalid non-ICEs that sparse doesn't
> diagnose.
> 
> extern int f(void);
> enum { cast_to_ptr = (int) (void *) 0 };
> enum { cast_to_float = (int) (double) 1 };
> enum { fncall = 0 ? f(): 3 };
> 
> Hey, I did warn you it was tricky :)

Nope.  They are recognized as non-ICE (try with struct { int n :<expr>;};
for tester).  Again, no check for ICE in enums, and that one is for
a good reason - we might very well want non-integer enums as an extension
at some point.  We certainly need to check that they are constant, though.

If you want to test ICE recognition, right now only the following places
are checking for it:
	* bitfield width
	* __attribute__((aligned(<number>)))
	* __attribute__((address_space(<number>)))
	* [<index>] in designators within initializer list
	* [<index> ... <index>] - ditto, gccism

That's it.  We can use it elsewhere too, but that's a separate bunch of
patches (trivial to do now).
