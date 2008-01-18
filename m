Return-Path: <linux-kernel-owner+w=401wt.eu-S1763601AbYARRYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763601AbYARRYl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 12:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759989AbYARRYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 12:24:34 -0500
Received: from dspnet.fr.eu.org ([213.186.44.138]:1100 "EHLO dspnet.fr.eu.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759553AbYARRYd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 12:24:33 -0500
Date: Fri, 18 Jan 2008 18:24:29 +0100
From: Olivier Galibert <galibert@pobox.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Why is the kfree() argument const?
Message-ID: <20080118172428.GB61848@dspnet.fr.eu.org>
Mail-Followup-To: Olivier Galibert <galibert@pobox.com>,
	linux-kernel@vger.kernel.org
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com> <alpine.LFD.1.00.0801171710160.2957@woody.linux-foundation.org> <47905A95.4030500@cateee.net> <47906133.6010301@cateee.net> <4790AF68.8040403@myrealbox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4790AF68.8040403@myrealbox.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2008 at 08:53:44AM -0500, Andy Lutomirski wrote:
> I'd say this implies the exact opposite.  It almost sounds like the 
> compiler is free to change:
> 
> void foo(const int *x);
> foo(x);
> printf("%d", x);
> 
> to:
> 
> void foo(const int *x);
> printf("%d", x);
> foo(x);

That's only if neither function has side effects noticeable by the
other.  Invalidating the pointer in (k)free is rather noticeable.


> (Note that this isn't just a problem for optimizers -- a programmer 
> might expect that passing a pointer to a function that takes a const 
> pointer argument does not, in and of itself, change the pointed-to 
> value.  Given that const certainly does not mean that no one else 
> changes the object, I'm not sure what else it could mean.

Most of the time, const pointer arguments means "I won't change the
contents of the object so that you'll notice by reading it in a normal
way afterwards".  That's pretty much what mutable in a variety of
languages (including C++) is about, saying "this field is internal
management stuff not visible from the external interface, so I need to
be able to change it even through const pointers I got as parameters".
Reference counters for copy-on-write setups is the usual example of
use.

In the case of deallocation functions you are not allowed to do
anything through the pointer or its aliases after the function
returns.  So we're outside of the "most of the time" case, since
you're not allowed to try to notice any change.  Pragmatism takes
over, you want the type that catches as many possible types as
possible while staying reasonable (volatile is never reasonable), and
that's const void *.  As simple as that.

As for releasing resources through const pointers, that happens all
the time as soon as your const use is tight, and if you think forcing
the systematic addition of a (void *) cast is going to make your code
more readable, well, you need more experience in maintaining other
people's applications.


> kfree does not have either property, so I'm don't think it makes
> sense for it to take a const argument.

delete in C++ allows const pointers. Think about it.

  OG.
