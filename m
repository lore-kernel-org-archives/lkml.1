Return-Path: <linux-kernel-owner+w=401wt.eu-S1755184AbZARXim@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184AbZARXim (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 18:38:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753220AbZARXid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 18:38:33 -0500
Received: from hera.kernel.org ([140.211.167.34]:36535 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbZARXic (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 18:38:32 -0500
Message-ID: <4973BD73.6010001@kernel.org>
Date: Mon, 19 Jan 2009 08:38:27 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Brian Gerst <brgerst@gmail.com>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] x86-64: Convert irqstacks to per-cpu
References: <1232296759-2253-1-git-send-email-tj@kernel.org>	 <1232296759-2253-4-git-send-email-tj@kernel.org> <73c1f2160901181016t61cd1954s3ced677ab5b3b28a@mail.gmail.com>
In-Reply-To: <73c1f2160901181016t61cd1954s3ced677ab5b3b28a@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sun, 18 Jan 2009 23:38:26 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Brian.

Brian Gerst wrote:
>>    * irq_stack_ptr is not used till traps_init(), no reason to
>>      initialize it early.  On SMP, just leaving it NULL till proper
>>      initialization in setup_per_cpu_areas() works.  Dropped
>>      is_boot_cpu and early irq_stack_ptr initialization.
> 
> And it adds more #ifdefs.  All these conditional initializations on
> CONFIG_SMP are really cluttering up the code.

Yes, at the cost of removing a hidden relocation in head_64.S.  We can
also remove #ifdef there and just comment that it will be overridden
during setup_per_cpu_areas() but I think #ifdef there is better for
documentation purposes.

> It also conflicts with one of my goals with these patches: have as
> much state as possible already prepared when a cpu boots.  For the
> boot cpu this means static initialization.  For secondary cpus, that
> means setting up the values in setup_per_cpu_areas().  This
> eliminates any window where the state isn't ready yet, as you've
> already seen with per_cpu_offset.

I like the goal but it has certain dangers in the current form because
the boot cpu is using the init data area not its actual percpu area,
so each usage needs to be closely controlled till actual per cpu areas
are setup, so I think in the current form I don't think there's a good
reason to hurry initialization of variables which are not used early.
It also in a way fragments initialization paths further.  It would be
nice if boot cpu and secondary cpus can do it using the same path at
different times.

> And is_boot_cpu was a worthwhile optimization on its own.  I had plans
> on using it in more places later.

I didn't have any objection against it but with the additional
relocation removed, it looked out of place in the patch.  Please feel
free to add it back as necessary.

Thanks.

-- 
tejun
