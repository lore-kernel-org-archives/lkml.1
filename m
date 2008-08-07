Return-Path: <linux-kernel-owner+w=401wt.eu-S1754939AbYHGPvD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbYHGPvD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:51:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752492AbYHGPuv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:50:51 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:59527 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754490AbYHGPuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:50:50 -0400
Message-ID: <489B199B.40305@s5r6.in-berlin.de>
Date: Thu, 07 Aug 2008 17:49:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.16) Gecko/20080702 SeaMonkey/1.1.11
MIME-Version: 1.0
To: jmerkey@wolfmountaingroup.com
CC: linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] mdb-2.6.27-rc2-ia32-08-07-08.patch
References: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
In-Reply-To: <1300.69.2.248.210.1218119365.squirrel@webmail.wolfmountaingroup.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jmerkey@wolfmountaingroup.com wrote:
> The mdb-rc2 patch was posted this morning with the changes for a modular
> kernel debugger using kprobes.
> 
> ftp://ftp.wolfmountaingroup.org/pub/mdb/mdb-2.6.27-rc2-ia32-08-07-08.patch
> 
> Jeffrey Vernon Merkey


Quoting from this patch:

> +typedef struct _RLOCK 
> +{
> +#if defined(CONFIG_SMP)
> +    spinlock_t lock;
> +#endif
> +    unsigned long flags;
> +    unsigned long processor;
> +    unsigned long count;    
> +} rlock_t;

Is this something along the lines of a counting semaphore?  As far as I
understand its accessor functions, an rlock
  - can be taken by one CPU multiple times,
  - will block the other CPUs as long as the first CPU hasn't unlocked
    the rlock as many times as it locked it.

The accessors rspin_lock() and rspin_try_lock() peek into spinlock_t and
may therefore not be fully portable.  Also, they and rspin_unlock()
don't look SMP safe:

> +//
> +//   returns   0 - atomic lock occurred, processor assigned
> +//             1 - recusive count increased
> +//
> +
> +unsigned long rspin_lock(volatile rlock_t *rlock)
> +{
> +#if defined(CONFIG_SMP)
> +   register unsigned long proc = get_processor_id();
> +   register unsigned long retCode;
> +
> +   if (rlock->lock.raw_lock.slock && rlock->processor == proc)
> +   {
> +      rlock->count++;
> +      retCode = 1;
> +   }
> +   else
> +   {
> +      spin_lock_irqsave((spinlock_t *)&rlock->lock, rlock->flags);
> +      rlock->processor = proc;
> +      retCode = 0;
> +   }
> +   return retCode;
> +#else
> +   return 0;
> +#endif
> +}

In general, a lot can happen between the access to
rlock->lock.raw_lock.slock and the access to rlock->processor.

Even rlock->count++ in itself can go wrong.

The usage of "volatile" here looks a lot like DWIM to me.


> +volatile unsigned long debuggerActive;
> +volatile unsigned long ProcessorHold[MAX_PROCESSORS]; 
> +volatile unsigned long ProcessorState[MAX_PROCESSORS]; 
> +volatile unsigned long ProcessorMode[MAX_PROCESSORS]; 

Are these datasets shared between CPUs and do you access them without
lock protection?  (It looks like that from a quick glance.)  If yes,
instead of the volatile qualifier, can't you use memory barriers in
order to define the access semantics more clearly (and more effective)
than volatile can?

If there are interdependencies in these datasets, with which mechanisms
if not locks do you serialize critical sections?


> +void MDBInitializeDebugger(void)
> +{
...
> +   for (i=0; i < MAX_PROCESSORS; i++)
> +   {
> +      BreakMask[i] = 0;
> +      ProcessorHold[i] = 0; 
> +      ProcessorState[i] = 0; 
> +      ProcessorMode[i] = 0; 
> +   }

Not necessary, because static (and extern) variables are already
implicitly initialized to zero.
-- 
Stefan Richter
-=====-==--- =--- --===
http://arcgraph.de/sr/
