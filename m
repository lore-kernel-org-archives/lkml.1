Return-Path: <linux-kernel-owner+w=401wt.eu-S1751625AbZH1MD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751625AbZH1MD6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 08:03:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbZH1MD6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 08:03:58 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:36461 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZH1MD5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 08:03:57 -0400
X-SpamScore: 2
X-BigFish: VPS2(z34a4jz1432R98dN936eMa594izz1202hzz3198u327alz32i6bh203h43j61h)
X-Spam-TCS-SCL: 0:0
X-FB-SS: 5,
X-WSS-ID: 0KP35IC-01-QWS-02
X-M-MSG: 
Date: Fri, 28 Aug 2009 14:03:32 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/15] x86: Fix cpu_coregroup_mask to return correct
	cpumask on multi-node processors
Message-ID: <20090828120332.GH13576@alberich.amd.com>
References: <20090820131243.GO29327@alberich.amd.com> <20090820134604.GD29327@alberich.amd.com> <1251128176.7538.301.camel@twins> <20090825093101.GJ20811@alberich.amd.com> <1251194143.7538.1128.camel@twins> <20090827152551.GE13576@alberich.amd.com> <1251455984.17617.5.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <1251455984.17617.5.camel@laptop>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 28 Aug 2009 12:03:32.0835 (UTC) FILETIME=[90726B30:01CA27D7]
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 28, 2009 at 12:39:44PM +0200, Peter Zijlstra wrote:
> On Thu, 2009-08-27 at 17:25 +0200, Andreas Herrmann wrote:
> > On Tue, Aug 25, 2009 at 11:55:43AM +0200, Peter Zijlstra wrote:
> > > On Tue, 2009-08-25 at 11:31 +0200, Andreas Herrmann wrote:
> > > > On Mon, Aug 24, 2009 at 05:36:16PM +0200, Peter Zijlstra wrote:
> > > > > On Thu, 2009-08-20 at 15:46 +0200, Andreas Herrmann wrote:
> > > > > > The correct mask that describes core-siblings of an processor
> > > > > > is topology_core_cpumask. See topology adapation patches, especially
> > > > > > http://marc.info/?l=linux-kernel&m=124964999608179
> > > > > 
> > > > > 
> > > > > argh, violence, murder kill.. this is the worst possible hack and you're
> > > > > extending it :/
> > > > 
> > > > So this is the third code area
> > > > (besides sched_*_power_savings sysfs interface, and the __cpu_power fiddling)
> > > > that is crap, mess, a hack.
> > > > 
> > > > Didn't know that I'd enter such a minefield when touching this code. ;-(
> > > 
> > > Yeah, you're lucky that way ;-) Its been creaking for a while, and I've
> > > been making noises to the IBM people (who so far have been the main
> > > source of power saving patches) to clean this up, but now you trod onto
> > > all of it at once..
> > > 
> > > > What would be your perferred solution for the
> > > > core_cpumask/llc_shared_map stuff?  Another domain level to get rid of
> > > > this function?
> > > 
> > > Right, I'd like to see everything exposed as domain levels.
> > > 
> > > 
> > > numa-cluster
> > > numa
> > > socket
> > > in-socket-numa
> > > multi-core
> > > shared-cache
> > > core
> > > threads
> > 
> > Out of curiosity, when does cpu_core_mask differ from llc_shared_map
> > on Intel? Only in case of MCM (e.g. Core2 Quad)?
> 
> Yes, I think both c2q and some dual-core opteron have multiple cache
> domains per socket.
> 
> > If yes, the hackery of cpu_coregroup_mask() could be replace by
> > the domain that I'd like to introduce for Magny-Cours:
> > 
> >   MC domain span would represent one die.
> >   The new domain would span all dies in an MCM.
> > 
> > Bad idea?
> 
> No, I think all the mentioned chips have the multi-die thing in common,
> the intel c2q has 2 dual-core dies,

> the opteron I have seems to be two
> single cores

Really? I am not aware of such a thing.

Can you check how many sets of northbridge functions do you have?  If
you would have two dies in one package then you should see one set of
PCI functions at bus 0 device 24 and a second set of PCI functions at
bus 0 device 25, e.g.

  # lspci -d 1022:
  ...
  00:18.0 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h
          [Opteron, Athlon64, Sempron] HyperTransport Configuration [1022:1200]
  ...
  00:19.0 Host bridge [0600]: Advanced Micro Devices [AMD] Family 10h
          [Opteron, Athlon64, Sempron] HyperTransport Configuration [1022:1200]
  ... 

> and this magny thing has 2 many cores -- teh pun, sides
> aching :-)
> 
> So the generalization to dies per socket seems sensible.

Yup


Andreas

-- 
Operating | Advanced Micro Devices GmbH
  System  | Karl-Hammerschmidt-Str. 34, 85609 Dornach b. München, Germany
 Research | Geschäftsführer: Andrew Bowd, Thomas M. McCoy, Giuliano Meroni
  Center  | Sitz: Dornach, Gemeinde Aschheim, Landkreis München
  (OSRC)  | Registergericht München, HRB Nr. 43632


