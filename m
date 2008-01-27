Return-Path: <linux-kernel-owner+w=401wt.eu-S1756681AbYA0UB1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbYA0UB1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 15:01:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbYA0UBS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 15:01:18 -0500
Received: from ug-out-1314.google.com ([66.249.92.171]:24327 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbYA0UBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 15:01:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=cB5lUHchdOs6BjY/a9tQIUgrJCf1Avk2Xaro3BbBRO2BrT8WkmmXZHT1Md7qDGFOl65D3+ArVdUfjNvxkp3bqjdG+E7ELgYyRpJUl0IatbzZJMa+4+uUP3XiAkoLQl4i8S8apwWvVHZN2MdSUTbcnfH3wpkzCpW+I07eHSmx/cw=
Message-ID: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
Date: Sun, 27 Jan 2008 21:01:15 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Srivatsa Vaddagiri" <vatsa@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: High wake up latencies with FAIR_USER_SCHED
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 32da76536e9456ad
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I noticed some strangely high wake up latencies with FAIR_USER_SCHED
using this script:

#!/usr/bin/python

import os
import time

SLEEP_TIME = 0.1
SAMPLES = 100
PRINT_DELAY = 0.5

def print_wakeup_latency():
    times = []
    last_print = 0
    while True:
        start = time.time()
        time.sleep(SLEEP_TIME)
        end = time.time()
        times.insert(0, end - start - SLEEP_TIME)
        del times[SAMPLES:]
        if end > last_print + PRINT_DELAY:
            copy = times[:]
            copy.sort()
            print '%f ms' % (copy[len(copy)/2] * 1000)
            last_print = end

if os.fork() == 0:
    os.setuid(1)
    for i in xrange(2):
        if os.fork() == 0:
            while True:
                pass
else:
    os.setuid(2) # <-- here
    print_wakeup_latency()

We have two busy loops with UID=1.
And UID=2 maintains the running median of its wake up latency.
I get these latencies:

# ./sched.py
4.300022 ms
4.801178 ms
4.604006 ms
4.606867 ms
4.604006 ms
4.606867 ms
4.604006 ms
4.606867 ms
4.606867 ms
4.676008 ms
4.604006 ms
4.604006 ms
4.606867 ms

Disabling FAIR_USER_SCHED restores wake up latencies in the noise:

# ./sched.py
-0.156975 ms
-0.067091 ms
-0.022984 ms
-0.022984 ms
-0.022030 ms
-0.022030 ms
-0.022030 ms
-0.021076 ms
-0.015831 ms
-0.015831 ms
-0.016069 ms
-0.015831 ms

Strangely enough, another way to restore normal latencies is to change
setuid(2) to setuid(1), that is, putting the latency measurement in
the same group as the two busy loops.

Thanks in advance for any help.

-- 
Guillaume
