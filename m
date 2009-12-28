Return-Path: <linux-kernel-owner+w=401wt.eu-S1750988AbZL1HpF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750988AbZL1HpF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 02:45:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750830AbZL1HpB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 02:45:01 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:36033 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZL1HpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 02:45:00 -0500
Date: Mon, 28 Dec 2009 08:44:26 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: Re: [PATCH] perf_event: mount debugfs automatically
Message-ID: <20091228074426.GA20039@elte.hu>
References: <4B383DE3.3070702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B383DE3.3070702@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Xiao Guangrong <xiaoguangrong@cn.fujitsu.com> wrote:

> Mount debugfs automatically if it's not mounted, umount it
> when programme exit
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
> ---
>  tools/perf/perf.c         |   10 +++++++++-
>  tools/perf/util/debugfs.c |   16 +++++++---------
>  tools/perf/util/debugfs.h |    2 +-
>  3 files changed, 17 insertions(+), 11 deletions(-)

I'm not sure that's a good idea. What happens if two perf tools are running in 
parallel:

  perf report #1 start
                          perf report #2 start
  perf report #2 exit [umount debugfs]
                          perf report #2 tries to open /debug file: kaboom
                          perf report #2 exit

But your idea is sound if we only do the first half: we should mount it under 
/sys/kernel/debug/ if it's not mounted already [and that directory is 
available], and leave it mounted there.

Furthermore please not that we must not mount it under any other path - 
mounting is always a dangerous operation because it changes the VFS namespace. 
For example some system might have some local files under /debug for whatever 
reason, we must not over-mount it and potentially destroy data because we'd 
confuse an app that writes into /debug. /sys/kernel/debug/ is a fair game to 
mount into OTOH.

(and even then we should just leave it mounted and never umount it.)

Thanks,

	Ingo
