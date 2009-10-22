Return-Path: <linux-kernel-owner+w=401wt.eu-S1753610AbZJVCuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610AbZJVCuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 22:50:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZJVCuK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 22:50:10 -0400
Received: from ausxippc101.us.dell.com ([143.166.85.207]:21117 "EHLO
	ausxippc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbZJVCuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 22:50:10 -0400
X-Loopcount0: from 143.166.82.43
Date: Wed, 21 Oct 2009 21:50:13 -0500
From: Matt Domsch <Matt_Domsch@dell.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Corey Minyard <minyard@acm.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       "Kok, Auke" <auke-jan.h.kok@intel.com>,
       "discuss@LessWatts.org" <discuss@LessWatts.org>,
       "openipmi-developer@lists.sourceforge.net" 
	<openipmi-developer@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: [Discuss] [PATCH] ipmi: use round_jiffies on timers to reduce timer overhead/wakeups
Message-ID: <20091022025013.GB20467@auslistsprd01.us.dell.com>
References: <20091021102822.5b32b2dc.randy.dunlap@oracle.com> <20091021114210.4d7e1ea9@linux.intel.com> <4ADF57D7.7010808@intel.com> <20091021130348.cd521b0c.randy.dunlap@oracle.com> <4ADF6D76.7070409@acm.org> <4ADF75A2.50202@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ADF75A2.50202@linux.intel.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 05:57:06AM +0900, Arjan van de Ven wrote:
> Corey Minyard wrote:
> >Certainly.  Yes, some (probably most) IPMI hardware does not use
> >interrupts, and unfortunately, it's not just older machines.  The driver
> >used to poll more slowly, but in many cases the performance was
> >unacceptable.
> 
> ... but now it burns quite a bit of power (I'd not be surprised if it is 10 
> Watts extra on a 70W server)
> 
> is there any way to poll slowly until there is active ipmi traffic, during 
> which we can then poll a bit faster.
> ... and then go back to slow polling when there is an ipmi idle period ?

I believe that's what the thread does already.  Depending on what
userspace apps are generating IPMI requests though, there may not be a
whole lot of time between requests.  Dell OpenManage software does a
poll of the IPMI sensors, SEL logs, etc. at regular intervals, on the
order of minutes between runs, but during each run there's almost
always an outstanding IPMI command.

The difference was several minutes during startup, and 15 minutes ->
1.5 minutes during a firmware flash, with the kipmi0 thread present.
I've heard requests to have the some userspace control over the
start/stop of that thread, so it could get started only when there are
more time-critical userspace requests to be made (such as during firmware
update), but I've not worked on that part.  We'd need an interface
(sysfs file?) to start/stop the thread, and could adjust userspace to
use that (Dell OpenManage, ipmitool, sblim-cmpi-ipmi, ...).

Though I'm really curious that HP has a KCS+interrupt controller
available.  That gives me hope that the industry-wide problems which
prevented Dell from doing likewise a couple years ago are now
resolved.  I'll have my team look into it again.


-- 
Matt Domsch
Technology Strategist, Dell Office of the CTO
linux.dell.com & www.dell.com/linux
