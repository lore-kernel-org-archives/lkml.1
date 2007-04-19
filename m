Return-Path: <linux-kernel-owner+w=401wt.eu-S1031156AbXDSGew@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031156AbXDSGew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 02:34:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031159AbXDSGew
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 02:34:52 -0400
Received: from mail.bmlv.gv.at ([193.171.152.37]:53178 "EHLO mail.bmlv.gv.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031156AbXDSGew (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 02:34:52 -0400
X-Greylist: delayed 1315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Apr 2007 02:34:51 EDT
From: "Ph. Marek" <philipp.marek@bmlv.gv.at>
To: linux-kernel@vger.kernel.org
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
Date: Thu, 19 Apr 2007 08:11:16 +0200
User-Agent: KMail/1.9.5
References: <E1HOuCl-0000K8-3c@mx1.bon.at>
In-Reply-To: <E1HOuCl-0000K8-3c@mx1.bon.at>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704190811.17290.philipp.marek@bmlv.gv.at>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Pine.LNX.4.64.0704181515290.25880 () alien ! or ! mcafeemobile ! com

Davide Libenzi wrote:
> On Wed, 18 Apr 2007, Ingo Molnar wrote:
> > That's one reason why i dont think it's necessarily a good idea to
> > group-schedule threads, we dont really want to do a per thread group
> > percpu_alloc().
>
> I still do not have clear how much overhead this will bring into the
> table, but I think (like Linus was pointing out) the hierarchy should look
> like:
...
> The "run_queue" concept (and data) that now is bound to a CPU, need to be
> replicated in:
>
> ROOT <- VCPUs add themselves here
>     VCPU <- USERs add themselves here
>         USER <- PROCs add themselves here
>             PROC <- THREADs add themselves here
>                 THREAD (ultimate fine grained scheduling unit)
>
> So ROOT, VCPU, USER and PROC will have their own "run_queue". 
...

I can't comment on the internals about run_queues, overhead and so on, but 
these discussion leads me to the idea about a dynamic *tree* of scheduler 
queues.

With dynamic I mean that they are configured in user-space - be it with 
something like CLONE_NEW_SCHEDULER_CLASS, or possibly better some other 
interface to allow an *arbitrary* tree that is not coupled on the 
user/process/thread borders. New threads and processes are per default 
created in the parents queue, just like now.

So user-space could build an tree like this (eg with a pam module):

 Default queue - init
   +- kernel-thread queue (to avoid having kernel threads being blocked by
   |               user-space)
   +- cron, atd, sshd, .... unless they change their "class"
   +- user1
   |  +- X
   |  +- kde
   |  |  + konsole
   |  |  \ kmail
   |  |    + mail fetch thread
   |  |    + mail filter thread
   |  |    + GUI thread
   |  |  \- mplayer 
   \- user2
      +.....

Whether the queues are handled with some staircase behaviour, or CFS, or just 
get CPU time distributed by nice level, is another question - but they have 
to be "fair" only locally.

Of course, that's simply some sort of moving the problem into user-space - but 
I think (and read that often enough) that the needs vary so much that a 
single, hardcoded system won't suffice. And we can try to get the "right" 
behaviour in each queue, just like now.

Walking the tree might make the scheduler not fully O(1) - but per default 
only one queue is defined (or possibly two queues, one for kernel threads), 
and everything else can be done by user-space.


The mentioned case of a web-server with gzip started would be done with having 
each httpd being in a queue just below init, and having everything else in 
another - or by nicing the webserver, as it's defined as "important".
(I believe that's called "moving policy into userspace" :-)


Regards,

Phil
