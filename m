Return-Path: <linux-kernel-owner+w=401wt.eu-S934706AbZLGIrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934706AbZLGIrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 03:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933594AbZLGIrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 03:47:41 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:51978 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933627AbZLGIrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 03:47:40 -0500
Subject: Re: [PATCH 16/19] workqueue: reimplement workqueue flushing using
 color coded works
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net
In-Reply-To: <4B196610.7090101@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-17-git-send-email-tj@kernel.org>
	 <1259927181.17907.98.camel@laptop>  <4B196610.7090101@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 07 Dec 2009 09:46:02 +0100
Message-ID: <1260175562.8223.1204.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-12-05 at 04:42 +0900, Tejun Heo wrote: 
> Hello,
> 
> On 12/04/2009 08:46 PM, Peter Zijlstra wrote:
> > Hmm, a long while back I did a PI aware workqueue implementation, that
> > used nested work-lists to implement barriers and flushing.
> > 
> > This colour thing seems very prone to starvation when you want to extend
> > worklets with priority.
> 
> Can you elaborate how it would be prone to starvation?  I was assuming
> flat-priority while designing and implementing this as that was the
> current behavior and never really thought about priority.

A sudden influx of high prio worklets would hold back the completion of
existing worklets, so simply waiting for a particular colour to deplete
is going to last a long while.

The barrier semantics I implemented ensured worklets couldn't cross a
barrier, so if a high prio item got stuck behind a barrier it would
simply elevate the priority of everything before the barrier, and would
complete everything before that barrier before running itself.

This insures progress and thereby guarantees completion of flushes.

