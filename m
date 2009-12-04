Return-Path: <linux-kernel-owner+w=401wt.eu-S1755678AbZLDLrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678AbZLDLrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 06:47:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZLDLrL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 06:47:11 -0500
Received: from casper.infradead.org ([85.118.1.10]:35504 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754673AbZLDLrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 06:47:10 -0500
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <1258692407-8985-17-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-17-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 12:46:21 +0100
Message-ID: <1259927181.17907.98.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:46 +0900, Tejun Heo wrote:
> Reimplement workqueue flushing using color coded works.  wq has the
> current work color which is painted on the works being issued via
> cwqs.  Flushing a workqueue is achieved by advancing the current work
> colors of cwqs and waiting for all the works which have any of the
> previous colors to drain.
> 
> Currently there are 16 colors allowing 15 concurrent flushes.  When
> color space gets full, flush attempts are batched up and processed
> together when color frees up, so even with many concurrent flushers,
> the new implementation won't build up huge queue of flushers which has
> to be processed one after another.
> 
> This new implementation leaves only cleanup_workqueue_thread() as the
> user of flush_cpu_workqueue().  Just make its users use
> flush_workqueue() and kthread_stop() directly and kill
> cleanup_workqueue_thread().  As workqueue flushing doesn't use barrier
> request anymore, the comment describing the complex synchronization
> around it in cleanup_workqueue_thread() is removed together with the
> function.
> 
> This new implementation is to allow having and sharing multiple
> workers per cpu.

Hmm, a long while back I did a PI aware workqueue implementation, that
used nested work-lists to implement barriers and flushing.

This colour thing seems very prone to starvation when you want to extend
worklets with priority.

