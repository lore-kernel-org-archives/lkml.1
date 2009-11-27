Return-Path: <linux-kernel-owner+w=401wt.eu-S1752847AbZK0STU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbZK0STU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 13:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZK0STT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 13:19:19 -0500
Received: from netrider.rowland.org ([192.131.102.5]:35952 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751274AbZK0STS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 13:19:18 -0500
Date: Fri, 27 Nov 2009 13:19:24 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Ondrej Zary <linux@rainbow-software.org>
cc: linux-usb@vger.kernel.org, <linux-kernel@vger.kernel.org>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
In-Reply-To: <200911271438.57467.linux@rainbow-software.org>
Message-ID: <Pine.LNX.4.44L0.0911271304240.30903-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Nov 2009, Ondrej Zary wrote:

> Hello,
> I have problems debbugging an oops. It happens when Nexio USB touchscreen
> (using my new code http://lkml.org/lkml/2009/11/25/568) is disconnected:
> 
> BUG: unable to handle kernel NULL pointer dereference at 00000048
> IP: [<f7c38afd>] start_unlink_async+0xb2/0x160 [ehci_hcd]
...

> It does not happen everytime - sometimes it survives the first disconnect.
> Tried adding printk()s to start_unlink_async function - and the oops does not appear.
> Looks like a race. It might be a bug in my code but I'm not able to find it.
> 
> It also happens only when the touchscreen is connected through a hub:
> Bus 001 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
> When connected directly to the machine, it does not oops.

That's understandable, since the stack trace showed that the oops 
occurred while the hub driver was running.

> Tried decodecode:
> Code: 00 fb e9 bb 00 00 00 c6 46 68 02 89 f0 e8 ee e8 ff ff 85 db 89 c7 89 43 18 75 06 68 c5 e4 c3 f7 e8 b4 5f 68 c9 50 8b 43 14 89 c6 <8b> 40 48 39 f8 75 
> f7 85 f6 75 0b 68 0c e5 c3 f7 e8 99 5f 68 c9
> All code
> ========
>    0:   00 fb                   add    %bh,%bl
>    2:   e9 bb 00 00 00          jmp    0xc2
>    7:   c6 46 68 02             movb   $0x2,0x68(%esi)
>    b:   89 f0                   mov    %esi,%eax
>    d:   e8 ee e8 ff ff          call   0xffffe900
>   12:   85 db                   test   %ebx,%ebx
>   14:   89 c7                   mov    %eax,%edi
>   16:   89 43 18                mov    %eax,0x18(%ebx)
>   19:   75 06                   jne    0x21
>   1b:   68 c5 e4 c3 f7          push   $0xf7c3e4c5
>   20:   e8 b4 5f 68 c9          call   0xc9685fd9
>   25:   50                      push   %eax
>   26:   8b 43 14                mov    0x14(%ebx),%eax
>   29:   89 c6                   mov    %eax,%esi
>   2b:*  8b 40 48                mov    0x48(%eax),%eax     <-- trapping instruction
>   2e:   39 f8                   cmp    %edi,%eax
>   30:   75 f7                   jne    0x29
>   32:   85 f6                   test   %esi,%esi
>   34:   75 0b                   jne    0x41
>   36:   68 0c e5 c3 f7          push   $0xf7c3e50c
>   3b:   e8 99 5f 68 c9          call   0xc9685fd9
> 
> Code starting with the faulting instruction
> ===========================================
>    0:   8b 40 48                mov    0x48(%eax),%eax
>    3:   39 f8                   cmp    %edi,%eax
>    5:   75 f7                   jne    0xfffffffe
>    7:   85 f6                   test   %esi,%esi
>    9:   75 0b                   jne    0x16
>    b:   68 0c e5 c3 f7          push   $0xf7c3e50c
>   10:   e8 99 5f 68 c9          call   0xc9685fae
> 
> and "make drivers/usb/host/ehci-hcd.s" but I'm not able to find the above code in ehci-hcd.s.
> 
> What am I doing wrong?

With your disassembly?  Nothing that I can see.  You might be able to 
locate the code in question by comparing the output above and the 
contents of ehci-hcd.s with the output of "objdump -D 
drivers/usb/host/ehci-hcd.o" -- search for the start of the 
start_unlink_async() routine and go forward from there.

For what it's worth, your disassembly doesn't bear any relation to the 
code for start_unlink_async() on my system.

As for what your driver is doing wrong...  Perhaps it is writing to a
memory area after freeing it.  Have you tried using usbmon to see 
what's going on before the oops occurs?

Alan Stern

