Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbYLUMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbYLUMCT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 07:02:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751604AbYLUMCD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 07:02:03 -0500
Received: from mail.gondor.com ([212.117.64.182]:1851 "EHLO moria.gondor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490AbYLUMCB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 07:02:01 -0500
X-Greylist: delayed 379 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Dec 2008 07:02:00 EST
Date: Sun, 21 Dec 2008 12:55:39 +0100
From: Jan Niehusmann <jan@gondor.com>
To: Max Kellermann <max@duempel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: KVM guest lockup
Message-ID: <20081221115538.GA25958@x61s.gondor.com>
References: <20081219174401.GA2730@squirrel.roonstrasse.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081219174401.GA2730@squirrel.roonstrasse.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 06:44:01PM +0100, Max Kellermann wrote:
> By starting kvm with "-s", I was able to attach gdb to KVM.  The
> following backtrace is with default options:
> 
>  #0  0xffffffff8023f3e0 in update_wall_time () at kernel/time/timekeeping.c:515
[...]

> The next one is with "noapic nolapic acpi=off":
>  
>  #0  0xffffffff8023f35a in update_wall_time () at kernel/time/timekeeping.c:501
> Both backtraces are from vanilla 2.6.28-rc8, .config attached.
[...]

Looking at the code, both these lines of code are inside a loop which
may run for quite a while if clocksource_read(clock) returns
non-monotonic values:

        offset = (clocksource_read(clock) - clock->cycle_last) & clock->mask;
	[...]
        while (offset >= clock->cycle_interval) {
                /* accumulate one interval */
                offset -= clock->cycle_interval;
	[...]
	}

As I observed such behaviour only when the host has frequency scaling
activated: Could it be that in this case, clocksource_read(clock) on the
guest is misbehaving?

Jan

