Return-Path: <linux-kernel-owner+w=401wt.eu-S1757463AbYBIX1f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757463AbYBIX1f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 18:27:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756582AbYBIX10
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 18:27:26 -0500
Received: from rv-out-0910.google.com ([209.85.198.189]:20133 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756553AbYBIX1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:27:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=nRodydWtkg2gnCrRXISbozlqmjKaxzSKwTFr9UOiSWsIwwYL8XcaKohw/6bN8EhJd+xCdQTxysNZAdsh+LL0pQUzSwa/vfZBvQCEiPkAnNwWdwmpYI73dQnJDpdPW3Y2ewhWmR9d6LVi3uHVg10ljpFxDrTFzSeqvKv+dwTsRkY=
Message-ID: <76366b180802091527n4ee2eeacu9d41193bba4701b3@mail.gmail.com>
Date: Sat, 9 Feb 2008 18:27:23 -0500
From: "Andrew Paprocki" <andrew@ishiboo.com>
To: "Thomas Gleixner" <tglx@linutronix.de>
Subject: Re: HPET timer broken using 2.6.23.13 / nanosleep() hangs
Cc: "Dhaval Giani" <dhaval@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       "Balaji Rao" <balajirrao@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Ingo Molnar" <mingo@elte.hu>, clemens@ladisch.de,
       venkatesh.pallipadi@intel.com, bob.picco@hp.com
In-Reply-To: <alpine.LFD.0.99999.0801181111430.4642@localhost.localdomain>
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
	 <76366b180801161139o24599152obb01cd6e9cc6148@mail.gmail.com>
	 <alpine.LFD.0.99999.0801181111430.4642@localhost.localdomain>
X-Google-Sender-Auth: 91e097f951bf1cc3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas,

I haven't found a good way to capture the SysRq output for this. I
found that when it locks up at boot time, even SysRq is unresponsive.
I don't have another way of getting console on the machine right now
to get the output off of it. I have since upgraded to 2.6.24 and the
problem still persists.

Another interesting twist though.. I just rebuilt my kernel with
ARCH=x86_64 and HPET works perfectly. So this only appears to break
when in 32-bit mode. For some reason it picks tsc at boot time, but if
I install hpet afterwards under x86_64 it no longer hangs when I run
'sleep 1'. Does that shed any more light on the problem?

Thanks,
-Andrew

# uname -a
Linux am2 2.6.24 #7 Sat Feb 9 18:06:50 EST 2008 x86_64 GNU/Linux
# dmesg | egrep -i clock\|hpet
ACPI: HPET 3DFE7780, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
ACPI: HPET id: 0x10b9a201 base: 0xfed00000
hpet clockevent registered
TSC calibrated against HPET
hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
hpet0: 4 32-bit timers, 14318180 Hz
Time: tsc clocksource has been installed.
Real Time Clock Driver v1.12ac
hpet_resources: 0xfed00000 is busy
# echo -n hpet >
/sys/devices/system/clocksource/clocksource0/current_clocksource
# dmesg | tail -1
Time: hpet clocksource has been installed.
# time sleep 1

real    0m1.001s
user    0m0.000s
sys     0m0.000s

On Jan 18, 2008 5:26 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> On Wed, 16 Jan 2008, Andrew Paprocki wrote:
>
> > I applied the patch and I am still locking up after
> > Time: hpet clocksource has been installed.
>
> That was expected :)
>
> > I rebooted with "clocksource=tsc" to get the logs of the trace which
> > was added. I'm assuming the grep below gets all the interesting parts.
> > I enabled the HPET character device as mentioned before, which is why
> > the hpet0 lines appear now.
> >
> > # dmesg | egrep -i "(hpet|time|clock)"
> > ACPI: HPET 37FE7400, 0038 (r1 RS690  AWRDACPI 42302E31 AWRD       98)
> > ATI board detected. Disabling timer routing over 8254.
> > ACPI: PM-Timer IO Port: 0x4008
> > ACPI: HPET id: 0x10b9a201 base: 0xfed00000
> > Kernel command line: vga=0x31a root=/dev/sda1 ro clocksource=tsc
> > HPET check: t1=5 t2=1139 s=56226339975 n=56226539985
>
> Ok, the counter works when we initialize the HPET.
>
> t2-t1 = 1134 ticks ~= 79us
> s-n = 200010 ~= 2525MHz --> That should be the frequency of your CPU.
>
> > Jan 16 14:44:43 am2 kernel: Call Trace:
> > Jan 16 14:44:48 am2 kernel:  [<c01371be>] enqueue_hrtimer+0xd7/0xe2
> > Jan 16 14:44:48 am2 kernel:  [<c0137803>] hrtimer_start+0xe8/0xf4
> > Jan 16 14:44:48 am2 kernel:  [<c03ac8d3>] do_nanosleep+0x48/0x73
> > Jan 16 14:44:48 am2 kernel:  [<c03ac932>] hrtimer_nanosleep_restart+0x34/0xa1
> > Jan 16 14:44:48 am2 kernel:  [<c013735d>] hrtimer_wakeup+0x0/0x18
> > Jan 16 14:44:48 am2 kernel:  [<c012e837>] sys_restart_syscall+0xe/0xf
> > Jan 16 14:44:48 am2 kernel:  [<c0103d0a>] sysenter_past_esp+0x5f/0x85
>
> When the system is hung, can you please hit SysRq-Q wait a bit and hit
> SysRq-Q again. Please provide the output.
>
> Thanks,
>         tglx
>
>
