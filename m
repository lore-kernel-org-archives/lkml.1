Return-Path: <linux-kernel-owner+w=401wt.eu-S1752202AbXCIA15@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202AbXCIA15 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 19:27:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752437AbXCIA15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 19:27:57 -0500
Received: from gw.goop.org ([64.81.55.164]:33857 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202AbXCIA14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 19:27:56 -0500
Message-ID: <45F0AA09.8070503@goop.org>
Date: Thu, 08 Mar 2007 16:27:53 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Martin Drab <drab@kepler.fjfi.cvut.cz>
CC: hugh@veritas.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Bryan O'Sullivan" <bos@serpentine.com>
Subject: Re: Question about memory mapping mechanism
References: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
In-Reply-To: <Pine.LNX.4.64.0703081345010.21317@kepler.fjfi.cvut.cz>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Martin Drab wrote:
> Hi,
>
> I'm writing a driver for a sampling device that is constantly delivering a 
> relatively high amount of data (about 16 MB/s) and I need to deliver the 
> data to the user-space ASAP. To prevent data loss I create a queue of 
> buffers (consisting of few pages each) which are more or less directly 
> filled by the device and then mapped to the user-space via mmap().
>
> The thing is that I'd like to prevent kernel to swap these pages out, 
> because then I may loose some data when they are not available in time 
> for the next round.
>
> My original idea (that used to work in the past) was to allocate the 
> buffers using __get_free_pages(), then pin the pages down by setting their 
> PG_reserved bit in the page flags before using them. And then set the 
> VM_RESERVED flag of the appropriate VMA when mmap() is called for these 
> pages that are then mapped using nopage() mechanism.
>
> But this way no longer seems to work correctly, it kind of works, but I'm 
> getting following messages for each mmapped page upon munmap() call:
>
> --------------------------------------
> [19172.939248] Bad page state in process 'dtrtest'
> [19172.939249] page:ffff81000160a978 flags:0x001a000000000404 mapping:0000000000000000 mapcount:0 count:0
> [19172.939251] Trying to fix it up, but a reboot is needed
> [19172.939253] Backtrace:
> [19172.939256]
> [19172.939257] Call Trace:
> [19172.939273]  [<ffffffff802adc37>] bad_page+0x57/0x90
> [19172.939280]  [<ffffffff8020b92f>] free_hot_cold_page+0x7f/0x180
> [19172.939287]  [<ffffffff80207a90>] unmap_vmas+0x450/0x750
> [19172.939308]  [<ffffffff80212867>] unmap_region+0xb7/0x160
> [19172.939318]  [<ffffffff80211918>] do_munmap+0x238/0x2f0
> [19172.939325]  [<ffffffff802656c5>] __down_write_nested+0x35/0xf0
> [19172.939334]  [<ffffffff80215ffd>] sys_munmap+0x4d/0x80
> [19172.939341]  [<ffffffff8025f11e>] system_call+0x7e/0x83
> -------------------------------
>
> Aparently due to the PG_reserved bit set.
>
> So my question is: What is currently a proper way to do all this cleanly?
>   


Have you looked at the Infiniband stuff?  I know the folks working on
the ipath driver eventually got this kind of thing working in a sane way.

    J
