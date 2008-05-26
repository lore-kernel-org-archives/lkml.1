Return-Path: <linux-kernel-owner+w=401wt.eu-S1756647AbYEZOa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756647AbYEZOa1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 10:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYEZOaP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 10:30:15 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47039 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455AbYEZOaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 10:30:14 -0400
From: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Subject: [RFC PATCH v1 0/3] Scaled statistics using APERF/MPERF in x86
To: Linux Kernel <linux-kernel@vger.kernel.org>, venkatesh.pallipadi@intel.com,
       suresh.b.siddha@intel.com, Michael Neuling <mikey@neuling.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Date: Mon, 26 May 2008 20:01:33 +0530
Message-ID: <20080526142513.24680.97164.stgit@drishya.in.ibm.com>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following RFC patch tries to implement scaled CPU utilisation statistics
using APERF and MPERF MSR registers in an x86 platform.

The CPU capacity is significantly changed when the CPU's frequency is reduced
for the purpose of power savings.  The applications that run at such lower CPU
frequencies are also accounted for real CPU time by default.  If the
applications have been run at full CPU frequency, they would have finished the
work faster and not get charged for excessive CPU time.

One of the solution to this problem it so scale the utime and stime entitlement
for the process as per the current CPU frequency.  This technique is used in
powerpc architecture with the help of hardware registers that accurately capture
the entitlement.

On x86 hardware, APERF and MPERF are MSR registers that can provide feedback on
current CPU frequency.  Currently these registers are used to detect current CPU
frequency on each core in a multi-core x86 processor where the frequency of the
entire package is changed.

This patch demonstrates the idea of scaling utime and stime based on cpu
frequency.  The scaled values are exported through taskstats delay accounting
infrastructure.

Example:

On a two socket two CPU x86 hardware:
./getdelays -d -l -m0-3  

PID     4172


CPU             count     real total  virtual total    delay total
                43873      148009250     3368915732       28751295
IO              count    delay total
                    0              0
MEM             count    delay total
                    0              0
                utime          stime
                40000         108000
         scaled utime   scaled stime          total
                26676          72032       98714169

The utime/stime and scaled utime/stime are printed in micro secs while the
totals are in nano seconds. The CPU was running at 66% of its maximum frequency.

We can observe that scaled utime/stime values are 66% of their normal
accumulated runtime values, and total is 66% of 'real total'.

The following output is for CPU intensive job running for 10s:

PID     4134


CPU             count     real total  virtual total    delay total
                   61    10000625000     9807860434              2
IO              count    delay total
                    0              0
MEM             count    delay total
                    0              0
                utime          stime
             10000000              0
         scaled utime   scaled stime          total
              9886696              0     9887313918

Ondemand governor was running and it took sometime to switch the frequency to
maximum.  Hence the scaled values are marginally less than that of the elapsed
utime.


Limitations:

* RFC patch to communicate just the idea, implementation may need rework
* Works only for 32-bit x86 hardware
* MSRs and APERF/MPERF ratio is calculated at every context switch which is very
  slow
* Hacked cputime_t task_struct->utime to hold 'jiffies * 1000' values just to
  account for fractional jiffies.  Since cputime_t is jiffies in x86, we cannot
  add fractional jiffies at each context switch. Need to convert the scaled
  utime/stime data types and units to micro seconds or nano seconds.


ToDo:

* Compute scaling ratio per package only at each frequency switch
  -- Notify frequency change to all affected CPUs
* Use more accurate time unit for x86 scaled utime and stime  

Signed-off-by: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>

---

Vaidyanathan Srinivasan (3):
      Print scaled utime and stime in getdelays
      Make calls to account_scaled_stats
      General framework for APERF/MPERF access and accounting


 Documentation/accounting/getdelays.c       |   13 ++
 arch/x86/kernel/cpu/cpufreq/acpi-cpufreq.c |   21 +++
 arch/x86/kernel/process_32.c               |    8 +
 arch/x86/kernel/time_32.c                  |  171 ++++++++++++++++++++++++++++
 include/linux/hardirq.h                    |    4 +
 kernel/delayacct.c                         |    7 +
 kernel/timer.c                             |    2 
 kernel/tsacct.c                            |   10 +-
 8 files changed, 225 insertions(+), 11 deletions(-)

-- 
        Vaidyanathan Srinivasan,
        Linux Technology Center,
        IBM India Systems and Technology Labs.

