Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120AbZDNMm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120AbZDNMm5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 08:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZDNMmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 08:42:46 -0400
Received: from ozlabs.org ([203.10.76.45]:38815 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753062AbZDNMmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 08:42:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: mmotm 2009-04-10-02-21 uploaded - forkbombed by work_for_cpu
Date: Tue, 14 Apr 2009 22:12:34 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: Valdis.Kletnieks@vt.edu, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       mm-commits@vger.kernel.org, Dave Jones <davej@redhat.com>,
       Ingo Molnar <mingo@elte.hu>
References: <200904100922.n3A9MOIV013828@imap1.linux-foundation.org> <4609.1239456126@turing-police.cc.vt.edu> <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904130847500.4583@localhost.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200904142212.35264.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 01:34:23 am Linus Torvalds wrote:
> So the _real_ problem came through the commits like
> 
>     cpufreq: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
>     cpumask: use work_on_cpu in acpi-cpufreq.c for read_measured_perf_ctrs
> 
> that were meant to reduce stack usage with big cpu masks. And sure, the 
> _old_ way of doing it was also stupid (it rescheduled the process to the 
> other CPU by using cpus_allowed()).

Reducing stack was main motivation, but old way was actually wrong: not only
can userspace see the affinity change, it can mess it up by setting it at the
same time.

It used to be reasonably quick, but forking a thread (to prevent locking
problems with keventd and yet avoid YA 1-thread-per-cpu) made it worse.

I'm no expert, but would life be more pleasant if the core cpufreq code
called these methods bound to an appropriate CPU?  They all seem to do these
tricks...

Cheers,
Rusty.
