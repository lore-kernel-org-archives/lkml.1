Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbZJJSLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbZJJSLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Oct 2009 14:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762074AbZJJSLg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Oct 2009 14:11:36 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10050 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762060AbZJJSLd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Oct 2009 14:11:33 -0400
Message-ID: <4AD0CDFB.9030704@redhat.com>
Date: Sat, 10 Oct 2009 20:10:03 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Zach Brown <zach.brown@oracle.com>,
       Chris Mason <chris.mason@oracle.com>
Subject: Re: [Xen-devel] Re: [PATCH 3/5] x86/pvclock: add vsyscall implementation
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>	<1254790211-15416-4-git-send-email-jeremy.fitzhardinge@citrix.com> <4ACB0833.2050203@redhat.com> <4ACB9074.1000804@goop.org> <4ACC6C9C.7080707@redhat.com> <4ACFD43E.6000506@goop.org>
In-Reply-To: <4ACFD43E.6000506@goop.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2009 02:24 AM, Jeremy Fitzhardinge wrote:
> On 10/07/09 03:25, Avi Kivity wrote:
>    
>> def try_pvclock_vtime():
>>    tsc, p0 = rdtscp()
>>    v0 = pvclock[p0].version
>>    tsc, p = rdtscp()
>>    t = pvclock_time(pvclock[p], tsc)
>>    if p != p0 or pvclock[p].version != v0:
>>       raise Exception("Processor or timebased change under our feet")
>>    return t
>>      
> This doesn't quite work.
>
> If we end up migrating some time after the first rdtscp, then the
> accesses to pvclock[] will be cross-cpu.  Since we don't made any strong
> SMP memory ordering guarantees on updating the structure, the snapshot
> isn't guaranteed to be consistent even if we re-check the version at the
> end.
>    

We only hit this if we have a double migration, otherwise we see p != p0.

Most likely all existing implementations do have a write barrier on the 
guest entry path, so if we add a read barrier between the two compares, 
that ensures we're reading from the same cpu again.

> So to use rdtscp we need to either redefine the update of
> pvclock_vcpu_time_info to be SMP-safe, or keep the additional migration
> check.
>    

I think we can update the ABI after verifying all implementations do 
have a write barrier.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

