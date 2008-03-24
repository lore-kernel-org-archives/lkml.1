Return-Path: <linux-kernel-owner+w=401wt.eu-S1758919AbYCXM1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758919AbYCXM1y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 08:27:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbYCXM1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 08:27:45 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:47822 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbYCXM1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 08:27:44 -0400
X-SBRS: 3.6
X-MesageID: 47219690
X-Ironport-Server: ftlpip02.citrite.net
X-Remote-IP: 216.142.71.134
X-Policy: $Relay
X-IronPort-AV: E=Sophos;i="4.25,546,1199682000"; 
   d="scan'208";a="47219690"
Date: Mon, 24 Mar 2008 12:27:00 +0000
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>, David Miller <davem@davemloft.net>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH,TRIVIAL] AF_UNIX, accept() and addrlen
Message-ID: <20080324122700.GK4434@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>,
	David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org
References: <20080308022321.GC5853@implementation> <20080323.215641.192753003.davem@davemloft.net> <20080324104330.GF4434@implementation.uk.xensource.com> <87abko734d.fsf@basil.nowhere.org> <20080324121719.GJ4434@implementation.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080324121719.GJ4434@implementation.uk.xensource.com>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault, le Mon 24 Mar 2008 12:17:19 +0000, a écrit :
> Andi Kleen, le Mon 24 Mar 2008 12:50:10 +0100, a écrit :
> > Samuel Thibault <samuel.thibault@ens-lyon.org> writes:
> > > David Miller, le Sun 23 Mar 2008 21:56:41 -0700, a écrit :
> > > > From: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > > > Date: Sat, 8 Mar 2008 02:23:21 +0000
> > > > 
> > > > > Accept and getpeername are supposed to return the amount of bytes
> > > > > written in the returned address.  However, on unnamed sockets, only
> > > > > sizeof(short) is returned, while a 0 is put in the sun_path member.
> > > > > This patch adds 1 for that additional byte.
> > > > > 
> > > > > Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>
> > > > 
> > > > This change isn't correct.  It's the fact that the
> > > > length returned is sizeof(short) that tells the caller
> > > > that the unix socket is unnamed.
> > > 
> > > Mmm, where that is documented?
> > > 
> > > I can't find any details about that in SUS, and man 7 unix says
> > > 
> > > `If sun_path starts with a null byte ('' '), then it refers to the
> > > abstract namespace main- tained by the Unix protocol module.'
> > 
> > [I wrote unix(7) originally]. The abstract name space is a Linux
> > extension and there is no written standard and whatever the kernel
> > implements is the de-facto standard. If unix(7) differs in anything
> > from what the code does please send patches to the manpages
> > maintainer.
> 
> Oops, sorry, we are not talking about abstract namespace actually (their
> sockaddr length are necessarily bigger than sizeof(sa_family_t) since
> they need some data), but unamed sockets.  So the Address Format
> paragraph just misses description of unnamed sockets.

How about this?

--- unix.7.orig	2008-03-24 12:24:37.000000000 +0000
+++ unix.7	2008-03-24 12:24:56.000000000 +0000
@@ -87,6 +87,15 @@
 bytes in
 .IR sun_path .
 Note that names in the abstract namespace are not zero-terminated.
+If the size returned by
+.BR accept
+or
+.BR getpeername
+is
+.IR sizeof(sa_family_t) ,
+then it refers to a unnamed socket and
+.I sun_path
+should not be read.
 .SS Socket Options
 For historical reasons these socket options are specified with a
 .B SOL_SOCKET

Samuel
