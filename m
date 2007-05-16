Return-Path: <linux-kernel-owner+w=401wt.eu-S1762587AbXEPSqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762587AbXEPSqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:46:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbXEPSqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:46:07 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464B3F2D.9030603@yahoo.com.au>
References: <464B3F2D.9030603@yahoo.com.au> <464B3209.4010003@yahoo.com.au> <464B07EC.4050308@yahoo.com.au> <464AF3F3.30204@yahoo.com.au> <20070516100225.18685.51699.stgit@warthog.cambridge.redhat.com> <17173.1179321391@redhat.com> <19714.1179331928@redhat.com> <23262.1179334587@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] AFS: Implement shared-writable mmap [try #2]
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 19:45:23 +0100
Message-ID: <31162.1179341123@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> You can drop the lock, do the invalidation,

Hmmm...  There's a danger of incurring a race by doing that.  Consider two
processes both trying to write to a dirty page for which writeback will be
rejected:

 (1) The first process gets EKEYREJECTED from the server, drops its lock and
     is then preempted.

 (2) The second process gets EKEYREJECTED from the server, drops its lock,
     truncates the page, reloads the page and modifies it.

 (3) The first process resumes and truncates the page, thereby splatting the
     second process's write.

Or:

 (1) The first process gets EKEYREJECTED from the server, clears the writeback
     information from the page, drops its lock and is then preempted.

 (2) The second process attaches its own writeback information to the page and
     modifies it.

 (3) The first process resumes and truncates the page, thereby splatting the
     second process's write.

Really, what I want to do is pass the page lock to truncate to deal with.
Better still, I want truncate to be selective, based on whether or not a page
is still associated with the rejected writeback.  I wonder if I should call
truncate_complete_page() or invalidate_complete_page() directly.

What might help is that PG_writeback is set on all pages in the rejected run,
even those that are unlocked.

Network filesystems are such fun:-)

David
