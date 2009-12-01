Return-Path: <linux-kernel-owner+w=401wt.eu-S1754073AbZLAKGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754073AbZLAKGM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 05:06:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753933AbZLAKGL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 05:06:11 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:60859 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753561AbZLAKGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 05:06:10 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: debugging oops after disconnecting Nexio USB touchscreen
Date: Tue, 1 Dec 2009 11:06:10 +0100
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.44L0.0911301502470.4478-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0911301502470.4478-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200912011106.12027.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 November 2009, Alan Stern wrote:
> On Mon, 30 Nov 2009, Ondrej Zary wrote:
> > It does not make much sense to me but I think that it crashes iside this
> > list manipulation:
> >
> >         prev = ehci->async;
> >         while (prev->qh_next.qh != qh)
> >                 prev = prev->qh_next.qh;
>
> Yes, it's crashing in the "while" test because prev is NULL.  This
> means the code is looking for qh in the async list but not finding it.
> That's supposed to be impossible.
>
> The assembly code is peculiar because it includes stuff that isn't in
> the source code!  For example, right at this point (after the end of
> the loop) there's a test to see whether prev is NULL.  Where could that
> have come from?  Do you have any idea?

I'm not sure, I might did something wrong and left it there from my previous
debugging attempt.

> >         prev->hw_next = qh->hw_next;
> >         prev->qh_next = qh->qh_next;
> >         wmb ();
>
> These lines aren't reached.
>
> Does this happen every time you disconnect the Nexio?

The crash happens almost always when disconnecting the touchscreen.
When booted without X, it often survives the first disconnect.

> You can try patching that loop.  If prev is NULL then print an error
> message in the log, including the value of qh and the value of
> ehci->async, and jump past the following three statements.
>
> With that change the system shouldn't crash, although khubd might hang.
> But we still need to find out how this could have happened.  Try
> collecting a usbmon trace while running the test; then let's compare
> the usbmon output with the error messages in the log.

gcc version is: gcc (Debian 4.3.4-6) 4.3.4

Tried something like that before but it did not help at all.
The check is not triggered and it still oopses. Now it looks like this:

        qh->qh_state = QH_STATE_UNLINK;
        ehci->reclaim = qh = qh_get (qh);

        prev = ehci->async;
        if (!prev) {
                printk("prev is NULL, qh=%p, ehci->async=%p\n", qh, ehci->async);
                goto after;
        }
        while (prev->qh_next.qh != qh) {
                if (!prev) {
                        printk("prev is NULL, qh=%p, ehci->async=%p\n", qh, ehci->async);
                        goto after;
                }
                prev = prev->qh_next.qh;
        }

        prev->hw_next = qh->hw_next;
        prev->qh_next = qh->qh_next;
        wmb ();
after:


objdump -D drivers/usb/host/ehci-hcd.o:

00002497 <start_unlink_async>:
    2497:       57                      push   %edi
    2498:       56                      push   %esi
    2499:       53                      push   %ebx
    249a:       89 c3                   mov    %eax,%ebx
    249c:       83 ec 04                sub    $0x4,%esp
    249f:       65 a1 14 00 00 00       mov    %gs:0x14,%eax
    24a5:       89 04 24                mov    %eax,(%esp)
    24a8:       31 c0                   xor    %eax,%eax
    24aa:       8b 43 04                mov    0x4(%ebx),%eax
    24ad:       8b 38                   mov    (%eax),%edi
    24af:       3b 53 14                cmp    0x14(%ebx),%edx
    24b2:       75 34                   jne    24e8 <start_unlink_async+0x51>
    24b4:       83 7b fc 00             cmpl   $0x0,-0x4(%ebx)
    24b8:       0f 84 e6 00 00 00       je     25a4 <start_unlink_async+0x10d>
    24be:       83 7b 18 00             cmpl   $0x0,0x18(%ebx)
    24c2:       0f 85 dc 00 00 00       jne    25a4 <start_unlink_async+0x10d>
    24c8:       83 e7 df                and    $0xffffffdf,%edi
    24cb:       8b 43 04                mov    0x4(%ebx),%eax
    24ce:       89 38                   mov    %edi,(%eax)
    24d0:       f0 83 04 24 00          lock addl $0x0,(%esp)
    24d5:       8d 83 08 01 00 00       lea    0x108(%ebx),%eax
    24db:       f0 80 a3 08 01 00 00    lock andb $0xfb,0x108(%ebx)
    24e2:       fb
    24e3:       e9 bc 00 00 00          jmp    25a4 <start_unlink_async+0x10d>
    24e8:       c6 42 68 02             movb   $0x2,0x68(%edx)
    24ec:       89 d0                   mov    %edx,%eax
    24ee:       e8 d6 e0 ff ff          call   5c9 <qh_get>
    24f3:       89 c1                   mov    %eax,%ecx
    24f5:       89 43 18                mov    %eax,0x18(%ebx)
    24f8:       8b 43 14                mov    0x14(%ebx),%eax
    24fb:       85 c0                   test   %eax,%eax
    24fd:       89 c2                   mov    %eax,%edx
    24ff:       75 1d                   jne    251e <start_unlink_async+0x87>
    2501:       6a 00                   push   $0x0
    2503:       eb 09                   jmp    250e <start_unlink_async+0x77>
    2505:       85 d2                   test   %edx,%edx
    2507:       74 04                   je     250d <start_unlink_async+0x76>
    2509:       89 f2                   mov    %esi,%edx
    250b:       eb 11                   jmp    251e <start_unlink_async+0x87>
    250d:       50                      push   %eax
    250e:       51                      push   %ecx
    250f:       68 53 01 00 00          push   $0x153
    2514:       e8 fc ff ff ff          call   2515 <start_unlink_async+0x7e>
    2519:       83 c4 0c                add    $0xc,%esp
    251c:       eb 16                   jmp    2534 <start_unlink_async+0x9d>
