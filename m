Return-Path: <linux-kernel-owner+w=401wt.eu-S1760746AbXEWAAf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760746AbXEWAAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 20:00:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757547AbXEWAA0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 20:00:26 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:49397 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757518AbXEWAAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 20:00:25 -0400
Date: Tue, 22 May 2007 17:00:18 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Houston <mikeserv@bmts.com>
cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc2
In-Reply-To: <20070522181444.ad932718.mikeserv@bmts.com>
Message-ID: <alpine.LFD.0.98.0705221653010.3890@woody.linux-foundation.org>
References: <alpine.LFD.0.98.0705182209030.3890@woody.linux-foundation.org>
 <20070520170506.814a38d9.mikeserv@bmts.com> <20070521084549.61a1aa71@freepuppy>
 <20070521131055.0017404f.mikeserv@bmts.com> <20070521103755.51b954e1@freepuppy>
 <20070521225806.bb18d589.mikeserv@bmts.com> <20070521213146.3e220a44@freepuppy>
 <20070522181444.ad932718.mikeserv@bmts.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 22 May 2007, Mike Houston wrote:
> 
> In this case I actually had the kernel crash. First time for me ever
> having a kernel oops! System locked up with keyboard LED's blinking.
> 
> Not sure if anyone wants to see all of it (maybe some screwy
> userland stuff involved), so I won't include that mess in the
> message. It's here:
> http://www.mikeserv.org/files/kernelcrash.txt

I think you have major memory corruption. That first oops disassembles to

		mov    0x10(%eax),%esi
		mov    $0xfffffdfd,%eax
		test   %esi,%esi
		je     after_call
		mov    %edx,%ecx
		mov    %edi,%eax
		mov    %ebx,%edx
		call   *%esi
	after_call:

which is (from net/ipv4/af_inet.c, inet_ioctl()):

                default:
                        if (sk->sk_prot->ioctl)
                                err = sk->sk_prot->ioctl(sk, cmd, arg);
                        else
                                err = -ENOIOCTLCMD;
                        break;

and the load off "sk->sk_prot->ioctl" oopses, because "sk->sk_prot" is 
corrupt and contains 0x8e3cad42, which is not a valid kernel pointer.

The other oops is even worse. 

I also think it meshes with

	sky2 eth0: descriptor error q=0x280 get=285 [800042375e2e5e] put=285

and I suspect your memory got corrupted by sky2 reading the wrong 
descriptors, and overwriting kernel memory.

So it's almost certainly some DMA problem. Now, _why_ you have DMA 
problems, I have no idea. But can you try:
 - disable CONFIG_PREEMPT
 - disable CONFIG_HIGHMEM if you have it on
 - just in general see if you can disable any kernel config options that 
   might be unnecessary.
to see if it changes the situation at all..

		Linus
