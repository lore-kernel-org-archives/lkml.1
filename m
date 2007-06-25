Return-Path: <linux-kernel-owner+w=401wt.eu-S1755360AbXFYUuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755360AbXFYUuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 16:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752147AbXFYUuI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 16:50:08 -0400
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:65095 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356AbXFYUuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 16:50:06 -0400
Subject: Re: [POSSIBLE BUG] use of tasklet_unlock in ipath_no_bufs_available
From: Steven Rostedt <rostedt@goodmis.org>
To: Ralph Campbell <ralph.campbell@qlogic.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       Roland Dreier <rdreier@cisco.com>, openib-general@openib.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1182803821.18911.237.camel@brick.pathscale.com>
References: <1182799994.5493.201.camel@localhost.localdomain>
	 <1182803821.18911.237.camel@brick.pathscale.com>
Content-Type: text/plain
Date: Mon, 25 Jun 2007 16:49:08 -0400
Message-Id: <1182804548.5493.216.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-06-25 at 13:37 -0700, Ralph Campbell wrote:
> This was fixed by a patch that Arthur Jones sent out to
> general@lists.openfabrics.org

Great!

> 
> Tue Jun 19 16:42:09 PDT 2007
> [PATCH 17/28] IB/ipath - wait for PIO available interrupt
> 
> I imagine that it is working its way into Roland's git tree
> for Linus.

 	 * tasklet_hi_schedule() is called.
-	 * We clear the tasklet flag now since we are committing to return
-	 * from the tasklet function.
+	 * We leave the busy flag set so that another post send doesn't
+	 * try to put the same QP on the piowait list again.
 	 */
-	clear_bit(IPATH_S_BUSY, &qp->s_busy);
-	tasklet_unlock(&qp->s_task);
 	want_buffer(dev->dd);
 	dev->n_piowait++;

This removes the final use of tasklet_unlock.  I'll submit a patch to
remove this from being a public function. So no others think they can
easily get to the internals of a tasklet.

-- Steve


