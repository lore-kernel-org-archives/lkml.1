Return-Path: <linux-kernel-owner+w=401wt.eu-S1751973AbXCYRY4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbXCYRY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 13:24:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751979AbXCYRY4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 13:24:56 -0400
Received: from www17.your-server.de ([213.133.104.17]:1545 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973AbXCYRYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 13:24:55 -0400
Message-ID: <4606B09C.6030902@m3y3r.de>
Date: Sun, 25 Mar 2007 19:25:48 +0200
From: Thomas Meyer <thomas@m3y3r.de>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@atrey.karlin.mff.cuni.cz, Greg Kroah-Hartman <gregkh@suse.de>,
       Tony Luck <tony.luck@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>
Subject: Re: [3/5] 2.6.21-rc4: known regressions (v2)
References: <Pine.LNX.4.64.0703160925270.26106@woody.linux-foundation.org> <20070323185022.GQ752@stusta.de> <46055A3B.6050107@m3y3r.de> <m1slbu4j0p.fsf@ebiederm.dsl.xmission.com> <46056BF3.3070707@m3y3r.de> <m1odmi4gx5.fsf@ebiederm.dsl.xmission.com> <46058B47.60204@m3y3r.de> <m1fy7u3sas.fsf@ebiederm.dsl.xmission.com> <46065FED.8030206@m3y3r.de> <20070325144838.GD16477@stusta.de>
In-Reply-To: <20070325144838.GD16477@stusta.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk schrieb:
> On Sun, Mar 25, 2007 at 01:41:33PM +0200, Thomas Meyer wrote:
>   
>> ...
>> The first suspend to disk is ok. The second suspend to disk has a
>> strange behaviour:
>> 1.) write pm image
>> 2.) the system disable the non-boot cpus again (i guess this happens in
>> power_down())
>> 3.) the system doesn't power down.
>> 4.) pressing any key and the system powers down.
>> ...
>>     
>
> Is this also present with 2.6.20, or is it a regression?
>   
No, this one is not present in 2.6.20 and this error doesn't (head=
317ec6cd00f25d05d153a780bc178c5335f320ee) occur with NO_HZ=n and
HIGH_RES_TIMERS=n

This error is maybe related with this commit:

commit cd05a1f818073a623455a58e756c5b419fc98db9
Author: Thomas Gleixner <tglx@linutronix.de>
Date:   Sat Mar 17 00:25:52 2007 +0100

    [PATCH] clockevents: Fix suspend/resume to disk hangs

    I finally found a dual core box, which survives suspend/resume without
    crashing in the middle of nowhere. Sigh, I never figured out from the
    code and the bug reports what's going on.

    The observed hangs are caused by a stale state transition of the clock
    event devices, which keeps the RCU synchronization away from completion,
    when the non boot CPU is brought back up.

    The suspend/resume in oneshot mode needs the similar care as the
    periodic mode during suspend to RAM. My assumption that the state
    transitions during the different shutdown/bringups of s2disk would go
    through the periodic boot phase and then switch over to highres resp.
    nohz mode were simply wrong.

    Add the appropriate suspend / resume handling for the non periodic
    modes.

    Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

