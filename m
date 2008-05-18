Return-Path: <linux-kernel-owner+w=401wt.eu-S1757538AbYERQZX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757538AbYERQZX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 12:25:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYERQZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 12:25:11 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:52336 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751779AbYERQZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 12:25:10 -0400
Date: Sun, 18 May 2008 12:24:29 -0400
From: Theodore Tso <tytso@mit.edu>
To: Bernie Innocenti <bernie@codewiz.org>
Cc: lkml <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
       ext3-users@redhat.com, ext2-devel@lists.sourceforge.net,
       Stefano Fedrigo <aleph@develer.com>
Subject: Re: ext3_dx_add_entry: Directory index full!
Message-ID: <20080518162429.GE31413@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Bernie Innocenti <bernie@codewiz.org>,
	lkml <linux-kernel@vger.kernel.org>,
	David Woodhouse <dwmw2@infradead.org>, ext3-users@redhat.com,
	ext2-devel@lists.sourceforge.net,
	Stefano Fedrigo <aleph@develer.com>
References: <48304CE2.1090808@codewiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48304CE2.1090808@codewiz.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2008 at 05:36:02PM +0200, Bernie Innocenti wrote:
>
> Some background: I'm moving users' Maildirs to a separate filesystem tuned
> for small files to increase performance.  One of our users intentionally
> collected spam for 5 years in one folder and likes it this way.
> We could easily work it around, but first I'd like to understand whether
> the particular parameters we used trigger a bug in ext3 or if we're just
> hitting a (possibly undocumented) limit.

No, not a bug, but a limit.  Ext3's hash directores are limited to a
depth of 3 blocks, which normally isn't a problem if you are using a
4k blocksize, since each internal node is small; only 8 bytes.  So you
have a fanout of 508 for each internal node, and two internal nodes
gets you to over 250,000 4k directory blocks.  But with a 1k
blocksize, the internal node fanout is only 124, so that only gets you
a bit more than 15,000 1k directory blocks.

We could remove this limit at some point; the problem is that Daniel
Phillip's original code had this as a limitation, and fixing it would
mean replacing the tree implementation.  We actually have some code
from Lustre that we could use for this purpose, but to date we've been
focused on some other higher priority items for ext4.

							- Ted
