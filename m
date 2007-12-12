Return-Path: <linux-kernel-owner+w=401wt.eu-S1759519AbXLLQ7V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759519AbXLLQ7V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 11:59:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbXLLQ7N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 11:59:13 -0500
Received: from an-out-0708.google.com ([209.85.132.251]:37243 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979AbXLLQ7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 11:59:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=WV6+15UnMsDb8VygLRrjkdOtiCb0fDEoWR/qju9LE4rJkXt/sXt7InTCGcnhjUSI6pYwO51BINwAIS0S1u6dxlA7P/UTcrQ9wvWEzOKuk92Qu4k5FjOuxcvH9z2S1d8JW+H+FRIdg8dHqMxG3xc88EFKIJNeb9u8YDWFPC+IP9U=
Date: Wed, 12 Dec 2007 19:59:03 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFT] Port 0x80 I/O speed
Message-ID: <20071212165903.GA7727@cvg.cvg>
References: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Rene Herman - Wed, Dec 12, 2007 at 12:31:18AM +0100]
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run 
> the attached program? This is about testing how long I/O port access to 
> port 0x80 takes. It measures in CPU cycles so CPU speed is crucial in 
> reporting.
>
> Posted a previous incarnation of this before, buried in the outb 0x80 
> thread which had a serialising problem. This one should as far as I can see 
> measure the right thing though. Please yell if you disagree...
>
> For me, on a Duron 1300 (AMD756 chipset) I have a constant:
>
> rene@7ixe4:~/src/port80$ su -c ./port80
> cycles: out 2400, in 2400
>
> and on a PII 400 (Intel 440BX chipset) a constant:
>
> rene@6bap:~/src/port80$ su -c ./port80
> cycles: out 553, in 251
>
> Results are (mostly) independent of compiler optimisation, but testing with 
> an -O2 compile should be most useful. Thanks!
>
> Rene.

| /* gcc -W -Wall -O2 -o port80 port80.c */
| 
| #include <stdlib.h>
| #include <stdio.h>
| 
| #include <sys/io.h>
| 
| #define LOOPS 10000
| 
| inline unsigned long long rdtsc(void)
| {
| 	unsigned long long tsc;
| 
| 	asm volatile ("rdtsc": "=A" (tsc));
| 
| 	return tsc;
| }
| 
| inline void serialize(void)
| {
| 	asm volatile ("cpuid": : : "eax", "ebx", "ecx", "edx");
| }
| 
| int main(void)
| {
| 	unsigned long long start;
| 	unsigned long long overhead; 
| 	unsigned long long output;
| 	unsigned long long input;
| 	int i;
| 
| 	if (iopl(3) < 0) {
| 		perror("iopl");
| 		return EXIT_FAILURE;
| 	}
| 
| 	asm volatile ("cli");
| 	start = rdtsc();
| 	for (i = 0; i < LOOPS; i++) {
| 	 	serialize();	
| 		serialize();
| 	}
| 	overhead = rdtsc() - start;
| 
| 	start = rdtsc() + overhead;
| 	for (i = 0; i < LOOPS; i++) {
| 		serialize();
| 		asm volatile ("outb %al, $0x80");
| 		serialize();
| 	}
| 	output = rdtsc() - start;
| 
| 	start = rdtsc() + overhead;
| 	for (i = 0; i < LOOPS; i++) {
| 		serialize();
| 		asm volatile ("inb $0x80, %%al": : : "al");
| 		serialize();
| 	}
| 	input = rdtsc() - start;
| 	asm volatile ("sti");
| 
| 	output /= LOOPS;
| 	input  /= LOOPS;
| 	printf("cycles: out %llu, in %llu\n", output, input);
| 
| 	return EXIT_SUCCESS;
| }

Here we go (for 1000 times started) ;)

---
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1427, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1449
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1427, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1449
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1449
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1449
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1429, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
cycles: out 1428, in 1450
---

processor	: 0
vendor_id	: AuthenticAMD
cpu family	: 15
model		: 36
model name	: AMD Turion(tm) 64 Mobile Technology ML-30
stepping	: 2
cpu MHz		: 800.000
cache size	: 1024 KB
fdiv_bug	: no
hlt_bug		: no
f00f_bug	: no
coma_bug	: no
fpu		: yes
fpu_exception	: yes
cpuid level	: 1
wp		: yes
flags		: fpu vme de pse tsc msr pae mce cx8 apic sep mtrr pge mca cmov pat pse36 clflush mmx fxsr sse sse2 syscall nx mmxext fxsr_opt lm 3dnowext 3dnow pni lahf_lm ts fid vid ttp tm stc
bogomips	: 1601.04
clflush size	: 64

		Cyrill

