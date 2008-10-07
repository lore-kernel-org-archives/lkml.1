Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbYJGVLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbYJGVLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 17:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756298AbYJGVKH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 17:10:07 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:15784 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757589AbYJGVKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 17:10:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=ji2FKQEVVJQL2G6VaU3dbRtg1tZ/ITRaJR/g446jLN2X/rvji3+XfDCOev3eowSTsE
         ftimzMa6px1NO/7ySV2ICHk26wOA12tB3AgrkQMk3a/brxVS/vTc9tYu0NXlwI2qZ0e8
         0NXNfPr4U9Byu9EbIRdWzcsG1UQO/ol83dZ+c=
Message-ID: <7c86c4470810071410u205fe7c4n43f9dbb76e49812e@mail.gmail.com>
Date: Tue, 7 Oct 2008 23:10:00 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: NMI watchdog setup_lapic_nmi_watchdog() problem
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, andi@firstfloor.org,
       tglx@linutronix.de, "Shaohua Li" <shaohua.li@intel.com>
In-Reply-To: <20081007132158.009669d2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470810070845w1346107cx211148c52fd03b68@mail.gmail.com>
	 <20081007132158.009669d2.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

On Tue, Oct 7, 2008 at 10:21 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Tue, 7 Oct 2008 17:45:32 +0200
> "stephane eranian" <eranian@googlemail.com> wrote:
>
>> Hello,
>>
>> I was doing some more testing with perfmon when I ran into
>> a problem with the NMI watchdog code in 2.6.27-rc8.
>>
>> Since 2.6.20, it is possible to enable/disable the NMI watchdog
>> on-the-fly via /proc/sys/kernel/nmi_watchdog. This is a nice option
>> which avoids having to reboot the kernel.
>>
>> Enabling/disabling the NMI watchdog uses two internal functions
>> enable_lapic_nmi_watchdog() and disable_lapic_nmi_watchdog().
>>
>> Enable_lapic_nmi_watchdog() uses  a IPI handler to setup the
>> APIC on each CPU. However, it turns out that this handler, namely,
>> setup_apic_nmi_watchdog() relies on some explicit ordering constraint
>> due to suspend/resume constraints as explained in the comment
>> below:
>>
>> void setup_apic_nmi_watchdog(void *unused)
>> {
>>         if (__get_cpu_var(wd_enabled))
>>                 return;
>>
>>         /* cheap hack to support suspend/resume */
>>         /* if cpu0 is not active neither should the other cpus */
>>         if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
>>                 return;
>>
>>         switch (nmi_watchdog) {
>> [snip]
>> }
>>
>> Supposing watchdog was disabled via /proc, nmi_active = 0. Then if you
>> re-enable, and if CPU0 is not the first to execute the IPI handler, then none
>> of the other CPUS will re-enable their NMI watchdog timer.  On a quad-core
>> system, I have seen, for instance, 2 out of 4 with NMI watchdogs re-enabled.
>>
>> I am not an expert at suspend/resume. I am assuming there was a race condition
>> there and that's why this code was added early on. The problem is that it now
>> conflicts with the /proc option.
>>
>> It is not clear to me how this works during boot. Obviously the order
>> is respected
>> and all CPUs have their NMI watchdog enabled.
>>
>> Until I understand the suspend/resume issue, it is hard to provide a
>> fix for this.
>>
>> Any comments?
>
> The "cheap hack" was added in September 2006.
>
> 2.6.20 was released in Feb 2007.
>
> So presumably this problem has always been there, since
> /proc/sys/kernel/nmi_watchdog was first added, only nobody has hit it
> before.
>
Yes, I believe that is true. The bug was there as soon as the /proc interface
was introduced.

The bug is not visible unless you instrument that setup_lapic_nmi_watchdog()
routine. I did that because I was tracking the value of nmi_active
within perfmon.
On a quad-core, nmi_active is equal to 4, so when I saw 2, I started
investigating.

> Have you only recently started to use /proc/sys/kernel/nmi_watchdog, or
> did it work OK on any earlier kernel?
>
I started playing with that because wanted to see whether NMI was releasing
the PMU MSR back to the free pool which it did. However, I had not
paid attention
to whether or not NMI was re-activated on all CPUs.

If you remove the 'cheap hack', disabling/enabling works. That's why
I'd like to better
understand was is going on with suspend/resume.