==> 251e:       8b 72 48                mov    0x48(%edx),%esi
    2521:       39 ce                   cmp    %ecx,%esi
    2523:       75 e0                   jne    2505 <start_unlink_async+0x6e>
    2525:       8b 01                   mov    (%ecx),%eax
    2527:       89 02                   mov    %eax,(%edx)
    2529:       8b 41 48                mov    0x48(%ecx),%eax
    252c:       89 42 48                mov    %eax,0x48(%edx)
    252f:       f0 83 04 24 00          lock addl $0x0,(%esp)
    2534:       f6 43 fc 01             testb  $0x1,-0x4(%ebx)
    2538:       75 17                   jne    2551 <start_unlink_async+0xba>
    253a:       8b 14 24                mov    (%esp),%edx
    253d:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
    2544:       75 6a                   jne    25b0 <start_unlink_async+0x119>
    2546:       5f                      pop    %edi
    2547:       89 d8                   mov    %ebx,%eax
    2549:       5b                      pop    %ebx
    254a:       5e                      pop    %esi
    254b:       5f                      pop    %edi
    254c:       e9 8b fe ff ff          jmp    23dc <end_unlink_async>
    2551:       83 cf 40                or     $0x40,%edi
    2554:       8b 43 04                mov    0x4(%ebx),%eax
    2557:       89 38                   mov    %edi,(%eax)
    2559:       8b 43 04                mov    0x4(%ebx),%eax
    255c:       8b 00                   mov    (%eax),%eax
    255e:       83 bb a8 00 00 00 00    cmpl   $0x0,0xa8(%ebx)
    2565:       74 0f                   je     2576 <start_unlink_async+0xdf>
    2567:       ba ac 00 00 00          mov    $0xac,%edx
    256c:       b8 78 01 00 00          mov    $0x178,%eax
    2571:       e8 fc ff ff ff          call   2572 <start_unlink_async+0xdb>
    2576:       b8 0a 00 00 00          mov    $0xa,%eax
    257b:       8b 35 00 00 00 00       mov    0x0,%esi
    2581:       e8 fc ff ff ff          call   2582 <start_unlink_async+0xeb>
    2586:       8b 14 24                mov    (%esp),%edx
    2589:       65 33 15 14 00 00 00    xor    %gs:0x14,%edx
    2590:       75 1e                   jne    25b0 <start_unlink_async+0x119>
    2592:       8d 14 30                lea    (%eax,%esi,1),%edx
    2595:       5e                      pop    %esi
    2596:       8d 83 a8 00 00 00       lea    0xa8(%ebx),%eax
    259c:       5b                      pop    %ebx
    259d:       5e                      pop    %esi
    259e:       5f                      pop    %edi
    259f:       e9 fc ff ff ff          jmp    25a0 <start_unlink_async+0x109>
    25a4:       8b 04 24                mov    (%esp),%eax
    25a7:       65 33 05 14 00 00 00    xor    %gs:0x14,%eax
    25ae:       74 05                   je     25b5 <start_unlink_async+0x11e>
    25b0:       e8 fc ff ff ff          call   25b1 <start_unlink_async+0x11a>
    25b5:       5b                      pop    %ebx
    25b6:       5b                      pop    %ebx
    25b7:       5e                      pop    %esi
    25b8:       5f                      pop    %edi
    25b9:       c3                      ret


Decoded code from oops is obviously modified (push at 1c, call at 21
and sfence at 3c):


All code
========
   0:   89 c1                   mov    %eax,%ecx
   2:   89 43 18                mov    %eax,0x18(%ebx)
   5:   8b 43 14                mov    0x14(%ebx),%eax
   8:   85 c0                   test   %eax,%eax
   a:   89 c2                   mov    %eax,%edx
   c:   75 1d                   jne    0x2b
   e:   6a 00                   push   $0x0
  10:   eb 09                   jmp    0x1b
  12:   85 d2                   test   %edx,%edx
  14:   74 04                   je     0x1a
  16:   89 f2                   mov    %esi,%edx
  18:   eb 11                   jmp    0x2b
  1a:   50                      push   %eax
  1b:   51                      push   %ecx
  1c:   68 5f 7f d4 f7          push   $0xf7d47f5f
  21:   e8 92 a5 57 c9          call   0xc957a5b8
  26:   83 c4 0c                add    $0xc,%esp
  29:   eb 16                   jmp    0x41
  2b:*  8b 72 48                mov    0x48(%edx),%esi     <-- trapping instruction
  2e:   39 ce                   cmp    %ecx,%esi
  30:   75 e0                   jne    0x12
  32:   8b 01                   mov    (%ecx),%eax
  34:   89 02                   mov    %eax,(%edx)
  36:   8b 41 48                mov    0x48(%ecx),%eax
  39:   89 42 48                mov    %eax,0x48(%edx)
  3c:   0f ae f8                sfence
  3f:   89                      .byte 0x89

Code starting with the faulting instruction
===========================================
   0:   8b 72 48                mov    0x48(%edx),%esi
   3:   39 ce                   cmp    %ecx,%esi
   5:   75 e0                   jne    0xffffffe7
   7:   8b 01                   mov    (%ecx),%eax
   9:   89 02                   mov    %eax,(%edx)
   b:   8b 41 48                mov    0x48(%ecx),%eax
   e:   89 42 48                mov    %eax,0x48(%edx)
  11:   0f ae f8                sfence
  14:   89                      .byte 0x89



-- 
Ondrej Zary
