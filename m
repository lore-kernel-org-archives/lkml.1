Return-Path: <linux-kernel-owner+w=401wt.eu-S1755249AbZBBOxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755249AbZBBOxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 09:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751797AbZBBOxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 09:53:16 -0500
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:60187 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751393AbZBBOxP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 09:53:15 -0500
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: "linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: next-20090202: task kmemleak:763 blocked for more than 120 seconds.
References: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Mon, 02 Feb 2009 14:53:05 +0000
In-Reply-To: <a4423d670902020327x61a1d9dehb1642b25ec7f82f1@mail.gmail.com> (Alexander Beregalov's message of "Mon\, 2 Feb 2009 14\:27\:28 +0300")
Message-ID: <tnxiqns28mm.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 02 Feb 2009 14:53:11.0024 (UTC) FILETIME=[F79C8F00:01C98545]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov <a.beregalov@gmail.com> wrote:
> It seems it is blocked forever.

Scanning the full memory may take a lot of time, depending on the
amount of RAM and the number of objects allocated. It is not unlikely
to take more than 120 seconds on some loaded systems. However, it
should call schedule() periodically to let other tasks run. Is your
system unresponsive during this?

> [ 1704.619898] INFO: task kmemleak:763 blocked for more than 120 seconds.
> [ 1704.697951] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
> disables this message.
> [ 1704.791613] kmemleak      D 0000000000000001  6008   763      2
[...]
> [ 1706.246334] no locks held by kmemleak/763.

It looks like the kmemleak thread is in the TASK_UNINTERUPTIBLE state.
This happens when it calls schedule_timeout_uninterruptible() to sleep
between scans. It probably took more than 120 to scan the memory and
hence the report.

It doesn't look like a problem, only that the watchdog thread checks
for uninterruptible tasks. I can try to make it sleep with
TASK_INTERRUPTIBLE to avoid the message.

Thanks.

-- 
Catalin
