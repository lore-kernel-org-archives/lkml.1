Return-Path: <linux-kernel-owner+w=401wt.eu-S1767266AbXDEXSK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767266AbXDEXSK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 19:18:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767273AbXDEXSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 19:18:10 -0400
Received: from smtp.osdl.org ([65.172.181.24]:56797 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767266AbXDEXSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 19:18:08 -0400
Date: Thu, 5 Apr 2007 16:17:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: root@programming.kicks-ass.net
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, miklos@szeredi.hu,
       neilb@suse.de, dgc@sgi.com, tomoki.sekiyama.qu@hitachi.com,
       a.p.zijlstra@chello.nl, nikita@clusterfs.com
Subject: Re: [PATCH 11/12] mm: accurate pageout congestion wait
Message-Id: <20070405161713.dcd8bed9.akpm@linux-foundation.org>
In-Reply-To: <20070405174320.373513202@programming.kicks-ass.net>
References: <20070405174209.498059336@programming.kicks-ass.net>
	<20070405174320.373513202@programming.kicks-ass.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 05 Apr 2007 19:42:20 +0200
root@programming.kicks-ass.net wrote:

> Only do the congestion wait when we actually encountered congestion.

The name congestion_wait() was accurate back in 2002, but it isn't accurate
any more, and you got misled.  It does not only wait for a queue to become
uncongested.

See clear_bdi_congested()'s callers.  As long as the queue is in an
uncongested state, we deliver wakeups to congestion_wait() blockers on
every IO completion.  As I said before, it is so that the MM's polling
operations poll at a higher frequency when the IO system is working faster.
(It is also to synchronise with end_page_writeback()'s feeding of clean
pages to us via rotate_reclaimable_page()).



Page reclaim can get into trouble without any request queue having entered
a congested state.  For example, think about a machine which has a single
disk, and the operator has increased that disk's request queue size to
100,000.  With your patch all the VM's throttling would be bypassed and we
go into a busy loop and declare OOM instantly.

There are probably other situations in which page reclaim gets into trouble
without a request queue being congested.

Minor point: bdi_congested() can be arbitrarily expensive - for DM stackups
it is roughly proportional to the number of subdevices in the device.  We
need to be careful about how frequently we call it.

