Return-Path: <linux-kernel-owner+w=401wt.eu-S1752096AbXBRUxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbXBRUxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 15:53:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbXBRUxO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 15:53:14 -0500
Received: from smtp.osdl.org ([65.172.181.24]:55960 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752096AbXBRUxN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 15:53:13 -0500
Date: Sun, 18 Feb 2007 12:53:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: dirty balancing deadlock
Message-Id: <20070218125307.4103c04a.akpm@linux-foundation.org>
In-Reply-To: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu>
References: <E1HIqlm-0004iZ-00@dorka.pomaz.szeredi.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 Feb 2007 19:28:18 +0100 Miklos Szeredi <miklos@szeredi.hu> wrote:

> I was testing the new fuse shared writable mmap support, and finding
> that bash-shared-mapping deadlocks (which isn't so strange ;).  What
> is more strange is that this is not an OOM situation at all, with
> plenty of free and cached pages.
> 
> A little more investigation shows that a similar deadlock happens
> reliably with bash-shared-mapping on a loopback mount, even if only
> half the total memory is used.
> 
> The cause is slightly different in the two cases:
> 
>   - loopback mount: allocation by the underlying filesystem is stalled
>     on throttle_vm_writeout()
> 
>   - fuse-loop: page dirtying on the underlying filesystem is stalled on
>     balance_dirty_pages()
> 
> In both cases the underlying fs is totally innocent, with no
> dirty/writback pages, yet it's waiting for the global dirty+writeback
> to go below the threshold, which obviously won't, until the
> allocation/dirtying succeeds.
> 
> I'm not quite sure what the solution is, and asking for thoughts.

But....  these things don't just throttle.  They also perform large amounts
of writeback, which causes the dirty levels to subside.

>From your description it appears that this writeback isn't happening, or
isn't working.  How come?

