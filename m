Return-Path: <linux-kernel-owner+w=401wt.eu-S1756723AbXKKJRJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756723AbXKKJRJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 04:17:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753445AbXKKJQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 04:16:56 -0500
Received: from il.qumranet.com ([82.166.9.18]:43101 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753408AbXKKJQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 04:16:55 -0500
Message-ID: <4736C847.90000@qumranet.com>
Date: Sun, 11 Nov 2007 11:15:51 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Gerd Hoffmann <kraxel@redhat.com>
CC: Glauber de Oliveira Costa <gcosta@redhat.com>,
       linux-kernel@vger.kernel.org, jeremy@goop.org, aliguori@us.ibm.com,
       kvm-devel@lists.sourceforge.net, hollisb@us.ibm.com
Subject: Re: [PATCH 1/3] include files for kvmclock
References: <11945615632624-git-send-email-gcosta@redhat.com> <11945615703593-git-send-email-gcosta@redhat.com> <47341C4A.30508@redhat.com>
In-Reply-To: <47341C4A.30508@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gerd Hoffmann wrote:
>> +/*
>> + * Guest has page alignment and padding requirements. At the host, it will
>> + * only lead to wasted space at the vcpu struct. For this reason, the struct
>> + * is not anonymous
>> + */
>> +union kvm_hv_clock {
>> +	struct kvm_hv_clock_s {
>> +		u64 tsc_mult;
>> +		u64 now_ns;
>> +		/* That's the wall clock, not the water closet */
>> +		u64 wc_sec;
>> +		u64 last_tsc;
>> +		/* At first, we could use the tsc value as a marker, but Jeremy
>> +		 * well noted that it will cause us locking problems in 32-bit
>> +		 * sys, so we have a special version field */
>> +		u32 version;
>> +	} fields;
>> +	char page_align[PAGE_SIZE];
>> +};
>>     
>
> What is the point in using a whole page per vcpu?  You probably don't
> want struct kvm_hv_clock_s cross a page border.  Is that the only reason
> or are there other constrains too?
>   

We don't even have the cross-page-boundary constraint.

The real issue is that on i386 physical addresses are 64-bit while 
hypercall arguments are 32-bit.  A page frame number is 32-bit and so 
poses no issues.

I see two workarounds for this:
- make the first hypercall argument a u64 rather than a long (using two 
registers on i386)
- use an msr for registering the clock address

The first is more general, while the second has the nice property of 
taking care of live migration automatically.

> As the kvm clock looks quite simliar to what xen does, how about making
> the structs binary-compatible or simply reuse the xen version (struct
> vcpu_time_info in xen/interface/xen.h)?
>   

If there are no technical issues, I have no objections.

-- 
error compiling committee.c: too many arguments to function

