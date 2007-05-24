Return-Path: <linux-kernel-owner+w=401wt.eu-S1751994AbXEXWf0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994AbXEXWf0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:35:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750741AbXEXWfM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:35:12 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40859 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750721AbXEXWfK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:35:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070524144732.d9b2650b.akpm@linux-foundation.org>
References: <20070524144732.d9b2650b.akpm@linux-foundation.org> <20070524133821.3ee9c9f3.akpm@linux-foundation.org> <20070523191518.24135.81257.stgit@warthog.cambridge.redhat.com> <20070523191524.24135.2609.stgit@warthog.cambridge.redhat.com> <27608.1180042522@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] AFS: Add a function to excise a rejected write from the pagecache
X-Mailer: MH-E 8.0; nmh 1.2-20070115cvs; GNU Emacs 22.0.50
Date: Thu, 24 May 2007 23:34:33 +0100
Message-ID: <28590.1180046073@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> So my reason for asking the above is to try to find a way to make all these
> new PG-error games just go away.

Yeah.  However, there needs to be something to cover the gap between releasing
PG_writeback and getting PG_lock.  They have to be done in that order to avoid
deadlocking against truncate and other stuff, but that leaves a window in which
the page appears to be in a good state - one in which prepare_write() or
page_mkwrite() can potentially leak through.

Nick Piggin talked about using an extra lock, but as far as I can tell, that
just compounds the deadlock problems.

I suppose I could leave something in page->private that indicated that the
page was defunct, but that'd have to be done by the filesystem, probably
before calling cancel_rejected_write().

David
