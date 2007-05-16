Return-Path: <linux-kernel-owner+w=401wt.eu-S1757636AbXEPNVD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757636AbXEPNVD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 09:21:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754130AbXEPNUy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 09:20:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57178 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751581AbXEPNUx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 09:20:53 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <464AF224.30105@yahoo.com.au>
References: <464AF224.30105@yahoo.com.au> <20070318233008.GA32597093@melbourne.sgi.com> <18993.1179310769@redhat.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: David Chinner <dgc@sgi.com>, lkml <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 14:20:47 +0100
Message-ID: <17244.1179321647@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:

> Dave is using prepare_write here to ensure blocks are allocated in the
> given range. The filesystem's ->nopage function must ensure it is uptodate
> before allowing it to be mapped.

Which is fine... assuming it's called.  For blockdev-based filesystems, this
is probably true.  But I'm not sure you can guarantee it.

I've seen Ext3, for example, unlocking a page that isn't yet uptodate.
nopage() won't get called on it again, but prepare_write() might.  I don't
know why this happens, but it's something I've fallen over in doing
CacheFiles.  When reading, readpage() is just called on it again and again
until it is up to date.  When writing, prepare_write() is called correctly.

> Consider that the code currently works OK today _without_ page_mkwrite.
> page_mkwrite is being added to do block allocation / reservation.

Which doesn't prove anything.  All it means is that PG_uptodate being unset is
handled elsewhere.

David
