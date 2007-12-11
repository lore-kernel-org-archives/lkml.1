Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbXLKRGh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbXLKRGh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 12:06:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754474AbXLKRGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 12:06:16 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:51658 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbXLKRGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:06:13 -0500
Message-ID: <475EC320.5080008@keyaccess.nl>
Date: Tue, 11 Dec 2007 18:04:32 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: "David P. Reed" <dpreed@reed.com>
CC: Andi Kleen <andi@firstfloor.org>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       David Newall <david@davidnewall.com>, Paul Rolland <rol@as2917.net>,
       "H. Peter Anvin" <hpa@zytor.com>, Krzysztof Halasa <khc@pm.waw.pl>,
       Pavel Machek <pavel@ucw.cz>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, rol@witbe.net
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <m3bq8y23de.fsf@maximus.localdomain> <475DE37F.20706@davidnewall.com> <475DE6F4.80702@zytor.com> <475DEB23.1000304@davidnewall.com> <20071211084059.3d03e11d@tux.DEF.witbe.net> <475E5D4B.8020101@keyaccess.nl> <475E7DC2.4060509@davidnewall.com> <475E8D91.20201@keyaccess.nl> <475E95A3.3070801@davidnewall.com> <Pine.LNX.4.61.0712111024060.22976@chaos.analogic.com> <20071211163017.GD16750@one.firstfloor.org> <475EBFBA.6090301@keyaccess.nl> <475EC246.10205@reed.com>
In-Reply-To: <475EC246.10205@reed.com>
Content-Type: multipart/mixed;
 boundary="------------070402090502090105000307"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070402090502090105000307
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 11-12-07 18:00, David P. Reed wrote:

> Which port do you want me to test?

Oh, thought your previous reply was already responding to this. The "other 
diagnostic port", 0xed. The point is not so much that it's going to be a 
good alternate solution but to exclude it being a possible solution.

> Also, I can run the timing test on my machine if you share the source
> code so I can build it.

Thanks, would be interesting. This one:

Rene.

--------------070402090502090105000307
Content-Type: text/plain;
 name="port80.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="port80.c"

#include <stdlib.h>
#include <stdio.h>

#include <sys/io.h>

#define LOOPS 1000

unsigned long cycles[LOOPS];

int main(void)
{
	unsigned long overhead;
	unsigned long total;
	int i;

	if (iopl(3) < 0) {
		perror("iopl");
		return EXIT_FAILURE;
	}

	/* pull it in */
	for (i = 0; i < LOOPS; i++)
		cycles[i] = 0;

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	overhead = 0;
	for (i = 0; i < LOOPS; i++)
		overhead += cycles[i];

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"outb	%%al, $0x80	\n\t"
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	total = 0;
	for (i = 0; i < LOOPS; i++)
		total += cycles[i];
	total -= overhead;

	printf("out: %lu\n", total / LOOPS);

	asm volatile ("cli");
	for (i = 0; i < LOOPS; i++)
		asm (
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"	
			"rdtsc			\n\t"
			"movl	%%eax, %%esi	\n\t"	
			"inb	$0x80, %%al	\n\t"
			"xor	%%eax, %%eax	\n\t"
			"cpuid			\n\t"
			"rdtsc			\n\t"
			"subl	%%esi, %%eax	\n\t"

			: "=a" (cycles[i]) : : "ecx", "edx", "ebx", "esi");
	asm volatile ("sti");

	total = 0;
	for (i = 0; i < LOOPS; i++)
		total += cycles[i];
	total -= overhead;

	printf("in : %lu\n", total / LOOPS);

	return EXIT_SUCCESS;
}

--------------070402090502090105000307--
