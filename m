Return-Path: <linux-kernel-owner+w=401wt.eu-S1759383AbYGaAzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759383AbYGaAzb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:55:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbYGaAzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:55:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55513 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753439AbYGaAzN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:55:13 -0400
Date: Wed, 30 Jul 2008 17:51:15 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jamie Lokier <jamie@shareable.org>
cc: Miklos Szeredi <miklos@szeredi.hu>, jens.axboe@oracle.com,
       akpm@linux-foundation.org, nickpiggin@yahoo.com.au,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [patch v3] splice: fix race with page invalidation
In-Reply-To: <20080731004214.GA32207@shareable.org>
Message-ID: <alpine.LFD.1.10.0807301746500.3277@nehalem.linux-foundation.org>
References: <E1KOIYA-0002FG-Rg@pomaz-ex.szeredi.hu> <20080731001131.GA30900@shareable.org> <20080731004214.GA32207@shareable.org>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 31 Jul 2008, Jamie Lokier wrote:
>
> Jamie Lokier wrote:
> > not being able to tell when a sendfile() has finished with the pages
> > its sending.
> 
> (Except by the socket fully closing or a handshake from the other end,
> obviously.)

Well, people should realize that this is pretty fundamental to zero-copy 
scemes. It's why zero-copy is often much less useful than doing a copy in 
the first place. How do you know how far in a splice buffer some random 
'struct page' has gotten? Especially with splicing to spicing to tee to 
splice...

You'd have to have some kind of barrier model (which would be really 
complex), or perhaps a "wait for this page to no longer be shared" (which 
has issues all its own).

IOW, splice() is very closely related to a magic kind of "mmap()+write()" 
in another thread. That's literally what it does internally (except the 
"mmap" is just a small magic kernel buffer rather than virtual address 
space), and exactly as with mmap, if you modify the file, the other thread 
will see if, even though it did it long ago.

Personally, I think the right approach is to just realize that splice() is 
_not_ a write() system call, and never will be. If you need synchronous 
writing, you simply shouldn't use splice().

			Linus
