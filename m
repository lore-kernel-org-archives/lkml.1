Return-Path: <linux-kernel-owner+w=401wt.eu-S1754767AbZBRGC0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbZBRGC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 01:02:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751861AbZBRGCR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 01:02:17 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:54808 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbZBRGCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 01:02:16 -0500
Message-ID: <499BA413.2010705@cn.fujitsu.com>
Date: Wed, 18 Feb 2009 14:00:51 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: jens.axboe@oracle.com
CC: linux-kernel@vger.kernel.org
Subject: CFQ is worse than other IO schedulers in some cases
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found that CFQ's performance is worse than other IO scheduer in some cases
I confirmed its phenomenon when I executed dump command and sysbench on 2.6.28.


In dump(version:dump-0.4b41-2.fc6), I confirmed 
the speed under CFQ is slower than other IO schedulers.


The Test Result(dump):
   UNIT:Mb/sec
    _______________________
    |   IO       |        | 
    | scheduler  |  Speed |
    +------------|--------|
    |cfq         | 24.310 |  
    |noop        | 36.885 |  
    |anticipatory| 34.956 |  
    |deadline    | 36.758 |  
    +----------------------


Steps to reproduce(dump):
  #dump -0uf /dev/null /dev/sda6

  #df -h /dev/sda6
   Filesystem            Size  Used Avail Use% Mounted on
   /dev/sda6              19G   10G  7.6G  57% /mnt



In sysbench(version:sysbench-0.4.10), I confirmed followings.
  - CFQ's performance is worse than other IO schedulers when only multiple
    threads test.
    (There is no difference under single thread test.)
  - It is worse than other IO scheduler when
    I used read mode. (No regression in write mode).
  - There is no difference among other IO schedulers. (e.g noop deadline)


The Test Result(sysbench):
   UNIT:Mb/sec
    __________________________________________________
    |   IO       |      thread  number               |  
    | scheduler  |-----------------------------------|
    |            |  1   |  3    |  5   |   7  |   9  |
    +------------|------|-------|------|------|------|
    |cfq         | 77.8 |  32.4 | 43.3 | 55.8 | 58.5 | 
    |noop        | 78.2 |  79.0 | 78.2 | 77.2 | 77.0 |
    |anticipatory| 78.2 |  78.6 | 78.4 | 77.8 | 78.1 |
    |deadline    | 76.9 |  78.4 | 77.0 | 78.4 | 77.9 |
    +------------------------------------------------+


Steps to reproduce(sysbench):

  (1)#echo cfq > /sys/block/sda/queue/scheduler 

  (2)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd prepare

  (3)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd run
      [snip]
      Operations performed:  655360 Read, 0 Write, 0 Other = 655360 Total
      Read 10Gb  Written 0b  Total transferred 10Gb  (77.835Mb/sec)
      4981.44 Requests/sec executed                   ~~~~~~~~~~~
  (4)#sysbench --test=fileio --num-threads=1 --file-total-size=10G --file-test-mode=seqrd cleanup

  (5)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd prepare
  (6)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd run
      [snip]
      Operations performed:  655360 Read, 0 Write, 0 Other = 655360 Total
      Read 10Gb  Written 0b  Total transferred 10Gb  (43.396Mb/sec)
      2777.35 Requests/sec executed                   ~~~~~~~~~~~~
  (7)#sysbench --test=fileio --num-threads=5 --file-total-size=10G --file-test-mode=seqrd cleanup

when doing step 2 or 5, sysbench creats 128 files, and 80M each one. 
when doing step 4 or 7, sysbench deletes the files. 
when doing step 3 or 6, thread reads these files continuously and 
reads file-block-size(default:16Kbyte) at once, just like :

       t_0   t_0   t_0   t_0   t_0   t_0   t_0
        ^     ^     ^     ^     ^     ^     ^
     ---|-----|-----|-----|-----|-----|-----|--------
file | 16k | 16k | 16k | 16k | 16k | 16k | 16k | ... 
     ------------------------------------------------ 
                  (num-threads=1)

(t_0 stand for the first thread) 

       t_0   t_1   t_2   t_3   t_4   t_0   t_1
        ^     ^     ^     ^     ^     ^     ^
     ---|-----|-----|-----|-----|-----|-----|--------
file | 16k | 16k | 16k | 16k | 16k | 16k | 16k | ... 
     ------------------------------------------------ 
                  (num-threads=5)

(the executed threads are decide by the thread scheduler)


The Hardware Infos:
Arch    :x86_64
CPU     :4cpu; GenuineIntel 3325.087 MHz
MEMORY  :4044128kB

---- 
Shan Wei

