Return-Path: <linux-kernel-owner+w=401wt.eu-S1751936AbZH1GOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbZH1GOj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:14:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751830AbZH1GOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:14:38 -0400
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:46296 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751721AbZH1GOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:14:38 -0400
Date: Fri, 28 Aug 2009 11:44:34 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joel Schopp <jschopp@austin.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
       Arun Bharadwaj <arun@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
	cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
Message-ID: <20090828061434.GA11863@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
References: <20090827114908.GA24986@linux.vnet.ibm.com> <20090827115354.GC24986@linux.vnet.ibm.com> <1251377607.18584.96.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1251377607.18584.96.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-08-27 14:53:27]:

Hi Peter, Ben,

I've put the whole thing in a sort of a block diagram. Hope it
explains things more clearly.






				----------------
				|    CPUIDLE   |  (Select idle states like
				|   GOVERNORS  |   C1, C1e, C6 etc in case
				| (Menu/Ladder)|   x86 & nap, snooze in
				|	       |   case of POWER - based on
				----------------   latency & power req)
					^
					|
					|
					|
					|
					|
  ----------			-----------------	         -------------
  |	   |			|		|	         |  PSERIES  |
  |  ACPI  |------------------>	|    CPUIDLE	| <--------------|   IDLE    |
  |	   |			|		|	         |           |
  ----------			-----------------	         -------------

Main idle routine- pm_idle()			         Main idle routine-
							     ppc_md.power_save()

pm_idle = cpuidle_pm_idle;			         ppc_md.power_save =
(start using cpuidle's idle				      cpuidle_pm_idle();
 loop, which internally calls
 governor to select the right
 state to go into).


Relavent code snippet from drivers/cpuidle/cpuidle.c
-------------------------------------

static void cpuidle_idle_call(void)
{
	............
	............

	/* Call the menu_select() to select the idle state to enter. */
	next_state = cpuidle_curr_governor->select(dev);

	............
	............

	/*
	 * Enter the idle state previously selected. target_state->enter
	 * would call pseries_cpuidle_loop() which selects nap/snooze
	 * /
	dev->last_residency = target_state->enter(dev, target_state);
}

void cpuidle_install_idle_handler(void)
{
	.........
	.........
	cpuidle_pm_idle = cpuidle_idle_call;
}

--arun
