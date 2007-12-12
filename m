Return-Path: <linux-kernel-owner+w=401wt.eu-S1758560AbXLLIf3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758560AbXLLIf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2007 03:35:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758404AbXLLIfO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Dec 2007 03:35:14 -0500
Received: from wr-out-0506.google.com ([64.233.184.228]:18838 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758361AbXLLIfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2007 03:35:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AuxIwNoelpr1Qan1tL2uRDJ0Iwf1uJa4wUDUOvvBsojlAgoEV+LQqIY+hJA5v1FPHyvgMq2j0n+Fc2ARiEBS1IlACb7MNd2Xb9eQie1wW0BIrIC+QbTLlw+c7uLaI2ekZWIzrmk8Whv4o1TMD+uaNpGt3SpfKsn9BRkxXGaPZ5s=
Message-ID: <a8e1da0712120035r67165144i718c44f2c5c35c52@mail.gmail.com>
Date: Wed, 12 Dec 2007 16:35:09 +0800
From: "Dave Young" <hidave.darkstar@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: [RFT] Port 0x80 I/O speed
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, dpreed@reed.com,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, pavel@ucw.cz,
       andi@firstfloor.org, rol@as2917.net, "Krzysztof Halasa" <khc@pm.waw.pl>,
       david@davidnewall.com, hpa@zytor.com, john@stoffel.org,
       linux-os@analogic.com
In-Reply-To: <475F1DC6.5090403@keyaccess.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <475F1DC6.5090403@keyaccess.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 12, 2007 7:31 AM, Rene Herman <rene.herman@gmail.com> wrote:
> Good day.
>
> Would some people on x86 (both 32 and 64) be kind enough to compile and run
> the attached program? This is about testing how long I/O port access to port
> 0x80 takes. It measures in CPU cycles so CPU speed is crucial in reporting.
>
> Posted a previous incarnation of this before, buried in the outb 0x80 thread
> which had a serialising problem. This one should as far as I can see measure
> the right thing though. Please yell if you disagree...
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
>
> /* gcc -W -Wall -O2 -o port80 port80.c */
>
> #include <stdlib.h>
> #include <stdio.h>
>
> #include <sys/io.h>
>
> #define LOOPS 10000
>
> inline unsigned long long rdtsc(void)
> {
>         unsigned long long tsc;
>
>         asm volatile ("rdtsc": "=A" (tsc));
>
>         return tsc;
> }
>
> inline void serialize(void)
> {
>         asm volatile ("cpuid": : : "eax", "ebx", "ecx", "edx");
> }
>
> int main(void)
> {
>         unsigned long long start;
>         unsigned long long overhead;
>         unsigned long long output;
>         unsigned long long input;
>         int i;
>
>         if (iopl(3) < 0) {
>                 perror("iopl");
>                 return EXIT_FAILURE;
>         }
>
>         asm volatile ("cli");
>         start = rdtsc();
>         for (i = 0; i < LOOPS; i++) {
>                 serialize();
>                 serialize();
>         }
>         overhead = rdtsc() - start;
>
>         start = rdtsc() + overhead;
>         for (i = 0; i < LOOPS; i++) {
>                 serialize();
>                 asm volatile ("outb %al, $0x80");
>                 serialize();
>         }
>         output = rdtsc() - start;
>
>         start = rdtsc() + overhead;
>         for (i = 0; i < LOOPS; i++) {
>                 serialize();
>                 asm volatile ("inb $0x80, %%al": : : "al");
>                 serialize();
>         }
>         input = rdtsc() - start;
>         asm volatile ("sti");
>
>         output /= LOOPS;
>         input  /= LOOPS;
>         printf("cycles: out %llu, in %llu\n", output, input);
>
>         return EXIT_SUCCESS;
> }
>
>

dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2522, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2522, in 1795
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2523, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2516, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2516, in 1798
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2523, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2518, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2517, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2523, in 1788
dave@darkstar:~/work/tmp$ sudo ./port80
cycles: out 2517, in 1788

dave@darkstar:~$ cat /proc/cpuinfo
processor       : 0
vendor_id       : GenuineIntel
cpu family      : 15
model           : 4
model name      : Intel(R) Pentium(R) D CPU 2.80GHz
stepping        : 7
cpu MHz         : 2793.194
cache size      : 1024 KB
