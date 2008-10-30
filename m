Return-Path: <linux-kernel-owner+w=401wt.eu-S1756076AbYJ3B0T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076AbYJ3B0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 21:26:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756457AbYJ3BZq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 21:25:46 -0400
Received: from mga01.intel.com ([192.55.52.88]:33185 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753623AbYJ3BZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 21:25:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,510,1220252400"; 
   d="scan'208";a="633169091"
Subject: Re: [2.6.28-rc2] EeePC ACPI errors & exceptions
From: Zhao Yakui <yakui.zhao@intel.com>
To: Alexey Starikovskiy <aystarik@gmail.com>
Cc: Darren Salt <linux@youmustbejoking.demon.co.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
In-Reply-To: <49082D09.8060102@gmail.com>
References: <alpine.LFD.2.00.0810261221350.3386@nehalem.linux-foundation.org>
	 <4FFA7B13E0%linux@youmustbejoking.demon.co.uk>
	 <1225186966.5189.143.camel@yakui_zhao.sh.intel.com>
	 <4FFABF28C8%linux@youmustbejoking.demon.co.uk> <49077A13.7020603@gmail.com>
	 <1225265974.5189.189.camel@yakui_zhao.sh.intel.com>
	 <49082D09.8060102@gmail.com>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 09:32:24 +0800
Message-Id: <1225330344.5189.282.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 17:29 +0800, Alexey Starikovskiy wrote:
> Not a problem, just find the root cause. Or shut up.
Maybe you don't read the explanation I have written.
> 
> Zhao Yakui wrote:
> > On Tue, 2008-10-28 at 13:46 -0700, Alexey Starikovskiy wrote:
> >   
> >> Hi Darren,
> >>
> >> Please check if the patch 
> >> http://marc.info/?l=linux-acpi&m=122516784917952&w=4
> >> helps.
> >>     
> > In the attached patch the msleep is replaced by udelay gain. 
> >    In the following commit the udelay is replaced by msleep. 
> >    >commit 1b7fc5aae8867046f8d3d45808309d5b7f2e036a
> >    >Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> >    >Date:   Fri Jun 6 11:49:33 2008 -0400
> >      >ACPI: EC: Use msleep instead of udelay while waiting for event
> >    
> >    After the problem happens again, the udelay is restored again before
> > getting the root cause. 
> >    Maybe we should find the root cause of the problem and change the
> > working flowchart about the EC driver. It is inappropriate that we make
> > some changes and it is reverted again when the problem happens.
> >    
> >    At the same time after mlseep is replaced by the udelay, the CPU will
> > do thing but loop while doing EC transaction on some laptops (In the
> > function of ec_poll). If 100 EC transactions are done, the CPU will do
> > nothing but loop at least for 100*2*100 microseconds. In such case maybe
> > the performance will be affected.
> >
> >   After the following commit is merged, the EC transaction will be
> > executed in EC GPE interrupt context on most laptops.Maybe it is easier.
> > But for the some laptops it can't be done in EC GPE interrupt context.
> > So it falls back to the EC polling mode. (This is realized by the
> > function of ec_poll).
> >     >commit 7c6db4e050601f359081fde418ca6dc4fc2d0011
> >     >Author: Alexey Starikovskiy <astarikovskiy@suse.de>
> >     >Date:   Thu Sep 25 21:00:31 2008 +0400
> >        >ACPI: EC: do transaction from interrupt context
> >  
The following is the detailed explanation why this issue happens. In
fact after you sent your patch, I raise the issue about it. But it is
ignored. (Maybe the AE_TIME will be returned by EC driver. But the
reason is not caused by that EC controller can't update its status in
time. Instead it is caused by that host has no opportunity to issue the
sequence EC command.)
>   
> >    Why is AE_TIME sometimes returned by the function of ec_poll?
> >   
> >> static int ec_poll(struct acpi_ec *ec)
> >>     
> > {
> >         unsigned long delay = jiffies + msecs_to_jiffies(ACPI_EC_DELAY);
> >         msleep(1);
> > // Maybe the current jiffies is already after the predefined jiffies
> > after msleep(1). In such case the ETIME will be returned. Of course the
> > EC transaction can't be finished. If so, IMO this is not reasonable as
> > this is caused by that OS has no opportunity to issue the following EC
> > command sequence.
> >         while (time_before(jiffies, delay)) {
> >                 gpe_transaction(ec, acpi_ec_read_status(ec));
> >                 msleep(1);
> >                 if (ec_transaction_done(ec))
> >                         return 0;
> > //Maybe there exists the following cases. EC transaction is not finished
> > after msleep(1),but the current jiffies is already after predefined
> > jiffies. So ETIME is returned. In such case, IMO this is also not
> > reasonable.
> >         }
> >         return -ETIME;
> > }
> >      At the same time msleep is realized by schedule_timeout. On linux
> > although one process is waked up by some events, it won't be scheduled
> > immediately. So maybe the current jiffies is already after the
> > predefined timeout jiffies  after msleep(1). 
> >     Although the possibility of this issue can be reduced by that msleep
> > is replaced by udelay,maybe the issue still exists if the preempt
> > schedule happens at the corresponding place.
> >
> >     In the above case the ETIME will be returned by ec_poll. But the
> > reason is not that EC controller can't update its status in time.
> > Instead it is caused by that host has no opportunity to issue the
> > sequence operation in the current work flowchart. In current EC work
> > flowchart the EC transaction is done in a big loop. 
> >     
> >     Maybe the better solution is that the EC transaction is explicitly
> > divided into several different phases. 
> >
> >     Maybe my analysis is not correct. If so, please correct me. 
> > Welcome the comments.
> >
> >     thanks.
> >     
> >     
> >      
> >   
> >> Thanks,
> >> Alex.
> >>
> >>
> >>     
> >
> >   
> 

