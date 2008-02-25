Return-Path: <linux-kernel-owner+w=401wt.eu-S1758054AbYBYVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054AbYBYVKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 16:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752171AbYBYVKW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 16:10:22 -0500
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:44511 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752144AbYBYVKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 16:10:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:Received:Date:From:To:Subject:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id;
  b=poXRCi8ig8xonYHgoxbkf10W/9UfVisspqI0BeSvsJLATapZE99Trcetw+6P1zKEtyw7hYBYLhU1dR956bWceFhjommHBpHi0aB1vt0LxS3EQPKDOax1aCHuIZqNnjHzgu7bkjA020ePkUp+peQB1CjiYXLz601OZvAK8vuRH4A=  ;
X-YMail-OSG: SKUDkXYVM1mXYsR1LdAwCD_RuLkrVa_HVEavXl7aKYbdSYeOucQmlaByn8UsAAZQdU0ZWcuR2g--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Feb 2008 13:10:18 -0800
From: David Brownell <david-b@pacbell.net>
To: peterz@infradead.org
Subject: Re: [patch 2.6.25-rc3] lockdep:  add spin_lock_irq_nested()
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org
References: <200801181429.00485.david-b@pacbell.net>
 <1200904299.6341.2.camel@lappy>
 <200801211022.36312.david-b@pacbell.net>
 <200802242033.52208.david-b@pacbell.net>
 <1203934828.6242.140.camel@lappy>
 <20080225112102.3B6E928E368@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <1203945463.6242.162.camel@lappy>
In-Reply-To: <1203945463.6242.162.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080225211018.74604235C92@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I thought the way to use the *_nested() calls was "consistently"!
>
> Very much depends on your view of consistent :-)
>
> > That is, if one instance of a lock access uses it, they all should,
> > since that's the only way lockdep learns about equivalence classes.
> > Also, locks shouldn't move between those equivalence classes... so
> > the raw lockdep data stays correct.
>
> Ah, see, you're missing a detail (see below for the full story). Its the
> irq state that must be consistent. So if at any one point you take the
> lock in an irq safe context, you must always take it irq safe.

IRQ state is not a factor; that's already coded correctly.

The issue here is lockdep falsely reporting recursive locking.

Again, the locking is correct; it's lockdep getting confused,
because it puts all irq_desc[].lock instances in the same bag
instead of treating parent and child locks differently.  So
when something holding a child lock makes a call that grabs
a parent lock, it thinks that could be recursive.


> Also, have you looked at explicit lock_class_key usage per chip?

Never had reason to look at such stuff; you didn't mention the
option in the earlier chitchat...


> That
> way you can avoid using the _nested annotation. You can set a class on a
> lock right after spin_lock_init() using lockdep_set_class*().

All this stuff is set up in kernel/irq/handle.c ... spinlocks
are initialized statically, lock classes are set up even before
the kernel banner is printed, by early_init_irq_lock_class().

So I'm think that the reason this only _changes_ the false
recursion notification is that it doesn't support overriding
such class annotations; it doesn't seem to forget about the
first one set up.  Note that the code I posted earlier, using
the _nested annotations, isn't confused like this...

- Dave


=================== CUT
Try to remove some false lockdep warnings about lock recursion,
by marking putting GPIO irq_desc locks into their own class.

