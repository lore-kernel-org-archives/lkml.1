Return-Path: <linux-kernel-owner+w=401wt.eu-S1764240AbXGUF60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764240AbXGUF60 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:58:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756466AbXGUF6R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:58:17 -0400
Received: from il.qumranet.com ([82.166.9.18]:49055 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755259AbXGUF6Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:58:16 -0400
Message-ID: <46A1A074.6050803@qumranet.com>
Date: Sat, 21 Jul 2007 08:58:12 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: =?UTF-8?B?IlMuw4dhxJ9sYXIgT251ciI=?= <caglar@pardus.org.tr>,
       kvm-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [kvm-devel] [GIT PULL][RESEND] Late KVM Updates for the 2.6.23
 merge window
References: <1184952728548-git-send-email-avi@qumranet.com> <200707210221.34121.caglar@pardus.org.tr> <alpine.LFD.0.999.0707201633390.27249@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707201633390.27249@woody.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (firebolt.argo.co.il [0.0.0.0]); Sat, 21 Jul 2007 08:58:12 +0300 (IDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Sat, 21 Jul 2007, S.Çağlar Onur wrote:
>   
>> With Linus's latest git, shutting down a guest (fired with -smp 2 -m 512) sometimes 
>> ends up like [1], this occured as soon as qemu window closed.
>>
>> [1] http://cekirdek.pardus.org.tr/~caglar/kvm/dmesg.latest
>>     
>
> [  737.460654] Bad page state in process 'qemu-kvm'
> [  737.460656] page:f5e68000 flags:0xea020000 mapping:00000000 mapcount:2 count:0
> [  737.460657] Trying to fix it up, but a reboot is needed
> [  737.460659] Backtrace:
> [  737.460691]  [<c0159e70>] bad_page+0x64/0x8e
> [  737.460733]  [<c015a7ee>] free_hot_cold_page+0x68/0x15a
>
> That's the "free_pages_check()", and in particular it seems to be 
> "page_mapcount()" being non-zero that triggered that thing.
>
> So it looks like something in KVM isn't coherent about the mapping vs the 
> usage counters..
>
>   

Far more prosaic.  It calls __free_page() on the cleanup path with the
page's virtual address instead of the struct page.  I guess
__free_page() is happy with a zeroed out blob, which is the most likely
contents.

Trivial patch shortly.

-- 
Do not meddle in the internals of kernels, for they are subtle and quick to panic.

