Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYFSRu4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYFSRu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 13:50:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753984AbYFSRur
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 13:50:47 -0400
Received: from tetsuo.zabbo.net ([207.173.201.20]:50197 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbYFSRur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 13:50:47 -0400
Message-ID: <485A9C76.8050301@oracle.com>
Date: Thu, 19 Jun 2008 10:50:46 -0700
From: Zach Brown <zach.brown@oracle.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Jeff Moyer <jmoyer@redhat.com>, akpm@linux-foundation.org,
       linux-aio@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch] aio: invalidate async directio writes
References: <x49ej6uy5qo.fsf@segfault.boston.devel.redhat.com> <1213861885.16944.255.camel@twins>
In-Reply-To: <1213861885.16944.255.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I'm utterly ignorant of all thing [AD]IO, but doesn't deferring the
> invalidate open up/widen a race window?

The case we care about making consistent are buffered reads which the
user politely only issues after O_DIRECT writes have completed.

If they issue buffered reads that race with O_DIRECT writes, well, they
get to see weird versions of the data.  Just like if they issue buffered
reads that race with buffered writes.

But we must make sure that reads issued after the O_DIRECT writes are
not satisfied by cached data which was populated during a nasty racing
read.  So we invalidate cached pages in the range of the write after the
O_DIRECT write is on disk but before we tell the user that the write has
completed.

This is made even worse by the observation that racing buffered reads
might be issued behind the user's back as part of read-ahead.  People
have hit this very issue in systems where they have a ring buffer in a
file, an O_DIRECT writer, and a buffered reader that reads the blocks
just after they're written.

- z
