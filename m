Return-Path: <linux-kernel-owner+w=401wt.eu-S1752438AbZIHSci@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752438AbZIHSci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 14:32:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZIHSch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 14:32:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:46302 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752267AbZIHScg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:32:36 -0400
Subject: Re: [PATCH 8/8] vm: Add an tuning knob for vm.max_writeback_mb
From: Peter Zijlstra <peterz@infradead.org>
To: Chris Mason <chris.mason@oracle.com>
Cc: Artem Bityutskiy <dedekind1@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       david@fromorbit.com, hch@infradead.org, akpm@linux-foundation.org,
       jack@suse.cz, "Theodore Ts'o" <tytso@mit.edu>,
       Wu Fengguang <fengguang.wu@intel.com>
In-Reply-To: <1252432501.7746.156.camel@twins>
References: <1252401791-22463-1-git-send-email-jens.axboe@oracle.com>
	 <1252401791-22463-9-git-send-email-jens.axboe@oracle.com>
	 <4AA633FD.3080006@gmail.com> <1252425983.7746.120.camel@twins>
	 <20090908162936.GA2975@think> <1252428983.7746.140.camel@twins>
	 <20090908172842.GC2975@think>  <1252431974.7746.151.camel@twins>
	 <1252432501.7746.156.camel@twins>
Content-Type: text/plain
Date: Tue, 08 Sep 2009 20:32:26 +0200
Message-Id: <1252434746.7035.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-08 at 19:55 +0200, Peter Zijlstra wrote:
> 
> I think I'm somewhat confused here though..
> 
> There's kernel threads doing writeout, and there's apps getting stuck in
> balance_dirty_pages().
> 
> If we want all writeout to be done by kernel threads (bdi/pd-flush like
> things) then we still need to manage the actual apps and delay them.
> 
> As things stand now, we kick pdflush into action when dirty levels are
> above the background level, and start writing out from the app task when
> we hit the full dirty level.
> 
> Moving all writeout to a kernel thread sounds good from writing linear
> stuff pov, but what do we make apps wait on then?

OK, so like said in the previous email, we could have these app tasks
simply sleep on a waitqueue which gets periodic wakeups from
__bdi_writeback_inc() every time the dirty threshold drops.

The woken tasks would then check their bdi dirty limit (its task
dependent) against the current values and either go back to sleep or
back to work.

The only problem would be the mass wakeups when lots of tasks are
blocked on dirty, but I'm guessing there's no way around that anyway,
and its better to have a limited number of writers than have everybody
write something, which would result in massive write fragmentation.

