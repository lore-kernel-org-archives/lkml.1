Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXKPTN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXKPTN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2007 14:13:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752174AbXKPTNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Nov 2007 14:13:49 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:34203 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbXKPTNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2007 14:13:48 -0500
Message-ID: <473DEBDD.2010706@davidnewall.com>
Date: Sat, 17 Nov 2007 05:43:33 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: Micah Dowty <micah@vmware.com>
CC: Kyle Moffett <mrmacman_g4@mac.com>, Cyrus Massoumi <cyrusm@gmx.net>,
       LKML Kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Mike Galbraith <efault@gmx.de>,
       Paul Menage <menage@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: Re: High priority tasks break SMP balancer?
References: <20071109223417.GB16250@vmware.com> <4734F397.7080802@gmx.net> <20071110001103.GD16250@vmware.com> <2FAA6826-653E-482F-A037-C539BAEEA1DA@mac.com> <20071115191408.GA4914@vmware.com>
In-Reply-To: <20071115191408.GA4914@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

There are a couple of points I would make about your python test 
harness.  Your program compares real+system jiffies for both cpus; an 
ideal result would be 1.00.  The measurement is taken over a relatively 
short period of approximately a half-second, and you kill the CPU hogs 
before taking final measurements, even wait for them to die first.  You 
repeat this measurement, starting and killing CPU hogs each time.  Why 
do you do that?

What happens if you start the hogs and take the baseline outside of the 
loop?

    from __future__ import division
    import sys, os, time

    def getCpuTimes():
        cpu0 = 0
        cpu1 = 1
        for line in open("/proc/stat"):
            tokens = line.split()
            if tokens[0] == "cpu0":
                cpu0 = int(tokens[1]) + int(tokens[3])
            elif tokens[0] == "cpu1":
                cpu1 = int(tokens[1]) + int(tokens[3])
        return cpu0, cpu1

    pid = os.spawnl(os.P_NOWAIT, "./priosched")
    baseline = getCpuTimes()
    while True:
        time.sleep(0.5)
        current = getCpuTimes()
        print "%.04f" % (current[0] - baseline[0]) / (current[1] -
    baseline[1])

