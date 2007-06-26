Return-Path: <linux-kernel-owner+w=401wt.eu-S1757832AbXFZMh6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832AbXFZMh6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2007 08:37:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757401AbXFZMhr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jun 2007 08:37:47 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:59312 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757707AbXFZMhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2007 08:37:46 -0400
Date: Tue, 26 Jun 2007 08:34:49 -0400
From: Chris Mason <chris.mason@oracle.com>
To: David Chinner <dgc@sgi.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [RFC] fsblock
Message-ID: <20070626123449.GM14224@think.oraclecorp.com>
References: <20070624014528.GA17609@wotan.suse.de> <20070626030640.GM989688@sgi.com> <46808E1F.1000509@yahoo.com.au> <20070626092309.GF31489@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070626092309.GF31489@sgi.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2007 at 07:23:09PM +1000, David Chinner wrote:
> On Tue, Jun 26, 2007 at 01:55:11PM +1000, Nick Piggin wrote:

[ ... fsblocks vs extent range mapping ]

> iomaps can double as range locks simply because iomaps are
> expressions of ranges within the file.  Seeing as you can only
> access a given range exclusively to modify it, inserting an empty
> mapping into the tree as a range lock gives an effective method of
> allowing safe parallel reads, writes and allocation into the file.
> 
> The fsblocks and the vm page cache interface cannot be used to
> facilitate this because a radix tree is the wrong type of tree to
> store this information in. A sparse, range based tree (e.g. btree)
> is the right way to do this and it matches very well with
> a range based API.

I'm really not against the extent based page cache idea, but I kind of
assumed it would be too big a change for this kind of generic setup.  At
any rate, if we'd like to do it, it may be best to ditch the idea of
"attach mapping information to a page", and switch to "lookup mapping
information and range locking for a page".

A btree could be used to hold the range mapping and locking, but it
could just as easily be a radix tree where you do a gang lookup for the
end of the range (the same way my placeholder patch did).  It'll still
find intersecting range locks but is much faster for random
insertion/deletion than the btrees.

-chris
