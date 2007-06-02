Return-Path: <linux-kernel-owner+w=401wt.eu-S1760560AbXFBOTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760560AbXFBOTR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2007 10:19:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757788AbXFBOTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jun 2007 10:19:08 -0400
Received: from mga03.intel.com ([143.182.124.21]:55561 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757995AbXFBOTH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2007 10:19:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,375,1175497200"; 
   d="scan'208";a="234829192"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Dependent CPU core speed reporting not updated withCPUFREQ_SHARED_TYPE_HW?
Date: Sat, 2 Jun 2007 07:19:03 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F5F5B144@scsmsx415.amr.corp.intel.com>
In-Reply-To: <20070602064325.GB7445@redhat.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Dependent CPU core speed reporting not updated withCPUFREQ_SHARED_TYPE_HW?
Thread-Index: Acek4V9WMEFElWA3TB+6uT+8n1QEfgAPg6Kw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Dave Jones" <davej@redhat.com>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>, <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 02 Jun 2007 14:19:05.0344 (UTC) FILETIME=[F9E55000:01C7A520]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Dave Jones [mailto:davej@redhat.com] 
>Sent: Friday, June 01, 2007 11:43 PM
>To: Pallipadi, Venkatesh
>Cc: Darrick J. Wong; linux-kernel@vger.kernel.org
>Subject: Re: Dependent CPU core speed reporting not updated 
>withCPUFREQ_SHARED_TYPE_HW?
>
>On Fri, Jun 01, 2007 at 06:59:25PM -0700, Venki Pallipadi wrote:
>
> > Hmmm. How about having a new cpufreq_sysfs entry to say
> > these CPUs are frequency dependent in hardware.
>
>Wait, wasn't this the entire purpose of affected_cpus in the first
>place? So we could see which CPUs would be affected by a frequency
>change?  What went wrong here?
>
> > affected_cpus today has a single cpufreq directory for all 
>affected_cpus
> > and we coordinate all CPUs in software. To change freq, we 
>will have to
> > move among all affected_cpus and write an MSR.
>
>This I think is where the problem started.  That these remained
>independant.  Changing one should also affect the others that it
>'affects'. Is that not the case?
>

Yes. Current affected_cpus they are dependent from user perspective.
Single set of /sysfs files linked in to multiple cpus. But kernel
Kernel knows that these are multiple dependent cpus and while
changing freq, driver typically goes from one CPU to other using
set_cpus_allowed to write MSR on all CPUs.

> > Hardware coordination basically tells us that kernel can control
> > frequency
> > percpu, but underneath hardware will pick highest requested 
>freq among a
> > group of CPUs. Instaed of handling this case as the 
>existing software
> > coordination case above, we can add a new entry in cpufreq /sysfs
> > denoting
> > hardware coordinated CPU group.
> > 
> > Though it will be confusing with too many interfaces, I 
>feel this is the
> > right way to go about here.
>
>If 'affected_cpus' doesn't do the right thing, I'd vote for making it
>do so over adding more interfaces.
>

The problem here is that with hardware coordination, kernel need not
do what we do for affected_cpus today. Kernel can manage each CPU
independently in terms of setting freq as underlying hardware
guarantees to do the coordination (picking up the highest freq
among a group of dependent cpus). So ideally we can just manage cpu
frequencies as we do today without affected_cpus. But, in this case
there is a fyi from hardware which says even though OS is thinking that
CPUs are independent, hardware is doing the coordination across these
CPUs.

We cannot directly use affected_cpus for this. We can probably change
to use affected_cpus in a way that we enforce software coordination on
top of hardware coordination. But, maintaining freq as in current
affected_cpus may not be as optimal as doing a percpu policy and
decision.

Thanks,
Venki
