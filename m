Return-Path: <linux-kernel-owner+w=401wt.eu-S1756830AbZEJXNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756830AbZEJXNg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 May 2009 19:13:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751444AbZEJXN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 May 2009 19:13:27 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:56690 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbZEJXN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 May 2009 19:13:26 -0400
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: lockdep warnings: cpufreq ondemand gorvernor possibly circular locking
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Greg KH <greg@kroah.com>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ben Slusky <sluskyb@paranoiacs.org>,
       Dave Jones <davej@redhat.com>, Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <20090510110428.8c55aab1.akpm@linux-foundation.org>
References: <2f11576a0905100822y5507a9f7m6f9aa0fcc05ac18@mail.gmail.com> <20090510110428.8c55aab1.akpm@linux-foundation.org>
Message-Id: <20090511080509.B9A1.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 11 May 2009 08:13:24 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 11 May 2009 00:22:26 +0900 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > my box output following warnings.
> > it seems regression by commit 7ccc7608b836e58fbacf65ee4f8eefa288e86fac.
> > 
> > A: work -> do_dbs_timer()  -> cpu_policy_rwsem
> > B: store() -> cpu_policy_rwsem -> cpufreq_governor_dbs() -> work
> 
> I can't find any commit which matches
> 7ccc7608b836e58fbacf65ee4f8eefa288e86fac

Grr, sorry. it's mmotm only commit.

filename is cpufreq-fix-timer-teardown-in-ondemand-governor.patch.

commit 7ccc7608b836e58fbacf65ee4f8eefa288e86fac
Author: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Date:   Tue Apr 28 20:50:21 2009 +0200

    The problem is that dbs_timer_exit() uses cancel_delayed_work() when it
    should use cancel_delayed_work_sync().  cancel_delayed_work() does not
    wait for the workqueue handler to exit.

    The ondemand governor does not "seem" to be affected (read : race
    condition occurs very rarely) because the "if (!dbs_info->enable)" check
    at the beginning of the workqueue handler returns immediately without
    rescheduling the work.  The conservative governor in 2.6.30-rc has the
    same check as the ondemand governor, which makes things usually run
    smoothly.  However, if the governor is quickly stopped and then started,
    this could lead to the following race :

    dbs_enable could be reenabled and multiple do_dbs_timer handlers would
    run.  This is why a synchronized teardown is required.

    The patch applies to, at least, 2.6.28.x, 2.6.29.1, 2.6.30-rc2.



