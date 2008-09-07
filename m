Return-Path: <linux-kernel-owner+w=401wt.eu-S1755943AbYIGSLo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbYIGSLo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 14:11:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754268AbYIGSLf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 14:11:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:39791 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754138AbYIGSLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 14:11:34 -0400
Date: Sun, 7 Sep 2008 11:11:37 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, tglx@tglx.de, torvalds@linux-foundation.org,
       peterz@infradead.org
Subject: update on hrtimer based select/poll and range-hrtimers
Message-ID: <20080907111137.76a10b1e@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

since the last lkml posting I've merged a few fixes and added comments
from Peter, and I've redone the "estimate_accuracy" function.

Rather than reposting the entire series, I'll point to the git tree at

git://git.kernel.org/pub/scm/linux/kernel/git/arjan/linux-2.6-hrtimer.git

and I've pasted the new function below.
Rather than having the hardcoded steps from the "Linus" function, I've
turned it into:
0 for realtime tasks
"0.1% of the time" for not-nice, not realtime tasks
"0.5% of the time" for nice, not realtime tasks
with a cap of 100msec for both.

I would like to request feedback on this approach; I think this is
better than the "hardcoded steps" as before, but maybe someone can come
up with an ever better idea....

static unsigned long __estimate_accuracy(struct timespec *tv)
{
        unsigned long slack;
        int divfactor = 1000;
  
        if (task_nice(current))
                divfactor = divfactor / 5;

        slack = tv->tv_nsec / divfactor; 
        slack += tv->tv_sec * (NSEC_PER_SEC/divfactor);

        if (slack > 100 * NSEC_PER_MSEC)
                slack =  100 * NSEC_PER_MSEC;
        return slack;
}

static unsigned long estimate_accuracy(struct timespec *tv)
{
        unsigned long ret;
        struct timespec now;

        /*
         * Realtime tasks get a slack of 0 for obvious reasons.
         */

        if (current->policy == SCHED_FIFO ||
                current->policy == SCHED_RR)
                return 0;

        ktime_get_ts(&now);
        now = timespec_sub(*tv, now);
        ret = __estimate_accuracy(&now);
        if (ret < current->timer_slack_ns)
                return current->timer_slack_ns;
        return ret;
}
