Return-Path: <linux-kernel-owner+w=401wt.eu-S1755960AbYKDRjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960AbYKDRjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 12:39:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753000AbYKDRje
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 12:39:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:52244 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbYKDRje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 12:39:34 -0500
Message-Id: <1225820372.15162.1282956905@webmail.messagingengine.com>
X-Sasl-Enc: cOFAsgj445vEtwuMqUJMuZ3OcX+d/p6EB+At9ymM/bYn 1225820372
From: "Alexander van Heukelum" <heukelum@fastmail.fm>
To: "Ingo Molnar" <mingo@elte.hu>
Cc: "Cyrill Gorcunov" <gorcunov@gmail.com>,
       "Alexander van Heukelum" <heukelum@mailshack.com>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, lguest@ozlabs.org,
       jeremy@xensource.com, "Steven Rostedt" <srostedt@redhat.com>,
       "Mike Travis" <travis@sgi.com>
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
X-Mailer: MessagingEngine.com Webmail Interface
Subject: Re: [PATCH RFC/RFB] x86_64, i386: interrupt dispatch changes
In-Reply-To: <20081104165409.GA511@elte.hu>
Date: Tue, 04 Nov 2008 18:39:32 +0100
References: <20081104122839.GA22864@mailshack.com>
 <20081104150729.GC21470@localhost>
 <1225813659.22738.1282932197@webmail.messagingengine.com>
 <20081104163636.GA20534@elte.hu>
 <1225817106.2795.1282945873@webmail.messagingengine.com>
 <20081104165409.GA511@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 4 Nov 2008 17:54:09 +0100, "Ingo Molnar" <mingo@elte.hu> said:
> 
> * Alexander van Heukelum <heukelum@fastmail.fm> wrote:
> 
> > > My estimation is that if we do it right, your approach will behave 
> > > better on modern CPUs (which is what matters most for such 
> > > things), especially on real workloads where there's a considerable 
> > > instruction-cache pressure. But it should be measured in any case.
> > 
> > Fully agreed. I will do some measurements in the near future, maybe 
> > next week. At least noone came up with an absolutely blocking 
> > problem with this approach ;).
> 
> how about "it does not build with lguest enabled" as a blocking 
> problem? ;-)
> 
>   arch/x86/lguest/built-in.o: In function `lguest_init_IRQ':
>   boot.c:(.init.text+0x33f): undefined reference to `interrupt'

The following makes it compile... Whether it works is a different
question ;).

index a5d8e1a..ad7e292 100644
--- a/arch/x86/lguest/boot.c
+++ b/arch/x86/lguest/boot.c
@@ -580,6 +580,7 @@ static struct irq_chip lguest_irq_controller = {
  * interrupt (except 128, which is used for system calls), and then
  tells the
  * Linux infrastructure that each interrupt is controlled by our
  level-based
  * lguest interrupt controller. */
+void maininterrupt(void);
 static void __init lguest_init_IRQ(void)
 {
        unsigned int i;
@@ -590,7 +591,7 @@ static void __init lguest_init_IRQ(void)
                 * a straightforward 1 to 1 mapping, so force that here.
                 */
                __get_cpu_var(vector_irq)[vector] = i;
                if (vector != SYSCALL_VECTOR) {
-                       set_intr_gate(vector, interrupt[vector]);
+                       set_intr_gate(vector, maininterrupt);
                        set_irq_chip_and_handler_name(i,
                        &lguest_irq_controller,
                                                      handle_level_irq,
                                                      "level");

> config attached.
> 
> 	Ingo
-- 
  Alexander van Heukelum
  heukelum@fastmail.fm

-- 
http://www.fastmail.fm - One of many happy users:
  http://www.fastmail.fm/docs/quotes.html

