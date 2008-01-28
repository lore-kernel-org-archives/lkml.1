Return-Path: <linux-kernel-owner+w=401wt.eu-S1759268AbYA1JnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759268AbYA1JnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:43:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYA1JnD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:43:03 -0500
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:54383 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752051AbYA1Jm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:42:59 -0500
X-Trace: 658483897/mk-filter-4.mail.uk.tiscali.com/B2C/$THROTTLED-DYNAMIC/CUSTOMER-DYNAMIC-IP/81.1.80.29
X-SBRS: None
X-RemoteIP: 81.1.80.29
X-IP-MAIL-FROM: adrian@newgolddream.dyndns.info
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ah4FALAynUdRAVAd/2dsb2JhbACBWKh4
Message-ID: <26713.85.118.17.158.1201513309.squirrel@newgolddream.dyndns.info>
In-Reply-To: <20080126204402.GA30867@kroah.com>
References: <1201377200.6672.10.camel@localhost.localdomain>
    <20080126204402.GA30867@kroah.com>
Date: Mon, 28 Jan 2008 09:41:49 -0000 (UTC)
Subject: Re: kobject oops with maple bus
From: "Adrian McMenamin" <adrian@newgolddream.dyndns.info>
To: "Greg KH" <greg@kroah.com>
Cc: "LKML" <linux-kernel@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, January 26, 2008 8:44 pm, Greg KH wrote:
> On Sat, Jan 26, 2008 at 07:53:20PM +0000, Adrian McMenamin wrote:
>> Greg,
>>
>> Just updated my git to the latest sources and get these (seemingly
>> non-fatal) oops with the Dreamcast maple bus. I'll investigate further,
>> but they may mean something to out out of the box.
>>
>> Adrian

....

>> [    0.000000] kobject (8cc2d360): tried to init an initialized object,
>> something is seriously wrong.
>
> The problem is here.  You have possibly already initialized this object,
> or called 'kobject_get' on it before registering it with the driver
> core.  This is a new sanity check that has been in the -mm tree for
> years :)
>
> So I think something needs to be fixed in the code.  Do you want me to
> take a look at it?
>
> thanks,
>
> greg k-h
> -
> To unsubscribe from this list: send the line "unsubscribe linux-sh" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Greg,

Have now patched that. But I am trying to hunt down another bug - which
seems memory related. After N hotplug events (where N is greater than two
and less than about 100) I get this below - either indicating something
very wrong in SLUB (unlikely) or a memory leak in my driver (sadly, much
more likely).

I cannot see anything obvious and my best guess is that I am freeing up
the underlying struct device incorrectly - this is allocated currently as
staticly allocated member of a dynamically allocated struct maple_device.
It gets hit by the kfree(mdev) - is that going to cause a problem?


