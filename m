Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbZFXOXn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbZFXOXn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 10:23:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758215AbZFXOXg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 10:23:36 -0400
Received: from fbr02.csee.onr.siteprotect.com ([64.26.60.146]:59830 "EHLO
	fbr02.csee.onr.siteprotect.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758030AbZFXOXf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 10:23:35 -0400
X-Greylist: delayed 2061 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jun 2009 10:23:35 EDT
Date: Wed, 24 Jun 2009 09:59:54 -0400 (EDT)
From: Vince Weaver <vince@deater.net>
X-X-Sender: vince@pianoman.cluster.toy
To: linux-kernel@vger.kernel.org
Subject: performance counter 20% error finding retired instruction count
Message-ID: <Pine.LNX.4.64.0906240937120.10620@pianoman.cluster.toy>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

As an aside, is it time to set up a dedicated Performance Counters
for Linux mailing list?   (Hereafter referred to as p10c7l to avoid
confusion with the other implementations that have already taken
all the good abbreviated forms of the concept).  If/when the 
infrastructure appears in a released kernel, there's going to be a lot of 
chatter by people who use performance counters and suddenly find they are 
stuck with a huge step backwards in functionality.  And asking Fortran 
programmers to provide kernel patches probably won't be a productive 
response.  But I digress.


I was trying to get an exact retired instruction count from p10c7l.
I am using the test million.s, available here
  ( http://www.csl.cornell.edu/~vince/projects/perf_counter/million.s )
It should count exactly one million instructions.

Tests with valgrind and qemu show that it does.

Using perfmon2 on Pentium Pro, PII, PIII, P4, Athlon32, and Phenom
all give the proper result:

tobler:~% pfmon -e retired_instructions ./million
1000002 RETIRED_INSTRUCTIONS

    ( it is 1,000,002 +/-2 because on most x86 architectures retired
      instruction count includes any hardware interrupts that might
      happen at the time.  It woud be a great feature if p10c7l
      could add some way of gathering the per-process hardware
      instruction count statistic to help quantify that).

Yet with perf on the same Athlon32 machine (using
kernel 2.6.30-03984-g45e3e19) gives:

tobler:~%perf stat ./million

  Performance counter stats for './million':

        1.519366  task-clock-ticks     #       0.835 CPU utilization factor
               3  context-switches     #       0.002 M/sec
               0  CPU-migrations       #       0.000 M/sec
              53  page-faults          #       0.035 M/sec
         2483822  cycles               #    1634.775 M/sec
         1240849  instructions         #     816.689 M/sec # 0.500 per cycle
          612685  cache-references     #     403.250 M/sec
            3564  cache-misses         #       2.346 M/sec

  Wall-clock time elapsed:     1.819226 msecs

Running multiple times gives:
    1240849
    1257312
    1242313

Which is a varying error of at least 20% which isn't even 
consistent.  Is this because of sampling?  The documentation doesn't 
really warn about this as far as I can tell.

Thanks for any help resolving this problem

Vince


