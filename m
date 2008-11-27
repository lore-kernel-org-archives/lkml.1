Return-Path: <linux-kernel-owner+w=401wt.eu-S1755864AbYK0MEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755864AbYK0MEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 07:04:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755176AbYK0MEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 07:04:35 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:50012 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755013AbYK0MEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 07:04:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=TAW0bVv11ZZUjGn7FAtsaRuScy3YBMjx52GdaC3oI+xwo9ihzpoR+SiAwJdOGLEF8Y
         zFND11KWCHWbODNWGziOXtJbrpryBUiffIsB3AL5oTm64WPe57U5og9N0O5gryssfyJC
         5ZmYZAbZ3siPbdHWAIoeb4M4p+YfzXyd9xQIA=
Message-ID: <7c86c4470811270404q2ce1b503lf78c24d5c2223c44@mail.gmail.com>
Date: Thu, 27 Nov 2008 13:04:31 +0100
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "Peter Zijlstra" <peterz@infradead.org>
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Cc: "Andi Kleen" <andi@firstfloor.org>, "Thomas Gleixner" <tglx@linutronix.de>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, sfr@canb.auug.org.au
In-Reply-To: <1227786746.4454.1468.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com>
	 <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain>
	 <20081126140054.GX6703@one.firstfloor.org>
	 <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
	 <20081127100602.GF6703@one.firstfloor.org>
	 <7c86c4470811270209q18d4e83aq8901837159838cc4@mail.gmail.com>
	 <20081127113115.GH6703@one.firstfloor.org>
	 <7c86c4470811270335p2dbd61ebpe2c584e32d8b2292@mail.gmail.com>
	 <1227786746.4454.1468.camel@twins>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter,

On Thu, Nov 27, 2008 at 12:52 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2008-11-27 at 12:35 +0100, stephane eranian wrote:
>> On Thu, Nov 27, 2008 at 12:31 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> The only reason why I have to deal with NMI is not so much to allow
>> >> for profiling irq-off regions but because I have to share the PMU with
>> >> the NMI watchdog. Otherwise I'd have to fail  or disable the NMI watchdog
>> >> on the fly.
>> >
>> > The NMI watchdog is now off by default so failing with it enabled
>> > is fine.
>>
>> Yes, but most likely it is on in distro kernels.
>
> So? You can disable it on the fly when there is a perfmon user.
>
Yes, you can. There is clearly an interface to do this. I think this is the
best solution. I know it can work because it experimented with this approach
no later than last month. But I ran into a bug which I reported on LKML. I did
not provide a patch because I  did not fully understand the connection to
suspend/resume.

The bug has to do with some obscure suspend/resume sequence in:

void setup_apic_nmi_watchdog(void *unused)
{
        if (__get_cpu_var(wd_enabled))
                return;

        /* cheap hack to support suspend/resume */
        /* if cpu0 is not active neither should the other cpus */
        if (smp_processor_id() != 0 && atomic_read(&nmi_active) <= 0)
                return;

Basically, when you re-enable the NMI watchdog, it is not always re-enabled
correctly on all CPUs, it depends on the order if which they process the IPI.
