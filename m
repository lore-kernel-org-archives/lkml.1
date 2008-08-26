Return-Path: <linux-kernel-owner+w=401wt.eu-S1755015AbYHZBfj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755015AbYHZBfj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 21:35:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753200AbYHZBfb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 21:35:31 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46793 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751144AbYHZBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 21:35:30 -0400
Date: Mon, 25 Aug 2008 18:35:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Marc Haber <mh+linux-kernel@zugschlus.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.26.3 mount process looping on ext3 rw remount
Message-Id: <20080825183528.30b66f45.akpm@linux-foundation.org>
In-Reply-To: <20080823084228.GA21293@torres.zugschlus.de>
References: <20080823084228.GA21293@torres.zugschlus.de>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 Aug 2008 10:42:28 +0200 Marc Haber <mh+linux-kernel@zugschlus.de> wrote:

> Hi,
> 
> on my laptop, I am a heavy user of laptop-mode and suspend-to-disk.
> Sometimes (maybe once out of ten), when disconnecting or connecting
> external power, I have a mount process called by laptopmode busy
> looping and taking all available CPU:
> 
>   ______acpid,4680 -c /etc/acpi/events
>   ___   ______lm_ac_adapter.s,29317 /etc/acpi/actions/lm_ac_adapter.sh
>   ___       ______laptop_mode,29318 /usr/sbin/laptop_mode auto
>   ___           ______laptop-mode,29386 /usr/share/laptop-mode-tools/modules/laptop-mode
>   ___               ______laptop-mode,29390 /usr/share/laptop-mode-tools/modules/laptop-mode
>   ___                   ______laptop-mode,29409 /usr/share/laptop-mode-tools/modules/laptop-mode
>   ___                       ______mount,29410 /dev/mapper/usr /mnt/usr -t ext3 -o remount,rw,commit=600
> 
> this is what top says
> Cpu(s):  2.7%us, 96.0%sy,  0.0%ni,  0.0%id,  0.0%wa,  1.3%hi,  0.0%si, 0.0%st
> 29410 root      20   0  2068  684  564 R 92.7  0.0  87:37.71 mount
> 
> The mount process does not react to SIGKILL, stracing the looping
> process doesn't give any output, and the strace gets stuck and does
> not react to Ctrl-C. A SIGKILL works for the strace process, though.
> 
> To me as a layman this looks like the mount process gets stuck
> somewhere in kernel land. I currently have the issue with 2.6.26.3.
> 
> In the situation of plugging and/or unplugging the power, the notebook
> used to completely freeze in the time when 2.6.24 and 2.6.25.$SMALL
> were in use, with 2.6.25.$HIGH and 2.6.26 I haven't hat these freezes
> any more. However, I am now plagued with the hanging mount processes.

Yes, it's hung in the kernel.

Please try to get a kernel profile while it's happening.  oprofile
maybe, or just the plain old timer-based profiler.  There's some info
in Documentation/basic_profiling.txt.

> Any ideas?

The profile will tell us where it got stuck.


Actually, a simple alternative is to hit sysrq-P five or ten times. 
Most of the resulting stack traces will point back at where the CPU is
stuck.

This gets a bit hit-or-miss if you have multiple CPUs, because the
sysrq-p trace can land on the wrong CPU.  We recently added a sysrq-l
which will generate a trace on all CPUS.

I think we might recently have broken the sysrq output: some info which
should be coming out isn't.  Altering the logging priority (dmesg -n 7)
might help with that.

