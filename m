Return-Path: <linux-kernel-owner+w=401wt.eu-S935607AbYCFUxs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607AbYCFUxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 15:53:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935415AbYCFUxN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 15:53:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:45257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935404AbYCFUxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 15:53:12 -0500
Date: Thu, 6 Mar 2008 12:51:53 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: g.liakhovetski@gmx.de, mingo@elte.hu, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       bunk@kernel.org, gregkh@suse.de
Subject: Re: 2.6.25-rc3-git3: Reported regressions from 2.6.24
Message-Id: <20080306125153.d95db2b9.akpm@linux-foundation.org>
In-Reply-To: <20080306121127.42ac0682.akpm@linux-foundation.org>
References: <200803030316.07165.rjw@sisk.pl>
	<20080306072704.GA28518@elte.hu>
	<Pine.LNX.4.64.0803062054110.8669@axis700.grange>
	<20080306121127.42ac0682.akpm@linux-foundation.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Mar 2008 12:11:27 -0800
Andrew Morton <akpm@linux-foundation.org> wrote:

> Reminder: what _does_ fix it is:
> 
> a) CONFIG_DETECT_SOFTLOCKUP=n or
> 
> b) This:
> 
> --- a/kernel/softlockup.c~softlockup-workaround
> +++ a/kernel/softlockup.c
> @@ -289,6 +289,7 @@ cpu_callback(struct notifier_block *nfb,
>  	case CPU_DEAD_FROZEN:
>  		p = per_cpu(watchdog_task, hotcpu);
>  		per_cpu(watchdog_task, hotcpu) = NULL;
> +		msleep(1);
>  		kthread_stop(p);
>  		break;
>  #endif /* CONFIG_HOTPLUG_CPU */

sysrq-t works: http://userweb.kernel.org/~akpm/x.txt

It shows that `halt' is stuck in kthread_stop(), waiting for `watchdog' to
go away.  But all the watchdog tasks are dreamily asleep, as if the wakeup
didn't work.

I'd love to poke around in kgdb (what does kthread_stop_info.k point at?)
but it seems that -mm's copy of kgdb got taken away when I wasn't looking. 
Can I have it back please?

(btw, it isn't compulsory that every cpu callback function be literally
called "cpu_callback").
