Return-Path: <linux-kernel-owner+w=401wt.eu-S1755225AbYERTqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbYERTqu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 15:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYERTqk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 15:46:40 -0400
Received: from vena.lwn.net ([206.168.112.25]:53882 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751600AbYERTqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 15:46:39 -0400
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jonathan Corbet <corbet@lwn.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Thomas Gleixner <tglx@linutronix.de>,
       Alexander Viro <viro@ftp.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kill empty chardev open/release methods 
From: corbet@lwn.net (Jonathan Corbet)
In-reply-to: Your message of "Fri, 16 May 2008 21:55:17 BST."
             <20080516215517.30101a39@core> 
Date: Sun, 18 May 2008 13:46:39 -0600
Message-ID: <11727.1211139999@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> Actually it turns out you can introduce bugs doing this when the BKL is
> pushed down.
> 
> The problem is the methods are not NULL, they (with the lock pushed down
> are)
> 
> {
> 	lock_kernel();
> 	unlock_kernel();
> }
> 
> And we have drivers with setup code that does things in the wrong order
> but under the BKL. eg one I just fixed did
> 
> 	misc_register()
> 	init locks
> 	allocate memory
> 	do stuff
> 	return 0;

Hmph.

As it turns out, a misc driver will still be OK because the BKL has not
(yet) been pushed past misc_open().  What this does mean, though, is
that all of those empty and trivial open functions need to be
revisited.  I thought this looked too easy the first time through...

jon
