Return-Path: <linux-kernel-owner+w=401wt.eu-S1752750Ab0AWWpH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab0AWWpH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 17:45:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624Ab0AWWpG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 17:45:06 -0500
Received: from mout7.freenet.de ([195.4.92.97]:55642 "EHLO mout7.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413Ab0AWWpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 17:45:04 -0500
From: "S.Beck" <sebastian.bw@freenet.de>
To: linux-kernel@vger.kernel.org
Subject: HPET support to user space
Date: Sun, 24 Jan 2010 01:40:18 +0100
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001240140.18162.sebastian.bw@freenet.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET kernel support
-----------------------

1.) Delay support (very short, up to 20 ns)
------------------------------------------------------------------------------
A hpet/comparator is setup in single shot mode. There is setup always one
more timer than needed to get a intime start on demand.
That comparator gets loaded with the delay and the kernel can do then
some other work, schedule or whatever.
That timer interrupt sets up the stack in a way that on the IRET-Instruction 
of that interrupt the app. that requested for the delay continues its 
execution.
On more core computers  the CPU of that app. is just sopped during that delay,
no matter what scheduling mode is used.
In FIFO mode only the app.'s core and the system's core are running, other
cores should be stopped.

2.) Dynamic, very short and high precision,
    periodic execution of registered routines
    (OS RT support for kernel and user space software, up to 50 MHz )
------------------------------------------------------------------------------
One procedure works like the syscall routine (INT 80h) just for the
HPET-timers. Maybe we can use INT 81h for this procedure / mechanism  -
procedure registration, timer setup, stop, start, pause, error handling, ...,
all the sub functions needed to handle a hpet-timer.
A second central interrupt procedure in the kernel is responsible for the
comparator requests for all hpet-timer interrupts but not the first three of a
HPET chip, those are connected to ports and are so free usable.
A hpet-timer is set up via FSB-/systembus-interrupt if available, else it is
set up through the APIC via IRQ but to the same INT number (IDT entry)
The central interrupt procedure sitting on that INT number is responsible for
reading the timer number the interrupt occurred and calls the corresponding
process. If this interrupt is called from the same timer while the registered
process don't have returned, that process get closed with the error
"Process to slow" and that timer is stopped.

This has nothing to do with the decoupled hrtimer support of the kernel but 
this is HPET real time (RT) timer support for user space apps. 
That means that a computer / PC can be used for RT tasks in the real world:
- Chip burning (flash-, PROM-, EEPROM-, ..., chips)
- RT measuring and controlling of external periphery / machines / automotives.
- Real Mode tasks like BIOS updating.
- all timing sensible things behind the north bridge, that are decoupled from
  the CPU clock.

To programm this I need following informations:
- Is INT 81h free for use ?
- How can I setup an IQR properly with which linux functions?
- Can linux give me a free unused high priority IRQ (0..15, not 16..31)?
- Can linux set up my function descriptor to the IDT?
- Can linux set such a free IRQ automatically to a corresponding INT [n] and
   return that numbers ( IRQ and INT [n] ) to set up the timer properly ?
- What is standard in linux ?

- Can linux set up FSB / systembus interrupts if available ?
  (that we aren't limited to interrupt frequencies of 1 MHz or 10 MHz (APIC)
  but up to 50 MHz (HPET) ).
- What do I need (functions) to call a process in a multicore environment ?
- How can I set a process (app.) to an other core ?
   (that the user space process is not running in the same core like the 
kernel
   and IDT) (Only as option for more safety) 

This HPET support isn't a big thing to programm if all this information is
available. I'm new to kernel core programming and initialization.
It would be also nice to see such detailed documentation in the kernel.
This would guaranty much better code - good documentation is all and only !

   bastl
