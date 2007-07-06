Return-Path: <linux-kernel-owner+w=401wt.eu-S1762056AbXGFD0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762056AbXGFD0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 23:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760661AbXGFD0L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 23:26:11 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48129 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760929AbXGFD0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 23:26:09 -0400
Date: Fri, 6 Jul 2007 04:26:04 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Josh Triplett <josht@linux.vnet.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070706032604.GU21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk> <468D1003.1050901@freedesktop.org> <20070705164334.GM21478@ftp.linux.org.uk> <1183661456.2604.43.camel@josh-work.beaverton.ibm.com> <20070705191358.GQ21478@ftp.linux.org.uk> <1183664153.2604.63.camel@josh-work.beaverton.ibm.com> <20070705200839.GR21478@ftp.linux.org.uk> <alpine.LFD.0.98.0707051341290.9434@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.98.0707051341290.9434@woody.linux-foundation.org>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 01:56:35PM -0700, Linus Torvalds wrote:

> Is it slightly complex? Yes. It's a bit strange that the SYM_PTR doesn't 
> contain the information about the *pointer*, and the real information 
> about an object is actually "one removed" from the type infromation, but 
> it's a rather direct result of how sparse parses and maintains the type 
> information.

Not only that, but it's a fairly natural if you look at that as
lazy expression in type space...  Fortunately, we do have referential
transparency there, unlike e.g. in expression graphs handling.

BTW, one really ugly thing about __attribute__((mode(...))) is that
int *A;
int B;
typeof (A) __attribute__((mode(__pointer__))) p;
typeof (B) __attribute__((mode(__pointer__))) q;

gives int *p and intptr_t q resp.  IOW, we can't eliminate the damn thing
in parser unless we are willing to deal with typeof() in there, and I'd
rather not.

It really looks like we have to delay at least some of those suckers
until examine_... time.  IOW, new kind of SYM_... nodes.

FWIW, I'm going to kill off direct messing with symbol->type et.al.
in evaluate.c and trim that stuff down to few primitives provided
by symbol.c; classify_type() is one such thing, but it really ought
to be lazy - i.e. do not assume that type is already examined,
do just enough type expression evaluation to get the derivation
type and be done with that; we probably want to get more degrees
of ->examined.  Plus "find all qualifiers", "find all qualifiers of
pointed-to", type-related part of degenerate(), type_difference()
(after lifting !Wtypesign stuff into compatible_assignment_types())
and "calculate compatible type".  All lazy...  We probably want
to go for more grades of ->examined, while we are at it.

After that we'll have much more straightforward logics in evaluate.c
and free hands for fixing the handling of attributes, etc.

Eventually I'd like to kill off MOD_CHAR/MOD_SHORT/MOD_LONG/MOD_LONGLONG
as ->modifiers bits and separate the use of struct ctype for declaration
parser state from that in struct symbol; we *are* tight on bits
there, we have a bunch of MOD_... that make sense only in parser
state (MOD_BITWISE is the same kind of thing, BTW) and parser context
might need to grow, which is obviously not nice for struct symbol.
Very few places really care about MOD_SPECIFIER outside of parser and
they could be dealt with in saner way...

BTW, what the hell is struct symbol ->value and what's SYM_MEMBER is
supposed to be used for?  AFAICS, nothing ever sets them these days
and SYM_MEMBER appears to have never been used in the entire history
of sparse...

I'm documenting the existing type system (i.e. uses of struct symbol,
etc.); I think I've got most of the picture by now, will post when
it's done.
