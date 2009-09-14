Return-Path: <linux-kernel-owner+w=401wt.eu-S1754569AbZINHon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569AbZINHon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 03:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752996AbZINHom
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 03:44:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49872 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZINHol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 03:44:41 -0400
Date: Mon, 14 Sep 2009 00:43:01 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, lenb@kernel.org, mingo@elte.hu,
       peterz@infradead.org, yanmin_zhang@linux.intel.com,
       torvalds@linux-foundation.org, jens.axboe@oracle.com,
       Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Howells <dhowells@redhat.com>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Subject: Re: PATCH] cpuidle: A new variant of the menu governor to boost IO
 performance
Message-Id: <20090914004301.105196cc.akpm@linux-foundation.org>
In-Reply-To: <20090911174019.1ed02737@infradead.org>
References: <20090911174019.1ed02737@infradead.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Sep 2009 17:40:19 +0200 Arjan van de Ven <arjan@infradead.org> wrote:

> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: [PATCH] cpuidle: A new variant of the menu governor
> 
> This patch adds a new idle governor which balances power savings,
> energy efficiency and performance impact.
> 
> The reason for a reworked governor is that there have been
> serious performance issues reported with the existing code
> on Nehalem server systems.
> 
> To show this I'm sure Andrew wants to see benchmark results:
> (benchmark is "fio", "no cstates" is using "idle=poll")
> 
> 		no cstates	current linux	new algorithm
> 1 disk		107 Mb/s	85 Mb/s		105 Mb/s
> 2 disks		215 Mb/s	123 Mb/s	209 Mb/s
> 12 disks	590 Mb/s	320 Mb/s	585 Mb/s
> 
> In various power benchmark measurements, no degredation was found
> by our measurement&diagnostics team. Obviously a bit more power was
> used in the "fio" benchmark, due to the much higher performance.
> 
> The integration plan for this is to first add the new governor,
> but for one kernel generation, leave the old menu governor in place
> so that it's possible to separate out behavior from this governor
> versus other things in diagnostics. If no issues are found,
> I'll remove the old governor in the kernel cycle after that.
> 
> While it would be a novel idea to describe the new algorithm in this
> commit message, I cheaped out and described it in comments in the
> code instead.

This fails to compile in linux-next:

drivers/cpuidle/governors/menu-tng.o:(.discard+0x0): multiple definition of `__pcpu_unique_menu_devices'
drivers/cpuidle/governors/menu.o:(.discard+0x0): first defined here

because we have

static DEFINE_PER_CPU(struct menu_device, menu_devices);

in both menu.c and menu-tng.c.

Despite the `static', the percpu changes in

commit 7c756e6e19e71f0327760d8955f7077118ebb2b1
Author:     Tejun Heo <tj@kernel.org>
AuthorDate: Wed Jun 24 15:13:50 2009 +0900
Commit:     Tejun Heo <tj@kernel.org>
CommitDate: Wed Jun 24 15:13:50 2009 +0900

    percpu: implement optional weak percpu definitions

are emitting global symbol derived from `menu_devices' and they clash.


I'll rename menu_devices to fix that up, but we have a problem...
