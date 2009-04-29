Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZD2RGk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZD2RGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 13:06:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752658AbZD2RG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 13:06:28 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:35637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239AbZD2RG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 13:06:28 -0400
Date: Wed, 29 Apr 2009 13:06:20 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Elladan <elladan@eskimo.com>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       peterz@infradead.org, tytso@mit.edu, kosaki.motohiro@jp.fujitsu.com,
       linux-mm@kvack.org
Subject: Re: [PATCH] vmscan: evict use-once pages first
Message-ID: <20090429170620.GA6307@infradead.org>
References: <20090428044426.GA5035@eskimo.com> <20090428192907.556f3a34@bree.surriel.com> <20090429033650.GA4612@eskimo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090429033650.GA4612@eskimo.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 28, 2009 at 08:36:51PM -0700, Elladan wrote:
> Rik,
> 
> This patch appears to significantly improve application latency while a large
> file copy runs.  I'm not seeing behavior that implies continuous bad page
> replacement.
> 
> I'm still seeing some general lag, which I attribute to general filesystem
> slowness.  For example, latencytop sees many events like these:
> 
> down xfs_buf_lock _xfs_buf_find xfs_buf_get_flags 1475.8 msec          5.9 %

This actually is contention on the buffer lock, and most likely
happens because it's trying to access a buffer that's beeing read
in currently.

> 
> xfs_buf_iowait xfs_buf_iostart xfs_buf_read_flags 1740.9 msec          2.6 %

That's an actual metadata read.

> Writing a page to disk                            1042.9 msec         43.7 %
> 
> It also occasionally sees long page faults:
> 
> Page fault                                        2068.3 msec         21.3 %
> 
> I guess XFS (and the elevator) is just doing a poor job managing latency
> (particularly poor since all the IO on /usr/bin is on the reader disk).

The filesystem doesn't really decide which priorities to use, except
for some use of the WRITE_SYNC which is used rather minimall in XFS in
2.6.28.

> Creating block layer request                      451.4 msec         14.4 %

I guess that a wait in get_request because we're above nr_requests..
