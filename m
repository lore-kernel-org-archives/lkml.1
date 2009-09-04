Return-Path: <linux-kernel-owner+w=401wt.eu-S1750897AbZIDEC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750897AbZIDEC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 00:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750774AbZIDEC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 00:02:27 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:43720 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbZIDEC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 00:02:27 -0400
Date: Fri, 04 Sep 2009 13:02:28 +0900 (JST)
Message-Id: <20090904.130228.104054439.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com
Subject: Re: Regarding dm-ioband tests
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090901165011.GB3753@redhat.com>
References: <20090901165011.GB3753@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi Ryo,
> 
> I decided to play a bit more with dm-ioband and started doing some
> testing. I am doing a simple two dd threads doing reads and don't seem
> to be gettting the fairness. So thought will ask you what's the issue
> here. Is there an issue with my testing procedure.

Thank you for testing dm-ioband. dm-ioband is designed to start
throttling bandwidth when multiple IO requests are issued to devices
simultaneously, IOW, to start throttling when IO load exceeds a
certain level.

Here is my test script that runs multiple dd threads on each
directory. Each directory stores 20 files of 2GB.

    #!/bin/sh
    tmout=60

    for nr_threads in 1 4 8 12 16 20; do
            sync; echo 3 > /proc/sys/vm/drop_caches

            for i in $(seq $nr_threads); do
                    dd if=/mnt1/ioband1.${i}.0 of=/dev/null &
                    dd if=/mnt2/ioband2.${i}.0 of=/dev/null &
            done
            iostat -k 1 $tmout > ${nr_threads}.log
            killall -ws TERM dd
    done
    exit 0

Here is the result. The average throughputs of each device are
according to the proportion of the weight settings when the number of
thread is over four.

              Average thoughput in 60 seconds [KB/s]

              ioband1           ioband2
  threads    weight 200        weight 100       total
        1   26642 (54.9%)     21925 (45.1%)     48568
        4   33974 (67.7%)     16181 (32.3%)     50156
        8   31952 (66.2%)     16297 (33.8%)     48249
       12   32062 (67.8%)     15236 (32.2%)     47299
       16   31780 (67.7%)     15165 (32.3%)     46946
       20   29955 (66.3%)     15239 (33.7%)     45195

Please try to run the above script on your envirionment and I would be
glad if you let me know the result.

Thanks,
Ryo Tsuruta
