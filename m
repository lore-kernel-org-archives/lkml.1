Return-Path: <linux-kernel-owner+w=401wt.eu-S1753631AbZAKTDI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753631AbZAKTDI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 14:03:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753897AbZAKTCe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 14:02:34 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34338 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbZAKTCd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 14:02:33 -0500
Date: Sun, 11 Jan 2009 20:02:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dieter Ries <clip2@gmx.de>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: travis@sgi.com, rusty@rustcorp.com.au, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc1 does not boot
Message-ID: <20090111190218.GA18651@elte.hu>
References: <496A085E.8020604@gmx.de> <20090111151924.GA5722@elte.hu> <496A107A.2090301@gmx.de> <20090111153548.GB7401@elte.hu> <496A3F62.8090902@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <496A3F62.8090902@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dieter Ries <clip2@gmx.de> wrote:

> Bisected it:
> 
> ####################################################################
> 7503bfbae89eba07b46441a5d1594647f6b8ab7d is first bad commit
> commit 7503bfbae89eba07b46441a5d1594647f6b8ab7d
> Author: Mike Travis <travis@sgi.com>
> Date:   Sun Jan 4 05:18:09 2009 -0800
> 
> cpumask: use work_on_cpu in acpi-cpufreq.c for drv_read and drv_write
> 
> Impact: use new cpumask API to reduce stack usage

thanks, this is very helpful!

Mike, most of the work_on_cpu() patches you did so far were rather 
problematic. Especially something like cpufreq can run rather early during 
bootup or during suspend/resume, so i'm not sure it's correct to rely on 
keventd for it.

I dont see anything particularly wrong in the commit itself - but 
obviously it causes this boot hang - if the bug is not found we'll revert 
it .

Also, this bit in get_cur_val():

+       if (unlikely(!alloc_cpumask_var(&cmd.mask, GFP_KERNEL)))
+               return 0;

how is that supposed to work? If we fail to allocate a cpumask we just 
ignore the call silently? That cannot be right. (but has no connection to 
this boot problem)

	Ingo
