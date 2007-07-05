Return-Path: <linux-kernel-owner+w=401wt.eu-S1760640AbXGEJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760640AbXGEJfi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754827AbXGEJfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:35:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55883 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757981AbXGEJf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:35:29 -0400
Date: Thu, 5 Jul 2007 10:35:28 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: linux-sparse@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: [RFC] bloody mess with __attribute__() syntax
Message-ID: <20070705093528.GK21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

	We have a fun problem and for a change it's not sparse fault.
It's gcc folks' one.  Basically, __attribute__((...)) behaves in
an idiotic way and it's an intentional (and documented) behaviour.
In declaration of form
	T __attribute__((foo)) **v;
the attribute applies to v, not to **v.  IOW, in that position it
behaves (regardless of the nature of attribute) as storage class,
not as a qualifier.  Even if the same attribute can be used in
	T * __attribute__((foo)) *v;
where it will apply to *v.  Intended way to have it apply to **v is
	T (__attribute__((foo)) **v);

To put it mildly, that blows.  Note that qualifiers can *not* behave
that way - direct declarator can not expand to (<qualifier> <something>).
I.e. if you replace __attribute__((foo)) with qualifier in the
above, you'll get invalid syntax.

Now, that idiocy would be none of our concern, if not for the fact
that noderef and address_space() are definitely supposed to imitate
qualifiers.  If anybody seriously suggests switching to syntax
like
	int (__user *p);
all over the place, well...

Note that gcc rules for __attribute__() (and that's the only source
of rules we _have_ for the damn thing) clearly say that
	int __user *p;
is the same thing as
	int *__user p;

Now, we could declare gcc people responsible for that turd rejects
of Vogon Construction Fleet and handle the damn thing sanely.
The first part is clearly the right thing to do, but the second one...
Can't do without breaking gccisms using __attribute__.  E.g.
	int (__attribute__((mode(__pointer__))) *p);
is a gcc way to say "pointer to integer type equivalent to intptr_t" and
	int __attribute__((mode(__pointer__))) *p;
is exactly the same thing as
	int *p;
since the damn attribute applies to the entire type here (and is obviously
a no-op).

Frankly, I would rather add a new primitive (__qualifier__) mirroring the
__attribute__, but acting like real qualifiers do.  And switched the
noderef et.al. to it.  The only real alternative is to have __attribute__
behaviour dependent on its guts and that's not feasible - remember that
there can be more than one attribute in the list insider the damn thing.
Besides, it's bloody disgusting.

And yes, I realize that it's an incompatible change, i.e. not a step
to be taken lightly.  Better ways out of that mess are more than
welcome; I don't see any ;-/
