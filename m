Return-Path: <linux-kernel-owner+w=401wt.eu-S1762621AbXGEVIp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762621AbXGEVIp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 17:08:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756805AbXGEVIh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 17:08:37 -0400
Received: from mail-gw3.sa.ew.hu ([212.108.200.82]:58806 "EHLO
	mail-gw3.sa.ew.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199AbXGEVIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 17:08:37 -0400
To: oliver@neukum.org
CC: miklos@szeredi.hu, pavel@ucw.cz, paulus@samba.org,
       stern@rowland.harvard.edu, johannes@sipsolutions.net, rjw@sisk.pl,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, benh@kernel.crashing.org
In-reply-to: <200707052249.45495.oliver@neukum.org> (message from Oliver
	Neukum on Thu, 5 Jul 2007 22:49:44 +0200)
Subject: Re: [linux-pm] Re: [PATCH] Remove process freezer from suspend to RAM pathway
References: <18059.10554.955290.148535@cargo.ozlabs.ibm.com> <200707052234.30021.oliver@neukum.org> <E1I6YDJ-0001sj-00@dorka.pomaz.szeredi.hu> <200707052249.45495.oliver@neukum.org>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1I6YXX-0001yE-00@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 05 Jul 2007 23:07:03 +0200
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > > Yes, fuse could handle being frozen there.  However that would only
> > > > solve part of the problem: an operation waiting for a reply could be
> > > > holding a VFS mutex and some other task may be blocked on that mutex.
> > > > 
> > > > How would you solve freezing those tasks?
> > > 
> > > OK, you made me reach for literatur on theoretical computer science.
> > > 
> > > IMHO the range of actions a fuse server is inherently limited.
> > > You must never ever block on a lock one of your clients is holding. In
> > > this case the limitation is not influenced by the freezer.
> > 
> > Obviously.  But I wasn't about the server trying to acquire a lock
> > held by a client.  I was talking about a client trying to acquire a
> > lock held by _another_ client.
> > 
> > If this coincides with the server (or some other task which the server
> > is depending on) being frozen before the clients, the freezer has a
> > problem.
> 
> True, but that case can only happen if servers are frozen before clients.
> You don't need a full dependency graph. A simple set sequence of two
> classes of tasks will do.

Umm, let's take sshfs, it has a separate "reply processing thread",
that reads replies from the sftp server and then wakes up the relevant
request thread.  The reply processing thread has no direct contact
with the fuse kernel module.  How is freezer supposed to know that
that task in fact also belongs to the server and needs to be kept from
freezing?

Given, it's in the same thread group, but using that is a rather weak
heuristic, as it could easily be a separate process, and likely in
some filesystems it is.

I fear, that your efforts to "save" the freezer are in vain.  It is
already moderately hackish with that PF_FREEZER_SKIP and the kernel
dotted randomly with try_to_freeze() calls, but adding bandaids to try
to order freezing userspace processes in the right order would just
make it a horrible mess.

Miklos
