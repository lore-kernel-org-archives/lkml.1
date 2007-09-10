Return-Path: <linux-kernel-owner+w=401wt.eu-S1760603AbXIJQrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760603AbXIJQrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 12:47:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756136AbXIJQqt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 12:46:49 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:4865 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756090AbXIJQqr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 12:46:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=DMb5qzO0yDS7Na1vXo+H35kZmCvIDgy8VsigYOOKHfsDeosqQ2YGMQr8+MGHLr8nDG9Z5y3bgfZlo+t7xWQScqJ0kJOfNJ8/Pkq4aUZmO1VFC7nGVwd8WqM97rt8DrSAa34ekLVovdxQrHSZNOi6KTXfmZM/F9zWKgi/XDPEnqI=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 0/24] make atomic_read() behave consistently across all architectures
Date: Mon, 10 Sep 2007 17:46:33 +0100
User-Agent: KMail/1.9.1
Cc: Kyle Moffett <mrmacman_g4@mac.com>, Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Chris Snook <csnook@redhat.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <200709101516.03234.vda.linux@googlemail.com> <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709101746.34513.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 September 2007 16:09, Linus Torvalds wrote:
> On Mon, 10 Sep 2007, Denys Vlasenko wrote:
> > static inline int
> > qla2x00_wait_for_loop_ready(scsi_qla_host_t *ha)
> > {
> >         int      return_status = QLA_SUCCESS;
> >         unsigned long loop_timeout ;
> >         scsi_qla_host_t *pha = to_qla_parent(ha);
> > 
> >         /* wait for 5 min at the max for loop to be ready */
> >         loop_timeout = jiffies + (MAX_LOOP_TIMEOUT * HZ);
> > 
> >         while ((!atomic_read(&pha->loop_down_timer) &&
> >             atomic_read(&pha->loop_state) == LOOP_DOWN) ||
> >             atomic_read(&pha->loop_state) != LOOP_READY) {
> >                 if (atomic_read(&pha->loop_state) == LOOP_DEAD) {
> ...
> > Is above correct or buggy? Correct, because msleep is a barrier.
> > Is it obvious? No.
> 
> It's *buggy*. But it has nothing to do with any msleep() in the loop, or 
> anything else.
> 
> And more importantly, it would be equally buggy even *with* a "volatile" 
> atomic_read().

I am not saying that this code is okay, this isn't the point.
(The code is in fact awful for several more reasons).

My point is that people are confused as to what atomic_read()
exactly means, and this is bad. Same for cpu_relax().
First one says "read", and second one doesn't say "barrier".

This is real code from current kernel which demonstrates this:

"I don't know that cpu_relax() is a barrier already":

drivers/kvm/kvm_main.c
        while (atomic_read(&completed) != needed) {
                cpu_relax();
                barrier();
        }

"I think that atomic_read() is a read from memory and therefore
I don't need a barrier":

arch/x86_64/kernel/crash.c
        msecs = 1000; /* Wait at most a second for the other cpus to stop */
        while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
                mdelay(1);
                msecs--;
        }

Since neither camp seems to give up, I am proposing renaming
them to something less confusing, and make everybody happy.

cpu_relax_barrier()
atomic_value(&x)
atomic_fetch(&x)

I'm not native English speaker, do these sound better?
--
vda
