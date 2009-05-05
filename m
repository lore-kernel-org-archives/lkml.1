Return-Path: <linux-kernel-owner+w=401wt.eu-S1756235AbZEEGPv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235AbZEEGPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 02:15:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbZEEGPl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 02:15:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59302 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384AbZEEGPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 02:15:40 -0400
Date: Mon, 4 May 2009 23:11:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oliver Neukum <oliver@neukum.org>
Cc: David Brownell <david-b@pacbell.net>, Li Hong <lihong.hi@gmail.com>,
       linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb: use memdup_user()
Message-Id: <20090504231157.1ff2cf15.akpm@linux-foundation.org>
In-Reply-To: <200905041601.51789.oliver@neukum.org>
References: <3a3680030905030900x672af596mc2ebc3c38f119c92@mail.gmail.com>
	<200905040854.03329.oliver@neukum.org>
	<200905040002.38304.david-b@pacbell.net>
	<200905041601.51789.oliver@neukum.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 May 2009 16:01:51 +0200 Oliver Neukum <oliver@neukum.org> wrote:

> Am Montag, 4. Mai 2009 09:02:38 schrieb David Brownell:
> > On Sunday 03 May 2009, Oliver Neukum wrote:
> > > No. To make it plain. To me any use of memdup_user() in USB code
> > > is a bad idea. I don't want to have to think about a new primitive.
> >
> > Unless it's incorrect to use that, I have to say that it
> > makes more sense to use that utility than recreate it by
> > open-coding...
> 
> I want people to be forced to think about memory allocations.
> We had endless trouble during 2.4 with storage deadlocking.
> We simply need full control of this.
> 

thou-shalt-use-GFP_NOFS is a very common pattern in many filesystems. 
And thou-shalt-use-GFP_NOIO is a very common pattern in block drivers.

I wonder how hard it would be to add runtime debugging checks?  If
there are clearly identified transition points where (say) GFP_NOIO
becomes required and unrequired then we could do something along the
lines of

	current->disallowed_gfp_flags |= __GFP_IO;
	....
	current->disallowed_gfp_flags &= ~__GFP_IO;

and check (gfp_flags & current->disallowed_gfp_flags) in the various
memory-allocation functions, and perhaps in the uaccess functions.

Or possibly teach lockdep about it, although that seems inappropriate.

Anyway.  A little project for someone, perhaps.
