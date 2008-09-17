Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYIQNlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYIQNlp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 09:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752321AbYIQNl2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 09:41:28 -0400
Received: from casper.infradead.org ([85.118.1.10]:50573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbYIQNl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 09:41:27 -0400
Date: Wed, 17 Sep 2008 06:41:28 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       torvalds@linux-foundation.org, davem@davemloft.net
Subject: Re: warn: Turn the netdev timeout WARN_ON() into a WARN()
Message-ID: <20080917064128.2b2f8616@linux.intel.com>
In-Reply-To: <20080917032708.GA8431@havoc.gtf.org>
References: <200809170259.m8H2xClI020907@hera.kernel.org>
	<20080917032708.GA8431@havoc.gtf.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008 23:27:08 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> On Wed, Sep 17, 2008 at 02:59:12AM +0000, Linux Kernel Mailing List
> wrote:
> 
> hrm, am I misunderstanding?
> 
> AFAICS, this change means the user is no longer notified [after
> the first time] of a condition they really need to know about --
> a hardware or driver bug.
> 
> These conditions can occur many hours or days apart, and the admin
> needs to know EACH time it occurs, because it is a major networking
> event, generally leading to a complete reset of the entire hardware.

ok fair enough; the patch below drops the _ONCE

> 
> And quite honestly, the backtrace is not useful (yes, even the one
> that existing previously)...  THINK for a second.  The backtrace
> is going to look exactly the same, since it is a timer-triggered
> dev_watchdog() call.
> 
> NETDEV WATCHDOG timeouts are not easily fixable errors like lockdep
> warnings, and the admin really does need to see each one.
> 
> Unless I am missing something, (1) this patch should be reverted,

.. or rather changed as below ..

> and in additional, (2) I recommend removing the WARN_ON_ONCE()
> because the backtrace is not helpful.

I disagree on your (2):
First of all, you say that these messages are really critical for the
admin; well, a WARN() is a much more critical message than a printk, and
tends to get a lot more attention to it.
Second, a WARN() is about giving a set of standard information so that
the bugreports we get are more useful the first time. Yes a backtrace
is part of that, and yes you're right just the backtrace won't have new
information here, but a WARN() message also contains things such as the
kernel version, the loaded modules and is generally easier for a user
to make a good bugreport from. That one component of it isn't going to
contain new information so be it.
Third, by using this standardized format, computer programs such as
the kerneloops tools can automatically collect these reports and do
statistics on them.

Your argument that these are not easily fixable may be valid, but
they're as you say serious issues, and at least some portion can be
fixed by doing driver work; I just got an email from an ATL1E developer
as a result of my oopsreport who said he was fixing such issues the
last week for example. If all the networking guys agree that the report
has no value for developers because they're all unfixable hardware bugs,
I'm happy to stop tracking it in kerneloops.org, but I get the impression 
so far that that is not the case.




From: Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH] net: WARN_ONCE -> WARN as requested by Jeff Garzik

Jeff points out that you want to see each and every
timeout message

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 net/sched/sch_generic.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index ec0a083..8772642 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -215,7 +215,7 @@ static void dev_watchdog(unsigned long arg)
 			    time_after(jiffies, (dev->trans_start +
 						 dev->watchdog_timeo))) {
 				char drivername[64];
-				WARN_ONCE(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
+				WARN(1, KERN_INFO "NETDEV WATCHDOG: %s (%s): transmit timed out\n",
 				       dev->name, netdev_drivername(dev, drivername, 64));
 				dev->tx_timeout(dev);
 			}
-- 
1.5.5.1



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
