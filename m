Return-Path: <linux-kernel-owner+w=401wt.eu-S1760685AbXEPS22@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760685AbXEPS22 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:28:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756415AbXEPS2V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:28:21 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51026 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753395AbXEPS2V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:28:21 -0400
Date: Wed, 16 May 2007 11:25:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Chuck Ebbert <cebbert@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: filesystem benchmarking fun
Message-Id: <20070516112515.b6f247b2.akpm@linux-foundation.org>
In-Reply-To: <20070516171156.GY26766@think.oraclecorp.com>
References: <20070516144205.GV26766@think.oraclecorp.com>
	<464B2AC2.10206@redhat.com>
	<20070516171156.GY26766@think.oraclecorp.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 May 2007 13:11:56 -0400
Chris Mason <chris.mason@oracle.com> wrote:

> At least on ext3, it may help to sort the blocks under io for
> flushing...it may not.  A bigger log would definitely help, but I would
> say the mkfs defaults should be reasonable for a workload this simple.
> 
> (data=writeback was used for my ext3 numbers).

When ext3 runs out of journal space it needs to sync lots of metadata out
to the fs so that its space in the journal can be reclaimed.  That metadata
is of course splattered all over the place so it's seekstorm time.

The filesystem does take some care to place the metadata blocks "close" to
the data blocks.  But of course if we're writing all the pagecache and then
we later separately go back and write the metadata then that would screw
things up.

I put some code in there which will place indirect blocks under I/O at the
same time as their data blocks, so everything _should_ go out in a nice
slurp (see write_boundary_block()).  The first thing to do here is to check
that write_boundary_block() didn't get broken.

If that's still working then the problem will _probably_ be directory
writeout.  Possibly inodes, but they should be well-laid-out.

Were you using dir_index?  That might be screwing things up.
