Return-Path: <linux-kernel-owner+w=401wt.eu-S1756736AbZEUWWB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736AbZEUWWB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 18:22:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755264AbZEUWVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 18:21:54 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33698 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755509AbZEUWVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 18:21:53 -0400
Date: Thu, 21 May 2009 23:22:49 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: How to tell whether a struct file is held by a process?
Message-ID: <20090521232249.0da2097c@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
References: <20090521095217.GU8633@ZenIV.linux.org.uk>
	<Pine.LNX.4.44L0.0905210945290.2886-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here's the story.  People have requested that the kernel add a
> mechanism whereby a user program can get more-or-less exclusive access
> rights to a USB device.  In fact, they'd like to reserve these rights

People ask for lots of things, often things they should be doing user
space, violate the laws of causality or are just dumb.

> In order to prevent programs from dying without releasing their
> exclusive rights, it seems natural to implement these rights as open
> files.  Thus, opening file A(P) will give a program exclusive access

Standard unix lock files have this property and its worked for many
things for many years.

> The problem is this.  Let D be the device plugged into port P.  When
> some program opens D's device file, it's necessary to check whether
> that same program has an open file reference for A(P), i.e., has opened
> A(P), or has inherited a descriptor for A(P) from its parent, or has
> been passed such a descriptor over a Unix socket, etc.  If not, and if 
> A(P) is open (owned by someone else), then access to D is denied.

Define "program" - is that one thread, many threads, a group of processes
involving child processes (often essential for user space device drivers
to get the security boundaries right) ? pid doesn't work for thread
groups or security divisisons, uid doesn't work for security.

There are two kernel models used that I can think of
	- lock file (pure user space policy)
	- O_EXCL - stop any other opens with -EBUSY

the latter plus file handle passing is quite sufficient to implement
pretty much any policy cleanly and to ensure that there are no
"inadvertent" accessors. It does mean the fd has to be passed about but
that is easy and the natural flow of apps doing that kind of work is to
inherit such handles.

> If you can think up a better way to implement these exclusive access 
> rights, I'd be glad to hear it.

User space - precisely because defining the access policy and what its
really meant by "program" in this case is so device and situation
dependant.

