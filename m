Return-Path: <linux-kernel-owner+w=401wt.eu-S1754077AbYA1UOG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbYA1UOG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:14:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752073AbYA1UNz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:13:55 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:57666 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbYA1UNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:13:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=F/DEX0tLheqlPxjwBTrIYjqc4S9jWnloWvgtELRUdqCz2c2Y1S9j18ytBM9Bw3PXVxPeYib//vm0qzJTTkePw9yZpNXJWSrb7l4vmBL/gRZXyT9q+CeVYd1lDh5G3ISgEjVo6gXg9nj6rTF0DwkeLE0ytbuHmEtsNP80MAjgJQE=
Message-ID: <3d8471ca0801281213l5ec62984i763afb22216cb423@mail.gmail.com>
Date: Mon, 28 Jan 2008 21:13:53 +0100
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: vatsa@linux.vnet.ibm.com
Subject: Re: High wake up latencies with FAIR_USER_SCHED
Cc: "Ingo Molnar" <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       a.p.zijlstra@chello.nl, dhaval@linux.vnet.ibm.com
In-Reply-To: <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3d8471ca0801271201o5a41955cg552ef06a2f821285@mail.gmail.com>
	 <20080128023129.GD1044@linux.vnet.ibm.com>
	 <3d8471ca0801280857m2ea8518ds2ad8d5346f756a0e@mail.gmail.com>
X-Google-Sender-Auth: 6994625304679651
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately it seems to not be completely fixed, with this script:

#!/usr/bin/python

import os
import time

SLEEP_TIME = 0.1
SAMPLES = 5
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
    if os.fork() == 0:
        os.setuid(1)
        while True:
            pass
    else:
        os.setuid(2)
        while True:
            pass
else:
    os.setuid(1)
    print_wakeup_latency()

I get seemingly unpredictable latencies (with or without the patch applied):

# ./sched.py
14.810944 ms
19.829893 ms
1.968050 ms
8.021021 ms
-0.017977 ms
4.926109 ms
11.958027 ms
5.995893 ms
1.992130 ms
0.007057 ms
0.217819 ms
-0.004864 ms
5.907202 ms
6.547832 ms
-0.012970 ms
0.209951 ms
-0.002003 ms
4.989052 ms

Without FAIR_USER_SCHED, latencies are consistently in the noise.
Also, I forgot to mention that I'm on a single CPU.

Thanks for the help.

-- 
Guillaume
