Return-Path: <linux-kernel-owner+w=401wt.eu-S1752005AbZH1Gt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbZH1Gt3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 02:49:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751889AbZH1Gt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 02:49:29 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:1375 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZH1Gt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 02:49:28 -0400
X-SourceIP: 213.93.53.227
Subject: Re: [PATCH 2/4]: CPUIDLE: Introduce architecture independent
 cpuidle_pm_idle in drivers/cpuidle/cpuidle.c
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: arun@linux.vnet.ibm.com
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Joel Schopp <jschopp@austin.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>,
       "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <20090828061434.GA11863@linux.vnet.ibm.com>
References: <20090827114908.GA24986@linux.vnet.ibm.com>
	 <20090827115354.GC24986@linux.vnet.ibm.com>
	 <1251377607.18584.96.camel@twins>
	 <20090828061434.GA11863@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 28 Aug 2009 08:48:05 +0200
Message-Id: <1251442085.18584.120.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-28 at 11:44 +0530, Arun R Bharadwaj wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2009-08-27 14:53:27]:
> 
> Hi Peter, Ben,
> 
> I've put the whole thing in a sort of a block diagram. Hope it
> explains things more clearly.
> 
> 
> 
> 
> 
> 
> 				----------------
> 				|    CPUIDLE   |  (Select idle states like
> 				|   GOVERNORS  |   C1, C1e, C6 etc in case
> 				| (Menu/Ladder)|   x86 & nap, snooze in
> 				|	       |   case of POWER - based on
> 				----------------   latency & power req)
> 					^
> 					|
> 					|
> 					|
> 					|
> 					|
>   ----------			-----------------	         -------------
>   |	   |			|		|	         |  PSERIES  |
>   |  ACPI  |------------------>	|    CPUIDLE	| <--------------|   IDLE    |
>   |	   |			|		|	         |           |
>   ----------			-----------------	         -------------
> 
> Main idle routine- pm_idle()			         Main idle routine-
> 							     ppc_md.power_save()
> 
> pm_idle = cpuidle_pm_idle;			         ppc_md.power_save =
> (start using cpuidle's idle				      cpuidle_pm_idle();
>  loop, which internally calls
>  governor to select the right
>  state to go into).
> 
> 
> Relavent code snippet from drivers/cpuidle/cpuidle.c
> -------------------------------------
> 
> static void cpuidle_idle_call(void)
> {
> 	............
> 	............
> 
> 	/* Call the menu_select() to select the idle state to enter. */
> 	next_state = cpuidle_curr_governor->select(dev);
> 
> 	............
> 	............
> 
> 	/*
> 	 * Enter the idle state previously selected. target_state->enter
> 	 * would call pseries_cpuidle_loop() which selects nap/snooze
> 	 * /
> 	dev->last_residency = target_state->enter(dev, target_state);
> }
> 
> void cpuidle_install_idle_handler(void)
> {
> 	.........
> 	.........
> 	cpuidle_pm_idle = cpuidle_idle_call;
> }

All I'm seeing here is a frigging mess.

How on earths can something called: cpuidle_install_idle_handler() have
a void argument, _WHAT_ handler is it going to install?

So somehow you added to the ACPI mess by now having 3 wild function
pointers, that's _NOT_ progress.

