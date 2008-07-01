Return-Path: <linux-kernel-owner+w=401wt.eu-S1757472AbYGANit@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757472AbYGANit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 09:38:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbYGANij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 09:38:39 -0400
Received: from gate.crashing.org ([63.228.1.57]:44974 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753230AbYGANii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 09:38:38 -0400
Subject: Re: [Ksummit-2008-discuss] Delayed interrupt work, thread pools
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: ksummit-2008-discuss@lists.linux-foundation.org,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <20080701125357.GT14894@parisc-linux.org>
References: <1214916335.20711.141.camel@pasglop>
	 <20080701125357.GT14894@parisc-linux.org>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 23:38:31 +1000
Message-Id: <1214919511.20711.150.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-01 at 06:53 -0600, Matthew Wilcox wrote:
> On Tue, Jul 01, 2008 at 10:45:35PM +1000, Benjamin Herrenschmidt wrote:
> > In various areas (I'll come up with some examples later), kernel code
> > such as drivers want to defer some processing to "task level", for
> > various reasons such as locking (taking mutexes), memory allocation,
> > interrupt latency, or simply doing things that may take more time than
> > is reasonable to do at interrupt time or do things that may block.
> > 
> > Currently, the main mechanism we provide to do that is workqueues. They
> > somewhat solve the problem, but at the same time, somewhat can make it
> > worse.
> 
> Why not just use a dedicated thread?  The API to start / stop threads is
> now pretty easy to use.

A dedicated thread isn't far from a dedicated workqueue. The thread can
be blocked servicing a page fault and that will delay any further work.

In the case of spufs, we could solve that by having a dedicated thread
per context. That's probably what we'll do for our proof-of-concept
implementation of our new ideas. But that sounds overkill, there
shouldn't be -that- much page faults. Similar comes with gfx cards with
MMUs, etc.. we'd end up with shitload of dedicated threads mostly
staying there sleeping and wasting kernel resources.

Another option I though about would be something akin to some of the
threadlet discussions (or whatever we call those nowadays). ie, have the
workqueue fork when it blocks basically. That would require some API
changes as current drivers may rely on the fact that all workqueues
tasks are serialized though.

Cheers,
Ben.


