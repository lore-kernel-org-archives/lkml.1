Return-Path: <linux-kernel-owner+w=401wt.eu-S1760783AbXH1LtO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760783AbXH1LtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:49:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753746AbXH1Ls5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:48:57 -0400
Received: from mtagate2.uk.ibm.com ([195.212.29.135]:14061 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753AbXH1Ls4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:48:56 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: James Chapman <jchapman@katalix.com>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Tue, 28 Aug 2007 13:48:20 +0200
User-Agent: KMail/1.8.2
Cc: David Miller <davem@davemloft.net>, shemminger@linux-foundation.org,
       akepner@sgi.com, netdev@vger.kernel.org, raisch@de.ibm.com,
       themann@de.ibm.com, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, meder@de.ibm.com, tklein@de.ibm.com,
       stefan.roscher@de.ibm.com
References: <46D2F301.7050105@katalix.com> <20070827.145600.102570576.davem@davemloft.net> <46D3E971.4010909@katalix.com>
In-Reply-To: <46D3E971.4010909@katalix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708281348.21302.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 August 2007 11:22, James Chapman wrote:
> > So in this scheme what runs ->poll() to process incoming packets?
> > The hrtimer?
> 
> No, the regular NAPI networking core calls ->poll() as usual; no timers 
> are involved. This scheme simply delays the napi_complete() from the 
> driver so the device stays in the poll list longer. It means that its 
> ->poll() will be called when there is no work to do for 1-2 jiffies, 
> hence the optimization at the top of ->poll() to efficiently handle that 
> case. The device's ->poll() is called by the NAPI core until it has 
> continuously done no work for 1-2 jiffies, at which point it finally 
> does the netif_rx_complete() and re-enables its interrupts.
> 
I'm not sure if I understand your approach correctly.
This approach may reduce the number of interrupts, but it does so
by blocking the CPU for up to 1 jiffy (that can be quite some time
on some platforms). So no other application / tasklet / softIRQ type
can do anything in between. The CPU utilization does not drop at all, 
and I thought that is one reason why we try to reduce the number of interrupts.

> If people feel that holding the device in the poll list for 1-2 jiffies 
> is too long (because there are too many wasted polls), a counter could 
> be used to to delay the netif_rx_complete() by N polls instead. N would 
> be a value depending on CPU speed. I use the jiffy sampling method 
> because it results in some natural randomization of the actual delay 
> depending on when the jiffy value was sampled in relation to the jiffy tick.
> 

Waiting for N polls seems to make no sense if there are no further network adapters
in that machine. It would take no time to call poll N times in a row when no
new packets arrive. There is no real delay as the net_rx_action function will
do nothing else between the poll calls.

Please correct me if I'm wrong.

Regards,
Jan-Bernd
