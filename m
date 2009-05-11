Return-Path: <linux-kernel-owner+w=401wt.eu-S1754690AbZEKHf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbZEKHf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 03:35:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751409AbZEKHfQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 03:35:16 -0400
Received: from mtagate1.de.ibm.com ([195.212.17.161]:50873 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752203AbZEKHfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 03:35:14 -0400
Date: Mon, 11 May 2009 09:35:12 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Michael Abbott <michael@araneidae.co.uk>
Cc: Jan Engelhardt <jengelh@medozas.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Re: /proc/uptime idle counter remains at 0
Message-ID: <20090511093512.38ba9b70@skybase>
In-Reply-To: <Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
References: <alpine.LSU.2.00.0905090957490.27646@fbirervta.pbzchgretzou.qr>
	<20090510191229.71f43f3c@skybase>
	<alpine.LSU.2.00.0905110237310.17675@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0905110656180.6983@venus.araneidae.co.uk>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 07:23:58 +0100 (BST)
Michael Abbott <michael@araneidae.co.uk> wrote:

> On Mon, 11 May 2009, Jan Engelhardt wrote:
> > On Sunday 2009-05-10 19:12, Martin Schwidefsky wrote:
> > >> So, were the updates to uptime.c missed, or do we now live on with 
> > >> /proc/uptime constantly having 0?
> 
> Please, let's not do this -- it breaks my instrument (which currently 
> thinks the processor is overloaded).

Hmm, bad..

> I have to confess I don't really understand the logic of what's going on 
> here -- in particular, what does the idle process do other than account 
> for time when the processor has nothing useful to do?  It does seem to me 
> now that the .utime and .stime fields are now less than useful -- maybe 
> they can be deleted now?

The idle task does not just sleep, it will do "real" work, e.g. softirq
handling for interrupts / network traffic. This is added to the stime
field of the idle process and it does carry some information. And
deleting these fields won't be possible as utime/stime are needed for
the other processes as well. To selectively remove them for the idle
process doesn't make sense to me.
 
> I've always assumed that the second field of /proc/uptime was a simple 
> measure of time not spent doing real work, in other words a crude measure 
> of spare CPU resources.  My instrument basically uses the the two fields 
> of this file to compute a measure of CPU loading so it can raise an alert 
> if the CPU doesn't have enough spare (idle) capacity.

But it wasn't.. the old style stime of idle is a mixture of true idle
time and some system time.

> So as a simple solution, I've attached a patch where I just copy the idle 
> field processing from fs/proc/stat.c.  I expect that on a multi-processor 
> machine things may not be quite so simple -- as up time is in elapsed 
> wall-clock time, then so should idle time be, so we probably need to also 
> divide by the number of processors.  Afraid I don't have a multiprocessor 
> test system, and /proc/stat seems ok, so I've not made this refinement.

Yes, on a multiprocessor in particular with cpu hotplug you need
additional information to be able to interpret the number. I still like
the patch because it gives the field a defined semantic: the total time
spent by the activated cpus waiting for work measured in cputime terms.
The semantic is still different from the old style number though.

For whom it matters:
Acked-by: Martin Schwidefsky <schwidefsky@de.ibm.com>

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

