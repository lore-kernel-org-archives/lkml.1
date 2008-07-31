Return-Path: <linux-kernel-owner+w=401wt.eu-S1757434AbYGaSnS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbYGaSnS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 14:43:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753551AbYGaSnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 14:43:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36464 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753481AbYGaSnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 14:43:03 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@openvz.org>,
       Oleg Nesterov <oleg@tv-sign.ru>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Paul Menage <menage@google.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080731170022.GE9663@sgi.com>
Date: Thu, 31 Jul 2008 11:35:19 -0700
In-Reply-To: <20080731170022.GE9663@sgi.com> (Robin Holt's message of "Thu, 31
	Jul 2008 12:00:22 -0500")
Message-ID: <m1prot297c.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Robin Holt <holt@sgi.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0450]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 XMBrknScrpt_02 Possible Broken Spam Script
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Patch] Scale pidhash_shift/pidhash_size up based on num_possible_cpus().
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robin Holt <holt@sgi.com> writes:

> For large cpu configurations, we find the number of pids in a pidhash
> bucket cause things like 'ps' to perform slowly.  Raising pidhash_shift
> from 12 to 16 cut the time for 'ps' in half on a 2048 cpu machine.
>
> This patch makes the upper limit scale based upon num_possible_cpus().
> For machines 128 cpus or less, the current upper limit of 12 is
> maintained.

It looks like there is a magic limit we are dancing around.

Can we please make the maximum for the hash table size be based
on the maximum number of pids.  That is fls(PID_MAX_LIMIT) - 6?

12 actually looks like it was fls(PID_MAX_LIMIT) - 3 at one point in
time.

Basing the hash table size on PID_MAX_LIMIT seems to say interesting
about the maximum number of hash chain entries we will tolerate in
practice.

Eric

> Signed-off-by: Robin Holt <holt@sgi.com>
>
>
> Index: contention_unroll/kernel/pid.c
> ===================================================================
> --- contention_unroll.orig/kernel/pid.c	2008-07-31 11:59:21.154284073 -0500
> +++ contention_unroll/kernel/pid.c	2008-07-31 11:59:22.862497720 -0500
> @@ -502,9 +502,10 @@ void __init pidhash_init(void)
>  {
>  	int i, pidhash_size;
>  	unsigned long megabytes = nr_kernel_pages >> (20 - PAGE_SHIFT);
> +	int pidhash_shift_ul = max(12, fls(num_possible_cpus() - 1) + 5);
>  
>  	pidhash_shift = max(4, fls(megabytes * 4));
> -	pidhash_shift = min(12, pidhash_shift);
> +	pidhash_shift = min(pidhash_shift_ul, pidhash_shift);
>  	pidhash_size = 1 << pidhash_shift;
>  
>  	printk("PID hash table entries: %d (order: %d, %Zd bytes)\n",
