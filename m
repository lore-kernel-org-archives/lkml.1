Return-Path: <linux-kernel-owner+w=401wt.eu-S1753544AbYKZPRe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544AbYKZPRe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 10:17:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYKZPR0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 10:17:26 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:31173 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYKZPRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 10:17:25 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [patch] fix for sched_clock() when using jiffies
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ron <ron@debian.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <20081126150645.GA28153@homer.shelbyville.oz>
References: <20081126150645.GA28153@homer.shelbyville.oz>
Content-Type: text/plain
Date: Wed, 26 Nov 2008 16:16:38 +0100
Message-Id: <1227712598.4454.199.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-11-27 at 01:36 +1030, Ron wrote:
> Hi,
> 
> I'm in the process of updating a port for an ARM based chip we've been
> working on, from 2.6.22-rc4'ish to the current HEAD of Linus' tree, and
> I started seeing the following:
> 
> [    0.000000] PID hash table entries: 512 (order: 9, 2048 bytes)
> [42949372.970000] Dentry cache hash table entries: 16384 (order: 4, 65536 bytes)
> 
> The reason appears to be that printk_clock() has been replaced with a
> call to cpu_clock, which in our case currently falls back to the default
> (weak) implementation of sched_clock() that uses jiffies -- but doesn't
> account for the initial offset of the jiffy count.  The following simple
> patch fixes it for me, in line with what printk_clock used to do.
> 

Looks good, except I suspect this line will now be longer than 80
characters and you forgot to provide your signed-off-by line.

> 
> diff --git a/kernel/sched_clock.c b/kernel/sched_clock.c
> index 8178724..d76814e 100644
> --- a/kernel/sched_clock.c
> +++ b/kernel/sched_clock.c
> @@ -37,7 +37,7 @@
>   */
>  unsigned long long __attribute__((weak)) sched_clock(void)
>  {
> -       return (unsigned long long)jiffies * (NSEC_PER_SEC / HZ);
> +       return (unsigned long long)(jiffies - INITIAL_JIFFIES) * (NSEC_PER_SEC / HZ);
>  }
>  
> 

