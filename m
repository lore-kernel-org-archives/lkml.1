Return-Path: <linux-kernel-owner+w=401wt.eu-S1752473AbZFVU0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbZFVU0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 16:26:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751091AbZFVU0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 16:26:16 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:37551 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbZFVU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 16:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type:content-transfer-encoding;
        b=vlEUEuzAMORimVVcrn8mzF7R+X6luvBXnxFSgorKNcrR0aYgAGWqx0rUxHM7SzN6pN
         w5+DESuGAVZXZL5xjJKfuOh8QbPt651tku2t4up9gWH6lCDIEbjHgT2TzAY3kExL+3FY
         4CggWRQZfI1soxQQOaHfEK3FRxeKOfKnJHgfk=
MIME-Version: 1.0
Reply-To: eranian@gmail.com
Date: Mon, 22 Jun 2009 22:26:15 +0200
Message-ID: <7c86c4470906221326j6edbf9f3g5d65e96d86aaf7ab@mail.gmail.com>
Subject: perf_counter Atom patch
From: stephane eranian <eranian@googlemail.com>
To: yong.y.wang@intel.com
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


You recently submitted a patch for perf_counter to disable
use of fixed counters on Atom because you claim they do
not work.

--------------------------------------------------------------------------------------
author	Yong Wang <yong.y.wang@linux.intel.com>
Fri, 12 Jun 2009 08:08:55 +0000 (16:08 +0800)
committer	Ingo Molnar <mingo@elte.hu>
Fri, 12 Jun 2009 11:48:32 +0000 (13:48 +0200)
commit	dff5da6d09daaab40a8741dce0ed3c2e94079de2
tree	c1f4ce70e4a566a231ba00c775de4e96fb8acb39
parent	faafec1e61e61d350248af2a7e5f047606adab6e
perf_counter/x86: Add a quirk for Atom processors

The fixed-function performance counters do not work on current Atom
processors. Use the general-purpose ones instead.
--------------------------------------------------------------------------------------


I would like to better understand what makes you think
this is the case.

Perfmon is working on Atom and there, fixed counters work perfectly:
$ head -6 /proc/cpuinfo
processor	: 0
vendor_id	: GenuineIntel
cpu family	: 6
model		: 28
model name	: Intel(R) Atom(TM) CPU  230   @ 1.60GHz
stepping	: 2
...
$ pfmon -v --us-c -e
unhalted_core_cycles,unhalted_reference_cycles,instructions_retired
noploop 10
[FIXED_CTRL(pmc16)=0xaaa pmi0=1 en0=0x2 any0=0 pmi1=1 en1=0x2 any1=0
pmi2=1 en2=0x2 any2=0] INSTRUCTIONS_RETIRED UNHALTED_CORE_CYCLES
UNHALTED_REFERENCE_CYCLES
[FIXED_CTR0(pmd16)]
[FIXED_CTR1(pmd17)]
[FIXED_CTR2(pmd18)]
noploop for 10 seconds
15,902,604,169 UNHALTED_CORE_CYCLES
15,902,586,180 UNHALTED_REFERENCE_CYCLES
7,941,842,505 INSTRUCTIONS_RETIRED


I seem to recall that what may be bogus on Atom is what is returned by
CPUID(0xa)
for the fixed counters. But they are there and they work. Thus, I
believe, the quirk
should be  at the location where CPUID(0xa) is invoked not where you've put it.
