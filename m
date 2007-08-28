Return-Path: <linux-kernel-owner+w=401wt.eu-S1760501AbXH1LTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760501AbXH1LTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 07:19:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755921AbXH1LTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 07:19:08 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:52000 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755235AbXH1LTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 07:19:06 -0400
From: Jan-Bernd Themann <ossthema@de.ibm.com>
To: David Miller <davem@davemloft.net>
Subject: Re: RFC: issues concerning the next NAPI interface
Date: Tue, 28 Aug 2007 13:19:03 +0200
User-Agent: KMail/1.8.2
Cc: jchapman@katalix.com, shemminger@linux-foundation.org, akepner@sgi.com,
       netdev@vger.kernel.org, raisch@de.ibm.com, themann@de.ibm.com,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, meder@de.ibm.com,
       tklein@de.ibm.com, stefan.roscher@de.ibm.com
References: <46D1D634.7060007@katalix.com> <200708271147.01890.ossthema@de.ibm.com> <20070827.133721.59473971.davem@davemloft.net>
In-Reply-To: <20070827.133721.59473971.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200708281319.03903.ossthema@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 22:37, David Miller wrote:
> From: Jan-Bernd Themann <ossthema@de.ibm.com>
> Date: Mon, 27 Aug 2007 11:47:01 +0200
> 
> > So the question is simply: Do we want drivers that need (benefit
> > from) a timer based polling support to implement their own timers
> > each, or should there be a generic support?
> 
> I'm trying to figure out how an hrtimer implementation would
> even work.
> 
> Would you start the timer from the chip interrupt handler?  If so,
> that's taking two steps backwards as you've already taken all of the
> overhead of running the interrupt handler.

I'm also still trying to understand how hrtimer work exactly. 
The implementation of hrtimers for P6 has not been finished yet, so
I can't do experiments with hrtimers and eHEA now.

I will try the following scheme (once we get hrtimers):
Each device (queue) has a hrtimer.
Schedule the timer in the poll function instead of reactivating IRQs
when a high load situation has been detected and all packets have
been emptied from the receive queue.
The timer function could then just call netif_rx_schedule to register
the rx_queue for NAPI again. 

The advantages of this scheme (if it works as I understood it) would be:
- we don't have to modify NAPI
- benefit from fairness amoung rx_queues / network devices 
- The poll function can decide how long to stick to the timer based
  polling mode, and when to switch back to it's HW IRQs.
- driver can determine the time to wait based on the receive queue length and
  speed

Regards,
Jan-Bernd