[   41.491053] Maple bus device detaching at (0, 2)
[   42.509136] Maple bus at (0, 2): Connected function 0x10
[   42.513939] No maple driver found for this device
[   44.504875] Maple bus device detaching at (0, 2)
[   45.523250] Maple bus at (0, 2): Connected function 0x10
[   45.529272] No maple driver found for this device
[   46.514861] Maple bus device detaching at (0, 1)
[   47.516651] Maple bus device detaching at (0, 2)
[   48.539093] Maple bus at (0, 1): Connected function 0xE
[   48.545090] No maple driver found for this device
[   48.565052] Maple bus at (0, 2): Connected function 0x10
[   48.569995] No maple driver found for this device
[   49.528324] Maple bus device detaching at (0, 2)
[   51.551459] Maple bus at (0, 2): Connected function 0x10
[   51.557579] No maple driver found for this device
[   52.542771] Maple bus device detaching at (0, 2)
[   53.560892] Maple bus at (0, 2): Connected function 0x10
[   53.566011] No maple driver found for this device
[   55.556921] Maple bus device detaching at (0, 2)
[   56.574966] Maple bus at (0, 2): Connected function 0x10
[   56.580969] No maple driver found for this device
[   58.570982] Maple bus device detaching at (0, 2)
[   59.589076] Maple bus at (0, 2): Connected function 0x10
[   59.594105] No maple driver found for this device
[   60.579944] Maple bus device detaching at (0, 2)
[   61.598478] Maple bus at (0, 2): Connected function 0x10
[   61.602238] No maple driver found for this device
[   61.615106] Fault in unaligned fixup: 0000 [#1]
[   61.616970] Modules linked in: nbd
[   61.616970]
[   61.616970] Pid : 752, Comm:                udevd
[   61.616970] PC is at kmem_cache_alloc+0x2e/0xc0
[   61.616970] PC  : 8c074a4e SP  : 8c88ddc4 SR  : 400080f0 TEA :
c00077c4    Not tainted
[   61.616970] R0  : 00000000 R1  : 00000000 R2  : 00000000 R3  :
8ce1d000
[   61.616970] R4  : 8c2b03b0 R5  : 000080d0 R6  : 00007fff R7  :
8c0c09e0
[   61.616970] R8  : 00000000 R9  : ffffffff R10 : 8c2b03f4 R11 :
000080d0
[   61.616970] R12 : 8c88dee4 R13 : 00007fff R14 : 8c88ddc4
[   61.616970] MACH: 00000002 MACL: 00000000 GBR : 29708440 PR  :
8c0c09e0
[   61.616970]
[   61.616970] Call trace:
[   61.616970] [<8c0c09e0>] show_stat+0x20/0x3e0
[   61.616970] [<8c0556b4>] rmqueue_bulk+0x34/0xa0
[   61.616970] [<8c056e2e>] get_page_from_freelist+0x32e/0x540
[   61.616970] [<8c057088>] __alloc_pages+0x48/0x3c0
[   61.616970] [<8c09baa6>] seq_open+0x66/0xa0
[   61.616970] [<8c09bbde>] single_open+0x3e/0xa0
[   61.616970] [<8c0c09c0>] show_stat+0x0/0x3e0
[   61.616970] [<8c0c094a>] stat_open+0x2a/0xa0
[   61.616970] [<8c0b87d4>] proc_reg_open+0x54/0xc0
[   61.616970] [<8c0c0920>] stat_open+0x0/0xa0
[   61.616970] [<8c0b87dc>] proc_reg_open+0x5c/0xc0
[   61.616970] [<8c075944>] __dentry_open+0xe4/0x2c0
[   61.616970] [<8c0b8780>] proc_reg_open+0x0/0xc0
[   61.616970] [<8c09bcae>] seq_read+0x6e/0x360
[   61.616970] [<8c0b82c4>] proc_reg_read+0x64/0x100
[   61.616970] [<8c09bc40>] seq_read+0x0/0x360
[   61.616970] [<8c0781c4>] vfs_read+0x84/0xe0
[   61.616970] [<8c07899c>] sys_read+0x3c/0xa0
[   61.616970] [<8c008240>] syscall_call+0xc/0x10
[   61.616970] [<8c078960>] sys_read+0x0/0xa0
[   61.616970]
[   61.616970] Process: udevd (pid: 752, stack limit = 8c88c001)
[   61.616970] Stack: (0x8c88ddc4 to 0x8c88e000)
[   61.616970] ddc0:          8c0c09e0 8c88dddc 8c4103c0 8cef3f80
00000001 8c4103c0 8c0556b4
[   61.616970] dde0: 8c88ddfc 8c2bd6f0 00000000 00000000 00000001
00000000 8c2bd710 8c056e2e
[   61.616970] de00: 8c88de20 8c2bd6f0 00000000 00000000 8c2bd704
00000000 8c2bd710 00000000
[   61.616970] de20: 00000001 00000044 00000000 000240d0 8c2bdc34
00000000 00000000 00000001
[   61.616970] de40: 8c057088 8c88de60 8c52f010 00000000 8cc65380
00000000 000040d0 8cef3f80
[   61.616970] de60: 8c09baa6 8c88de78 8c48f240 8cef3fc0 8cef3f9c
8c88de78 8c09bbde 8c88de90
[   61.616970] de80: 8c0c09c0 fffffff4 8cef3fc0 8c48f240 8c0c094a
8c88deac 00000000 8cef3f80
[   61.616970] dea0: fffffff4 8ce1d000 8cef3fc0 8c0b87d4 8c88dec0
8c0c0920 8c0b87dc 8c88dec0
[   61.616970] dec0: 8c075944 8c88dedc 8c0b8780 ffffff9c 8cd09c80
8c52f08c 8c88dedc 8cef3fc0
[   61.616970] dee0: 8c09bcae 8c88df00 00007fff 8c88dee4 8c88df1c
8cef3f80 00000001 8c4103c0
[   61.616970] df00: 8cef3fc0 8c88df7c 7bf155f8 8c4103e0 00000000
00008000 8c85d174 00000000
[   61.616970] df20: 00000000 8c0b82c4 8c88df44 00007fff 7bf155f8
8c88df7c 8cef3f80 8c09bc40
[   61.616970] df40: 8cc039c0 fffffffb 8c0781c4 8c88df68 00000000
0041e8a0 8c88df48 8c88df7c
[   61.616970] df60: 7bf155f8 8cef3f80 8c07899c 8c88df7c 8cef3f80
00007fff fffffff7 00000000
[   61.616970] df80: 00000000 00000000 8c008240 7bf155ec ffffff0f
00000021 8c88dff8 8c078960
[   61.616970] dfa0: 00000000 00000440 fffffff9 00000003 00000007
7bf155f8 00007fff 0041cb3c
[   61.616970] dfc0: 00000007 7bf155f8 fffffffb 00000000 0041e8a0
00000000 7bf155ec 7bf155ec
[   61.616970] dfe0: 2962d174 00402b22 00000001 29708440 00000002
00000000 0000004c 00000160
[   61.651001] ---[ end trace 31be9d8019f52cfa ]---