But that doesn't seem to work; all it does is change the fault
report to be more confusing:

  =============================================
  [ INFO: possible recursive locking detected ]
  2.6.25-rc3 #80
  ---------------------------------------------
  swapper/1 is trying to acquire lock:
   (&irq_desc_lock_class){+...}, at: [<c007150c>] set_irq_wake+0x34/0xe8

  but task is already holding lock:
   (&irq_desc_lock_class){+...}, at: [<c007150c>] set_irq_wake+0x34/0xe8

  other info that might help us debug this:
  2 locks held by swapper/1:
   #0:  (&irq_desc_lock_class){+...}, at: [<c007150c>] set_irq_wake+0x34/0xe8
   #1:  (&bank->lock){....}, at: [<c0038d80>] _set_gpio_wakeup+0x38/0xa4

  stack backtrace:
  [<c0029d78>] (dump_stack+0x0/0x14) from [<c0064a48>] (print_deadlock_bug+0xa0/0xcc)
  [<c00649a8>] (print_deadlock_bug+0x0/0xcc) from [<c0064ae0>] (check_deadlock+0x6c/0x84)
   r6:c1c1834c r5:00000000 r4:00000000
  [<c0064a74>] (check_deadlock+0x0/0x84) from [<c0066500>] (validate_chain+0x1d8/0x2c4)
   r7:c1c1834c r6:00000000 r5:01403805 r4:c04c0658
  [<c0066328>] (validate_chain+0x0/0x2c4) from [<c0066aec>] (__lock_acquire+0x500/0x5bc)
  [<c00665ec>] (__lock_acquire+0x0/0x5bc) from [<c006705c>] (lock_acquire+0x70/0x88)
  [<c0066fec>] (lock_acquire+0x0/0x88) from [<c02260d0>] (_spin_lock_irqsave+0x50/0x64)
   r6:20000093 r5:c007150c r4:c02cf6c8
  [<c0226080>] (_spin_lock_irqsave+0x0/0x64) from [<c007150c>] (set_irq_wake+0x34/0xe8)
   r6:00000001 r5:00000025 r4:c02cf698
  [<c00714d8>] (set_irq_wake+0x0/0xe8) from [<c0038da4>] (_set_gpio_wakeup+0x5c/0xa4)
  [<c0038d48>] (_set_gpio_wakeup+0x0/0xa4) from [<c0039410>] (gpio_wake_enable+0x48/0x50)
   r8:c00393c8 r7:c02d5ecc r6:00000001 r5:00000162 r4:000000c2
  [<c00393c8>] (gpio_wake_enable+0x0/0x50) from [<c0071594>] (set_irq_wake+0xbc/0xe8)
   r6:00000001 r5:00000162 r4:c02d5e9c
  [<c00714d8>] (set_irq_wake+0x0/0xe8) from [<c000c8d0>] (osk_mistral_init+0x160/0x1c8)
  [<c000c770>] (osk_mistral_init+0x0/0x1c8) from [<c000c9e4>] (osk_init+0xac/0xd4)
   r4:c001f3f8
  [<c000c938>] (osk_init+0x0/0xd4) from [<c0009db4>] (customize_machine+0x20/0x2c)
   r4:c001e000
  [<c0009d94>] (customize_machine+0x0/0x2c) from [<c0008684>] (do_initcalls+0x78/0x200)
  [<c000860c>] (do_initcalls+0x0/0x200) from [<c000882c>] (do_basic_setup+0x20/0x24)
  [<c000880c>] (do_basic_setup+0x0/0x24) from [<c0008bd0>] (kernel_init+0x44/0x90)
  [<c0008b8c>] (kernel_init+0x0/0x90) from [<c004576c>] (do_exit+0x0/0x30c)
   r4:00000000
---
 arch/arm/plat-omap/gpio.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+)

--- a/arch/arm/plat-omap/gpio.c	2008-02-24 19:02:32.000000000 -0800
+++ b/arch/arm/plat-omap/gpio.c	2008-02-25 10:54:29.000000000 -0800
@@ -1332,6 +1332,28 @@ static struct clk *gpio_fclks[OMAP34XX_N
 static struct clk *gpio_iclks[OMAP34XX_NR_GPIOS];
 #endif
 
+#ifdef CONFIG_LOCKDEP
+
+/* tell lockdep that this IRQ's locks and its parent's locks are in
+ * different categories, so that it won't detect false recursion.
+ */
+static struct lock_class_key gpio_lock_class;
+
+static inline void mark_gpio_locking(unsigned gpio_irq)
+{
+	lockdep_set_class(&irq_desc[gpio_irq].lock, &gpio_lock_class);
+}
+
+#else
+
+static inline void mark_gpio_locking(unsigned gpio_irq)
+{
+	/* NOP */
+}
+
+#endif
+
+
 static int __init _omap_gpio_init(void)
 {
 	int i;
@@ -1532,6 +1554,7 @@ static int __init _omap_gpio_init(void)
 				set_irq_chip(j, &gpio_irq_chip);
 			set_irq_handler(j, handle_simple_irq);
 			set_irq_flags(j, IRQF_VALID);
+			mark_gpio_locking(i);
 		}
 		set_irq_chained_handler(bank->irq, gpio_irq_handler);
 		set_irq_data(bank->irq, bank);
