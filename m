Return-Path: <linux-kernel-owner+w=401wt.eu-S1759389AbZCCAKe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759389AbZCCAKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:10:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757881AbZCCAKS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:10:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:53766 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756829AbZCCAKQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:10:16 -0500
Message-ID: <49AC74FA.3010206@kernel.org>
Date: Mon, 02 Mar 2009 16:08:26 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>, Ingo Molnar <mingo@elte.hu>,
       Suresh Siddha <suresh.b.siddha@intel.com>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain> <20090226114457.GB6651@elte.hu> <20090227001757.GE27240@localdomain> <20090228094430.GH12095@elte.hu> <20090302235120.GF27240@localdomain>
In-Reply-To: <20090302235120.GF27240@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Sat, Feb 28, 2009 at 10:44:30AM +0100, Ingo Molnar wrote:
>> * Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
>>
>>> True, but by how much? 212 bytes, out of 7285943 bytes which 
>>> is very very small percentage wise.
>> How does this eliminate the validity of the patch?
>>
> 
> It costs 212 bytes to leave is_vsmp_box() to not just be a dummy no-op.
> Having is_vsmp_box() detect if the hardware is indeed vSMP, is meaningful even when
> CONFIG_VSMP is not turned on.   This is because is_vsmp_box() is used to
> tell the kernel, that although the cpus being used are supposed to have TSCs
> in sync, they are not really in sync.  This is because
> you cannot ensure TSCs won't drift between multiple boards being aggregated
> on vSMP systems. Take the case of distro kernels.   Distro kernels typically do
> not have CONFIG_X86_VSMP on.  Due to the large internode cacheline
> setting, CONFIG_VSMP would not be on on the generic distro installer kernels.
> If is_vsmp_box() is a no-op, the generic distro installer kernels will
> assume TSCs to be synched, which is bad.  Hence, it will be nice if, for
> the cost of 212 bytes, vsmp64.o be compiled either unconditionally, OR
> conditionally for 64bit architectures only.  The question is, is 212 bytes out
> of 7285943 bytes too expensive for the generic kernels?  I hope not.

we may need to revisit apic_is_clustered_box()

/*
 * apic_is_clustered_box() -- Check if we can expect good TSC
 *
 * Thus far, the major user of this is IBM's Summit2 series:
 *
 * Clustered boxes may have unsynced TSC problems if they are
 * multi-chassis. Use available data to take a good guess.
 * If in doubt, go HPET.
 */
__cpuinit int apic_is_clustered_box(void)

....

        /*
         * If clusters > 2, then should be multi-chassis.
         * May have to revisit this when multi-core + hyperthreaded CPUs come
         * out, but AFAIK this will work even for them.
         */


with intel new cpus with 8 cores and HT enabled, even 2 sockets system will get 3 (?) so called "apic cluster"

we really need to use dmi etc way to detect multi-chassis system from now on

YH
