Return-Path: <linux-kernel-owner+w=401wt.eu-S1752753AbZK3PbD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753AbZK3PbD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 10:31:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbZK3PbA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 10:31:00 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:46393 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751964AbZK3Pa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 10:30:58 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Mon, 30 Nov 2009 16:30:59 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0911271304240.30903-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911271304240.30903-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911301631.00484.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 27 November 2009, Alan Stern wrote:
> On Fri, 27 Nov 2009, Ondrej Zary wrote:
> > Hello,
> > I have problems debbugging an oops. It happens when Nexio USB touchscreen
> > (using my new code http://lkml.org/lkml/2009/11/25/568) is disconnected:
> >
> > BUG: unable to handle kernel NULL pointer dereference at 00000048
> > IP: [<f7c38afd>] start_unlink_async+0xb2/0x160 [ehci_hcd]
>
> ...
>
> > It does not happen everytime - sometimes it survives the first
> > disconnect. Tried adding printk()s to start_unlink_async function - and
> > the oops does not appear. Looks like a race. It might be a bug in my code
> > but I'm not able to find it.
> >
> > It also happens only when the touchscreen is connected through a hub:
> > Bus 001 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0
> > hub When connected directly to the machine, it does not oops.
>
> That's understandable, since the stack trace showed that the oops
> occurred while the hub driver was running.
>
> > Tried decodecode:
> > Code: 00 fb e9 bb 00 00 00 c6 46 68 02 89 f0 e8 ee e8 ff ff 85 db 89 c7
> > 89 43 18 75 06 68 c5 e4 c3 f7 e8 b4 5f 68 c9 50 8b 43 14 89 c6 <8b> 40 48
> > 39 f8 75 f7 85 f6 75 0b 68 0c e5 c3 f7 e8 99 5f 68 c9
> > All code
> > ========
> >    0:   00 fb                   add    %bh,%bl
> >    2:   e9 bb 00 00 00          jmp    0xc2
> >    7:   c6 46 68 02             movb   $0x2,0x68(%esi)
> >    b:   89 f0                   mov    %esi,%eax
> >    d:   e8 ee e8 ff ff          call   0xffffe900
> >   12:   85 db                   test   %ebx,%ebx
> >   14:   89 c7                   mov    %eax,%edi
> >   16:   89 43 18                mov    %eax,0x18(%ebx)
> >   19:   75 06                   jne    0x21
> >   1b:   68 c5 e4 c3 f7          push   $0xf7c3e4c5
> >   20:   e8 b4 5f 68 c9          call   0xc9685fd9
> >   25:   50                      push   %eax
> >   26:   8b 43 14                mov    0x14(%ebx),%eax
> >   29:   89 c6                   mov    %eax,%esi
> >   2b:*  8b 40 48                mov    0x48(%eax),%eax     <-- trapping
> > instruction 2e:   39 f8                   cmp    %edi,%eax
> >   30:   75 f7                   jne    0x29
> >   32:   85 f6                   test   %esi,%esi
> >   34:   75 0b                   jne    0x41
> >   36:   68 0c e5 c3 f7          push   $0xf7c3e50c
> >   3b:   e8 99 5f 68 c9          call   0xc9685fd9
> >
> > Code starting with the faulting instruction
> > ===========================================
> >    0:   8b 40 48                mov    0x48(%eax),%eax
> >    3:   39 f8                   cmp    %edi,%eax
> >    5:   75 f7                   jne    0xfffffffe
> >    7:   85 f6                   test   %esi,%esi
> >    9:   75 0b                   jne    0x16
> >    b:   68 0c e5 c3 f7          push   $0xf7c3e50c
> >   10:   e8 99 5f 68 c9          call   0xc9685fae
> >
> > and "make drivers/usb/host/ehci-hcd.s" but I'm not able to find the above
> > code in ehci-hcd.s.
> >
> > What am I doing wrong?
>
> With your disassembly?  Nothing that I can see.  You might be able to
> locate the code in question by comparing the output above and the
> contents of ehci-hcd.s with the output of "objdump -D
> drivers/usb/host/ehci-hcd.o" -- search for the start of the
> start_unlink_async() routine and go forward from there.

Thanks, found it there:
00001a4b <start_unlink_async>:
    1a4b:       55                      push   %ebp
    1a4c:       57                      push   %edi
    1a4d:       56                      push   %esi
    1a4e:       89 d6                   mov    %edx,%esi
    1a50:       53                      push   %ebx
    1a51:       89 c3                   mov    %eax,%ebx
    1a53:       83 ec 04                sub    $0x4,%esp
    1a56:       65 a1 14 00 00 00       mov    %gs:0x14,%eax
    1a5c:       89 04 24                mov    %eax,(%esp)
    1a5f:       31 c0                   xor    %eax,%eax
    1a61:       85 db                   test   %ebx,%ebx
    1a63:       75 0b                   jne    1a70 <start_unlink_async+0x25>
    1a65:       68 57 01 00 00          push   $0x157
    1a6a:       e8 fc ff ff ff          call   1a6b <start_unlink_async+0x20>
    1a6f:       58                      pop    %eax
    1a70:       83 7b 04 00             cmpl   $0x0,0x4(%ebx)
    1a74:       75 0b                   jne    1a81 <start_unlink_async+0x36>
    1a76:       68 91 01 00 00          push   $0x191
    1a7b:       e8 fc ff ff ff          call   1a7c <start_unlink_async+0x31>
    1a80:       58                      pop    %eax
    1a81:       85 f6                   test   %esi,%esi
    1a83:       75 0b                   jne    1a90 <start_unlink_async+0x45>
    1a85:       68 d1 01 00 00          push   $0x1d1
    1a8a:       e8 fc ff ff ff          call   1a8b <start_unlink_async+0x40>
    1a8f:       58                      pop    %eax
    1a90:       8b 43 04                mov    0x4(%ebx),%eax
    1a93:       8b 28                   mov    (%eax),%ebp
    1a95:       3b 73 14                cmp    0x14(%ebx),%esi
    1a98:       75 3f                   jne    1ad9 <start_unlink_async+0x8e>
    1a9a:       68 0b 02 00 00          push   $0x20b
    1a9f:       e8 fc ff ff ff          call   1aa0 <start_unlink_async+0x55>
    1aa4:       83 7b fc 00             cmpl   $0x0,-0x4(%ebx)
    1aa8:       58                      pop    %eax
    1aa9:       0f 84 e5 00 00 00       je     1b94 <start_unlink_async+0x149>
    1aaf:       83 7b 18 00             cmpl   $0x0,0x18(%ebx)
    1ab3:       0f 85 db 00 00 00       jne    1b94 <start_unlink_async+0x149>
    1ab9:       83 e5 df                and    $0xffffffdf,%ebp
    1abc:       8b 43 04                mov    0x4(%ebx),%eax
    1abf:       89 28                   mov    %ebp,(%eax)
    1ac1:       f0 83 04 24 00          lock addl $0x0,(%esp)
    1ac6:       8d 83 08 01 00 00       lea    0x108(%ebx),%eax
    1acc:       f0 80 a3 08 01 00 00    lock andb $0xfb,0x108(%ebx)
    1ad3:       fb
    1ad4:       e9 bb 00 00 00          jmp    1b94 <start_unlink_async+0x149>
    1ad9:       c6 46 68 02             movb   $0x2,0x68(%esi)
    1add:       89 f0                   mov    %esi,%eax
    1adf:       e8 ee e8 ff ff          call   3d2 <qh_get>
    1ae4:       85 db                   test   %ebx,%ebx
    1ae6:       89 c7                   mov    %eax,%edi
    1ae8:       89 43 18                mov    %eax,0x18(%ebx)
    1aeb:       75 0b                   jne    1af8 <start_unlink_async+0xad>
    1aed:       68 d1 01 00 00          push   $0x1d1
    1af2:       e8 fc ff ff ff          call   1af3 <start_unlink_async+0xa8>
    1af7:       58                      pop    %eax
    1af8:       8b 43 14                mov    0x14(%ebx),%eax
    1afb:       89 c6                   mov    %eax,%esi
==> 1afd:       8b 40 48                mov    0x48(%eax),%eax
    1b00:       39 f8                   cmp    %edi,%eax
    1b02:       75 f7                   jne    1afb <start_unlink_async+0xb0>
    1b04:       85 f6                   test   %esi,%esi
    1b06:       75 0b                   jne    1b13 <start_unlink_async+0xc8>
    1b08:       68 18 02 00 00          push   $0x218
    1b0d:       e8 fc ff ff ff          call   1b0e <start_unlink_async+0xc3>
    1b12:       58                      pop    %eax
    1b13:       8b 07                   mov    (%edi),%eax
    1b15:       89 06                   mov    %eax,(%esi)
    1b17:       8b 47 48                mov    0x48(%edi),%eax
    1b1a:       89 46 48                mov    %eax,0x48(%esi)
    1b1d:       f0 83 04 24 00          lock addl $0x0,(%esp)
    1b22:       f6 43 fc 01             testb  $0x1,-0x4(%ebx)
    1b26:       75 18                   jne    1b40 <start_unlink_async+0xf5>
    1b28:       8b 14 24                mov    (%esp),%edx
    1b2b:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
    1b32:       75 6c                   jne    1ba0 <start_unlink_async+0x155>
    1b34:       5d                      pop    %ebp
    1b35:       89 d8                   mov    %ebx,%eax
    1b37:       5b                      pop    %ebx
    1b38:       5e                      pop    %esi
    1b39:       5f                      pop    %edi
    1b3a:       5d                      pop    %ebp
    1b3b:       e9 50 fe ff ff          jmp    1990 <end_unlink_async>
    1b40:       83 cd 40                or     $0x40,%ebp
    1b43:       8b 43 04                mov    0x4(%ebx),%eax
    1b46:       89 28                   mov    %ebp,(%eax)
    1b48:       8b 43 04                mov    0x4(%ebx),%eax
    1b4b:       8b 00                   mov    (%eax),%eax
    1b4d:       83 bb a8 00 00 00 00    cmpl   $0x0,0xa8(%ebx)
    1b54:       74 0f                   je     1b65 <start_unlink_async+0x11a>
    1b56:       ba ac 00 00 00          mov    $0xac,%edx
    1b5b:       b8 33 02 00 00          mov    $0x233,%eax
    1b60:       e8 fc ff ff ff          call   1b61 <start_unlink_async+0x116>
    1b65:       b8 0a 00 00 00          mov    $0xa,%eax
    1b6a:       8b 35 00 00 00 00       mov    0x0,%esi
    1b70:       e8 fc ff ff ff          call   1b71 <start_unlink_async+0x126>
    1b75:       8b 14 24                mov    (%esp),%edx
    1b78:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
    1b7f:       75 1f                   jne    1ba0 <start_unlink_async+0x155>
    1b81:       5f                      pop    %edi
    1b82:       8d 14 30                lea    (%eax,%esi,1),%edx
    1b85:       8d 83 a8 00 00 00       lea    0xa8(%ebx),%eax
    1b8b:       5b                      pop    %ebx
    1b8c:       5e                      pop    %esi
    1b8d:       5f                      pop    %edi
    1b8e:       5d                      pop    %ebp
    1b8f:       e9 fc ff ff ff          jmp    1b90 <start_unlink_async+0x145>
    1b94:       8b 04 24                mov    (%esp),%eax
    1b97:       65 33 05 14 00 00 00    xor    %gs:0x14,%eax
    1b9e:       74 05                   je     1ba5 <start_unlink_async+0x15a>
    1ba0:       e8 fc ff ff ff          call   1ba1 <start_unlink_async+0x156>
    1ba5:       5e                      pop    %esi
    1ba6:       5b                      pop    %ebx
    1ba7:       5e                      pop    %esi
    1ba8:       5f                      pop    %edi
    1ba9:       5d                      pop    %ebp
    1baa:       c3                      ret


It does not make much sense to me but I think that it crashes iside this list 
manipulation:

        prev = ehci->async;
        while (prev->qh_next.qh != qh)
                prev = prev->qh_next.qh;

        prev->hw_next = qh->hw_next;
        prev->qh_next = qh->qh_next;
        wmb ();

-- 
Ondrej Zary
