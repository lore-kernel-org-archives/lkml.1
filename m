Return-Path: <linux-kernel-owner+w=401wt.eu-S965478AbXBOKNg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965478AbXBOKNg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 05:13:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965409AbXBOKNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 05:13:36 -0500
Received: from smtp.osdl.org ([65.172.181.24]:42074 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965478AbXBOKNf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 05:13:35 -0500
Date: Thu, 15 Feb 2007 02:13:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [patch 19/31] clockevents: i386 drivers
Message-Id: <20070215021317.65e84dd7.akpm@linux-foundation.org>
In-Reply-To: <20061213130211.GT21847@elte.hu>
References: <20060529212109.GA2058@elte.hu>
	<20061213130211.GT21847@elte.hu>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Dec 2006 14:02:11 +0100 Ingo Molnar <mingo@elte.hu> wrote:

> Add clockevent drivers for i386: lapic (local) and PIT (global).  Update 
> the timer IRQ to call into the PIT driver's event handler and the 
> lapic-timer IRQ to call into the lapic clockevent driver.  The 
> assignement of timer functionality is delegated to the core framework 
> code and replaces the compile and runtime evalution in 
> do_timer_interrupt_hook()
> 
> Use the clockevents broadcast support and implement the lapic_broadcast
> function for ACPI.
> 
> No changes to existing functionality.

This patch breaks the NMI on my crufty old dual-PIII supermicro p6dbe
machine:


Testing NMI watchdog ... CPU#0: NMI appears to be stuck (26->26)!
CPU#1: NMI appears to be stuck (0->0)!


vmm:/home/akpm> cat /proc/interrupts 
           CPU0       CPU1       
  0:         59          0   IO-APIC-edge      timer
  1:          2          0   IO-APIC-edge      i8042
  2:          0          0    XT-PIC-XT        cascade
  6:          3          0   IO-APIC-edge      floppy
  8:          1          0   IO-APIC-edge      rtc
 10:        192         61   IO-APIC-fasteoi   aic7xxx
 11:       1339         31   IO-APIC-fasteoi   eth0
 12:          3          1   IO-APIC-edge      i8042
 15:       3067          7   IO-APIC-edge      ide1
NMI:         26          0 
LOC:      58665      58663 
ERR:          0
MIS:          0

and it isn't changing.

See http://userweb.kernel.org/~akpm/nmi-prob/
