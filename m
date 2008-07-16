Return-Path: <linux-kernel-owner+w=401wt.eu-S1752397AbYGPEG2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752397AbYGPEG2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 00:06:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750723AbYGPEGT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 00:06:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59329 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbYGPEGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 00:06:18 -0400
Message-ID: <487D738B.4070104@jp.fujitsu.com>
Date: Wed, 16 Jul 2008 13:05:31 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Rusty Russell <rusty@rustcorp.com.au>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stopmachine: add stopmachine_timeout
References: <487B05CE.1050508@jp.fujitsu.com> <200807142043.56968.rusty@rustcorp.com.au> <487BF946.1050006@jp.fujitsu.com> <200807151750.12131.rusty@rustcorp.com.au>
In-Reply-To: <200807151750.12131.rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rusty,

Rusty Russell wrote:
> On Tuesday 15 July 2008 11:11:34 Hidetoshi Seto wrote:
>> However we need to be careful that the stuck CPU can restart unexpectedly.
> 
> OK, if you are worried about that race, I think we can still fix it...

After having a relaxing day, once I said:
 "I like your idea that if we did not want to do something on the stuck CPU
  then treat the CPU as stopped."
but now I noticed that the stuck CPU can harm what we want to do if it is
not real stuck... ex. busy loop in a subsystem, and we want to touch the
core of the subsystem exclusively.
So "force progress" is not safe, on some rare case.  I'd like to make this
timeout feature as a safe-net, therefore we should return error without
taking a risk even it would be small, I think.

> Hmm, there's still the vague possibility that the thread doesn't schedule 
> until we start a new stop_machine (and clear prepared_cpus).  We could simply 
> loop in the main thread if any threads are alive, before freeing them (inside 
> the lock).  A counter and notifier is the other way, but it seems like 
> overkill for a very unlikely event.

I suppose my current implementation, returning control to user immediately,
is better than looping in main thread.  In my implementation, num_threads is
initialized to num_online_cpus() by main thread, and decremented 1 by 1
each child thread.  If time out happen, main thread will return without
waiting completion but set state STOPMACHINE_EXIT.  Then child threads are now
detached from usual procedure, so they exit soon without do any work.

At the beginning of new stop_machine, we can check the num_threads to know
whether there are remaining child threads.  If there are, something is wrong
since the system cannot run MAX_PRIO RT thread, not binded to typical cpu now.
So we can return error in such case, assuming that the new stop_machine will
fail in same way.

Anyway, I also think we can better thing here, but we don't need to do all
at once.  Making steps by incremental patches would be nice, I think.

Thanks,
H.Seto
