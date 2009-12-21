Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZLUO2k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZLUO2k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 09:28:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753257AbZLUO2i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 09:28:38 -0500
Received: from casper.infradead.org ([85.118.1.10]:44928 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbZLUO2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 09:28:38 -0500
Subject: Re: workqueue thing
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, awalls@radix.net,
       linux-kernel@vger.kernel.org, jeff@garzik.org, mingo@elte.hu,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org
In-Reply-To: <4B2F7879.2080901@kernel.org>
References: <1261141088-2014-1-git-send-email-tj@kernel.org>
	 <1261143924.20899.169.camel@laptop>  <4B2EE5A5.2030208@kernel.org>
	 <1261387377.4314.37.camel@laptop>  <4B2F7879.2080901@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Dec 2009 15:26:44 +0100
Message-ID: <1261405604.4314.154.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-21 at 22:30 +0900, Tejun Heo wrote:

> I think you're primarily concerned with the scheduler modifications

No I think the whole wq redesign sucks chunks, because it:

 1) looses the queue property
 2) doesn't deal with cpu heavy tasks/wakeup parallelism
 3) gets fragile at memory-pressure/reclaim
 4) didn't consider the RT needs

Also, I think that whole move tasks back on online stuff is utter crazy,
just move then to another cpu and leave them there.

Also, I don't think it can properly warn of simple AB-BA flush
deadlocks, where work A flushes B and B flushes A.

(I also don't much like the colour coding flush implementation, but I
haven't spend a lot of time considering alternatives)

> and think that the choose-between-two-masks on migration is ugly.  I
> agree it's not the prettiest thing in this world but then again it's
> not a lot of code.  The reason why it looks ugly is because the way
> migration is implemented and parameter is passed in.  API-wise, I
> think making kthread_bind() synchronized against cpu onliness should
> be pretty clean.

Assuming you only migrate blocked tasks the current kthread_bind()
should suit your needs -- I recently reworked most of the migration
logic.

But as it stands I don't think its wise to replace the current workqueue
implementation with this, esp since there are known heavy CPU users
using it, nor have you addressed the queueing issue (or is that the
restoration of the single-queue workqueue?)



