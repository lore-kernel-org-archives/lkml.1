Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab0CFGqa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Mar 2010 01:46:30 -0500
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:54928 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889Ab0CFGq1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Mar 2010 01:46:27 -0500
Message-ID: <4B91FA42.8020400@vmware.com>
Date: Fri, 05 Mar 2010 22:46:26 -0800
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.21) Gecko/20090303 SeaMonkey/1.1.15 (Ubuntu-1.1.15+nobinonly-0ubuntu2)
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Jeff Chua <jeff.tw.chua@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: commit 554f76962d3a6eb5110415f1591aca83f96a84ae hangs USB for
 	vmware 7.0.1
References: <Pine.LNX.4.64.1003060606480.6040@boston.corp.fedex.com>	 <alpine.LFD.2.00.1003051438280.3906@localhost.localdomain>	 <4B91CFE0.8000705@vmware.com> <b6a2187b1003052129l7703dee6s6e820b8ca18b9e2d@mail.gmail.com>
In-Reply-To: <b6a2187b1003052129l7703dee6s6e820b8ca18b9e2d@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Chua wrote:
> 
> 
> On Sat, Mar 6, 2010 at 11:45 AM, Petr Vandrovec <petr@vmware.com 
> <mailto:petr@vmware.com>> wrote:
> 
>       does your box hang, or is it just vmware process that is hung?
> 
> 
> Just the "vmware" process that hangs only. It just got stuck, and even 
> kill -9 doesn't free it.
>  
> 
>      I've noticed that my box here at work has this change too, and I do
>     not see any hang - neither in kernel, or in GUI startup, nor in test
>     sample:
> 
>     open("/proc/bus/usb/devices", O_RDWR)   = 3
>     poll([{fd=3, events=POLLIN}], 1, 5000)  = 1 ([{fd=3, revents=POLLIN}])
>     poll([{fd=3, events=POLLIN}], 1, 5000)  = 0 (Timeout)
>     exit_group(0)                           = ?
>     petr-dev3:/tmp# uname -a
>     Linux petr-dev3 2.6.33-64-05079-g6517b45-dirty #51 SMP PREEMPT Thu
>     Mar 4 20:29:55 PST 2010 x86_64 GNU/Linux
> 
> 
> Here's mine ...
> open("/proc/bus/usb/devices", O_RDONLY) = 65
> fcntl(65, F_GETFL)                      = 0x8000 (flags 
> O_RDONLY|O_LARGEFILE)
> fstat(65, {st_mode=S_IFREG|0444, st_size=0, ...}) = 0
> mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) 
> = 0x7f85396c8000
> lseek(65, 0, SEEK_CUR)                  = 0
> read(65,
> 
> 
> Again in my previous email, on my box,  "cat /proc/bus/usb/devices" 
> hangs as well. You sure you've commit 
> 554f76962d3a6eb5110415f1591aca83f96a84ae
>  on yours?

Well, I hope.  Disassembly of usbcore says that I have 
mutex_lock(&usbfs_mutex) in usbfs_conn_disc_event, so that checkin 
should be in my tree:

000000000001cc10 <usbfs_conn_disc_event>:
    1cc10:       55                      push   %rbp
    1cc11:       48 89 e5                mov    %rsp,%rbp
    1cc14:       e8 00 00 00 00          callq  1cc19 
<usbfs_conn_disc_event+0x9>
                         1cc15: R_X86_64_PC32    mcount+0xfffffffffffffffc
    1cc19:       31 f6                   xor    %esi,%esi
    1cc1b:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                         1cc1e: R_X86_64_32S     usbfs_mutex
    1cc22:       e8 00 00 00 00          callq  1cc27 
<usbfs_conn_disc_event+0x17>
                         1cc23: R_X86_64_PC32 
mutex_lock_nested+0xfffffffffffffffc
    1cc27:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                         1cc2a: R_X86_64_32S     usbfs_mutex
    1cc2e:       ff 05 00 00 00 00       incl   0x0(%rip)        # 1cc34 
<usbfs_conn_disc_event+0x24>
                         1cc30: R_X86_64_PC32    .bss+0x9a4
    1cc34:       e8 00 00 00 00          callq  1cc39 
<usbfs_conn_disc_event+0x29>
                         1cc35: R_X86_64_PC32 
mutex_unlock+0xfffffffffffffffc
    1cc39:       31 c9                   xor    %ecx,%ecx
    1cc3b:       ba 01 00 00 00          mov    $0x1,%edx
    1cc40:       be 03 00 00 00          mov    $0x3,%esi
    1cc45:       48 c7 c7 00 00 00 00    mov    $0x0,%rdi
                         1cc48: R_X86_64_32S     .data+0x1d00
    1cc4c:       e8 00 00 00 00          callq  1cc51 
<usbfs_conn_disc_event+0x41>
                         1cc4d: R_X86_64_PC32 
__wake_up+0xfffffffffffffffc
    1cc51:       c9                      leaveq
    1cc52:       c3                      retq


One thing is that I brought my only USB device home, so currently I have 
none attached to the box:

petr-dev3:/usr/src/git/linux-2.6# cat /proc/bus/usb/devices

T:  Bus=02 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 3
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-64-05079-g6517b45-dirty ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:03:00.1
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms

T:  Bus=01 Lev=00 Prnt=00 Port=00 Cnt=00 Dev#=  1 Spd=12  MxCh= 3
B:  Alloc=  0/900 us ( 0%), #Int=  0, #Iso=  0
D:  Ver= 1.10 Cls=09(hub  ) Sub=00 Prot=00 MxPS=64 #Cfgs=  1
P:  Vendor=1d6b ProdID=0001 Rev= 2.06
S:  Manufacturer=Linux 2.6.33-64-05079-g6517b45-dirty ohci_hcd
S:  Product=OHCI Host Controller
S:  SerialNumber=0000:03:00.0
C:* #Ifs= 1 Cfg#= 1 Atr=e0 MxPwr=  0mA
I:* If#= 0 Alt= 0 #EPs= 1 Cls=09(hub  ) Sub=00 Prot=00 Driver=hub
E:  Ad=81(I) Atr=03(Int.) MxPS=   2 Ivl=255ms
petr-dev3:/usr/src/git/linux-2.6#

I'll try upgrading my box at home.  Maybe that one will hang.
							Petr
