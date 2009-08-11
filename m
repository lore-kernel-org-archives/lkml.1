Return-Path: <linux-kernel-owner+w=401wt.eu-S1753440AbZHKPlH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440AbZHKPlH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 11:41:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752159AbZHKPlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 11:41:06 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:65041 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883AbZHKPlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 11:41:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=FQbxqKB/+km8SVH/FXAPFH2QWddKhxsRL9wHkovZmXEl6s7VJNO8ej10c9ukNIAsos
         2h3QJY/GCqQFlBjOyYWMIaJ+GybO5fxq1mXVo0P4LqP3YspOQedckw67naCWy9McDltV
         c0jrH24AXSbE3YL/OpFxkvMdrspW6+Ym8zBr0=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Tue, 11 Aug 2009 17:41:03 +0200
Message-ID: <7c86c4470908110841wca07382gf7487c0ed55909f2@mail.gmail.com>
Subject: perf_counters issue with PERF_SAMPLE_GROUP
From: stephane eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Richter <robert.richter@amd.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Andi Kleen <andi@firstfloor.org>,
       Maynard Johnson <mpjohn@us.ibm.com>, Carl Love <cel@us.ibm.com>,
       Corey J Ashford <cjashfor@us.ibm.com>,
       Philip Mucci <mucci@eecs.utk.edu>, Dan Terpstra <terpstra@eecs.utk.edu>,
       perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It seems to me there is a problem with the group counter values
when you use PERF_SAMPLE_GROUP. The counts are bogus
for all events.

Test case is pretty simple:
    - single group, 2 events
    - sampling on PERF_COUNT_HW_CYCLES
    - other event is PERF_COUNT_HW_CYCLES
    - leader has SAMPLE_IP|SAMPLE_GROUP
    - no inheritance
    - single thread
    - using sampling in one shot mode with PERF_COUNTER_IOC_REFRESH
    - all events but leader start with disabled = 0 (i.e., enabled)
    - sampling period is 240000000 (cycles)

Notification 1: ip=0x401300  39100608 PERF_COUNT_HW_CPU_CYCLES (12)
Notification 2: ip=0x401300  17991616 PERF_COUNT_HW_CPU_CYCLES (12)
Notification 3: ip=0x401300  17981248 PERF_COUNT_HW_CPU_CYCLES (12)
Notification 4: ip=0x401300  9409478912 PERF_COUNT_HW_CPU_CYCLES (12)

I would expect the value for the 2nd event to be close to 240000000.
But instead,
it is going up and down. The IP, nr and id (12) fields are correct, so
the parsing of
the buffer is correct. This is with the latest from Linus's 2.6.31-rc5.


Related to PERF_SAMPLE_GROUP, I believe there is some information missing.
You need to provide the TIMING information because in the case of SAMPLE_GROUP
you'd like to be able to scale the values of the counters you are
collecting. And you
need the timing at the moment, the sample was recorded not later.
