Return-Path: <linux-kernel-owner+w=401wt.eu-S1752989AbXDCTPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989AbXDCTPY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 15:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbXDCTPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 15:15:24 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:51255 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752989AbXDCTPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 15:15:23 -0400
X-AuthUser: davidel@xmailserver.org
Date: Tue, 3 Apr 2007 12:15:14 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ulrich Drepper <drepper@redhat.com>
cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: getting processor numbers
In-Reply-To: <461286D6.2040407@redhat.com>
Message-ID: <Pine.LNX.4.64.0704031152370.23808@alien.or.mcafeemobile.com>
References: <461286D6.2040407@redhat.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Apr 2007, Ulrich Drepper wrote:

> More and more code depends on knowing the number of processors in the
> system to efficiently scale the code.  E.g., in OpenMP it is used by
> default to determine how many threads to create.  Creating more threads
> than there are processors/cores doesn't make sense.
> 
> glibc for a long time provides functionality to retrieve the number
> through sysconf() and this is what fortunately most programs use.  The
> problem is that we are currently using /proc/cpuinfo since this is all
> there was available at that time.  Creating /proc/cpuinfo takes the
> kernel quite a long time, unfortunately (I think Jakub said it is mainly
> the interrupt information).
> 
> The alternative today is to use /sys/devices/system/cpu and count the
> number of cpu* directories in it.  This is somewhat faster.  But there
> would be another possibility: simply stat /sys/devices/system/cpu and
> use st_nlink - 2.
> 
> This last step unfortunately it made impossible by recent changes:
> 
>   http://article.gmane.org/gmane.linux.kernel/413178
> 
> I would like to propose changing that patch, move the sched_*
> pseudo-files in some other directly and permanently ban putting any new
> file into /sys/devices/system/cpu.
> 
> To get some numbers, you can try
> 
>   http://people.redhat.com/drepper/nproc-timing.c
> 
> The numbers I see on x86-64:
> 
> cpuinfo 10145810 cycles for 100 accesses
> readdir /sys 3113870 cycles for 100 accesses
> stat /sys 741070 cycles for 100 accesses

It sucks when seen from a micro-bench POV, but does it really matter 
overall? The vast majority of software usually calls 
sysconf(_SC_NPROCESSORS_*) with very little frequency (mostly once at 
initialization time) anyway. That's what 50us / call?



- Davide


