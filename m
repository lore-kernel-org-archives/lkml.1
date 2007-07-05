Return-Path: <linux-kernel-owner+w=401wt.eu-S1762792AbXGEU47@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762792AbXGEU47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 16:56:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761064AbXGEU4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 16:56:50 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37066 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760661AbXGEU4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 16:56:49 -0400
Date: Thu, 5 Jul 2007 13:56:35 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@ftp.linux.org.uk>
cc: Josh Triplett <josht@linux.vnet.ibm.com>,
       Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
In-Reply-To: <20070705200839.GR21478@ftp.linux.org.uk>
Message-ID: <alpine.LFD.0.98.0707051341290.9434@woody.linux-foundation.org>
References: <20070705093528.GK21478@ftp.linux.org.uk> <468D1003.1050901@freedesktop.org>
 <20070705164334.GM21478@ftp.linux.org.uk> <1183661456.2604.43.camel@josh-work.beaverton.ibm.com>
 <20070705191358.GQ21478@ftp.linux.org.uk> <1183664153.2604.63.camel@josh-work.beaverton.ibm.com>
 <20070705200839.GR21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 5 Jul 2007, Al Viro wrote:
> 
> Nope.  __noderef is a property of object being pointed to.  Again,
> consider &p->x.  It should not be int *.  And it should not be
> an error.  We want it to be int __noderef *.

A more interesting example to some degree is what happens to

	&*p

when p is a pointer to noderef.

The end result should be a pointer to noderef again, and it should be 
legal to do (ie we didn't actually _really_ derefence it).

It's interesting for a couple of reasons, specifically it shows how sparse 
ends up carrying around the "node" information in two _different_ places: 
either in the SYM_NODE (or SYM_ARRAY) that actually "is" the object, _or_ 
in the SYM_PTR thing that describes a pointer to the object.

So this behaviour can be directly seen in the sparse type logic when we 
convert to/from a pointer:

 - it shows how the "pointerness" is secondary, even if we actually 
   do end up putting some object flags in the SYM_PTR node.

   So the "*" needs to move the noderef from the SYM_PTR node into the 
   resulting SYM_NODE node. This is what "MOD_PTRINHERIT" is all about 
   (see its use in "create_pointer": it peels off the SYM_NODE'ness, but 
   inserts the node modifiers into the SYM_PTR).

 - the address-of operator does the reverse, and we merge the information 
   from the pointer into the resulting node (everything but the storage 
   modifiers, to be exact, see "merge_type()").

So I think Josh may be confused by the fact that the SYM_PTR node actually 
contains information about the thing the pointer _points_ to, and then the 
SYM_NODE for the pointer object actually contains information about the 
pointer itself!

So some of the flags about the object are really in the SYM_PTR node, but 
despite that, they are really about the *object*, not about the pointer, 
and that shows most clearly exactly when converting an object to a pointer 
("&" - evaluate_addressof() and crreate_pointer()) and when dereferencing 
a pointer to an object ("*" - evaluate_dereference() and merge_type())

Is it slightly complex? Yes. It's a bit strange that the SYM_PTR doesn't 
contain the information about the *pointer*, and the real information 
about an object is actually "one removed" from the type infromation, but 
it's a rather direct result of how sparse parses and maintains the type 
information.

Maybe it could have been done differently. I dunno. But it does end up 
being how the C types parse most naturally, I think.

			Linus
