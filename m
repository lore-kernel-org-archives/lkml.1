Return-Path: <linux-kernel-owner+w=401wt.eu-S1759351AbXKLQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351AbXKLQ7V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755305AbXKLQ7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 11:59:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:52613 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942AbXKLQ7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 11:59:07 -0500
Date: Mon, 12 Nov 2007 11:58:43 -0500
From: Jakub Jelinek <jakub@redhat.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [RFC: 2.6 patch] add -fno-tree-scev-cprop to KBUILD_CFLAGS
Message-ID: <20071112165843.GF5451@devserv.devel.redhat.com>
Reply-To: Jakub Jelinek <jakub@redhat.com>
References: <20071111064829.GG21669@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071111064829.GG21669@stusta.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 11, 2007 at 07:48:29AM +0100, Adrian Bunk wrote:
> The gcc from svn that will become gcc 4.3 generates libgcc calls in 
> cases like the following (on 32bit architectures):
> 
> <--  snip  -->
> 
> static inline void timespec_add_ns(struct timespec *a, u64 ns)
> {
> ...
>         while(ns >= NSEC_PER_SEC) {
>                 ns -= NSEC_PER_SEC;
>                 a->tv_sec++;
>         }
> ...
> 
> <--  snip  -->

Blindly using -fno-tree-scev-cprop just to get rid of one case where
this turns out to be a pessimization when kernel knows ns is usually very
small is IMHO a wrong thing, you'd lose many cases where this optimization
can actually improve performance.  Instead, for this exact case just
add an optimization barrier to avoid gcc doing this.
Adding asm ("" : "=r" (ns) : "0" (ns)); (or hide it in some macro) into the
loop will do the job just fine.

	Jakub
