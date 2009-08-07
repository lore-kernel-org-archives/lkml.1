Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbZHGWRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbZHGWRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 18:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZHGWRX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 18:17:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57692 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755151AbZHGWRW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 18:17:22 -0400
Date: Fri, 7 Aug 2009 15:16:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stefani Seibold <stefani@seibold.net>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix proc_file_write missing ppos update
Message-Id: <20090807151657.d577dd2d.akpm@linux-foundation.org>
In-Reply-To: <1249681387.17422.10.camel@wall-e>
References: <1249676830.27640.16.camel@wall-e>
	<20090807135806.ffd068e9.akpm@linux-foundation.org>
	<1249681387.17422.10.camel@wall-e>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 07 Aug 2009 23:43:07 +0200
Stefani Seibold <stefani@seibold.net> wrote:

> > > +			*ppos += rv;
> > >  	}
> > >  	return rv;
> > >  }
> > 
> > Yes, that's odd.
> > 
> > I worry that there might be procfs write handlers which are looking at
> > *ppos and whose behaviour might be altered by this patch.
> > 
> > <searches a bit>
> > 
> > Look at arch/s390/appldata/appldata_base.c:appldata_timer_handler().
> > 
> > static int
> > appldata_timer_handler(ctl_table *ctl, int write, struct file *filp,
> > 			   void __user *buffer, size_t *lenp, loff_t *ppos)
> > {
> > 	int len;
> > 	char buf[2];
> > 
> > 	if (!*lenp || *ppos) {
> > 		*lenp = 0;
> > 		return 0;
> > 	}
> > 
> > 
> 
> This function will be handled IMHO by the proc_sys_call_handler which
> has nothing to do with the proc_file_write.
> /proc/sys/... file access should be not touched because there are
> handled differently. 

hm, OK, fail.

> > Prior to your change, an application which opened that proc file and
> > repeatedly wrote to the fd would repeatedly start and stop the timer.
> > 
> > After your change, the second and successive writes would have no
> > effect unless the application was changed to lseek back to the start of
> > the "file".
> > 
> > And that was just the second file I looked at via
> > 
> > 	$EDITOR $(grep -l '[*]ppos' $(grep -rl _proc_ .))
> 
> Yes, i think you are right, i have forseen also that there maybe some
> pitfalls. The question is: is there any appplication which will be
> broken by this patch?

There is no way of telling.  We have to assume that there will be such
code out there.

> So what is your suggestion? Should we drop this patch or should we
> analyze the users and fix it?

Well.

We could review all implementations of ->write_proc.  There only seem
to be twenty or so.

If any of them will have their behaviour altered by this patch then
let's look at those on a case-by-case basis and decide whether making
this change will have an acceptable risk.

If we _do_ find one for which we simply cannot make this behavioural
change then..  ugh.  We could perhaps add a new `bool
proc_dir_entry.implement_old_broken_behaviour' and set that flag for
the offending driver(s) and test it within proc_write_file().

Or we could do

	if (pde->write_proc_new) {
		rv = pde->write_proc_new(file, buffer, count, pde->data);
		*ppos += rv;
	} else {
		rv = pde->write_proc(file, buffer, count, pde->data);
	}

which is really the same thing and isn't obviously better ;)

> My opinion is to fix it, because it is wrong and it limits the usage of
> the proc_write operation. Many embedded developers like me count on proc
> support, because it is much simpler to use than the seqfile thing.
> 
