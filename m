Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbXJ3Rei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbXJ3Rei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 13:34:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753109AbXJ3Rea
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 13:34:30 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:54881 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752861AbXJ3Re3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 13:34:29 -0400
Date: Tue, 30 Oct 2007 10:33:56 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pierre Peiffer <pierre.peiffer@bull.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.23-mm1] Change the ida/idr_pre_get() return value to
 follow the kernel convention
Message-Id: <20071030103356.bf11d1a7.akpm@linux-foundation.org>
In-Reply-To: <20071030171350.cd25b87c.pierre.peiffer@bull.net>
References: <20071030171350.cd25b87c.pierre.peiffer@bull.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Oct 2007 17:13:50 +0100
Pierre Peiffer <pierre.peiffer@bull.net> wrote:

> 
> ida_pre_get() and idr_pre_get() currently return 0 in case of error, and 1
> in case of success, what is not the conventional way to handle error cases.
> 
> This patch makes both of them return 0 in case of success, and an errcode
> otherwise, and then it changes each caller to let them return the error
> reported instead of ENOMEM. This avoids to the callers to make any assumption
> about the cause of the error.
> 

If we're going to do this (and really we should), then we risk quietly
breaking out-of-tree code and we risk breaking in-tree or
soon-to-be-in-tree code which we didn't know about.

So what we should do is to rename these functions when we change their
interfaces.

Happily, this means that we then don't need to remove the old functions -
we can keep them there for a while as we transition everything over to the
new functions.  It also means that we can sneak the new functions into the
2.6.24 stream and then merge these changes via the relevant maintainers
rather than needing a single atomic megapatch.


Although I'd much prefer just to remove the pathetic things - idr_pre_get()
is a truly awful interface.

It would be slightly better if it took an `id' argument and filled in the
nodes at the appropriate position in the tree so that the caller is
guaranteed that the subsequent idr_get_new() will succeed.  Because at
present there is no guarantee that the nodes which you preallocated with
idr_pre_get() are still available when you do your idr_get_new(): some
other CPU/task might have come in and used them all.

Storage classes which need to allcoate memory at insertion time are hard:
radix_tree_preload() gets it right in terms of robustness, but it's an
awful lot of fuss.

IDR gets it all wrong and compounds the problem by implementing internal
locking.  It shouldn't have done that: storage code like this should use
only caller-provided locking.

