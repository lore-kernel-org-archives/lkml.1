Return-Path: <linux-kernel-owner+w=401wt.eu-S1753826AbZGNJOO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753826AbZGNJOO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 05:14:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbZGNJON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 05:14:13 -0400
Received: from hera.kernel.org ([140.211.167.34]:33535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386AbZGNJOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 05:14:12 -0400
Subject: Re: [ANNOUNCE] 2.6.29.6-rt23
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Fernando Lopez-Lezcano <nando@ccrma.Stanford.EDU>,
       LKML <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>, Carsten Emde <ce@ceag.ch>,
       Clark Williams <williams@redhat.com>,
       Frank Rowand <frank.rowand@am.sony.com>,
       Robin Gareus <robin@gareus.org>, Gregory Haskins <ghaskins@novell.com>,
       Philippe Reynes <philippe.reynes@isismpp.fr>,
       Will Schmidt <will_schmidt@vnet.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Jan Blunck <jblunck@suse.de>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Jon Masters <jcm@redhat.com>
In-Reply-To: <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain>
References: <alpine.LFD.2.00.0902112332370.415@localhost.localdomain>
	 <alpine.LFD.2.00.0904031918090.12916@localhost.localdomain>
	 <alpine.LFD.2.00.0904081937191.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904092046440.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904110003370.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904181204420.21577@localhost.localdomain>
	 <alpine.LFD.2.00.0904251500150.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0904290036500.4529@localhost.localdomain>
	 <alpine.LFD.2.00.0905012348200.3375@localhost.localdomain>
	 <alpine.LFD.2.00.0905130122250.3561@localhost.localdomain>
	 <alpine.LFD.2.00.0905221459030.3570@localhost.localdomain>
	 <alpine.LFD.2.00.0906101803210.3367@localhost.localdomain>
	 <alpine.LFD.2.00.0906121800590.3369@localhost.localdomain>
	 <alpine.LFD.2.00.0906151117440.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906170903370.2800@localhost.localdomain>
	 <alpine.LFD.2.00.0906231418500.2767@localhost.localdomain>
	 <alpine.LFD.2.00.0907092020410.2768@localhost.localdomain>
	 <1247249002.18898.11.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0907102023500.2768@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 14 Jul 2009 14:42:33 +0530
Message-Id: <1247562753.2473.4.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-07-10 at 20:29 +0200, Thomas Gleixner wrote:
> On Fri, 10 Jul 2009, Fernando Lopez-Lezcano wrote:
> > On Thu, 2009-07-09 at 20:25 +0200, Thomas Gleixner wrote:
> > > We are pleased to announce the next update to our new preempt-rt
> > > series.
> > >  
> > >      - update to 2.6.29.6
> > >  
> > >      - compile fixes (Wu Zhangjin)
> > > 
> > >      - powerpc highmem fix
> > > 
> > >      - hwlat smp_processor_id() fix (Carsten)
> > > 
> > >      - ktime_get* speedups (Martin)
> > 
> > I'm getting slightly weird behavior from rt23 in an intel quad core
> > machine (my T61 laptop is fine), rt22 was fine. It is some timer issue,
> > if I type continuously I get (every few seconds) repeated keys. Nothing
> > in the logs, nothing in dmesg that is (significantly) different from an
> > rt22 boot. 
> 
> Hmm. The only change which touches timer related stuff is the ktime*
> speedups. Can you please apply the revert patch below and check
> whether that changes anything? If not, then we need to look at the
> 2.6.29.5 -> .6 delta.
> 
> Thanks,
> 
> 	tglx
> -----
> diff --git b/kernel/hrtimer.c a/kernel/hrtimer.c
> index 93affb0..cb8a15c 100644
> --- b/kernel/hrtimer.c
> +++ a/kernel/hrtimer.c
> @@ -46,6 +46,37 @@
>  
>  #include <asm/uaccess.h>
>  
> +/**
> + * ktime_get - get the monotonic time in ktime_t format
> + *
> + * returns the time in ktime_t format
> + */
> +ktime_t ktime_get(void)
> +{
> +	struct timespec now;
> +
> +	ktime_get_ts(&now);
> +
> +	return timespec_to_ktime(now);
> +}
> +EXPORT_SYMBOL_GPL(ktime_get);
> +
> +/**
> + * ktime_get_real - get the real (wall-) time in ktime_t format
> + *
> + * returns the time in ktime_t format
> + */
> +ktime_t ktime_get_real(void)
> +{
> +	struct timespec now;
> +
> +	getnstimeofday(&now);
> +
> +	return timespec_to_ktime(now);
> +}
> +
> +EXPORT_SYMBOL_GPL(ktime_get_real);
> +

Remove extra line before EXPORT_SYMBOL_GPL(ktime_get_real);

--
JSR

