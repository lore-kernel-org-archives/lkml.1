Return-Path: <linux-kernel-owner+w=401wt.eu-S1761169AbYGaA61@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761169AbYGaA61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:58:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754214AbYGaA6Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:58:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59802 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752759AbYGaA6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:58:15 -0400
Date: Wed, 30 Jul 2008 17:54:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <alpine.LFD.1.10.0807301746500.3277@nehalem.linux-foundation.org>
Message-ID: <alpine.LFD.1.10.0807301751320.3277@nehalem.linux-foundation.org>
References: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <20080731001131.GA30900@shareable.org> <20080731004214.GA32207@shareable.org> <alpine.LFD.1.10.0807301746500.3277@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 30 Jul 2008, Linus Torvalds wrote:
> 
> Personally, I think the right approach is to just realize that splice() is 
> _not_ a write() system call, and never will be. If you need synchronous 
> writing, you simply shouldn't use splice().

Side note: in-kernel users could probably do somethign about this. IOW, if 
there's some in-kernel usage (and yes, knfsd would be a prime example), 
that one may actually be able to do things that a _user_level user of 
splice() could never do.

That includes things like getting the inode semaphore over a write (so 
that you can guarantee that pages that are in flight are not modified, 
except again possibly by other mmap users), and/or a per-page callback for 
when splice() is done with a page (so that you could keep the page locked 
while it's getting spliced, for example).

And no, we don't actually have that either, of course.

			Linus
