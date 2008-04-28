Return-Path: <linux-kernel-owner+w=401wt.eu-S966309AbYD1SxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966309AbYD1SxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 14:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965964AbYD1Swz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 14:52:55 -0400
Received: from relay2.sgi.com ([192.48.171.30]:38241 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965948AbYD1Swy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 14:52:54 -0400
Date: Mon, 28 Apr 2008 13:52:52 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-ID: <20080428185252.GC1167@sgi.com>
References: <20080423201613.GA8546@sgi.com> <20080428165544.GE18210@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080428165544.GE18210@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2008 at 06:55:44PM +0200, Ingo Molnar wrote:
> 
> good idea - but why dont you set softlockup_thresh to 0, which is the 
> "off" switch already? (and that way it can be turned back on later as 
> well, by the sysadmin.)
> 

I'm getting unaligned access errors trying to set it to anything, so it's not working for me currently (2.6.25):

It's tripping up on the address of 'one', which is an int that is not properly aligned for the unsigned long comparison in proc_doulongvec_minmax on my 64 bit machine.  Also, the value '0' is invalid for softlockup_thresh, correct?

I temporarily got around these issues with the following hack.

Index: linux/kernel/sysctl.c
===================================================================
--- linux.orig/kernel/sysctl.c  2008-04-16 21:49:44.000000000 -0500
+++ linux/kernel/sysctl.c       2008-04-28 13:37:43.000561710 -0500
@@ -748,9 +748,9 @@ static struct ctl_table kern_table[] = {
                .data           = &softlockup_thresh,
                .maxlen         = sizeof(unsigned long),
                .mode           = 0644,
-               .proc_handler   = &proc_doulongvec_minmax,
+               .proc_handler   = &proc_dointvec_minmax,
                .strategy       = &sysctl_intvec,
-               .extra1         = &one,
+               .extra1         = &zero,
                .extra2         = &sixty,



Also, I'm not convinced that changing this to 0 does indeed switch off softlockup detection (but I could be missing something):

void softlockup_tick(void)
{
..
..
        /* Warn about unreasonable delays: */
        if (now <= (touch_timestamp + softlockup_thresh))
                return;
        
        per_cpu(print_timestamp, this_cpu) = touch_timestamp;
   
        spin_lock(&print_lock);
        printk(KERN_ERR "BUG: soft lockup - CPU#%d stuck for %lus! [%s:%d]\n",
                        this_cpu, now - touch_timestamp,
                        current->comm, task_pid_nr(current));


Dimitri
