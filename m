Return-Path: <linux-kernel-owner+w=401wt.eu-S1752715AbZBPTSz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbZBPTSz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 14:18:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751209AbZBPTSr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 14:18:47 -0500
Received: from hot.fatooh.org ([208.78.103.127]:60207 "EHLO hot.fatooh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119AbZBPTSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 14:18:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=fatooh.org; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to:
	content-type; q=dns; s=domainkeys; b=Xiqotpo8smJb4eGfQT3abat/JRK
	0jhP+VHGYdO7BRS8d3WofzmLXdF4tkW4Yl5bkgqxJa6UTpy4bPLnnBQbBhdcg/yo
	aDRIsGUpixPYgODl/Jc3G92Qn3JNrNO/HQNgx0t+tLiO6hrEZP2xCRKOuypGK/Xw
	/rl7Nn7uDZCT0kHo=
Message-ID: <4999BC0C.1010304@fatooh.org>
Date: Mon, 16 Feb 2009 11:18:36 -0800
From: Corey Hickey <bugfood-ml@fatooh.org>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Bharata B Rao <bharata@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, mtk.manpages@gmail.com
Subject: Re: RT scheduling and a way to make a process hang, unkillable
References: <4997672B.1000301@fatooh.org> <1234697096.4713.24.camel@laptop> <20090216103636.GC17355@linux.vnet.ibm.com> <1234782516.4703.15.camel@laptop> <20090216120213.GB3925@linux.vnet.ibm.com> <1234787082.30178.3.camel@laptop> <20090216131440.GC3925@linux.vnet.ibm.com> <20090216132014.GD3925@linux.vnet.ibm.com>
In-Reply-To: <20090216132014.GD3925@linux.vnet.ibm.com>
Content-Type: multipart/mixed;
 boundary="------------090501020801040100000406"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090501020801040100000406
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Dhaval Giani wrote:
> And it continues on! Please try this version.
> 
> sched: Don't allow setuid to succeed if the user does not have rt bandwidth
> 
> Corey Hickey reported that on using setuid to change the uid of a
> rt process, the process would be unkillable and not be running.
> This is because there was no rt runtime for that user group. Add
> in a check to see if a user can attach an rt task to its task group.
> 
> Disclaimer: Not sure about the return values, and if setuid allows
> return values other than EPERM and EAGAIN.
> 
> Changes from v3:
> 1. Actually fix the leak.
> 
> Changes from v2:
> 1. Patch compiles for CONFIG_CGROUP_SCHED as well
> 2. Fix two memory leaks.
> 
> Changes from v1:
> 1. Peter suggested that rt_task_can_change_user should be renamed to
> task_can_change_user
> 2. Changed sched_rt_can_attach to boolean.
> 
> Signed-off-by: Dhaval Giani <dhaval@linux.vnet.ibm.com>

Thank you, Peter and Dhaval, for looking at this. I appreciate your work.

I tested patch v4 on 2.6.29-rc5, and I get frequent kernel BUG messages.
Should I be testing your patch on a different source tree? The patch
applied to rc5 ok but with lots of offsets.

I attached the full dmesg log, and here's a sample of one of the messages:

------------------------------------------------------------------------
BUG: unable to handle kernel NULL pointer dereference at 00000034
IP: [<c011d642>] task_can_switch_user+0xe/0x28
*pde = 00000000
Oops: 0000 [#1]
last sysfs file: /sys/devices/virtual/net/lo/address
Modules linked in:

Pid: 1058, comm: vol_id Not tainted (2.6.29-rc5-fix1 #1) Satellite 5105
EIP: 0060:[<c011d642>] EFLAGS: 00010202 CPU: 0
EIP is at task_can_switch_user+0xe/0x28
EAX: 00000000 EBX: dfbe6ae0 ECX: 0000fffe EDX: c039a4a0
ESI: 00000000 EDI: 0000fffe EBP: dfbc7f88 ESP: dfbc7f80
 DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
Process vol_id (pid: 1058, ti=dfbc6000 task=dfbe6ae0 task.ti=dfbc6000)
Stack:
 fffffff4 df9a5e80 dfbc7f98 c0120c0a fffffff4 df9a5e80 dfbc7fb0 c0120da8
 df9a5180 0000fffe 00000003 bff8dec1 dfbc6000 c0102b45 0000fffe b8050ff4
 00000000 00000003 bff8dec1 bff8c918 000000d5 0000007b 0000007b c0100000
Call Trace:
 [<c0120c0a>] ? set_user+0x15/0x78
 [<c0120da8>] ? sys_setuid+0x4d/0x9d
 [<c0102b45>] ? sysenter_do_call+0x12/0x25
Code: f2 a1 90 b9 3f c0 e8 58 69 03 00 eb 02 53 9d b8 14 a9 39 c0 e8 fb
49 1b 00 5b 5e 5d c3 55 89 e5 56 53 89 d3 e8 3d fc ff ff 89 c6 <8b> 40
34 89 da e8 4b 22 ff ff 89 c3 89 f0 e8 04 ff ff ff 89 d8
EIP: [<c011d642>] task_can_switch_user+0xe/0x28 SS:ESP 0068:dfbc7f80
---[ end trace 3e1918a81c708690 ]---

Thank you,
Corey

--------------090501020801040100000406
Content-Type: application/gzip;
 name="dmesg.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dmesg.log.gz"

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
PSKUlBhK/gEmRj85BG4AAA==
--------------090501020801040100000406--
