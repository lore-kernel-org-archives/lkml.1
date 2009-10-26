Return-Path: <linux-kernel-owner+w=401wt.eu-S1754784AbZJZGDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbZJZGDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 02:03:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754756AbZJZGDt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 02:03:49 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34796 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754750AbZJZGDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 02:03:48 -0400
Date: Sun, 25 Oct 2009 23:03:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, mingo@elte.hu,
       Frederic Weisbecker <fweisbec@gmail.com>, auke-jan.h.kok@intel.com
Subject: Re: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
Message-Id: <20091025230321.aa4f26a1.akpm@linux-foundation.org>
In-Reply-To: <20091025225342.007138f5@infradead.org>
References: <20091025225342.007138f5@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Oct 2009 22:53:42 -0700 Arjan van de Ven <arjan@infradead.org> wrote:

> >From b894af8a33bec621dd1a4126603a3ca372bf0643 Mon Sep 17 00:00:00 2001
> From: Arjan van de Ven <arjan@linux.intel.com>
> Date: Sun, 25 Oct 2009 15:37:04 -0700
> Subject: [PATCH] vfs: Add a trace point in the mark_inode_dirty function
> 
> PowerTOP would like to be able to show who is keeping the disk
> busy by dirtying data. The most logical spot for this is in the vfs
> in the mark_inode_dirty() function. Doing this on the block level
> is not possible because by the time the IO hits the block layer the
> guilty party can no longer be found ("kjournald" and "pdflush" are not
> useful answers to "who caused this file to be dirty).
> 
> The trace point follows the same logic/style as the block_dump code
> and pretty much dumps the same data, just not to dmesg (and thus to
> /var/log/messages) but via the trace events streams.
> 
> ...
>
> @@ -1071,6 +1072,8 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>  	if ((inode->i_state & flags) == flags)
>  		return;
>  
> +	trace_dirty_inode(inode, current);
> +
>  	if (unlikely(block_dump))
>  		block_dump___mark_inode_dirty(inode);
>  

Doesn't powertop also want to know who is spinning up the disk via
buffered reads, direct-io reads and direct-io writes?

That's why the block_dump hook in submit_bio() is there.

