Return-Path: <linux-kernel-owner+w=401wt.eu-S1754321AbZDTH05@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321AbZDTH05 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:26:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753964AbZDTH0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:26:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58816 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994AbZDTH0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:26:33 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RESEND][PATCH -tip 2/3] x86, mce: Revert "add mce=nopoll option to disable timer polling"
From: Andi Kleen <andi@firstfloor.org>
References: <49EBCDB0.7000505@jp.fujitsu.com>
	<49EBCF67.1060400@jp.fujitsu.com>
Date: Mon, 20 Apr 2009 09:26:29 +0200
In-Reply-To: <49EBCF67.1060400@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 20 Apr 2009 10:27:03 +0900")
Message-ID: <87r5znpyze.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> Disabling only polling but not cmci is pointless setting.
> Instead of "mce=nopoll" which tend to be paired with cmci disablement,
> it rather make sense to have a "mce=ignore_ce" option that disable
> both of polling and cmci at once.  A patch for this new implementation
> will follow this reverting patch.
>
> OTOH, once booted, we can disable polling by setting check_interval
> to 0, but there are no mention about the fact.  Later Andi will post
> updated documents that can respond this issue.

I still think that patch has bad semantics because you leave around
the events in the machine check registers and never clear
them. Especially with MCA recovery that has very unfortunate side
effects -- it means the OVER bit will be set and a in principle
recoverable MCA will require a panic. Even without MCA recovery it has
similar problems and will lead to confusing log output for non CE
MCAs.

I think a patch to not log corrected errors would be reasonable,
but you still need to clear the events from the machine check
banks at least.

So I would recommend you add a mce=dont_log_ce or somesuch
that just guards the mce_log() call in machine_check_poll()

Also for your use case really the better way would be to use
some way to let the firmware communicate that it doesn't want the OS
to log.

Also BTW before adding new features like this it would be a good
idea to first add the bug fixes I posted two weeks ago.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
