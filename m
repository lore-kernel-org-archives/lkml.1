Return-Path: <linux-kernel-owner+w=401wt.eu-S1756549AbYLOTFd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbYLOTFd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 14:05:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751414AbYLOTF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 14:05:26 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:28696 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbYLOTFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 14:05:25 -0500
X-BigFish: VPS-58(z6c9Rz3b49K1432R98dR1805M1fa4L936fO3117K655Ozzzzz32i6bh62h)
X-Spam-TCS-SCL: 1:0
X-WSS-ID: 0KBXMCG-02-7NF-01
Date: Mon, 15 Dec 2008 20:05:09 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: re-enable MCE on secondary CPUS after
	suspend/resume
Message-ID: <20081215190509.GB5620@alberich.amd.com>
References: <20081212180650.GS19144@alberich.amd.com> <20081212181021.GU19144@alberich.amd.com> <873agtnrgy.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <873agtnrgy.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 15 Dec 2008 19:05:11.0012 (UTC) FILETIME=[0D95E240:01C95EE8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2008 at 08:06:21PM +0100, Andi Kleen wrote:
> Andreas Herrmann <andreas.herrmann3@amd.com> writes:
> 
> > Impact: fix suspend/resume bug with MCE
> >
> > After suspend/resume MCx_CTL registers of secondary CPUs are cleared.
> > (At least that's what I've observed on several systems.)
> > Linux currently only re-initializes MCE on the boot CPU - see mce_resume().
> > Thus after suspend/resume we end up with a system where MCE is active
> > on the boot CPU but switched off on all other CPUs.
> >
> > By calling mce_init() whenever a CPU comes online this problem is
> > solved.
> 
> Can you double check that please?
> 
> Suspend/resume are supposted to hotunplug all CPUs except the BP and
> then re-online them on resume (with "disable_nonboot_cpus()) . The
> re-online initializes MCEs in the standard CPU bootup path.

For BP we have

/* On resume clear all MCE state. Don't want to see leftovers from the BIOS.
   Only one CPU is active at this time, the others get readded later using
   CPU hotplug. */
static int mce_resume(struct sys_device *dev)
{
        mce_init(NULL);
        return 0;
}

For APs mcheck_init() is called on resume. But as the respective bit
for an AP is usually set in "mce_cpus" after boot (which is correct, I
think) mcheck_init does not call mce_init, see:

void __cpuinit mcheck_init(struct cpuinfo_x86 *c)
{
        static cpumask_t mce_cpus = CPU_MASK_NONE;

        mce_cpu_quirks(c);

        if (mce_dont_init ||
            cpu_test_and_set(smp_processor_id(), mce_cpus) ||
            !mce_available(c))
  =>             return;

        mce_init(NULL);
        mce_cpu_features(c);
}

But we need to call mce_init to clear all MCE state.
IMHO the best location to call mce_init for APs is the cpu notifier.


Regards,

Andreas


