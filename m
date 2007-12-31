Return-Path: <linux-kernel-owner+w=401wt.eu-S1758760AbXLaOja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758760AbXLaOja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2007 09:39:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751739AbXLaOjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Dec 2007 09:39:21 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:53803 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbXLaOjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2007 09:39:20 -0500
Message-ID: <4778FE42.6010003@keyaccess.nl>
Date: Mon, 31 Dec 2007 15:35:46 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>, dpreed@reed.com,
       Islam Amer <pharon@gmail.com>, hpa@zytor.com,
       Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: provide a DMI based port 0x80 I/O delay override
References: <477711DC.5030800@keyaccess.nl>	<alpine.LFD.1.00.0712300124440.32517@woody.linux-foundation.org>	<20071230144700.78f4605c@the-village.bc.nu>	<20071230152835.GX16946@elte.hu>	<20071230153818.1a554a7e@the-village.bc.nu>	<20071230160132.GA14311@elte.hu>	<20071230164828.039916c8@the-village.bc.nu>	<4777E010.7030703@keyaccess.nl> <20071231122344.7b403cd8@the-village.bc.nu>
In-Reply-To: <20071231122344.7b403cd8@the-village.bc.nu>
Content-Type: multipart/mixed;
 boundary="------------080809080803040401030608"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080809080803040401030608
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 31-12-07 13:23, Alan Cox wrote:

> I dug out the reference drivers. The reference drivers use the delay and
> the 8390 datasheet confirms it is neccessary.

Great, thanks for that.

> The Crynwr driver has some interesting things to say
> 
> | The National 8390 Chip (NIC) requires 4 bus clocks between successive
> | chip selects (National DP8390 Data Sheet Addendum, June 1990)

Okay, that's pretty specific. Given that these things exist on actual ISA 
cards and "I/O recovery time" BIOS settings that are availabe also on these 
old 386s already it's probably still at least somewhat debatable how much 
linux drivers really need to care even in this case -- but let's ignore that.

> Also " To establish a minimum delay, an I/O instruction must be used. A
> good rule of ; thumb is that ISA I/O instructions take ~1.0 microseconds
> and MCA I/O ; instructions take ~0.5 microseconds. Reading the NMI Status
> Register (0x61) ; is a good way to pause on all machines."
> 
> But all the official drivers use pauses and the manual says they are
> needed for correct, reliable behaviour - at least with a genuine 8390.

Okay. Am about to go stuff my face with new years celebrations but will 
definitely try to make that old WD8003 hickup.

By the way, expected, but before anyone else mentions it -- no, reading from 
port 0x61 is not a reliable delay today. Duron 1300 / AMD756:

rene@7ixe4:~/src/port80$ su -c ./portime
out 0x80: 2400 cycles
in  0x80: 2400 cycles
in  0x61: 2400 cycles

But PII 400 / Intel 440BX:

rene@6bap:~/port80$ su -c ./portime
out 0x80: 545 cycles
in  0x80: 254 cycles
in  0x61: 254 cycles

Rene.

--------------080809080803040401030608
Content-Type: text/plain;
 name="portime.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="portime.c"

/* gcc -W -Wall -O2 -o portime portime.c */

#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>

#include <sys/io.h>

#define LOOPS 10000

inline uint64_t rdtsc(void)
{
	uint32_t hi, lo;

	asm ("rdtsc": "=d" (hi), "=a" (lo));

	return (uint64_t)hi << 32 | lo;
}

inline void serialize(void)
{
	asm ("cpuid": : : "eax", "ebx", "ecx", "edx");
}

int main(void)
{
	uint64_t tsc0, tsc1, tsc2, tsc3, tsc4;
	uint64_t out, in8, in6;
	int i;

	if (iopl(3) < 0) {
		perror("iopl");
		return EXIT_FAILURE;
	}

	asm ("cli");
	tsc0 = rdtsc();
	for (i = 0; i < LOOPS; i++) {
	 	serialize();	
		serialize();
	}
	tsc1 = rdtsc();
	for (i = 0; i < LOOPS; i++) {
		serialize();
		asm ("outb %al, $0x80");
		serialize();
	}
	tsc2 = rdtsc();
	for (i = 0; i < LOOPS; i++) {
		serialize();
		asm ("inb $0x80, %%al": : : "al");
		serialize();
	}
	tsc3 = rdtsc();
	for (i = 0; i < LOOPS; i++) {
		serialize();
		asm ("inb $0x61, %%al": : : "al");
		serialize();
	}
	tsc4 = rdtsc();
	asm ("sti");

	out = ((tsc2 - tsc1) - (tsc1 - tsc0)) / LOOPS;
	in8 = ((tsc3 - tsc2) - (tsc1 - tsc0)) / LOOPS;
	in6 = ((tsc4 - tsc3) - (tsc1 - tsc0)) / LOOPS;

	printf("out 0x80: %llu cycles\n", out);
	printf("in  0x80: %llu cycles\n", in8);
	printf("in  0x61: %llu cycles\n", in6);

	return EXIT_SUCCESS;
}

--------------080809080803040401030608--
