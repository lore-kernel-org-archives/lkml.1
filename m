Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXEXWqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXEXWqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:46:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751201AbXEXWqY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:46:24 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:49307 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750798AbXEXWqX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:46:23 -0400
Date: Thu, 24 May 2007 15:46:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from
 the pagecache
Message-Id: <20070524154611.080b38ed.akpm@linux-foundation.org>
In-Reply-To: <28590.1180046073@redhat.com>
References: <20070524144732.d9b2650b.akpm@linux-foundation.org>
	<20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	<20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	<20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	<27608.1180042522@redhat.com>
	<28590.1180046073@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007 23:34:33 +0100
David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > So my reason for asking the above is to try to find a way to make all these
> > new PG-error games just go away.
> 
> Yeah.  However, there needs to be something to cover the gap between releasing
> PG_writeback and getting PG_lock.  They have to be done in that order to avoid
> deadlocking against truncate and other stuff, but that leaves a window in which
> the page appears to be in a good state - one in which prepare_write() or
> page_mkwrite() can potentially leak through.

hm.  I don't see why that race window would be a problem in practice: the
page-exciser does a lock_page();wait_on_page_writeback() as normal, then
proceeds with its business?

But given that this doesn't work right for some reason, can we use PG_error
and then handle that appropriately in the filesystem's ->prepare_write() and
->page_mkwrite()?

> Nick Piggin talked about using an extra lock, but as far as I can tell, that
> just compounds the deadlock problems.
> 
> I suppose I could leave something in page->private that indicated that the
> page was defunct, but that'd have to be done by the filesystem, probably
> before calling cancel_rejected_write().

Well, using PG_error is OK and appropriate for that if it's localised to
the fs.  But I'd be a bit worried about requiring that the VFS maintain
some special protocol for it, partly because it would be such a
rarely-tested thing.

