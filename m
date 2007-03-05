Return-Path: <linux-kernel-owner+w=401wt.eu-S1751877AbXCEXbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbXCEXbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 18:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751913AbXCEXbh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 18:31:37 -0500
Received: from smtp.osdl.org ([65.172.181.24]:41182 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751877AbXCEXbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 18:31:36 -0500
Date: Mon, 5 Mar 2007 15:31:08 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Chuck Ebbert <cebbert@redhat.com>
Subject: Re: [PATCH] fs: nobh_truncate_page() fix
Message-Id: <20070305153108.27bd0f33.akpm@linux-foundation.org>
In-Reply-To: <1173136211.9109.81.camel@kleikamp.austin.ibm.com>
References: <20070305150317.57e62d70@disher.kickcrew>
	<45EC3058.2010903@redhat.com>
	<1173108985.9109.11.camel@kleikamp.austin.ibm.com>
	<1173109811.9109.17.camel@kleikamp.austin.ibm.com>
	<1173128289.9109.36.camel@kleikamp.austin.ibm.com>
	<Pine.LNX.4.64.0703051333140.3998@woody.linux-foundation.org>
	<20070305145753.1180a1d4.akpm@linux-foundation.org>
	<1173136211.9109.81.camel@kleikamp.austin.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Mar 2007 17:10:11 -0600
Dave Kleikamp <shaggy@linux.vnet.ibm.com> wrote:

> On Mon, 2007-03-05 at 14:57 -0800, Andrew Morton wrote:
> > Is OK, I think.  nobh_prepare_write() brings the outside-from-and-to
> > sections of the page uptodate and memset in nobh_truncate_page() brings the
> > rest of the page uptodate.
> > 
> > We bring the to->PAGE_CACHE_SIZE section uptodate twice, which could be
> > optimised.
> 
> Why not have nobh_truncate_page() call prepare_write() with to =
> PAGE_CACHE_SIZE?  I don't really grok:
> 
> to = (offset + blocksize) & ~(blocksize - 1);

OK, let's say we have a 4k pagesize and a 1k fs blocksize and someone does
ftruncate(fd, 1024 + 100).

We need to:

- load bytes (0 ...  1024+100) from disk (these are live file data)

- zero the bytes (1024+100 ...  1024+1024) (these are data outside the
  truncation point, but inside the fs block which straddles the truncation
  point)

- zero the bytes (1024+1024 ...  4096) (these are the rest of the
  pagecache page, outside the truncation point).

- mark the page dirty so those zeroes outside the truncation point but
  inside the block which straddles i_size (ie: (1024+100 ...  1024+1024)
  get written back.

Now, it just so happens that

	nobh_prepare_write(NULL, page, 1024+100, 1024+1024)

will indeed load bytes (0 ...  1024+1024) from disk, and will then zero out
bytes (1024+100 ...  4096) for us (I think - assumes that ->get_block does
the right thing with buffer_mapped)).  We could exploit that knowledge of
prepare_write() internals in nobh_truncate_page().

But as it stands, nobh_truncate_page() is being formal and is not making
assumptions about what nobh_prepare_write() does with blocks outside
i_size.
