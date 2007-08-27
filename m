Return-Path: <linux-kernel-owner+w=401wt.eu-S965134AbXH0Uw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134AbXH0Uw1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 16:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbXH0UwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 16:52:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36582 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758280AbXH0UwT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 16:52:19 -0400
Date: Mon, 27 Aug 2007 13:52:12 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fix bogus hotplug cpu warning
Message-Id: <20070827135212.6a5a847e.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0708272126050.29594@blonde.wat.veritas.com>
References: <Pine.LNX.4.64.0708271604440.21853@blonde.wat.veritas.com>
	<20070827111802.8d0a675b.akpm@linux-foundation.org>
	<Pine.LNX.4.64.0708272126050.29594@blonde.wat.veritas.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 21:37:14 +0100 (BST)
Hugh Dickins <hugh@veritas.com> wrote:

> > So I agree with the patch, but not with its description.
> 
> I don't see which part of the description you disagree with, but please
> do improve it if you can.

I'd change the description to


current_is_keventd() is a stupid load of crap.  It does

int current_is_keventd(void)
{
	struct cpu_workqueue_struct *cwq;
	int cpu = smp_processor_id();	/* preempt-safe: keventd is per-cpu */

but that comment (and the code itself) only make sense when
current_is_keventd() is called by keventd.  In which case thers is no point
in the function even existing!

We need to use raw_smp_processor_id() so that non-keventd (or, more
specifically, non-pinned-to-one-cpu) callers won't generate "using
smp_processor_id() in preemptible" warnings.

