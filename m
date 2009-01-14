Return-Path: <linux-kernel-owner+w=401wt.eu-S1755346AbZANSsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346AbZANSsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:48:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752777AbZANSsK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:48:10 -0500
Received: from web82508.mail.mud.yahoo.com ([209.191.86.195]:33347 "HELO
	web82508.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752737AbZANSsJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:48:09 -0500
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Jan 2009 13:48:09 EST
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=sbcglobal.net;
  h=X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=2v7lauQ7knP/Gn9DepXNzbrFnmvVhajTiWPsFUIE/e0RguD5fw1yJoThJXw/nazg15xHdIYu9Roh1LrOmsjI9y0spQaDHd0ppfbhpbS3LrW011ohMK2/OW7DsXsS/C6CTyD4w07Hv/n+yXbrimqO6TLlWt0vgu1tFKBJpNqvOXI=;
X-YMail-OSG: Ca10K3UVM1mNq_MdWMzpflUd2kgd85KbUXlgq_OXhLBlhccH09_1iXO80XwGzPSPXPfJS7gIF.i1ffZUp7gmjnV6le52v7Ah3AvygjQqSuf5eTqbCvWWsSvEgJvExq7YgcbnQ9RK8Jk3XYtcoDurpSuB8Mi91NhcNJ6gmnH361Ngijm6z78YPdEfHgo.oyj3gK8nQ3ihn19wElpKs0p7Np2Eb2NBuFI-
X-Mailer: YahooMailWebService/0.7.218.2
Date: Wed, 14 Jan 2009 10:41:28 -0800 (PST)
From: Keith Kong <keith_kong@sbcglobal.net>
Subject: isolcpus jitter performance
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <718120.6885.qm@web82508.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,
 
Newbie here to this list, so please be gentle 8-)
 
I’m doing some latency-sensitive work that requires isolating a CPU and running stuff on it with as little perturbance as possible.  Someone pointed me to isolcpus and Max Krasnyansky’s work on preventing IRQs from being handled by isolated CPUs.  Exactly what I needed, so I went ahead and ftped kernel 2.6.25.6 and patched it with this: http://kernel.org/pub/linux/kernel/people/maxk/cpuisol/patches/v2.6.25.6.cpuisol1.patch
 
But the measured jitter is much bigger than “single digit usec worst case and around 200nsec ave response time”  (http://readlist.com/lists/vger.kernel.org/linux-kernel/89/447300.html).
 
So a couple of questions:

1. ***Has anyone gotten the kinds of results above?  If so, how did you do it, along with your definition of “worst case and ave response time.”***  If your source code is not too big, attaching it would be good. 

2. The methodology I used is below.  *** Any issues with it? ***

  1. Patch kernel 2.6.25.6 with v2.6.25.6.cpuisol1.patch, RedHat Enterprise AS4, on 8GB dual Xeon quad core (8 cores) 2.67GHz machine.  No load on the machine (according to “top”).

  2. Add kernel parms: isolcpus=4,5,6,7 

  3. Ensure /etc/sysconfig/syspart has PAR0_CPUS=”0-3” so that CPUs 0-3 handle general kernel and user tasks, and CPUs 4-7 are isolated 
Ensure /etc/init.d/syspart has “activated” the partition 

  4. Collected Pentium clock register values via rdtscll() using following code (ensuring cpu affinity set correctly): 
 
      #define BUFSIZE 1000000
      #define LOOPCNT 10000
      for ( i = 0; i < BUFSIZE; i++ ) {
        for ( j = 0; j < LOOPCNT; j++ ) {}
        rdtscll(gullStartCpuTime); /* Pentium clock register */
        ullTimeStampBuf[i] = gullStartCpuTime;
      }

  5. Dumped the ullTimeStampBuf[] data into a file and do post-process.  Definition of jitter and details of post-processing below. 
 
The kinds of results I’m getting are:

Max jitter (max diff between consecutive Pentium counter values):
*** ~ 460 usec ***

Ave. jitter (std. deviation of diff between consecutive Pentium counters): *** ~ 5.7 usec ***
 
 
Thanks!
 
 
Keith

----- detailed explanation of methodology below --- 
All the data is based on computing statistics on “diff and diff of diff” between successive Pentium counters.  For example:
 
83228160 71336 0 0
83299496 71336 0 0
83370832 71336 0 0
83442168 71336 0 0
83513528 71360 24 0.00900003262511827
83584864 71336 -24 -0.00900003262511827
83656200 71336 0 0
83727536 71336 0 0
83798872 71336 0 0
 
The first column is Pentium counter, second column is diff of previous and current counter, third column is diff of this diff.  Last column is simply third column converted into microseconds.
 
The third column is added to some array, which is then fed as input to some statistics package to provide results.  Note that STDDEV (usec): 5.7567 means standard deviation of the third column.
 
 
 
SAMPLE INFO FILE
------------------------------
STATISTICS
----------
 DIFF SAMPLE COUNT: 999998
   DIFF MIN (usec):   26.7449164221
   DIFF MAX (usec):  462.6135543326
  DIFF MEAN (usec):   26.8811017636
DIFF MEDIAN (usec):   26.7509164034
DIFF STDDEV (usec):    5.7567862963
   DIFF VAR (usec):   33.1405884609
 
 
 DIFFDIFF SAMPLE COUNT: 999997
   DIFFDIFF MIN (usec): -435.1036403011
   DIFFDIFF MAX (usec):  435.8626379293
  DIFFDIFF MEAN (usec):   -0.0000089190
DIFFDIFF MEDIAN (usec):    0.0000000000
DIFFDIFF STDDEV (usec):    8.1034032634
   DIFFDIFF VAR (usec):   65.6651444491
 
 
PENTIUM COUNTER ROLLOVER SANITY CHECK
-------------------------------------
          GETTIMEOFDAY LAPSED TIME (usec): 26881133
 TOTAL PENTIUM COUNTER LAPSED TIME (usec): 26881048.00135
              DIFF OF LAPSED TIMES (usec): 84.9986500032246
[DIFF TIME OF 84.9986500032246 usec < 10 ms (resolution of gettimeofday() on linux), SO GOOD CONFIDENCE ROLLOVERS ACCOUNTED FOR PROPERLY]
 
 
