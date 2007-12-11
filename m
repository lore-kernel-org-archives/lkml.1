Return-Path: <linux-kernel-owner+w=401wt.eu-S1756557AbXLKXdA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557AbXLKXdA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 18:33:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbXLKXcr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 18:32:47 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:58544 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbXLKXcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 18:32:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:user-agent:mime-version:to:cc:subject:content-type:from;
        b=rE/cyRGgPox0Hq/hACXBbWg/caz2UdJahN3CtuRKZadxv0ROrNVpHaW5MM+iZnTmdmHHbEL/iJ4LzYk0kjZksWkW0ccb6xRBhGzwBNlB+zJn15wjZ3oFIMurmhBY6dszkvNJF2J8DOb6LLQ4k0aMC/ew+MK4c3MG+G1PSb+puzo=
Message-ID: <475F1DC6.5090403@keyaccess.nl>
Date: Wed, 12 Dec 2007 00:31:18 +0100
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>
CC: dpreed@reed.com, Alan Cox <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, Krzysztof Halasa <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
Subject: [RFT] Port 0x80 I/O speed
Content-Type: multipart/mixed;
 boundary="------------070402050109070509090404"
From: Rene Herman <rene.herman@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070402050109070509090404
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Good day.

Would some people on x86 (both 32 and 64) be kind enough to compile and run 
the attached program? This is about testing how long I/O port access to port 
0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.

Posted a previous incarnation of this before, buried in the outb 0x80 thread 
which had a serialising problem. This one should as far as I can see measure 
the right thing though. Please yell if you disagree...

For me, on a Duron 1300 (AMD756 chipset) I have a constant:

rene@7ixe4:~/src/port80$ su -c ./port80
cycles: out 2400, in 2400

and on a PII 400 (Intel 440BX chipset) a constant:

rene@6bap:~/src/port80$ su -c ./port80
cycles: out 553, in 251

Results are (mostly) independent of compiler optimisation, but testing with 
an -O2 compile should be most useful. Thanks!

Rene.

--------------070402050109070509090404
Content-Type: text/plain;
 name="port80.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="port80.c"

/* gcc -W -Wall -O2 -o port80 port80.c */

#include <stdlib.h>
#include <stdio.h>

#include <sys/io.h>

#define LOOPS 10000

inline unsigned long long rdtsc(void)
{
	unsigned long long tsc;

	asm volatile ("rdtsc": "=A" (tsc));

	return tsc;
}

inline void serialize(void)
{
	asm volatile ("cpuid": : : "eax", "ebx", "ecx", "edx");
}

int main(void)
{
	unsigned long long start;
	unsigned long long overhead; 
	unsigned long long output;
	unsigned long long input;
	int i;

	if (iopl(3) < 0) {
		perror("iopl");
		return EXIT_FAILURE;
	}

	asm volatile ("cli");
	start = rdtsc();
	for (i = 0; i < LOOPS; i++) {
	 	serialize();	
		serialize();
	}
	overhead = rdtsc() - start;

	start = rdtsc() + overhead;
	for (i = 0; i < LOOPS; i++) {
		serialize();
		asm volatile ("outb %al, $0x80");
		serialize();
	}
	output = rdtsc() - start;

	start = rdtsc() + overhead;
	for (i = 0; i < LOOPS; i++) {
		serialize();
		asm volatile ("inb $0x80, %%al": : : "al");
		serialize();
	}
	input = rdtsc() - start;
	asm volatile ("sti");

	output /= LOOPS;
	input  /= LOOPS;
	printf("cycles: out %llu, in %llu\n", output, input);

	return EXIT_SUCCESS;
}

--------------070402050109070509090404--
