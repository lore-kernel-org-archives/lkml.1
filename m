Return-Path: <linux-kernel-owner+w=401wt.eu-S1754745AbZLBIdL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbZLBIdL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:33:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754691AbZLBIdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:33:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42278 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754348AbZLBIdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:33:09 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B16262A.3030604@jp.fujitsu.com>
Date: Wed, 02 Dec 2009 17:32:42 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Stanislaw Gruszka <sgruszka@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Spencer Candland <spencer@bluehost.com>,
       =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
       Balbir Singh <balbir@in.ibm.com>
Subject: reproducer: invisible utime
References: <4AFB9029.9000208@jp.fujitsu.com> <20091112144919.GA6218@dhcp-lab-161.englab.brq.redhat.com> <1258038038.4039.467.camel@laptop> <20091112154050.GC6218@dhcp-lab-161.englab.brq.redhat.com> <4B01A8DB.6090002@bluehost.com> <20091117130851.GA3842@dhcp-lab-161.englab.brq.redhat.com> <1258464288.7816.305.camel@laptop> <20091119181744.GA3743@dhcp-lab-161.englab.brq.redhat.com> <4B05F835.10401@jp.fujitsu.com> <20091123100925.GB25978@dhcp-lab-161.englab.brq.redhat.com> <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
In-Reply-To: <20091123101612.GC25978@dhcp-lab-161.englab.brq.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This program can reproduce another problem that originally
task_{u,s}time() intended to solve, I think.

Adjustment by task_{u,s}time() was only applied on getrusage()
and /proc/<pid>/stat.  So even in .32-rc8, we can reproduce this
problem on sys_times() which has no adjustment.

I confirmed that my patches fix it, by thread_group_times().


Thanks,
H.Seto

===
/*
 * Sample program to demonstrate invisible utime
 */

#include <stdio.h>
#include <unistd.h>
#include <sys/times.h>

/* 300 million, arbitrary */
#define LOOP (300 * 1000 * 1000)

unsigned long lpt, l, c;

int do_loop(void)
{
	struct tms t1, t2;
	clock_t j1, j2;
	unsigned long i;

	printf("Loop %d times, sleeping %d times every %d.\n", l, l/c, c);
	printf("  start ...\n");
	j1 = times(&t1);
	for (i = 1; i <= l; i++)
		if (!(i % c))
			usleep(0);
	j2 = times(&t2);
	printf("  ... done.\n");

	/* tms_{u,s}time is clock_t */
	printf("  user   : %5d ms\n", (t2.tms_utime - t1.tms_utime) * 10);
	printf("  system : %5d ms\n", (t2.tms_stime - t1.tms_stime) * 10);
	printf("  elapse : %5d ms\n\n", (j2 - j1) * 10);

	return (t2.tms_utime - t1.tms_utime) * 10;
}

int main(int argc, char **argv)
{
	int u0, u1, u2, u3;
	int ticks;

	l = argc > 1 ? atoi(argv[1]) : LOOP;

	printf("### Prep:\n");
	c = l;
	ticks = do_loop();
	lpt = l / ticks;
	printf("loops/tick: %d\n", lpt);
	l = lpt * 1000;
	printf("change loop to %d to short test.\n\n", l);

	printf("### Test:\n");
	c = l;
	u0 = do_loop();
	c = lpt;
	u1 = do_loop();
	c = lpt / 2;
	u2 = do_loop();
	c = lpt / 8;
	u3 = do_loop();
	printf("result: %s\n\n",
		(u0 <= u1) && (u1 <= u2) && (u2 <= u3) ? "GOOD" : "BAD");
}

