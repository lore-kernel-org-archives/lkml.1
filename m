Return-Path: <linux-kernel-owner+w=401wt.eu-S1757541AbZFIVvA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757541AbZFIVvA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 17:51:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754856AbZFIVuw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 17:50:52 -0400
Received: from dallas.jonmasters.org ([72.29.103.172]:51501 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754549AbZFIVuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 17:50:51 -0400
Subject: Re: [RFC PATCH 1/1] smi_detector: A System Management Interrupt
 detector
From: Jon Masters <jonathan@jonmasters.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu,
       rostedt@goodmis.org
In-Reply-To: <20090601205720.825d3048.akpm@linux-foundation.org>
References: <20090531163117.502167374@jonmasters.org>
	 <20090531163343.771922592@jonmasters.org>
	 <20090601205720.825d3048.akpm@linux-foundation.org>
Content-Type: text/plain
Organization: World Organi[sz]ation Of Broken Dreams
Date: Tue, 09 Jun 2009 17:50:01 -0400
Message-Id: <1244584201.30733.93.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-06-01 at 20:57 -0700, Andrew Morton wrote:
> On Sun, 31 May 2009 12:31:18 -0400 Jon Masters <jonathan@jonmasters.org> wrote:
> 
> > This patch introduces a new SMI (System Management Interrupt) detector module
> > that can be used to detect high latencies within the system. It was originally
> > written for use in the RT kernel, but has wider applications.
> > 
> 
> Neat-looking code.

Thanks. Finally gotten around to cleaning it up, and renamed it. I think
I should have hwlat_detector out in a few minutes.

> AFACIT it can be used on any platform.

Agreed. I've added a description that is generic in terms of system
hardware latencies - nothing specific to SMIs except in a comment.

> > +	smi_kthread = kthread_run(smi_kthread_fn, NULL,
> > +					"smi_detector");
> > +	if (!smi_kthread) {
> 
> You'll need an IS_ERR() test here.

Thanks. I realized later that I did, because there's no reason that the
value returned couldn't, in theory, change someday (recent zero page
discussions notwithstanding).

> > +	if (0 != err)
> 
> 	if (err != 0)
> 
> or
> 
> 	if (err)
> 
> would be more typical.

The former runs the risk of assignment, whereas <value> != <variable>
will generate a compiler error if it goes wrong, so I trained myself to
always do that. The desired value is zero, so I prefer to show that in
the test, but I have changed it following your advice anyway - it's like
how I have to force myself not to use '{' '}' on single line
if-statements despite generally doing so, again for safety :)

> There's a lot of code duplication amongst all these debugfs write()
> handlers.  Can a common helper be used?

I originally used the generic debugfs _u|s<blah> functions to just
read/write from the variables directly but then needed some side effects
- but in any case, the generic functions don't offer any locking AFAIK.
I'm adding a little helper function instead.

> > +static int smi_debug_sample_fopen(struct inode *inode, struct file *filp)
> > +{
> > +	int ret = 0;
> > +
> > +	mutex_lock(&smi_data.lock);
> > +	if (atomic_read(&smi_data.sample_open))
> > +		ret = -EBUSY;
> > +	else
> > +		atomic_inc(&smi_data.sample_open);
> > +	mutex_unlock(&smi_data.lock);
> > +
> > +	return ret;
> > +}
> 
> It's strange to use a lock to protect an atomic_t.  A simple
> atomic_add_unless() might suffice.

You're right. I was just being pedantic to use the lock every time. I'll
take that out and wrap it with an _unless, I think.

Jon.


