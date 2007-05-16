Return-Path: <linux-kernel-owner+w=401wt.eu-S1761364AbXEPKTo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761364AbXEPKTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 06:19:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758202AbXEPKTg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 06:19:36 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55769 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757429AbXEPKTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 06:19:35 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20070318233008.GA32597093@melbourne.sgi.com>
References: <20070318233008.GA32597093@melbourne.sgi.com>
To: David Chinner <dgc@sgi.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 1 of 2] block_page_mkwrite() Implementation V2
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Wed, 16 May 2007 11:19:29 +0100
Message-ID: <18993.1179310769@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Chinner <dgc@sgi.com> wrote:

> +	ret = block_prepare_write(page, 0, end, get_block);

As I understand the way prepare_write() works, this is incorrect.

The start and end points passed to block_prepare_write() delimit the region of
the page that is going to be modified.  This means that prepare_write()
doesn't need to fill it in if the page is not up to date.  It does, however,
need to fill in the region before (if present) and the region after (if
present).  Look at it like this:

		+---------------+
		|               |
		|               |	<-- Filled in by prepare_write()
		|               |
	to->	|:::::::::::::::|
		|               |
		|               |	<-- Filled in by caller
		|               |
	offset->|:::::::::::::::|
		|               |
		|               |	<-- Filled in by prepare_write()
		|               |
	page->	+---------------+

However, page_mkwrite() isn't told which bit of the page is going to be
written to.  This means it has to ask prepare_write() to make sure the whole
page is filled in.  In other words, offset and to must be equal (in AFS I set
them both to 0).

With what you've got, if, say, 'offset' is 0 and 'to' is calculated at
PAGE_SIZE, then if the page is not up to date for any reason, then none of the
page will be updated before the page is written on by the faulting code.

You probably get away with this in a blockdev-based filesystem because it's
unlikely that the page will cease to be up to date.

However, if someone adds a syscall to punch holes in files, this may change...

David
