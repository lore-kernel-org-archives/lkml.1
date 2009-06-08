Return-Path: <linux-kernel-owner+w=401wt.eu-S1753614AbZFHGOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbZFHGOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 02:14:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751553AbZFHGN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 02:13:56 -0400
Received: from mga02.intel.com ([134.134.136.20]:53532 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751432AbZFHGN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 02:13:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,322,1241420400"; 
   d="scan'208";a="522545642"
Date: Mon, 8 Jun 2009 14:12:50 +0800
From: Feng Tang <feng.tang@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "mingo@elte.hu" <mingo@elte.hu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Li, Shaohua" <shaohua.li@intel.com>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH] tick: add check for the existence of broadcast clock
 event device
Message-ID: <20090608141250.6a5735fa@feng-desktop>
In-Reply-To: <alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
References: <20090605112711.67e7d5cb@feng-desktop>
	<alpine.LFD.2.00.0906061121330.3419@localhost.localdomain>
	<20090606204736.00700bd0@feng-desktop>
	<alpine.LFD.2.00.0906061450220.3419@localhost.localdomain>
	<alpine.LFD.2.00.0906061815460.3419@localhost.localdomain>
	<20090608095730.0c945e78@feng-desktop>
	<alpine.LFD.2.00.0906080739020.3419@localhost.localdomain>
Organization: intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Jun 2009 13:43:43 +0800
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Mon, 8 Jun 2009, Feng Tang wrote:
> > > 1) How do you calibrate the local APIC timer if you do not have
> > > some initial timer device ?
> > Yes, we have external timer device with the name "apbt"
> 
> So that timer is initialized and registered before the local apic,
> right ?
Hi tglx,

I would describe a little more about our apbt timer, and I believe the
complete driver will be posted by my colleague after it get into a good shape.

Our apbt driver is pretty similar with HPET's, including its cpu hotplug
notifier. But our platform only has 2 available apbt to use, otherwise we will
configure it just like HPET, using one timer as bc and others for per-cpu ones,
then it won't hit this case

There are 2 situations, one is for the normal boot, apbt0 will be inited first
and registered to OS as cpu0's timer, then tsc/lapic is calculated based on it,
and apbt1 is registered later in a fs_initcall() (just like hpet.c does) after basic
kernel core is up. so the sequence is:
apbt0 --> lapic0 --> lapic1 --> apbt1

The other situation is in a suspend/resume cycle, in which disable/enable_nonboot_cpus()
are called, in this case, the apbt0 is alwasy there and not unregistered for cpu0, but
apbt1 is first dumped from cpu1, and in the resume process, lapic1 is first inited and
registered in the cpu_up() call, and apbt1 initialization is put into a workqueue after
got a CPU_ONLINE notifier. so for the cpu1 after resume, lapic1 first and then apbt1,
if the BROADCAST_ENTER/EXIT comes in between, the NULL pointer case is triggered.

Thanks,
Feng
> 
> Why is the local APIC timer used at all ? The apbt timer should have a
> higher rating as the local APIC timer, so when APIC is registered it
> is not selected and the check in the broadcast functions
> 
>    !(dev->features & CLOCK_EVT_FEAT_C3STOP))
> 
> should protect you because that bit is not set on your apbt device.
> 
> Thanks,
> 
> 	tglx
