Return-Path: <linux-kernel-owner+w=401wt.eu-S1754144AbXEXXZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144AbXEXXZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:25:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbXEXXY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:24:56 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:44554 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750757AbXEXXY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:24:56 -0400
Date: Thu, 24 May 2007 16:24:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from
 the pagecache
Message-Id: <20070524162447.c9e14d14.akpm@linux-foundation.org>
In-Reply-To: <29173.1180048123@redhat.com>
References: <20070524154611.080b38ed.akpm@linux-foundation.org>
	<20070524144732.d9b2650b.akpm@linux-foundation.org>
	<20070524133821.3ee9c9f3.akpm@linux-foundation.org>
	<20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com>
	<20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com>
	<27608.1180042522@redhat.com>
	<28590.1180046073@redhat.com>
	<29173.1180048123@redhat.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 00:08:43 +0100
David Howells <dhowells@redhat.com> wrote:

> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> > hm.  I don't see why that race window would be a problem in practice: the
> > page-exciser does a lock_page();wait_on_page_writeback() as normal, then
> > proceeds with its business?
> 
> No.  The page-exciser ends (cancels) PG_writeback, not waits for it (something
> has to clear the flag).  The problem is that the truncation routines may be
> sat there holding a lock on the page whilst waiting for PG_writeback to go
> away - so we have to clear PG_writeback before we can think about getting
> PG_lock:-(

But we already covered that?  Your exciser can do an unconditional
end_page_writeback(), because it is this thread of control which did the
set_page_writeback().  So we end up with:

	end_page_writeback(page);
	lock_page(page);
	wait_on_page_writeback(page);
	<now nail it>

> > But given that this doesn't work right for some reason, can we use PG_error
> > and then handle that appropriately in the filesystem's ->prepare_write() and
> > ->page_mkwrite()?
> 
> Possibly, though I'd rather they didn't see such a page.

Well someone needs to be taught all about this case.  Question is, should
it be the VFS, or should it just be the address_space(s) which brought
this state about, and which care about it?
