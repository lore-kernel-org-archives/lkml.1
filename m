Return-Path: <linux-kernel-owner+w=401wt.eu-S1756074AbYGCV2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756074AbYGCV2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 17:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYGCV2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 17:28:07 -0400
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:25638 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753353AbYGCV2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 17:28:06 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=louVL3mOpL6fJcQrIItYSK9xqfb1oovSJ/RfjIQesrb8FL+Ic4AJbp+W164RRbw/Fq1N9dUVEZiqrJ0KsuiEPUavuX4SR8g1u1n3U/uawnY8b5Zc7W0u8wUWyULhy6sK7z+FcAXYOwuWRzaVHvWo+4zA2qUPoYBB8WXKw0LLS/g=  ;
X-YMail-OSG: 3HsXoYwVM1kIVokCgVvif1s5WALfhk1yRtOFYULecb5d8xdwk4aAPGcN5JxtnVWEaTWmk0fBpaxozWjiuWUHUedsGDj9RAA8UhJOQ_C31VuZu2ArS.Vj7C6BWd7VwM4MgyA-
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] gpiolib: Allow user-selection
Date: Thu, 3 Jul 2008 14:28:00 -0700
User-Agent: KMail/1.9.9
Cc: Andrew Morton <akpm@linux-foundation.org>, Michael Buesch <mb@bu3sch.de>,
       sfr@canb.auug.org.au, linux-kernel@vger.kernel.org
References: <200807022346.53222.mb@bu3sch.de> <200807022241.28046.david-b@pacbell.net> <20080703193755.GC14194@kroah.com>
In-Reply-To: <20080703193755.GC14194@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807031428.00765.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 03 July 2008, Greg KH wrote:
> On Wed, Jul 02, 2008 at 10:41:27PM -0700, David Brownell wrote:
> > The new "-next" process is still working out.  Backwards-incompatible
> > changes will *always* make problems.  In this case there seem to
> > have been three such changes:
> > 
> > 	- device_create() vanishing, even for users which did the
> > 	  locking correctly ... this was at least something of a
> > 	  graceful migration, although it would have been better
> > 	  if it were deprecated first.  Change can work against
> > 	  the current (2.6.26) code base.
> 
> device_create() did disappear in -next, but when it goes to Linus it
> will not, it will come back as a #define and everything will be
> converted back.  That was to catch the build errors when I audited the
> whole tree.  The -rc1 merge cycle will handle this properly.

Hmm, that's a surprise.  Any reason that's not in "-next" already?


> > 	- class.devices vanishing ... what I really needed was
> > 	  more of a "is this class initialized yet" call, so
> > 	  testing for class->devices.next non-null can be replaced
> > 	  by a test for class->p non-null.  (Or maybe this should
> > 	  be viewed as needing a "real" driver model call, so that
> > 	  code which must run before driver model init can more
> > 	  easily cooperate with driver model stuff that has to
> > 	  run much later, after the guts are initialized.)
> 
> If you need such a function, please let me know and I can provide it, I
> was not aware of anyone using class.devices, it is an
> internal-to-the-driver-core field, and has moved private.

When the fields are there, it's hard to say what's "internal"
in the absense of comments ... :)

The scenario is that gpios sometimes get initialized very early,
as part of board setup before kmalloc or irqs work, so when they
get registered sometimes there's work left over for later.  All
that's needed is a predicate to test whether that class can be
used as a parameter to stuff like device_create_drvdata() and
sysfs_create_group().


> > 	- Extra parameter to class_find_device().  This could
> > 	  have been done in a backwards-compatible manner, like
> > 	  device_create() was, but ... it wasn't.
> 
> This was simpler as there were less users of this function.  And the
> whole tree was fixed up.  If there are trees on top of -next that I
> can't see, that's pretty hard for me to fix :)

This was in the MM tree with other GPIO patches.

- Dave

