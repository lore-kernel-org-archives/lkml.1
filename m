Return-Path: <linux-kernel-owner+w=401wt.eu-S1760205AbXGETf4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760205AbXGETf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 15:35:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751556AbXGETfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 15:35:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:58634 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbXGETfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 15:35:47 -0400
Subject: Re: [RFC] bloody mess with __attribute__() syntax
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Josh Triplett <josh@freedesktop.org>, linux-sparse@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070705191358.GQ21478@ftp.linux.org.uk>
References: <20070705093528.GK21478@ftp.linux.org.uk>
	 <468D1003.1050901@freedesktop.org>
	 <20070705164334.GM21478@ftp.linux.org.uk>
	 <1183661456.2604.43.camel@josh-work.beaverton.ibm.com>
	 <20070705191358.GQ21478@ftp.linux.org.uk>
Content-Type: text/plain
Date: Thu, 05 Jul 2007 12:35:53 -0700
Message-Id: <1183664153.2604.63.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 20:13 +0100, Al Viro wrote:
> On Thu, Jul 05, 2007 at 11:50:56AM -0700, Josh Triplett wrote:
> > On Thu, 2007-07-05 at 17:43 +0100, Al Viro wrote:
> > > On Thu, Jul 05, 2007 at 08:36:35AM -0700, Josh Triplett wrote:
> > > > Wow.  Insane.  So these all declare the same type:
> > > > __attribute__((foo)) T *v;
> > > > T __attribute__((foo)) *v;
> > > > T *__attribute__((foo)) v;
> > > > ?  Specifically, they point to a foo-T, for convenient shooting?
> > > 
> > > They all give you foo-pointer-to-T.  
> > > 	T (__attribute__((foo)) *v);
> > > would give pointer-to-foo-T.
> > 
> > Doesn't that do exactly what we want, then?  If we say
> > T __attribute__((noderef)) *v;
> > , we want a noderef-pointer-to-T, not a pointer-to-noderef-T.  noderef
> > should modify a pointer.
> 
> No.  int __user *v is pointer to noderef,address_space(1) int.  Same
> as int const *v is pointer to const int.  Noderef is a property of
> object being pointed to, _not_ the pointer itself.

OK, that seems inconsistent with what you said before.  You said that 
T __attribute__((foo)) *v;
gives you a foo-pointer-to-T.  So shouldn't
int __attribute__((noderef)) *v;
give you a noderef-pointer-to-int?

> And yes, I know that we store it ->modifiers of SYM_PTR - that saves us
> a SYM_NODE we'd have to insert otherwise.  Same as with the rest of
> qualifiers.
> 
> The same goes for address_space.  The same goes for const and volatile.
> 
> If you have struct foo {int x;}; struct foo __user *p; then &p->x will
> be &((*p).x), i.e. &(<__user struct foo>.x), i.e. &(<__user int>), i.e.
> int __user *.  __user is not a property of pointer; it couldn't work if
> it would be.

OK, that makes sense; address_space describes the actual storage of the
thing pointed to, not the pointer.  It *could* describe the pointer, if
you had a pointer that resided in user address space, but that occurs
less often, and would use a different syntax.

However, noderef seems like a property of a pointer, hence why I
proposed the example I did.  A warning should occur when you do
*(<noderef T *>v) to get a T, not when you do *(<* noderef T>v) to get a
noderef T.

- Josh Triplett


