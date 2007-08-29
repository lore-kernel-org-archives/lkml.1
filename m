Return-Path: <linux-kernel-owner+w=401wt.eu-S1759409AbXH2BjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759409AbXH2BjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbXH2BjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:39:03 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:57015 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752549AbXH2BjB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:39:01 -0400
Message-ID: <388351538.28936@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Wed, 29 Aug 2007 09:38:58 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>,
       mingo@redhat.com
Subject: Re: Understanding I/O behaviour - next try
Message-ID: <20070829013858.GA7721@mail.ustc.edu.cn>
References: <713252.42570.qm@web32614.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <713252.42570.qm@web32614.mail.mud.yahoo.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2007 at 08:53:07AM -0700, Martin Knoblauch wrote:
[...]
>  The basic setup is a dual x86_64 box with 8 GB of memory. The DL380
> has a HW RAID5, made from 4x72GB disks and about 100 MB write cache.
> The performance of the block device with O_DIRECT is about 90 MB/sec.
> 
>  The problematic behaviour comes when we are moving large files through
> the system. The file usage in this case is mostly "use once" or
> streaming. As soon as the amount of file data is larger than 7.5 GB, we
> see occasional unresponsiveness of the system (e.g. no more ssh
> connections into the box) of more than 1 or 2 minutes (!) duration
> (kernels up to 2.6.19). Load goes up, mainly due to pdflush threads and
> some other poor guys being in "D" state.
[...]
>  Just by chance I found out that doing all I/O inc sync-mode does
> prevent the load from going up. Of course, I/O throughput is not
> stellar (but not much worse than the non-O_DIRECT case). But the
> responsiveness seem OK. Maybe a solution, as this can be controlled via
> mount (would be great for O_DIRECT :-).
> 
>  In general 2.6.22 seems to bee better that 2.6.19, but this is highly
> subjective :-( I am using the following setting in /proc. They seem to
> provide the smoothest responsiveness:
> 
> vm.dirty_background_ratio = 1
> vm.dirty_ratio = 1
> vm.swappiness = 1
> vm.vfs_cache_pressure = 1

You are apparently running into the sluggish kupdate-style writeback
problem with large files: huge amount of dirty pages are getting
accumulated and flushed to the disk all at once when dirty background
ratio is reached. The current -mm tree has some fixes for it, and
there are some more in my tree. Martin, I'll send you the patch if
you'd like to try it out.

>  Another thing I saw during my tests is that when writing to NFS, the
> "dirty" or "nr_dirty" numbers are always 0. Is this a conceptual thing,
> or a bug?

What are the nr_unstable numbers?

Fengguang

