Return-Path: <linux-kernel-owner+w=401wt.eu-S1759602AbZDOLng@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759602AbZDOLng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:43:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751307AbZDOLn1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:43:27 -0400
Received: from mx2.redhat.com ([66.187.237.31]:33496 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682AbZDOLn0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:43:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain>
References: <alpine.LFD.2.00.0904141103550.18124@localhost.localdomain> <alpine.LFD.2.00.0904140954160.18124@localhost.localdomain> <20090414161053.28145.1209.stgit@warthog.procyon.org.uk> <15312.1239731865@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dhowells@redhat.com, tj@kernel.org, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FRV: Fix the section attribute on UP DECLARE_PER_CPU()
Date: Wed, 15 Apr 2009 12:40:32 +0100
Message-ID: <14172.1239795632@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Linus Torvalds <torvalds@linux-foundation.org> wrote:

> But yeah, I didn't look at all the details. It _looked_ pretty
> straightforward to just move the DEFINE/DECLARE stuff up, but there may well
> be something subtle I'm missing.

The problem is mainly one of #include recursion.  There's way too much of it.

I wonder if we should replace the standard headerfile boilerplate:

	#ifndef _THIS_HEADER_H
	#define _THIS_HEADER_H
	...
	#endif /* _THIS_HEADER_H */

with something a bit nastier:

	#ifndef _THIS_HEADER_H
	#define _THIS_HEADER_H 1
	...
	#undef _THIS_HEADER_H
	#define _THIS_HEADER_H 2
	#elif  _THIS_HEADER_H == 1
	#error Recursive inclusion is not permitted
	#endif /* _THIS_HEADER_H */

and make people break up their header files to avoid getting this error.

There are a number of problems with doing this, of course; the least of which
is that cpp has special code for handling the first case efficiently, IIRC.

David
