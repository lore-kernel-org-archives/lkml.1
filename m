Return-Path: <linux-kernel-owner+w=401wt.eu-S938415AbXFHItp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938415AbXFHItp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 04:49:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937320AbXFHIti
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 04:49:38 -0400
Received: from vpn.merrillpress.com ([64.61.107.78]:57057 "EHLO
	vpn.merrillpress.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933799AbXFHIth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 04:49:37 -0400
X-Greylist: delayed 3744 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Jun 2007 04:49:37 EDT
Message-ID: <45111.76.180.38.217.1181288832.squirrel@vpn.merrillpress.com>
Date: Fri, 8 Jun 2007 03:47:12 -0400 (EDT)
Subject: O_CLOEXEC: An alternate proposal
From: "Daniel Colascione" <danc@merrillpress.com>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.8-4.0.1.el4.centos
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hey, this is my first post to linux-kernel, so please be kind. :-)

Linus Torvalds wrote on May 31:
> I'm with Uli on this one. "Stateful" stuff is bad. It's essentially
> impossible to handle with libraries - either the library would have to
> explciitly always turn the state the way _it_ needs it, or the library
> will do the wrogn thing.

I agree that stateful stuff is generally not very elegant,
but I think it's a win here -- we wouldn't have to create any
new APIs except for the state-setting stuff.

The state just has to be thread-local.

If it's thread-local, a library, say, glibc,
can use code like this:

  /* Internal library function */
  old_fd_flags = kernel_default_fd_flags(FD_CLOEXEC | FD_RANDFD);
  event_fd = super_duper_event_polling_mechanism_fd();
  kernel_default_fd_flags(old_fd_flags);

I think that's a lot cleaner than augmenting every
present and future fd-creating syscall to take some kind
of flags parameter and adding some kind of funny dup().

Other threads, and the caller of this function in the same thread,
aren't even aware that the library is changing any state. It's
race-free, since the default flags wouldn't be inherited across clone()
or exec(). It's still POSIX compliant too as long as the default
flags set remains empty.

The only disadvantage I can think of is that it requires three
system calls instead of one, but most of your time is going to be spent
working with event_fd, not creating it.

Also, what about an FD_CLOFORK as well? That seems to match
more closely what you'd want out of a library-internal FD than
FD_CLOEXEC.

