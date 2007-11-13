Return-Path: <linux-kernel-owner+w=401wt.eu-S1758152AbXKMPYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758152AbXKMPYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 10:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754150AbXKMPX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 10:23:58 -0500
Received: from mga11.intel.com ([192.55.52.93]:27955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbXKMPX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 10:23:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.21,411,1188802800"; 
   d="scan'208";a="202928297"
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Date: Tue, 13 Nov 2007 23:23:49 +0800
Message-ID: <10EA09EFD8728347A513008B6B0DA77A025DFB75@pdsmsx411.ccr.corp.intel.com>
In-Reply-To: <4739B916.4000405@qumranet.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [kvm-devel] [PATCH 2/3] kvmclock - the host part.
Thread-Index: AcgmBdB/kO7d5wAhQdq4zor0JHPrpAAAbVTg
References: <11945615632624-git-send-email-gcosta@redhat.com><11945615703593-git-send-email-gcosta@redhat.com> <11945615751747-git-send-email-gcosta@redhat.com> <10EA09EFD8728347A513008B6B0DA77A025DF8A2@pdsmsx411.ccr.corp.intel.com> <4739906B.2080103@redhat.com> <4739B916.4000405@qumranet.com>
From: "Dong, Eddie" <eddie.dong@intel.com>
To: "Avi Kivity" <avi@qumranet.com>,
       "Glauber de Oliveira Costa" <gcosta@redhat.com>
Cc: <linux-kernel@vger.kernel.org>, <jeremy@goop.org>, <hollisb@us.ibm.com>,
       <kvm-devel@lists.sourceforge.net>
X-OriginalArrivalTime: 13 Nov 2007 15:23:52.0304 (UTC) FILETIME=[32735700:01C82609]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Avi Kivity wrote:
> Glauber de Oliveira Costa wrote:
>> -----BEGIN PGP SIGNED MESSAGE-----
>> Hash: SHA1
>> 
>> Dong, Eddie escreveu:
>> 
>>>> +static void kvm_write_guest_time(struct kvm_vcpu *vcpu) +{
>>>> +	struct timespec ts; +	int r;
>>>> +
>>>> +	if (!vcpu->clock_gpa)
>>>> +		return;
>>>> +
>>>> +	/* Updates version to the next odd number, indicating we're
>>>> writing */ +	vcpu->hv_clock.version++;
>>>> +	kvm_write_guest(vcpu->kvm, vcpu->clock_gpa,
>>>> &vcpu->hv_clock, PAGE_SIZE);
>>>> +
>>>> +	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
>>>> +			  &vcpu->hv_clock.last_tsc);
>>>> +
>>>> +	ktime_get_ts(&ts);
>>>> 
>>> Do we need to disable preemption here?
>>> 
>> After thinking for a little while, you are theoretically right.
>> In the current state, we could even be preempted between all
>> operations ;-) Maybe after avi's suggestion of moving the call to it
>> it will end up in a preempt safe region, but anyway, it's safer to
>> add the preempt markers here. I'll put it in next version, thanks
>> 
>> 
> 
> Well, you can't kvm_write_guest() with preemption enabled.
> 
> preempt notifiers to the rescue!  We have a callout during preemption,
> so you can just zero out a flag there, and when we're scheduled again
> retry the whole thing. 
> 

The preemption issue is within following code which need to be done in a
short enough period.

+	kvm_get_msr(vcpu, MSR_IA32_TIME_STAMP_COUNTER,
+			  &vcpu->hv_clock.last_tsc);
+
+	ktime_get_ts(&ts);
+	vcpu->hv_clock.now_ns = ts.tv_nsec + (NSEC_PER_SEC *
(u64)ts.tv_sec);
+	vcpu->hv_clock.wc_sec = get_seconds();

I am even thinking we have to disable interrupt between these lines,
otherwise
guest wall clock may see backward time source when calculating the
delta TSC since last vcpu->hv_clock.now_ns update.

Also why we use both ktime_get_ts(&ts) & get_seconds() together? they
are not atomic
and may cause issues?

thx,eddie
