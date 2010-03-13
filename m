Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab0CMMbN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 07:31:13 -0500
Received: from www84.your-server.de ([213.133.104.84]:57283 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755144Ab0CMMbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 07:31:10 -0500
Subject: Re: [Patch] fix MTD CFI/LPDDR flash driver huge latency bug
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Kreuzer, Michael (NSN - DE/Ulm)" <michael.kreuzer@nsn.com>
In-Reply-To: <20100312142344.174bd46f.akpm@linux-foundation.org>
References: <1267894137.18869.0.camel@wall-e>
	 <20100312142344.174bd46f.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Sat, 13 Mar 2010 13:31:30 +0100
Message-ID: <1268483490.6339.21.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, den 12.03.2010, 14:23 -0800 schrieb Andrew Morton:
> On Sat, 06 Mar 2010 17:48:57 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > This patch fix a huge latency problem in the MTD CFI and LPDDR flash
> > drivers.
> > 
> > The use of a memcpy() during a spinlock operation will cause very long
> > thread context switch delays if the flash chip bandwidth is low and the
> > data to be copied large, because a spinlock will disable preemption.
> > 
> > For example: A flash with 6,5 MB/s bandwidth will cause under ubifs,
> > which request sometimes 128 KB (the flash erase size), a preemption
> > delay of 20 milliseconds. High priority threads will not be served
> > during this time, regardless whether this threads access the flash or
> > not. This behavior breaks real time.
> > 
> > The patch change all the use of spin_lock operations for xxxx->mutex
> > into mutex operations, which is exact what the name says and means. 
> > 
> > There is no performance regression since the mutex is normally not
> > acquired.
> 
> hm, big scary patch.  Are you sure this mutex is never taken from
> atomic or irq contexts?  Is it ully tested with all relevant debug options
> and lockdep enabled?
> 
> 

I have analyzed this drivers and IMHO i don't think there will be used
from irq or atomic contexts. There is no request interrupt and there are
a lot msleep and add_wait_queues/schedule calls during holding the
mutex, which are not very useful in a irq or atomic context. But i don't
know the whole mtd stack. 

I tested the patch with the following kernel debug options:

CONFIG_DEBUG_KERNEL=y
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_BOOTPARAM_SOFTLOCKUP_PANIC_VALUE=0
CONFIG_SCHED_DEBUG=y
CONFIG_SCHEDSTATS=y
CONFIG_TIMER_STATS=y
CONFIG_DEBUG_MUTEXES=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y


