Return-Path: <linux-kernel-owner+w=401wt.eu-S965764AbXCVFx0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965764AbXCVFx0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 01:53:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965771AbXCVFx0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 01:53:26 -0400
Received: from mailx.hitachi.co.jp ([133.145.228.49]:63921 "EHLO
	mailx.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965764AbXCVFxZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 01:53:25 -0400
Message-ID: <460218D2.40701@hitachi.com>
Date: Thu, 22 Mar 2007 14:49:06 +0900
From: Tomoki Sekiyama <tomoki.sekiyama.qu@hitachi.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Bill Davidsen <davidsen@tmr.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, yumiko.sugita.yf@hitachi.com,
       masami.hiramatsu.pt@hitachi.com, hidehiro.kawai.ez@hitachi.com,
       yuji.kakutani.uw@hitachi.com, soshima@redhat.com, haoki@redhat.com,
       kamezawa.hiroyu@jp.fujitsu.com, nikita@clusterfs.com,
       leroy.vanlogchem@wldelft.nl
Subject: Re: [PATCH 0/3] VM throttling: avoid blocking occasional writers
References: <45F7EDC6.5090303@hitachi.com> <20070315110745.af867b10.akpm@linux-foundation.org> <45FD53DB.5000207@tmr.com>
In-Reply-To: <45FD53DB.5000207@tmr.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Thanks for your comments.
I'm sorry for my late reply.

Bill Davidsen wrote:
 > Andrew Morton wrote:
 >>> On Wed, 14 Mar 2007 21:42:46 +0900 Tomoki Sekiyama
 >>> <tomoki.sekiyama.qu@hitachi.com> wrote:
 >>>
 >>> ...
 >>>
 >>>
 >>> -Solution:
 >>>
 >>> I consider that all of the dirty pages for the disk have been written
 >>> back and that the disk is clean if a process cannot write 'write_chunk'
 >>> pages in balance_dirty_pages().
 >>>
 >>> To avoid using up the free memory with dirty pages by passing blocking,
 >>> this patchset adds a new threshold named vm.dirty_limit_ratio to sysctl.
 >>>
 >>> It modifies balance_dirty_pages() not to block when the amount of
 >>> Dirty+Writeback is less than vm.dirty_limit_ratio percent of the memory.
 >>> In the other cases, writers are throttled as current Linux does.
 >>>
 >>>
 >>> In this patchset, vm.dirty_limit_ratio, instead of vm.dirty_ratio, is
 >>> used as the clamping level of Dirty+Writeback. And, vm.dirty_ratio is
 >>> used as the level at which a writers will itself start writeback of the
 >>> dirty pages.
 >>
 >> Might be a reasonable solution - let's see what Peter comes up with too.
 >>
 >> Comments on the patch:
 >>
 >> - Please don't VM_DIRTY_LIMIT_RATIO: just use CTL_UNNUMBERED and leave
 >>   sysctl.h alone.
 >>
 >> - The 40% default is already too high.  Let's set this new upper limit to
 >>   40% and decrease he non-blocking ratio.
 >>
 >> - Please update the procfs documentation in ./Docmentation/

OK, I'm going to fix them and repost the patchset.


 >> - I wonder if dirty_limit_ratio is the best name we could choose.
 >> vm_dirty_blocking_ratio, perhaps?  Dunno.
 >>
 > I don't like it, but I dislike it less than "dirty_limit_ratio" I guess.
 > It would probably break things to change it now, including my
 > sysctl.conf on a number of systems  :-(

I'm wondering which interface is preferred...

1) Just rename "dirty_limit_ratio" to "dirty_blocking_ratio."
    Those who had been changing dirty_ratio should additionally modify
    dirty_blocking_ratio in order to determine the upper limit of dirty pages.

2) Change "dirty_ratio" to a vector, consists of 2 values;
    {blocking ratio, writeback starting ratio}.
    For example, to change the both values:
      # echo 40 35 > /proc/sys/vm/dirty_ratio
    And to change only the first one:
      # echo 20 > /proc/sys/vm/dirty_ratio
    In the latter way the writeback starting ratio is regarded as the same as the
    blocking ratio if the writeback starting ratio is smaller. And then, the kernel behaves
    similarly as the current kernel.

3) Use "dirty_ratio" as the blocking ratio. And add
    "start_writeback_ratio", and start writeback at
    start_writeback_ratio(default:90) * dirty_ratio / 100 [%].
    In this way, specifying blocking ratio can be done in the same way as
    current kernel, but high/low watermark algorithm is enabled.


Regards,
-- 
Tomoki Sekiyama
Hitachi, Ltd., Systems Development Laboratory

