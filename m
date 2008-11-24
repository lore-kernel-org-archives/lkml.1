Return-Path: <linux-kernel-owner+w=401wt.eu-S1754392AbYKXXm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbYKXXm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 18:42:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753614AbYKXXmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 18:42:19 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43897 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753581AbYKXXmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 18:42:18 -0500
Date: Mon, 24 Nov 2008 15:42:14 -0800
From: malahal@us.ibm.com
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org,
       David Miller <davem@davemloft.net>, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: next-20081119: general protection fault:
	get_next_timer_interrupt()
Message-ID: <20081124234214.GA23553@us.ibm.com>
Mail-Followup-To: Thomas Gleixner <tglx@linutronix.de>,
	Mike Anderson <andmike@linux.vnet.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
	Ingo Molnar <mingo@elte.hu>, linux-scsi@vger.kernel.org,
	David Miller <davem@davemloft.net>,
	Jens Axboe <jens.axboe@oracle.com>
References: <a4423d670811190714k13721ae8s125e63d520892440@mail.gmail.com> <alpine.LFD.2.00.0811191308030.3119@localhost.localdomain> <a4423d670811210250t6b75645evd9646ffb07745867@mail.gmail.com> <alpine.LFD.2.00.0811241816120.3301@localhost.localdomain> <1227554117.25499.46.camel@localhost.localdomain> <alpine.LFD.2.00.0811242018370.3235@localhost.localdomain> <20081124213517.GA25898@linux.vnet.ibm.com> <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811242327130.3235@localhost.localdomain>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner [tglx@linutronix.de] wrote:
> > where seeing the signature shown in bug 12020. It appeared from debug that
> > there where a few paths that where adding timers for requests that where
> > not expected.
> > 
> > http://bugzilla.kernel.org/show_bug.cgi?id=12020
> > 
> > It would be good to know if the debug patch below effects your problem as while.
> > 
> > If it does we need to investigated a solution to resolve not adding a
> > timer for these requests.
> 
> Wrong. 
> 
> The problem is not a timer which is armed in the first place.

No, this could be a problem if such a timer is not dis-armed! As fas as
I know, the queue timer will be dis-armed in end_that_request_last() if
needed. Do we know end_that_request_last() gets called for every request
queued?

> The problem is an armed timer which is not canceled before the data
> structure which contains it is freed.
> 
> So not arming the timer will probably prevent this particular scan
> problem, but it does not solve the general wreckage of freeing a data
> structure with a possibly armed timer in it.
> 
> You need to fix the code path which frees the data structure which
> contains the timer and cancel the timer _before_ freeing the data
> structure.

Agreed but the timer is armed when a request is sent and is dis-armed
when it is completed. Essentially there should NOT be any active
timer(s) when you try to free the request queue. In other words, the
code which frees the data structure (request queue) is correct and there
is no need to cancel the timer there!

--Malahal.
