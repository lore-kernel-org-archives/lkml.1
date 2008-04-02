Return-Path: <linux-kernel-owner+w=401wt.eu-S932765AbYDBWDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932765AbYDBWDX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 18:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755249AbYDBWDJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 18:03:09 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59845 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932676AbYDBWDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 18:03:05 -0400
Date: Wed, 2 Apr 2008 15:01:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: mikulas@artax.karlin.mff.cuni.cz, viro@zeniv.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Fix SMP-reordering race in mark_buffer_dirty
Message-Id: <20080402150158.f366370f.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
References: <Pine.LNX.4.64.0804022058530.13737@artax.karlin.mff.cuni.cz>
	<alpine.LFD.1.00.0804021237031.14670@woody.linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008 12:44:05 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Wed, 2 Apr 2008, Mikulas Patocka wrote:
> > +	/*
> > +	 * Make sure that the test for buffer_dirty(bh) is not reordered with
> > +	 * previous modifications to the buffer data.
> > +	 * -- mikulas
> > +	 */
> > +	smp_mb();
> >  	WARN_ON_ONCE(!buffer_uptodate(bh));
> >  	if (!buffer_dirty(bh) && !test_set_buffer_dirty(bh))
> 
> At that point, the better patch is to just *remove* the buffer_dirty() 
> test, and rely on the stronger ordering requirements of 
> test_set_buffer_dirty().
> 
> The whole - and only - point of the buffer_dirty() check was to avoid the 
> more expensive test_set_buffer_dirty() call, but it's only more expensive 
> because of the barrier semantics. So if you add a barrier, the point goes 
> away and you should instead remove the optimization.

But then the test-and-set of an already-set flag would newly cause the
cacheline to be dirtied, requiring additional bus usage to write it back?

The CPU's test-and-set-bit operation could of course optimise that away in
this case.  But does it?


