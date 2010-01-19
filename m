Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793Ab0ASOhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab0ASOhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 09:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751559Ab0ASOhe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 09:37:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:49627 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524Ab0ASOhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 09:37:33 -0500
Date: Tue, 19 Jan 2010 06:37:18 -0800
From: Arjan van de Ven <arjan@linux.intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, avi@redhat.com,
       johannes@sipsolutions.net, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 32/40] async: introduce workqueue based alternative
 implementation
Message-ID: <20100119063718.3f1f39cc@linux.intel.com>
In-Reply-To: <4B5565BE.4050406@kernel.org>
References: <1263776272-382-1-git-send-email-tj@kernel.org>
	<1263776272-382-33-git-send-email-tj@kernel.org>
	<20100117220130.214d56f1@linux.intel.com>
	<4B5420A3.3080200@kernel.org>
	<20100118072523.2683cd59@linux.intel.com>
	<4B55038D.3070106@kernel.org>
	<4B550384.8030103@linux.intel.com>
	<4B5565BE.4050406@kernel.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jan 2010 16:56:46 +0900
Tejun Heo <tj@kernel.org> wrote:

> > where you get maximum concurrency during the pre-synchronization
> > part, and a "chain" of synchronized execution *as part of the same
> > function flow*, but possibly independent of other synchronization
> > flows.
> 
> This too can be implemented using wq directly.  More below.

however you are forcing the function to be split in pieces,
which makes for a more complex programming model.
For example, I have trouble proving to myself that your ata conversion
is acutally correct.


> 
> The tradeoff changes with the worker pool implementation can be shared
> with workqueue which provides its own ways to control concurrency and
> synchronize. 

while I don't mind sharing the pool implementation (all 20 lines of
it ;-), I don't think the objective of sharing some implementation
detail is worth complicating the programming model.


> Before, the cookie based synchronization is something
> inherent to the async mechanism.  The async worker pool was needed and
> the synchronization mechanism came integrated with it.  Now that the
> backend can be replaced with workqueue which supplies its own ways of
> synchronization, the cookie based synchronization model needs stronger
> justification as it no longer comes as a integral part of something
> bigger which is needed anyway.

the wq model is either "full async" or "fully ordered".
the cookie mechanism allows for "run async for the expensive bit, and
then INSIDE THE SAME FUNCTION, synchronize, and then run some more".

> If so, we can leave the list based cookie synchronization alone and
> simply use wq's to provide concurrency only without using its
> synchronization mechanisms (flushes).

can you flush from inside a wq element?
That's the critical part that makes the cookie based system easy to
program.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
