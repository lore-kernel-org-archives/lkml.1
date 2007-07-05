Return-Path: <linux-kernel-owner+w=401wt.eu-S1761947AbXGETOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947AbXGETOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760895AbXGETOE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:14:04 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41953 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760676AbXGETOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:14:01 -0400
Date: Thu, 5 Jul 2007 20:13:59 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Josh Triplett <josht@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705191358.GQ21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk> <468D1003.1050901@freedesktop.org> <20070705164334.GM21478@ftp.linux.org.uk> <1183661456.2604.43.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1183661456.2604.43.camel@josh-work.beaverton.ibm.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2007 at 11:50:56AM -0700, Josh Triplett wrote:
> On Thu, 2007-07-05 at 17:43 +0100, Al Viro wrote:
> > On Thu, Jul 05, 2007 at 08:36:35AM -0700, Josh Triplett wrote:
> > > Wow.  Insane.  So these all declare the same type:
> > > __attribute__((foo)) T *v;
> > > T __attribute__((foo)) *v;
> > > T *__attribute__((foo)) v;
> > > ?  Specifically, they point to a foo-T, for convenient shooting?
> > 
> > They all give you foo-pointer-to-T.  
> > 	T (__attribute__((foo)) *v);
> > would give pointer-to-foo-T.
> 
> Doesn't that do exactly what we want, then?  If we say
> T __attribute__((noderef)) *v;
> , we want a noderef-pointer-to-T, not a pointer-to-noderef-T.  noderef
> should modify a pointer.

No.  int __user *v is pointer to noderef,address_space(1) int.  Same
as int const *v is pointer to const int.  Noderef is a property of
object being pointed to, _not_ the pointer itself.

And yes, I know that we store it ->modifiers of SYM_PTR - that saves us
a SYM_NODE we'd have to insert otherwise.  Same as with the rest of
qualifiers.

The same goes for address_space.  The same goes for const and volatile.

If you have struct foo {int x;}; struct foo __user *p; then &p->x will
be &((*p).x), i.e. &(<__user struct foo>.x), i.e. &(<__user int>), i.e.
int __user *.  __user is not a property of pointer; it couldn't work if
it would be.
