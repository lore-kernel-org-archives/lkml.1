Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0BOP4e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 10:56:34 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:43949 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429Ab0BOP4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 10:56:32 -0500
Message-ID: <4B796D31.7030006@nortel.com>
Date: Mon, 15 Feb 2010 09:50:09 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: tracking memory usage/leak in "inactive" field in /proc/meminfo?
References: <4B71927D.6030607@nortel.com>	 <20100210093140.12D9.A69D9226@jp.fujitsu.com>	 <4B72E74C.9040001@nortel.com>	 <28c262361002101645g3fd08cc7t6a72d27b1f94db62@mail.gmail.com>	 <4B74524D.8080804@nortel.com> <28c262361002111838q7db763feh851a9bea4fdd9096@mail.gmail.com> <4B7504D2.1040903@nortel.com>
In-Reply-To: <4B7504D2.1040903@nortel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Feb 2010 15:56:27.0953 (UTC) FILETIME=[6EE77210:01CAAE57]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/2010 01:35 AM, Chris Friesen wrote:

> After being up about 2.5 hrs, there were 4265 pages in the LRU that
> weren't part of file or anon.  These broke down into two separate call
> chains (there were actually three separate offsets within
> compat_do_execve, but the rest was identical):

I added some further instrumentation to track timestamps of when they
were added to the LRU, and when they were added/removed from
NR_ANON_PAGES.  Based on this, it appears that the pages are being
removed from NR_ANON_PAGES but are still left in the LRU.

It looks like I have three general paths leading to the removal of the
pages from NR_ANON_PAGES:

 del from anon list backtrace:
    [<ffffffff8029c951>] kmemleak_clear_anon+0x7f/0xbe
    [<ffffffff802864c7>] page_remove_rmap+0x45/0x146
    [<ffffffff8027dc7e>] unmap_vmas+0x41c/0x948
    [<ffffffff80282405>] exit_mmap+0x7b/0x108
    [<ffffffff8022f441>] mmput+0x33/0x110
    [<ffffffff80233b05>] exit_mm+0x103/0x130
    [<ffffffff802355b5>] do_exit+0x17b/0x91f
    [<ffffffff80235d95>] do_group_exit+0x3c/0x9c
    [<ffffffff80235e07>] sys_exit+0x0/0x12
    [<ffffffff8021ddb5>] ia32_syscall_done+0x0/0xa
    [<ffffffffffffffff>] 0xffffffffffffffff

  del from anon list backtrace:
    [<ffffffff8029c951>] kmemleak_clear_anon+0x7f/0xbe
    [<ffffffff802864c7>] page_remove_rmap+0x45/0x146
    [<ffffffff8027dc7e>] unmap_vmas+0x41c/0x948
    [<ffffffff80282405>] exit_mmap+0x7b/0x108
    [<ffffffff8022f441>] mmput+0x33/0x110
    [<ffffffff802a3a4e>] flush_old_exec+0x1d6/0x86a
    [<ffffffff802dc007>] load_elf_binary+0x366/0x1d1f
    [<ffffffff802a35c6>] search_binary_handler+0xa4/0x25a
    [<ffffffff802d36dc>] compat_do_execve+0x2ab/0x2fd
    [<ffffffff8021e435>] sys32_execve+0x44/0x62
    [<ffffffff8021df25>] ia32_ptregs_common+0x25/0x50
    [<ffffffffffffffff>] 0xffffffffffffffff

  del from anon list backtrace:
    [<ffffffff8029c951>] kmemleak_clear_anon+0x7f/0xbe
    [<ffffffff802864c7>] page_remove_rmap+0x45/0x146
    [<ffffffff8027d1d7>] do_wp_page+0x37a/0x6f6
    [<ffffffff8027ef21>] handle_mm_fault+0x62b/0x77c
    [<ffffffff80632787>] do_page_fault+0x3c7/0xba0
    [<ffffffff8062fda9>] error_exit+0x0/0x51


Looking at the code, it looks like page_remove_rmap() clears the
Anonpage flag and removes it from NR_ANON_PAGES, and the caller is
responsible for removing it from the LRU.  Is that right?

I'll keep digging in the code, but does anyone know where the removal
from the LRU is supposed to happen in the above code paths?

Thanks,

Chris



