Return-Path: <linux-kernel-owner+w=401wt.eu-S1758915AbYDBTow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915AbYDBTow (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 15:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755487AbYDBTop
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 15:44:45 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51865 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249AbYDBTop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 15:44:45 -0400
Date: Wed, 2 Apr 2008 12:44:05 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>
cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
In-Reply-To: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
Message-ID: <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 2 Apr 2008, Mikulas Patocka wrote:
> +	/*
> +	 * Make sure that the test for buffer_dirty(bh) is not reordered with
> +	 * previous modifications to the buffer data.
> +	 * -- mikulas
> +	 */
> +	smp_mb();
>  	WARN_ON_ONCE(!buffer_uptodate(bh));
>  	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))

At that point, the better patch is to just *remove* the buffer_dirty() 
test, and rely on the stronger ordering requirements of 
test_set_buffer_dirty().

The whole - and only - point of the buffer_dirty() check was to avoid the 
more expensive test_set_buffer_dirty() call, but it's only more expensive 
because of the barrier semantics. So if you add a barrier, the point goes 
away and you should instead remove the optimization.

(I also seriously doubt you can actually trigger this in real life, but 
simplifying the code is probably fine regardless).

		Linus
