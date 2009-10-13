Return-Path: <linux-kernel-owner+w=401wt.eu-S1753202AbZJMDLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbZJMDLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 23:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZJMDLs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 23:11:48 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:36057 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbZJMDLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 23:11:47 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 13 Oct 2009 12:08:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: vedran.furac@gmail.com
Cc: Vedran =?UTF-8?B?RnVyYcSN?= <vedranf@vedranf.mine.nu>,
       linux-kernel@vger.kernel.org
Subject: Re: Memory overcommit
Message-Id: <20091013120840.a844052d.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <hav57c$rso$1@ger.gmane.org>
References: <hav57c$rso$1@ger.gmane.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Oct 2009 13:51:07 +0200
Vedran Furač <vedranf@vedranf.mine.nu> wrote:
> /proc/meminfo
> MemTotal:        3542532 kB
> MemFree:          892972 kB
> Buffers:            2664 kB
> Cached:           130940 kB
> 
> ...that there is almost 900MB free memory. But OK, I can live with it.
> 
> So, my question is: why today overcommit isn't turned off *by default*?
> I have it turned off for a few years now and only side effect is that I
> don't get processes killed randomly anymore, I don't loose valuable time
> and data.
> 
"isn't turned off" means "vm.overcommit_memory==2" ?
And...what's version your kernel is ?
oom-killer still finds "definitely-not-guilty" ones ?


I guess the reason of default value is that the kernel assume processes will
not always use all mmaped range. There will be unused range in process's virtual
memory and it can be big.

For example, typical case in a server, 
when you run multi-thread program (like java VM),

  - stack per thread
  - malloc() arena per thread 

can makes difference among size-of-mapped-range v.s. used-pages bigger.
I saw Gigabytes of unused range on ia64 host,...statck size was big.

IIUC, the size is determined by ulimit's stack size at default. it's 10M on
my x86-64 host.
You'll see 1G of commited usage when you run 100 no-op threads.

And if strict check(vm.ovecommit_memory=2) is used, mmap() return -ENOMEM
whenever it hits limit.
You have to find "which processs should be killed" by youself, anyway.


Against random-kill, you may have 2 choices.

1. use  /proc/<pid>/oom_adj
2. use  memory cgroup.

Something more easy-to-use method may be appriciated. We have above 2 now.

Thanks,
-Kame

