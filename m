Return-Path: <linux-kernel-owner+w=401wt.eu-S1755374AbYANKln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755374AbYANKln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2008 05:41:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752351AbYANKlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jan 2008 05:41:35 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:39035 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYANKlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2008 05:41:35 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Peter Zijlstra <peterz@infradead.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1200306902.5887.39.camel@johannes.berg>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 14 Jan 2008 11:41:28 +0100
Message-Id: <1200307288.7415.11.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-01-14 at 11:35 +0100, Johannes Berg wrote:
> > > When I "halt -p", lockdep warnings triggered as following (hand copy):
> > > 
> > > WARNING : at kernel/lockdep.c: 700 lookup_lock_class()
> > > 
> > > <snip>
> > > lock_acquire
> > > cleanup_workqueue_thread
> > > workqueue_cpu_callback
> > > notifier_call_chain
> > > __raw_notifier_call_chain
> > > raw_notifier_call_chain
> > > __cpu_down
> > > disable_nonboot_cpus
> > > kernel_power_off
> > > sys_reboot
> > > <snip>
> > 
> > My first guess would be a __create_workqueue_key() where a key is
> > re-used with a different workqueue name.
> 
> Hm, can you elaborate how you got there from the trace above? I don't
> think I'm following.

The warning that triggered (lockdep.c:700) means that one class (key)
was used with more than one name.

Looking at cleanup_workqueue_thread(), the lock_acquire() there works on
wq->lockdep_map, and that is only initialized at one spot:
__create_workqueue_key(), thus it stands to reason that that was
mis-used.



