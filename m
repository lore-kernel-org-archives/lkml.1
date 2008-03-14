Return-Path: <linux-kernel-owner+w=401wt.eu-S1757590AbYCNCoG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590AbYCNCoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 22:44:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753066AbYCNCnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 22:43:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752335AbYCNCny (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 22:43:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20080313152850.c76ab240.akpm@linux-foundation.org>
References: <20080313152850.c76ab240.akpm@linux-foundation.org> <20080313191432.28959.52722.stgit@warthog.procyon.org.uk> <20080313191442.28959.28152.stgit@warthog.procyon.org.uk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, kwc@citi.umich.edu,
       arunsr@cse.iitk.ac.in, dwalsh@redhat.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] KEYS: Make the keyring quotas controllable through /proc/sys
X-Mailer: MH-E 8.0.3+cvs; nmh 1.2-20070115cvs; GNU Emacs 23.0.50
Date: Fri, 14 Mar 2008 02:39:46 +0000
Message-ID: <4288.1205462386@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> >  #define key_serial(key) ((key) ? (key)->serial : 0)
> 
> err, why was that a macro?  It could have been implemented as an inline. 
> One which doesn't evaluate its argument twice (or once if it was -1).

Probably because the CONFIG_KEYS=n version of key_serial() has to be a macro
(so as to discard key without any attempt at evaluation).

However, that doesn't apply to the CONFIG_KEYS=y case, so I'll whip up a patch
to alter that for you.

> > +#ifdef CONFIG_SYSCTL
> > +extern ctl_table key_sysctls[];
> > +#endif
> 
> I've been going around telling people to not bother with the ifdefs here. 
> Upside: looks nicer.  Downside: defers the build error from compile-time to
> link-time.

Downside #2: the #ifdef is documentation of a sort.  Personally, I prefer the
extra #ifdef here as it makes it clearer to someone looking at the .h file why
their code doesn't compile/link rather than them having to know to go fishing
in Makefiles.

> open-coded knowledge of uid==0 might be problematic for containerisation. 
> Maybe it's on the containers team's radar, maybe it's actually not a
> problem, don't know.  (adds cc).

As I understand it, the same applies to any UID.  UID 0/root is typically
special, but I don't know how this is normally handled in alternate containers
for other kernel objects.  I can't just go and look at a capability on current
because the quota belongs to the user, not the process.

I have become aware in the last couple of days that the container people
missed or left out keys.  Possibly key IDs as well as key quotas should be
separated.

David
