Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbXLEUQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbXLEUQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 15:16:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750964AbXLEUQF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 15:16:05 -0500
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:59086 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbXLEUQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 15:16:02 -0500
Message-ID: <475706E2.50805@linux.vnet.ibm.com>
Date: Wed, 05 Dec 2007 21:15:30 +0100
From: Holger Wolf <wolf@linux.vnet.ibm.com>
Reply-To: Holger.Wolf@de.ibm.com
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: mingo@elte.hu
CC: schwidefsky@de.ibm.com, linux-kernel@vger.kernel.org
Subject: Scheduler behaviour
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We discovered performance degradation with dbench when using kernel 2.6.23 compared to kernel 2.6.22.

In our case we booted a Linux in a IBM System z9 LPAR with 256MB of ram with
4 CPU's. This system uses a striped LV with 16 disks on a Storage Server
connected via 8 4GBit links.
A dbench was started on that system performing I/O operations on the
striped LV. dbench runs were performed with 1 to 62 processes. Measurements
with a 2.6.22 kernel were compared to measurements with a 2.6.23 kernel.
We saw a throughput degradation from 7.2 to 23.4 percent and a cost
increase from 9.5 to 29.5 percent. Costs are calculated by consumed CPU
microseconds divided by transferred bytes written/read.
The cost increase is caused by fewer transferred bytes at an almost
constant level of spent CPU microseconds (except for 50 processes).

The throughput can be increased by generating an imbalance in scheduling of
the dbench processes with different nice value for the processes. The more
imbalance is created the higher is the throughput. By monitoring the
throughput of disk I/O it can be observed that the iostat read throughput
is significantly lower with this imbalance while the iostat write
throughput stays the same.
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
|                 |    Device:|     rrqm/s|     wrqm/s|        r/s|        w/s|     rsec/s|     wsec/s|   avgrq-sz|   avgqu-sz|      await|
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
  >-----------+-----------|
  |      svctm|      %util|
  >-----------+-----------|
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
|Balanced         |       dm-0|          0|          0|   10592.54|    8067.16|  694885.57|   510479.6|       64.6|      16.96|       0.91|
|scheduling       |           |           |           |           |           |           |           |           |           |           |
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
  >-----------+-----------|
  |       0.05|      97.51|
  >-----------+-----------|
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
|Imbalanced       |       dm-0|          0|          0|    3401.00|    7993.03|  175693.53|  526833.83|      61.66|      14.88|        1.3|
|scheduling       |           |           |           |           |           |           |           |           |           |           |
|-----------------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+-----------+----------->
  >-----------+-----------|
  |       0.07|      83.58|
  >-----------+-----------|




With profiling we saw that the mpage_end_io_read function consumes much
more CPU with a 2.6.23 kernel than with a 2.6.22 kernel.

To me it looks like the page cache is under stronger pressure when all
processes are scheduled fairly.

Normalized Throughput of dbench
                                                 
   Number of      2.6.22      2.6.23  Difference 
   Processes                          in Percent 
                                                 
           1           1         0.9     -10.24% 
                                                 
           4        3.64        3.74       2.68% 
                                                 
           8        3.57        3.71       3.83% 
                                                 
          12        3.51         3.6       2.55% 
                                                 
          16         3.4        3.53       3.96% 
                                                 
          20        3.32        3.43       3.33% 
                                                 
          26        3.29         3.4       3.29% 
                                                 
          32        3.14        2.92      -7.25% 
                                                 
          40        2.99        2.61     -12.92% 
                                                 
          46           3        2.47     -17.69% 
                                                 
          50        2.84         2.4     -15.55% 
                                                 
          54         3.1        2.37     -23.42% 
                                                 
          62        2.55        2.32      -8.99% 
                                                 




Normalized Costs of dbench
                                                 
   Number of      2.6.22      2.6.23  Difference 
   Processes                          in Percent 
                                                 
           1           1        0.96       3.84% 
                                                 
           4        1.08        1.05       2.97% 
                                                 
           8        1.08        1.07       1.10% 
                                                 
          12        1.09         1.1      -1.30% 
                                                 
          16         1.1        1.12      -1.90% 
                                                 
          20        1.12        1.15      -2.61% 
                                                 
          26        1.18        1.17       0.86% 
                                                 
          32        1.24        1.36      -9.50% 
                                                 
          40         1.3        1.52     -16.97% 
                                                 
          46        1.29         1.6     -23.92% 
                                                 
          50        1.37        1.64     -20.12% 
                                                 
          54        1.28        1.66     -29.60% 
                                                 
          62         1.5        1.69     -12.84% 

regards

Holger Wolf

