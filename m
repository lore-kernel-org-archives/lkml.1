Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZFHGsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZFHGsj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbZFHGsb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:48:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:40716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751501AbZFHGsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:48:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="464349557"
Date: Mon, 8 Jun 2009 14:47:40 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
Message-ID: <20090608144740.62f2ed95@feng-desktop>
In-Reply-To: <alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop>
	<alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
	<20090606204736.00700bd0@feng-desktop>
	<alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
	<alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
	<20090608095730.0c945e78@feng-desktop>
	<alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
	<20090608141250.6a5735fa@feng-desktop>
	<alpine.LFD.2.00.0906080828021.3419@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 14:33:14 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> Feng,
> 
> On Mon, 8 Jun 2009, Feng Tang wrote:
> > Our apbt driver is pretty similar with HPET's, including its cpu
> > hotplug notifier. But our platform only has 2 available apbt to
> > use, otherwise we will configure it just like HPET, using one timer
> > as bc and others for per-cpu ones, then it won't hit this case
> > 
> > There are 2 situations, one is for the normal boot, apbt0 will be
> > inited first and registered to OS as cpu0's timer, then tsc/lapic
> > is calculated based on it, and apbt1 is registered later in a
> > fs_initcall() (just like hpet.c does) after basic kernel core is
> > up. so the sequence is: apbt0 --> lapic0 --> lapic1 --> apbt1
> 
> Hmm, I do not like that at all. That explicitely relies on CPU0 doing
> some work which will kick CPU1. That's fragile as hell. 
I understand the concern. apbt0 is inited in a very early boot phase when
the cpu1 is not up yet, and os don't even know wether there is a cpu1, that's
why we registered apbt1 in fs_initcall(). If we explicitly setup apbt1 when
OS brings up cpu1, it is a little brutal and not generic as only our platform
has apbt, and I guess cpu hotplug maintainer won't like it :p

As I said if we have one more apbt, we will make it totally follow the HPET way,
sad thing is we don't have it :(

Thanks,
Feng

> 
> Why do you want to make the CPU1 case special? You setup apbt0 before
> you setup local APIC on CPU0, so why can't you do the same for apbt1
> on CPU1 ? That will also remove the complete hotplug logic from your
> code.
> 
> Thanks,
> 
> 	tglx
