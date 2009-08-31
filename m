Return-Path: <linux-kernel-owner+w=401wt.eu-S1752793AbZHaOap@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793AbZHaOap (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 10:30:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752619AbZHaOan
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 10:30:43 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:41690 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbZHaOal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 10:30:41 -0400
Date: Mon, 31 Aug 2009 10:19:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, schwidefsky@de.ibm.com, tglx@linutronix.de
Cc: tglx@linutronix.de, linux-tip-commits@vger.kernel.org,
       linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       johnstul@us.ibm.com
Subject: Re: [tip:timers/core] clocksource: Resolve cpu hotplug dead lock
 with TSC unstable
Message-ID: <20090831101928.4c00c797@skybase>
In-Reply-To: <tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org>
References: <new-submission>
	<tip-7285dd7fd375763bfb8ab1ac9cf3f1206f503c16@git.kernel.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Aug 2009 18:34:00 GMT
tip-bot for Thomas Gleixner <tglx@linutronix.de> wrote:

> Commit-ID:  7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> Gitweb:     http://git.kernel.org/tip/7285dd7fd375763bfb8ab1ac9cf3f1206f503c16
> Author:     Thomas Gleixner <tglx@linutronix.de>
> AuthorDate: Fri, 28 Aug 2009 20:25:24 +0200
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Fri, 28 Aug 2009 20:25:24 +0200
> 
> clocksource: Resolve cpu hotplug dead lock with TSC unstable
> 
> Martin Schwidefsky analyzed it:
> To register a clocksource the clocksource_mutex is acquired and if
> necessary timekeeping_notify is called to install the clocksource as
> the timekeeper clock. timekeeping_notify uses stop_machine which needs
> to take cpu_add_remove_lock mutex.
> Starting a new cpu is done with the cpu_add_remove_lock mutex held.
> native_cpu_up checks the tsc of the new cpu and if the tsc is no good
> clocksource_change_rating is called. Which needs the clocksource_mutex
> and the deadlock is complete.
> 
> The solution is to replace the TSC via the clocksource watchdog
> mechanism. Mark the TSC as unstable and schedule the watchdog work so
> it gets removed in the watchdog thread context.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> LKML-Reference: <new-submission>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: John Stultz <johnstul@us.ibm.com>

Ah, very good. I've been going round in circles to find a solution that
allows to  downgrade the tsc rating when the second cpu is enabled.
Could not find a solution. Your approach changes semantics slightly:
the tsc clock will continue with its old rating for a while until the
watchdog will do the downgrade. If that is acceptable then this is a
good solution.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

