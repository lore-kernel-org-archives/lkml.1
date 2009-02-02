Return-Path: <linux-kernel-owner+w=401wt.eu-S1753970AbZBBPOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbZBBPOd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 10:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752184AbZBBPOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 10:14:23 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:56610 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751598AbZBBPOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 10:14:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=at5ZBEbG47eqCZSrPSdA1v3X9J9PbbLc2YJo332tBkiMqEgR9BpUsJFi1JGtPt7U/Y
         lFshAEqJJrvNS/9gTK/8HRPuI/vU417DpFA7NNGOQ0x7eRRkliNJ7MNqaYBe4byutox7
         BpdyE7IcTl6DFe+ysgtSv4RnNwfI5AoG4HYZo=
MIME-Version: 1.0
In-Reply-To: <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
	 <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
Date: Mon, 2 Feb 2009 16:14:16 +0100
Message-ID: <c62985530902020714i73a68b59t47f89bdb9971585b@mail.gmail.com>
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120 
	seconds.
From: =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Alexander Beregalov <a.beregalov@gmail.com>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Mandeep Singh Baines <msb@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/2/2 Catalin Marinas <catalin.marinas@arm.com>:
> Alexander Beregalov <a.beregalov@gmail.com> wrote:
>> It seems it is blocked forever.
>
> Scanning the full memory may take a lot of time, depending on the
> amount of RAM and the number of objects allocated. It is not unlikely
> to take more than 120 seconds on some loaded systems. However, it
> should call schedule() periodically to let other tasks run. Is your
> system unresponsive during this?
>
>> [ 1704.619898] INFO: task kmemleak:763 blocked for more than 120 seconds.
>> [ 1704.697951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
>> disables this message.
>> [ 1704.791613] kmemleak      D 0000000000000001  6008   763      2
> [...]
>> [ 1706.246334] no locks held by kmemleak/763.
>
> It looks like the kmemleak thread is in the TASK_UNINTERUPTIBLE state.
> This happens when it calls schedule_timeout_uninterruptible() to sleep
> between scans. It probably took more than 120 to scan the memory and
> hence the report.
>
> It doesn't look like a problem, only that the watchdog thread checks
> for uninterruptible tasks. I can try to make it sleep with
> TASK_INTERRUPTIBLE to avoid the message.
>
> Thanks.
>
> --
> Catalin
> --


Hi,

May be it would be better to make the softlockup detector hooking into
schedule_timeout()
(ie by using a tracepoint) to check if a thread chose to sleep more
than hung_task_timeout_secs
intentionally in a TASK_UNINTERRUPTIBLE state.

Fixing it into kmemleak would not solve the problem in other tasks
which do similar sleeps...

Mandeep, if you want I can try something? Or perhaps you prefer to do
it yourself. As you wish.
