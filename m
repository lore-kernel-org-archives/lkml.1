Return-Path: <linux-kernel-owner+w=401wt.eu-S1752927Ab0A3XqW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752927Ab0A3XqW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 18:46:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543Ab0A3XqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 18:46:21 -0500
Received: from mail-iw0-f173.google.com ([209.85.223.173]:51628 "EHLO
	mail-iw0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752450Ab0A3XqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 18:46:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=keoTml1HqeqIhuZ189OpDheYH+B+pfG9U1r++D+4OHnIVL9jAzyTLEjlZPd19iSs9U
         yoZdBKgTKYBXzvpqhqGsEVvMkVEQlesz8hCMEdX2gDOg+sMpPlk5d0JR4wuPWzlYoL/V
         yKNXUmuhAgkVMNi5N7ONDyC4lSgKnDXV7rlAQ=
Date: Sat, 30 Jan 2010 17:45:51 -0600
From: Shawn Bohrer <shawn.bohrer@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
Subject: High scheduler wake up times
Message-ID: <20100130234551.GA27390@mediacenter.gateway.2wire.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Currently we have a workload that depends on around 50 processes that
wake up 1000 times a second do a small amount of work and go back to
sleep.  This works great on RHEL 5 (2.6.18-164.6.1.el5), but on recent
kernels we are unable to achieve 1000 iterations per second.  Using
the simple test application below on RHEL 5 2.6.18-164.6.1.el5 I can run
500 of these processes on and still achieve 999.99 iterations per
second.  Running just 10 of these processes on the same machine with
2.6.32.6 produces results like:

...
Iterations Per Sec: 905.659667
Iterations Per Sec: 805.099068
Iterations Per Sec: 925.195578
Iterations Per Sec: 759.310773
Iterations Per Sec: 702.849261
Iterations Per Sec: 782.157292
Iterations Per Sec: 917.138031
Iterations Per Sec: 834.770391
Iterations Per Sec: 850.543755
...

I've tried playing with some of the cfs tunables in /proc/sys/kernel/
without success.  Are there any suggestions on how to achieve the
results we are looking for using a recent kernel?

Thanks,
Shawn


#include <sys/epoll.h>
#include <sys/time.h>
#include <stdio.h>
#include <unistd.h>

int main ()
{
	int epfd = epoll_create(1);
	int i, j;
	struct timeval tv;
	unsigned long start, end;
	const unsigned int count = 60000;

	while (1) {
		gettimeofday(&tv, NULL);
		start = tv.tv_sec * 1000000 + tv.tv_usec;

		for (i = 0; i < count; ++i) {
			if (epoll_wait(epfd, 0, 1, 1) == -1)
				perror("epoll failed");

			for (j = 0; j < 10000; ++j)
				/* simulate work */;
		}
		gettimeofday(&tv, NULL);
		end = tv.tv_sec * 1000000 + tv.tv_usec;

		printf("Iterations Per Sec: %f\n", count/((double)(end - start)/1000000));
	}

	close(epfd);
}

