Return-Path: <linux-kernel-owner+w=401wt.eu-S965329AbXA3M4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965329AbXA3M4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 07:56:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965345AbXA3M4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 07:56:17 -0500
Received: from lmv.inov.pt ([146.193.64.2]:41806 "EHLO lmv.inov.pt"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965329AbXA3M4P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 07:56:15 -0500
Message-ID: <45BF4055.7030902@inov.pt>
Date: Tue, 30 Jan 2007 12:55:49 +0000
From: Jose Goncalves <jose.goncalves@inov.pt>
User-Agent: Thunderbird 1.5.0.9 (X11/20070111)
MIME-Version: 1.0
To: Frederik Deweerdt <deweerdt@free.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: Oops on serial access on kernel 2.6.16.38
References: <45BA2341.40008@inov.pt> <20061226201003.GA2990@slug> <45BA459F.7060604@inov.pt> <20070126212203.GB2990@slug> <45BE0D44.1080309@inov.pt>
In-Reply-To: <45BE0D44.1080309@inov.pt>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-INOV-EmailServer-Information: Please contact the Email service provider for more information
X-INOV-EmailServer: Found to be clean
X-INOV-EmailServer-From: jose.goncalves@inov.pt
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jose Goncalves wrote:
> Frederik Deweerdt wrote:
>   
>> On Fri, Jan 26, 2007 at 06:17:03PM +0000, Jose Goncalves wrote:
>>   
>>     
>>> Frederik Deweerdt wrote:
>>>     
>>>       
>>>> On Fri, Jan 26, 2007 at 03:50:25PM +0000, Jose Goncalves wrote:
>>>>   
>>>>       
>>>>         
>>>>> I'm having a problem with the latest 2.6.16 kernel (I've found the
>>>>> problem on 2.6.16.37 and 2.6.16.38). I have a application that retreives
>>>>> data from a GPS connected on a serial port. From time to time a get a
>>>>> kernel Oops, like this:
>>>>>
>>>>>     
>>>>>         
>>>>>           
>>>> Could you send your .config?
>>>>   
>>>>       
>>>>         
>>> Here it goes...
>>>
>>>     
>>>       
>> Thanks. It looks like something is wrong with port->ops->startup() in
>> uart_startup(), could you apply the following patch and report the
>> results? And btw, you're using a plain 8250 serial port, isn't it?
>>   
>>     
>
> OK. I've applied the patch and I'm now waiting for the kernel Oops...
> sometimes it takes two days until it happens.
> I'm using a standard 16550A serial controller found on my hardware, that
> is a PC/104 SBC:
>
>  http://www.icop.com.tw/products_detail.asp?ProductID=70
>
> We have a custom hardware that has another serial controller (TL16C554A)
> with 4 extra serial ports (also, 16550A type), and the problem happens
> in a test program that is retreiving data from ttyS0 (from the SBC) and
> ttyS3 (from our custom hardware).
> The serial ports initialization, as reported by the kernel:
>
> [   15.216847] Serial: 8250/16550 driver $Revision: 1.90 $ 6 ports, IRQ
> sharing disabled
> [   15.219517] serial8250: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [   15.221963] serial8250: ttyS1 at I/O 0x2f8 (irq = 3) is a 16550A
> [   15.223907] serial8250: ttyS2 at I/O 0x3e8 (irq = 5) is a 16550A
> [   15.225757] serial8250: ttyS3 at I/O 0x2e8 (irq = 5) is a 16550A
> [   15.227644] serial8250: ttyS4 at I/O 0x1a0 (irq = 6) is a 16550A
> [   15.229656] serial8250: ttyS5 at I/O 0x1a8 (irq = 6) is a 16550A
>
> With your patch I'm now getting the following for each iteration of my
> test program:
>
> <4>[  298.918962] type is 4
> <4>[  298.919011] ops is c0292f00
> <4>[  298.919033] ops->startup is c01bd777
> <4>[  299.436980] type is 4
> <4>[  299.437030] ops is c0292f00
> <4>[  299.437051] ops->startup is c01bd777
>
> I don't know if it's relevant or not but the kernel is running in
> NFS-Root mode.
>   
I've had a new kernel Oops with your patch applied:

<4>[35769.361941] type is 4
<4>[35769.361994] ops is c0292f00
<4>[35769.362016] ops->startup is c01bd777
<4>[35769.958983] type is 4
<4>[35769.959038] ops is c0292f00
<4>[35769.959060] ops->startup is c01bd777
<1>[35769.959201] Unable to handle kernel NULL pointer dereference at
virtual address 00000000
<1>[35769.966797]  printing eip:
<4>[35769.974265] 00000000
<1>[35769.974296] *pde = 00000000
<0>[35769.981814] Oops: 0000 [#1]
<4>[35769.989367] Modules linked in:
<0>[35769.996955] CPU:    0
<4>[35769.996974] EIP:    0060:[<00000000>]    Not tainted VLI
<4>[35769.996990] EFLAGS: 00010202   (2.6.16.38-mtm4-debug2 #1)
<0>[35770.020533] EIP is at rest_init+0x3feffdc0/0x1e
<0>[35770.029044] eax: 00000060   ebx: 00000000   ecx: 00000000   edx:
000002fd
<0>[35770.038017] esi: 00000000   edi: 00000040   ebp: 00000202   esp:
c72e9e34
<0>[35770.047118] ds: 007b   es: 007b   ss: 0068
<0>[35770.056257] Process gp_position (pid: 15013, threadinfo=c72e8000
task=c11a15a0)
<0>[35770.057042] Stack: <0>c02fae70 00000005 c02fae70 c77f6de0 c12815e4
c77714e0 c01ba4c4 c02fae70
<0>[35770.077407]        c025f18a c01bd777 c025f17f c0292f00 c025f173
00000004 c12815e4 00000000
<0>[35770.089263]        c77714e0 c77714e0 c01bbacc c12815e4 00000000
ffffffed c77714e0 00000100
<0>[35770.101473] Call Trace:
<0>[35770.113147]  [<c01ba4c4>] uart_startup+0x8d/0x120
<0>[35770.125473]  [<c01bd777>] serial8250_startup+0x0/0x2a5
<0>[35770.138071]  [<c01bbacc>] uart_open+0xaa/0xec
<0>[35770.150859]  [<c01a9e67>] tty_open+0x16c/0x270
<0>[35770.163665]  [<c013dbbb>] chrdev_open+0xd7/0xf0
<0>[35770.176636]  [<c013dae4>] chrdev_open+0x0/0xf0
<0>[35770.189587]  [<c0136449>] __dentry_open+0xb4/0x180
<0>[35770.202755]  [<c01365e8>] nameidata_to_filp+0x1f/0x31
<0>[35770.216107]  [<c013654c>] do_filp_open+0x37/0x3f
<0>[35770.229554]  [<c0137bc0>] __fput+0x11e/0x126
<0>[35770.242947]  [<c018f64f>] strncpy_from_user+0x2e/0x4c
<0>[35770.256773]  [<c013668d>] get_unused_fd+0x4c/0x91
<0>[35770.270556]  [<c013676c>] do_sys_open+0x40/0xb5
<0>[35770.284545]  [<c01367f4>] sys_open+0x13/0x17
<0>[35770.298620]  [<c01023d9>] syscall_call+0x7/0xb
<0>[35770.312965] Code:  Bad EIP value.
<4>[35770.357131]  type is 4
<4>[35775.528001] ops is c0292f00
<4>[35775.541519] ops->startup is c01bd777

Best regards,
José Gonçalves

