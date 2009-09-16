Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbZIPLK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbZIPLK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 07:10:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbZIPLKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 07:10:24 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:41425 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZIPLKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 07:10:24 -0400
Date: Wed, 16 Sep 2009 20:10:26 +0900 (JST)
Message-Id: <20090916.201026.71092560.ryov@valinux.co.jp>
To: vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
       dhaval@linux.vnet.ibm.com, jens.axboe@oracle.com, agk@redhat.com,
       akpm@linux-foundation.org, nauman@google.com,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Subject: Re: dm-ioband fairness in terms of sectors seems to be killing disk
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090915214032.GB3711@redhat.com>
References: <20090903131146.GA12041@redhat.com>
	<20090904.101222.226781140.ryov@valinux.co.jp>
	<20090915214032.GB3711@redhat.com>
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
> I am running a sequential reader in one group and few random reader and
> writers in second group. Both groups are of same weight. I ran fio scripts
> for 60 seconds and then looked at the output. In this case looks like we just
> kill the throughput of sequential reader and disk (because random
> readers/writers take over).

Thank you for testing dm-ioband. 

I ran your script on my environment, and here are the results.

                        Throughput  [KiB/s]
              vanilla     dm-ioband            dm-ioband   
                       (io-throttle = 4)  (io-throttle = 50)
  randread      312           392                 368
  randwrite      11            12                  10
  seqread      4341           651                1599

I ran the script on dm-ioband under two conditions, one is that the
io-throttle options is set to 4, and the other is set to 50. When
there are some in-flight IO requests in the group and those numbers
exceed io-throttle, then dm-ioband gives priority to the group and the
group can issue subsequent IO requests in preference to the other
groups. 50 io-throttle means that it cancels this mechanism, so the
seq-read got more bandwidth than 4 io-throttle.

I tried to test with 2.6.31-rc7 and io-controller v9, but unfortunately,
a kernel panic happened. I'll try to test with your io-controller
again later.
 
> with io scheduler based io controller, we see increased throughput for
> seqential reader as compared to CFQ, because now random readers are
> running in a separate group and hence reader gets isolation from random
> readers.

I summarized your results in a tabular format.

                   Throughput [KiB/s]
             vanilla io-controller  dm-ioband
randread        257        161          314
randwrite        11         45           15
seqread        5598       9556          631

On the result of io-controller, the throughput of seqread was
increased but randread was decreased against vanilla. Did it perform as
you expected? Was disktime consumed equally on each group according to
the weight settings? Could you tell me your opinion what an
io-controller should do when this kind of workload is applied?

Thanks,
Ryo Tsuruta
