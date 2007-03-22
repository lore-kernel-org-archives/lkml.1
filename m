Return-Path: <linux-kernel-owner+w=401wt.eu-S1030517AbXCVLhx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030517AbXCVLhx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 07:37:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030519AbXCVLhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 07:37:52 -0400
Received: from mail.tmr.com ([64.65.253.246]:46261 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030517AbXCVLhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 07:37:51 -0400
Message-ID: <46026B78.3080401@tmr.com>
Date: Thu, 22 Mar 2007 07:41:44 -0400
From: Bill Davidsen <davidsen@tmr.com>
Organization: TMR Associates Inc, Schenectady NY
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
To: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       yumiko.sugita.yf@hitachi.com, masami.hiramatsu.pt@hitachi.com,
       hidehiro.kawai.ez@hitachi.com, yuji.kakutani.uw@hitachi.com,
       soshima@redhat.com, haoki@redhat.com, kamezawa.hiroyu@jp.fujitsu.com,
       nikita@clusterfs.com, leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com> <460218D2.40701@hitachi.com>
In-Reply-To: <460218D2.40701@hitachi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tomoki Sekiyama wrote:
> Hi,
>
> Thanks for your comments.
> I'm sorry for my late reply.
>
> Bill Davidsen wrote:
> > Andrew Morton wrote:
>
> >> - I wonder if dirty_limit_ratio is the best name we could choose.
> >> vm_dirty_blocking_ratio, perhaps?  Dunno.
> >>
> > I don't like it, but I dislike it less than "dirty_limit_ratio" I 
> guess.
> > It would probably break things to change it now, including my
> > sysctl.conf on a number of systems  :-(
>
> I'm wondering which interface is preferred...
>
> 1) Just rename "dirty_limit_ratio" to "dirty_blocking_ratio."
>    Those who had been changing dirty_ratio should additionally modify
>    dirty_blocking_ratio in order to determine the upper limit of dirty 
> pages.
>
> 2) Change "dirty_ratio" to a vector, consists of 2 values;
>    {blocking ratio, writeback starting ratio}.
>    For example, to change the both values:
>      # echo 40 35 > /proc/sys/vm/dirty_ratio
>    And to change only the first one:
>      # echo 20 > /proc/sys/vm/dirty_ratio
>    In the latter way the writeback starting ratio is regarded as the 
> same as the
>    blocking ratio if the writeback starting ratio is smaller. And 
> then, the kernel behaves
>    similarly as the current kernel.
>
> 3) Use "dirty_ratio" as the blocking ratio. And add
>    "start_writeback_ratio", and start writeback at
>    start_writeback_ratio(default:90) * dirty_ratio / 100 [%].
>    In this way, specifying blocking ratio can be done in the same way as
>    current kernel, but high/low watermark algorithm is enabled.
I like 3 better, it should make tuning behavior more precise. You can 
make an argument for absolute values for writeback, if my disk will only 
write 70MB/s I may only want 203 sec of pending writes, regardless of 
available memory.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

