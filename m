Return-Path: <linux-kernel-owner+w=401wt.eu-S1756903AbXEXXJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbXEXXJO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 19:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751284AbXEXXIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 19:08:49 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48323 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbXEXXIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 19:08:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070524154611.080b38ed.akpm@linux-foundation.org>
References: <20070524154611.080b38ed.akpm@linux-foundation.org> <20070524144732.d9b2650b.akpm@linux-foundation.org> <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com> <27608.1180042522@redhat.com> <28590.1180046073@redhat.com> 
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Fri, 25 May 2007 00:08:43 +0100
Message-ID: <29173.1180048123@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> hm.  I don't see why that race window would be a problem in practice: the
> page-exciser does a lock_page();wait_on_page_writeback() as normal, then
> proceeds with its business?

No.  The page-exciser ends (cancels) PG_writeback, not waits for it (something
has to clear the flag).  The problem is that the truncation routines may be
sat there holding a lock on the page whilst waiting for PG_writeback to go
away - so we have to clear PG_writeback before we can think about getting
PG_lock:-(

> But given that this doesn't work right for some reason, can we use PG_error
> and then handle that appropriately in the filesystem's ->prepare_write() and
> ->page_mkwrite()?

Possibly, though I'd rather they didn't see such a page.

David
