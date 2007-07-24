Return-Path: <linux-kernel-owner+w=401wt.eu-S1757115AbXGXJo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757115AbXGXJo6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 05:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760165AbXGXJos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 05:44:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53833 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760038AbXGXJor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 05:44:47 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in>
References: <Pine.LNX.4.64.0707241154060.1433@cselinux1.cse.iitk.ac.in> <20070723160528.22137.84144.sendpatchset@cselinux1.cse.iitk.ac.in> <20070723160558.22137.71943.sendpatchset@cselinux1.cse.iitk.ac.in> <46A578A1.5010504@yahoo.com.au>
To: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 6/8] i386: bitops: Don't mark memory as clobbered unnecessarily
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Tue, 24 Jul 2007 10:44:34 +0100
Message-ID: <19305.1185270274@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Satyam Sharma <ssatyam@cse.iitk.ac.in> wrote:

> OTOH, as per Linus' review it seems we can drop the "memory" clobber
> and specify the output operand for the extended asm as "+m". But I
> must admit I didn't quite understand that at all.

As I understand it, the "+m" indicates to the compiler a restriction on the
ordering of things that access that particular memory location, whereas a
"memory" indicates a restriction on the orderings of all accesses to memory -
precisely what you need to produce a lock.

There are a number of things that use test_and_set_bit() and co to implement a
lock or other synchronisation.  This means that they must exhibit LOCK-class
barrier effects or better.  LOCK-class barrier effects mean, more or less,
that all memory accesses issued before the lock must happen before all memory
accesses issued after the lock.  But it most happen at both CPU-level and
compiler-level.  The "memory" constraint instructs the compiler in this
regard.

Remember also that this is gcc black magic and so some of it has had to be
worked out empirically - possibly after sacrificing a goat under a full moon.

David
