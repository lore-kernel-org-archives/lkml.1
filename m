Return-Path: <linux-kernel-owner+w=401wt.eu-S1755781AbZHVVPF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781AbZHVVPF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Aug 2009 17:15:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755303AbZHVVPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Aug 2009 17:15:04 -0400
Received: from mtagate2.de.ibm.com ([195.212.17.162]:48976 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125AbZHVVPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Aug 2009 17:15:02 -0400
Date: Sat, 22 Aug 2009 23:14:57 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       johnstul@us.ibm.com, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:timers/core] x86: Do not unregister PIT clocksource on	PIT
 oneshot setup/shutdown
Message-ID: <20090822231457.7139bd00@skybase>
In-Reply-To: <20090822103541.GA26476@elte.hu>
References: <tip-8cab02dc3c58a12235c6d463ce684dded9696848@git.kernel.org>
	<20090822103541.GA26476@elte.hu>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Aug 2009 12:35:41 +0200
Ingo Molnar <mingo@elte.hu> wrote:

> even after this fix, -tip testing found yet another circular locking 
> bug, on a 32-bit Core2 laptop:

You got to love lockdep .. another ugly one:
clocksource_register: has clocksource_mutex, get cpu_add_remove_lock
native_cpu_up: has cpu_add_remove_lock, get clocksource_mutex

To register a clocksource the clocksource_mutex is acquired and if
necessary timekeeping_notify is called to install the clocksource as
the timekeeper clock. timekeeping_notify uses stop_machine which needs
to take cpu_add_remove_lock mutex.
Starting a new cpu is done with the cpu_add_remove_lock mutex held.
native_cpu_up checks the tsc of the new cpu and if the tsc is no good
clocksource_change_rating is called. Which needs the clocksource_mutex
and the deadlock is complete.

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

