Return-Path: <linux-kernel-owner+w=401wt.eu-S1764344AbXEWA3u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764344AbXEWA3u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:29:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758517AbXEWA3n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:29:43 -0400
Received: from smtp.osdl.org ([207.189.120.12]:49085 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141AbXEWA3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:29:42 -0400
Message-ID: <46538AEE.4030700@linux-foundation.org>
Date: Tue, 22 May 2007 17:29:34 -0700
From: Stephen Hemminger <shemminger@linux-foundation.org>
Organization: Linux Foundation
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Mike Houston <mikeserv@bmts.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org> <20070520170506.814a38d9.mikeserv@bmts.com> <20070521084549.61a1aa71@freepuppy> <20070521131055.0017404f.mikeserv@bmts.com> <20070521103755.51b954e1@freepuppy> <20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy> <20070522181444.ad932718.mikeserv@bmts.com> <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> On Tue, 22 May 2007, Mike Houston wrote:
>   
>> In this case I actually had the kernel crash. First time for me ever
>> having a kernel oops! System locked up with keyboard LED's blinking.
>>
>> Not sure if anyone wants to see all of it (maybe some screwy
>> userland stuff involved), so I won't include that mess in the
>> message. It's here:
>> http://www.mikeserv.org/files/kernelcrash.txt
>>     
>
> I think you have major memory corruption. That first oops disassembles to
>
> 		mov    0x10(%eax),%esi
> 		mov    $0xfffffdfd,%eax
> 		test   %esi,%esi
> 		je     after_call
> 		mov    %edx,%ecx
> 		mov    %edi,%eax
> 		mov    %ebx,%edx
> 		call   *%esi
> 	after_call:
>
> which is (from net/ipv4/af_inet.c, inet_ioctl()):
>
>                 default:
>                         if (sk->sk_prot->ioctl)
>                                 err = sk->sk_prot->ioctl(sk, cmd, arg);
>                         else
>                                 err = -ENOIOCTLCMD;
>                         break;
>
> and the load off "sk->sk_prot->ioctl" oopses, because "sk->sk_prot" is 
> corrupt and contains 0x8e3cad42, which is not a valid kernel pointer.
>
> The other oops is even worse. 
>
> I also think it meshes with
>
> 	sky2 eth0: descriptor error q=0x280 get=285 [800042375e2e5e] put=285
>
>   
Descriptor error means,  the driver told it to do something but the 
OWNER bit wasn't set.
Only ever saw this on the Gigabyte motherboard.

It looks like the chip reads the wrong memory sometimes. The problem 
happens only on the on-board NIC's
and only on this kind of motherboard.  For testing, I have put code in 
to check that the receive data actually
arrived before the IRQ, it triggered on my Gigabyte 925 motherboard. It 
appears that DMA access
is messed up. This board has lots of "overclocker" friendly stuff; maybe 
the BIOS never really sets up the PCI
bridges and clocks properly.

It doesn't seem like a software or driver problem. I have tried tweaking 
PCI registers but nothing worked
in this case.
