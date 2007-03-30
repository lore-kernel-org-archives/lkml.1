Return-Path: <linux-kernel-owner+w=401wt.eu-S934195AbXC3BGZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934195AbXC3BGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 21:06:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934202AbXC3BGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 21:06:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:25337 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934195AbXC3BGY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 21:06:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,350,1170662400"; 
   d="scan'208"; a="66169712:sNHT22506255"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
Date: Thu, 29 Mar 2007 18:06:22 -0700
Message-ID: <653FFBB4508B9042B5D43DC9E18836F52DF4D8@scsmsx415.amr.corp.intel.com>
In-Reply-To: <460C5D24.608@us.ibm.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Dependent CPU core speed reporting not updated with CPUFREQ_SHARED_TYPE_HW?
thread-index: AcdyZEc3Vf/L4lXPScWRVi+KuVWLYwAACCaw
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
X-OriginalArrivalTime: 30 Mar 2007 01:06:22.0922 (UTC) FILETIME=[A20BAAA0:01C77267]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

 

>-----Original Message-----
>From: Darrick J. Wong [mailto:djwong@us.ibm.com] 
>Sent: Thursday, March 29, 2007 5:43 PM
>To: Pallipadi, Venkatesh
>Cc: linux-kernel@vger.kernel.org
>Subject: Dependent CPU core speed reporting not updated with 
>CPUFREQ_SHARED_TYPE_HW?
>
>Hi Venki,
>
>I have a dual-Woodcrest machine here with _PSD tables that specify that
>cpufreq coordination between cores is done in hardware with
>DOMAIN_COORD_TYPE_HW_ALL.  On this particular machine, CPU 0 and CPU 2
>are on the same package, and it looks like they have to be at the same
>frequency.
>
>However, it seems that acpi_cpufreq_cpu_init() only sets 
>policy->cpus to
>the shared cpu mask if software coordination is required.  While this
>does have the effect of letting the hardware do its coordination job as
>advertised, it also means that a frequency change to CPU0 doesn't get
>echoed to CPU2 as it should be, and affected_cpus is inaccurate.
>
>This seems like a bug to me.  I can whip up a patch to set the policy
>cpu mask in all cases and neuter all but one of the MSR/PCT 
>writes if HW
>coordination is desired so that HW coordination is preserved and sysfs
>is accurate, but I'm curious to know if I've gotten it right.
>

Darrick,

Above observation is correct. Affected_cpus and policy->cpus has
multiple
entry only when software coordination is desired. If hardware is doing
the
coordination, then setting policy->cpus makes another level of sw
coordination
on top of hardware coordination. The main reason is why I chose the
current
way is, from kernel perspective doing it at each logical CPU is much
better
than doing software coordination and making one CPU look at utilization
of different CPUs and take decisions on their behalf. Especially with
tickless
kind of situations, 
Example: say CPU 0 and CPU 2 are sharing frequency with hw coordination
and we make CPU 2 MSR lowest at all times and run the ondemand policy on
CPU 0
to control both CPUs. Now CPU 0 is idle and CPU 2 gets some load.
Ideally it
will be better for CPU 2 to recognise and handle it, rather than wait
for CPU 1
to come out of idle and handle this at a later point in time.
Having the policy per CPU and dealing with hw coordination locally also
simplifies
CPU hotplug handling.

I agree that affected_cpus is lying in case of hardware coordination. I
thought of
making affected CPUs show the dependency in case of hw coord, but
retaining the percpu
control. But, it seemed complicated change for something that is
cosmetic.

Note that this issue is the problem with what we display as current
freq. However,
ondemand knows the current freq of each CPU correctly even in this case,
as it uses
measured_freq interface that is supported on all recent processors to
make
frequency decisions.

Thanks,
Venki
