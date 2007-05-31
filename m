Return-Path: <linux-kernel-owner+w=401wt.eu-S1760572AbXEaQsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760572AbXEaQsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 12:48:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756013AbXEaQsc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 12:48:32 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:43953 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbXEaQsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 12:48:31 -0400
Subject: Re: [BUG] futex_unlock_pi() hurts my brain and may cause
	application deadlock
From: john stultz <johnstul@us.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Oleg Nesterov <oleg@tv-sign.ru>,
       Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
In-Reply-To: <20070531145555.GA24218@elte.hu>
References: <1180572567.6126.44.camel@localhost.localdomain>
	 <20070531142455.GA11310@elte.hu> <1180623027.17878.2.camel@localhost>
	 <20070531145555.GA24218@elte.hu>
Content-Type: text/plain
Date: Thu, 31 May 2007 09:48:27 -0700
Message-Id: <1180630107.17878.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-05-31 at 16:55 +0200, Ingo Molnar wrote:
> * john stultz <johnstul@us.ibm.com> wrote:
> 
> > > > --- a/kernel/futex.c
> > > > +++ b/kernel/futex.c
> > > > @@ -2011,6 +2011,7 @@ pi_faulted:
> > > >  					 attempt);
> > > >  		if (ret)
> > > >  			goto out_unlock;
> > > > +		uval = 0;
> > > >  		goto retry_locked;
> > > 
> > > this looks good to me. Oleg has posted a few more fixes as well - 
> > > have you tried those too?
> > 
> > Do you have a URL or subject line for the discussion? I'll take a look 
> > and give them a whirl.
> 
> i meant to say Alexey, not Oleg :-) Here's the thread:
> 
>    http://lkml.org/lkml/2007/5/7/129
> 
> i've Cc:-ed Alexey too.

I haven't had a chance to run it, but reviewing at Alexey's changes,
they do not look to be sufficient to the issue we were hitting. We still
need to clear uval to avoid  -EFAULT &'ing w/ FUTEX_OWNER_DIED.


Here's the patch against -rt9 (which also contains Alexey's fix)


diff -rup 2.6-rt/kernel/futex.c 2.6-rtnew/kernel/futex.c
--- 2.6-rt/kernel/futex.c	2007-05-31 06:38:00.000000000 -0500
+++ 2.6-rtnew/kernel/futex.c	2007-05-31 06:43:08.000000000 -0500
@@ -1954,6 +1954,7 @@ pi_faulted:
 			ret = -EFAULT;
 			goto out_unlock;
 		}
+		uval = 0;
 		goto retry_locked;
 	}
 
@@ -3503,6 +3504,7 @@ pi_faulted:
 			ret = -EFAULT;
 			goto out_unlock;
 		}
+		uval = 0;
 		goto retry_locked;
 	}
 



