Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbYLaRaR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbYLaRaR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 12:30:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbYLaRaA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 12:30:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38056 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752233AbYLaRaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 12:30:00 -0500
Date: Wed, 31 Dec 2008 09:29:36 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Helge Deller <deller@gmx.de>
cc: Rusty Russell <rusty@rustcorp.com.au>,
       linux-parisc <linux-parisc@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Kyle McMartin <kyle@mcmartin.ca>, Randolph Chung <randolph@tausq.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       John David Anglin <dave@hiauly1.hia.nrc.ca>
Subject: Re: [PATCH] parisc: fix module loading failure of large kernel
 modules (take 4)
In-Reply-To: <495B5806.3080505@gmx.de>
Message-ID: <alpine.LFD.2.00.0812310926450.5086@localhost.localdomain>
References: <4959346E.7060600@gmx.de> <200812310915.41693.rusty@rustcorp.com.au> <495B5806.3080505@gmx.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 31 Dec 2008, Helge Deller wrote:
>
> [PATCH 1/2] module.c: fix module loading failure of large kernel modules
> 
> When creating the final layout of a kernel module in memory, allow the
> module loader to reserve some additional memory in front of a given section.
> This is currently only needed for the parisc port which needs to put the
> stub entries there to fulfill the 17/22bit PCREL relocations with large
> kernel modules like xfs.
> 
> Differences of this patch to previous versions:
> - added weak funtion arch_module_section_size()

This doesn't work.

We've had this bug several times now, and one of them just very recently.

Some gcc versions will inline weak functions if they are in scope - even 
if there is a non-weak function somewhere else. So you MUST NOT have the 
weak definition in the same file (or indirectly called through some inline 
functions in a header file) as the call. Because if you do, then any user 
with the wrong version of gcc will get the weak function semantics, even 
if it was meant to be overridden by something else.

> +/* Additional bytes needed by arch in front of individual sections */
> +unsigned int __attribute__ ((weak)) arch_module_section_size(
> +		struct module *mod, unsigned int section)

We don't write out that whole "__attribute__" crud. We use

	unsigned in __weak arch_module_section_size(struct module *mod, unsigned int section)

instead. But as mentioned, it needs to be in another compilation unit.

		Linus
