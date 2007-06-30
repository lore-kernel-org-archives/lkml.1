Return-Path: <linux-kernel-owner+w=401wt.eu-S1758433AbXF3LPe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433AbXF3LPe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 07:15:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755152AbXF3LPW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 07:15:22 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754175AbXF3LPU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 07:15:20 -0400
Date: Sat, 30 Jun 2007 07:15:14 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Steve French <smfrench@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-cifs-client@lists.samba.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] CIFS: make cifsd (more)
Message-Id: <20070630071514.514d4833.jlayton@redhat.com>
In-Reply-To: <20070630084209.GA21186@infradead.org>
References: <524f69650706251525g7b17ea02o5fb3e637615fe542@mail.gmail.com>
	<20070630084209.GA21186@infradead.org>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 30 Jun 2007 09:42:09 +0100
Christoph Hellwig <hch@infradead.org> wrote:

> On Mon, Jun 25, 2007 at 05:25:00PM -0500, Steve French wrote:
> > Jeff,
> > Not seeing any objections to your revised approach (to not allowing
> > signals for cifsd kernel thread), I just merged something similar to
> > your patch to the cifs-2.6.git tree (also fixed some nearby lines that
> > went past 80 columns).
> 
> Ok, I'm back to this.
> 
> As I said mixing force_sig with the kthread infrastructure is a bad idea.
> The proper short-term (aka 2.6.22) fix is to revert the kthread conversion
> for this particular thread.  Just go back to what worked before.

Could you clarify why this is? It looks like kthreads and signalling
should be more or less orthogonal. Or is it just an issue of the
complexity added when you mix signalling into kthreads?

Note that the problem of insulation from userspace signals predates the
conversion to using the kthreads interface for cifsd. So even if we
revert the switch of the demultiplexer thread to kthreads in the near
term, I'd like to keep the recent change to block all signals from
userspace and use force_sig in lieu of send_sig.

Does that sound reasonable?

>
> Now the right fix is a lot more complicated and involved:
> 
> 	Stop using blocking recvmsg (or read) in kernel threads!
> 
> If you look at what the other consumers of networking reads from kernel
> threads do is they either use tcp_read_sock and hooks into the sk_ callbacks
> which would be nice for high performance reads in cifs aswell, but probably
> not the demultiplexer thread, or they use MSG_DONTWAIT to avoid this problems
> and deal with the blocking behaviour on a higher level.

-- 
Jeff Layton <jlayton@redhat.com>
