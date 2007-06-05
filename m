Return-Path: <linux-kernel-owner+w=401wt.eu-S1765261AbXFETQH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765261AbXFETQH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 15:16:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755368AbXFETP5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 15:15:57 -0400
Received: from www.osadl.org ([213.239.205.134]:59879 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753983AbXFETP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 15:15:56 -0400
Subject: Re: [RFC][PATCH] muptiple bugs in PI futexes
From: Thomas Gleixner <tglx@linutronix.de>
To: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Ulrich Drepper <drepper@redhat.com>
In-Reply-To: <1181069306.4404.145.camel@chaos>
References: <20070507144351.GA12302@ms2.inr.ac.ru>
	 <20070523072609.GC6859@elte.hu> <20070523115159.GA30251@ms2.inr.ac.ru>
	 <1181060711.4404.114.camel@chaos>  <20070605173949.GA27618@ms2.inr.ac.ru>
	 <1181069306.4404.145.camel@chaos>
Content-Type: text/plain
Date: Tue, 05 Jun 2007 21:15:53 +0200
Message-Id: <1181070953.4404.149.camel@chaos>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-06-05 at 20:48 +0200, Thomas Gleixner wrote:
> > > This does not really explain, why you do prevent the -ESRCH return value
> > > in the next cycle,
> > 
> > Because right curval is refetched, it already has FUTEX_OWNER_DIED bit set
> > and we succesfully take the lock.
> 
> Ok, handle_futex_death() is punching the OWNER_DIED bit into the futex
> without the hash bucket lock. We might as well grab the hash bucket lock
> right there to avoid this. I look for a sane solution.

We actually need to do something about this, as we might loop for ever
there. The robust cleanup code can fail (e.g. due to list corruption)
and we would see exit_state != 0 and the OWNER_DIED bit would never be
set, so we are stuck in a busy loop. I think I have an idea how to fix
this.

	tglx


