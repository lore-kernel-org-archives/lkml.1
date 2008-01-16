Return-Path: <linux-kernel-owner+w=401wt.eu-S1753314AbYAPTjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbYAPTjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 14:39:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751400AbYAPTja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 14:39:30 -0500
Received: from rv-out-0910.google.com ([209.85.198.185]:28808 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbYAPTj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 14:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=AoDpM7nOJ4PCP9eT/LIic3VdpIS5BbUu+rT2DAYMmmnZRHX5GPWnGs8uLMJ9Lx5tStzHBE20d1DEWAbbE+O82lngfCBeJKIzFu0TL9q9Bn7MXeeTkdOv2LuSfWuiJ4tIZmvR8eLrokEuk9n5EgKQfMID6qbu+uNTH63RueeNMRY=
Message-ID: <76366b180801161139o24599152obb01cd6e9cc6148@mail.gmail.com>
Date: Wed, 16 Jan 2008 14:39:27 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       "Balaji Rao" <balajirrao@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, bob.picco@hp.com
In-Reply-To: <alpine.LFD.0.99999.0801161618380.3764@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <76366b180801130310x57f24cc8s641d3ccb2415524c@mail.gmail.com>
	 <20080113120337.GA5548@linux.vnet.ibm.com>
	 <76366b180801130510w2af714fevf03f59164f90806f@mail.gmail.com>
	 <20080113140620.GA22507@linux.vnet.ibm.com>
	 <alpine.LFD.0.99999.0801161458470.3764@localhost.localdomain>
	 <alpine.LFD.0.99999.0801161524250.3764@localhost.localdomain>
	 <alpine.LFD.0.99999.0801161618380.3764@localhost.localdomain>
X-Google-Sender-Auth: 77830eeb0a47195c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I applied the patch and I am still locking up after
Time: hpet clocksource has been installed.

I rebooted with "clocksource=tsc" to get the logs of the trace which
was added. I'm assuming the grep below gets all the interesting parts.
I enabled the HPET character device as mentioned before, which is why
the hpet0 lines appear now.

# dmesg | egrep -i "(hpet|time|clock)"
ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ATI board detected. Disabling timer routing over 8254.
ACPI: PM-Timer IO Port: 0x4008
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
Kernel command line: vga=0x31a root=/dev/sda1 ro clocksource=tsc
HPET check: t1=5 t2=1139 s=56226339975 n=56226539985
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
Calibrating delay using timer specific routine.. 4927.58 BogoMIPS (lpj=9855168)
..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
Time: tsc clocksource has been installed.
PCI: Setting latency timer of device 0000:00:06.0 to 64
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
Clocksource tsc unstable (delta = 459979812 ns)
Software Watchdog Timer: 0.07 initialized. soft_noboot=0
soft_margin=60 sec (nowayout= 0)
PCI: Setting latency timer of device 0000:02:00.0 to 64

I ran a 'sleep 1', which hung as expected when I installed hpet as the
clocksource via /sys. I dumped the sysrq trace showing where it was
hung:

Jan 16 14:44:48 am2 kernel: sleep         S f582df68     0  2205   2155
Jan 16 14:44:48 am2 kernel:        f582df50 00000086 c1706e80 f582df68
c1706f04 c1706e78 00000000 c01371be
Jan 16 14:44:48 am2 kernel:        c17f8ab0 c17f8bf4 c1709a40 00000000
f7077200 00000286 c0137803 00000001
Jan 16 14:44:43 am2 kernel:        c1706e78 00000000 00000286 f582df68
00000000 f582c020 f582c000 c03ac8d3
Jan 16 14:44:43 am2 kernel: Call Trace:
Jan 16 14:44:48 am2 kernel:  [<c01371be>] enqueue_hrtimer+0xd7/0xe2
Jan 16 14:44:48 am2 kernel:  [<c0137803>] hrtimer_start+0xe8/0xf4
Jan 16 14:44:48 am2 kernel:  [<c03ac8d3>] do_nanosleep+0x48/0x73
Jan 16 14:44:48 am2 kernel:  [<c03ac932>] hrtimer_nanosleep_restart+0x34/0xa1
Jan 16 14:44:48 am2 kernel:  [<c013735d>] hrtimer_wakeup+0x0/0x18
Jan 16 14:44:48 am2 kernel:  [<c012e837>] sys_restart_syscall+0xe/0xf
Jan 16 14:44:48 am2 kernel:  [<c0103d0a>] sysenter_past_esp+0x5f/0x85

My 'cron' and 'atd' processes were also hung with this exact stack in
'enqueue_hrtimer'.

Thanks,
-Andrew

On Jan 16, 2008 10:21 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > > The hint is in the original report:
> > >
> > > Clocksource tsc unstable (delta = 500013666 ns)
> > >
> > > That means, that the TSC was counting, but HPET not. So it looks like
> > > the HPET readout is stale. Which explains, why after switching to HPET
> > > clocksource the time system gets hosed.
> > >
> > > I wonder why the HPET counter works check did not catch this.
> > >
> > > Can you please apply the path below and provide the output ?
>
> This time against 2.6.23
>
> Thanks,
>         tglx
