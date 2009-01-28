Return-Path: <linux-kernel-owner+w=401wt.eu-S1753524AbZA1Fav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753524AbZA1Fav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 00:30:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750995AbZA1Fam
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 00:30:42 -0500
Received: from x35.xmailserver.org ([64.71.152.41]:60242 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbZA1Fam (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 00:30:42 -0500
X-AuthUser: davidel@xmailserver.org
Date: Tue, 27 Jan 2009 21:30:39 -0800 (PST)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Bron Gondwana <brong@fastmail.fm>
cc: Ray Lee <ray-lk@madrabbit.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/3] epoll: increase default max_user_instances to 1024
In-Reply-To: <20090128045534.GA7571@brong.net>
Message-ID: <alpine.DEB.1.10.0901272125370.20262@alien.or.mcafeemobile.com>
References: <20090128033824.GA1662@brong.net> <59410684d947bc68862a4f5d6c2a5bb1f29519ee.1233114169.git.brong@fastmail.fm> <alpine.DEB.1.10.0901271949070.20262@alien.or.mcafeemobile.com> <2c0942db0901272007w4298738cq37918f776276d424@mail.gmail.com>
 <alpine.DEB.1.10.0901272010470.20262@alien.or.mcafeemobile.com> <20090128045534.GA7571@brong.net>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jan 2009, Bron Gondwana wrote:

> On Tue, Jan 27, 2009 at 08:14:36PM -0800, Davide Libenzi wrote:
> > On Tue, 27 Jan 2009, Ray Lee wrote:
> > > Userspace is not broken here, and the whole idea of a -stable series
> > > is that administrators can upgrade to them without having to worry
> > > about things getting broken or making specific configuration changes
> > > by point release.
> > 
> > The reason Greg took it, was that in a multiuser systems, that's a DoS 
> > EZ-PZ Lemon Squeezie.
> 
> Ok - we're at an impasse here.
> 
> You know the code a whole lot better than me.
> 
> Is there anything you can think of that will allow us to block the DOS
> without breaking every medium to heavily loaded postfix and apache site
> out there.
> 
> Somthing that doesn't require the administrators of every single
> machine in one or the other class to tune their configurations?

Making the initial value of max_instances dependent on the amount of 
memory we can tollerate a user to exploit with the trick showed before.
Allowing up to 1% of lower memory, should roughly result in:

512MB -> ~225
1GB   -> ~310
2GB   -> ~440

We could ssume that heavily loaded mail and web servers to have an amount 
of RAM sufficent to get an high-enough default max_instances.




- Davide


---
 fs/eventpoll.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-2.6.mod/fs/eventpoll.c
===================================================================
--- linux-2.6.mod.orig/fs/eventpoll.c	2009-01-27 21:12:29.000000000 -0800
+++ linux-2.6.mod/fs/eventpoll.c	2009-01-27 21:19:06.000000000 -0800
@@ -1419,7 +1419,9 @@
 	struct sysinfo si;
 
 	si_meminfo(&si);
-	max_user_instances = 128;
+	max_user_instances =
+		int_sqrt((((si.totalram - si.totalhigh) / 100) << PAGE_SHIFT) /
+			 EP_ITEM_COST);
 	max_user_watches = (((si.totalram - si.totalhigh) / 32) << PAGE_SHIFT) /
 		EP_ITEM_COST;
 
