Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXHYEko@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXHYEko (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 00:40:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbXHYEke
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 00:40:34 -0400
Received: from an-out-0708.google.com ([209.85.132.250]:19569 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839AbXHYEkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 00:40:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=jG/IMUptjRLnopI5VB63OnrieMq+Nzid7/TlSmzvBLAekuiPPTnJaTijyF3KzQqvxp6CkQOl/e3Mnu0oqSQ7Qi6rMa2cNU29k5+uckKZYu4EK1F2a2QktQBJZC7BMjU4q0hV6B9katOrQ/odXTAmTzoQK2zkj8/GIBFg6KVbe4s=
Message-ID: <e21d91280708242140i2e6223a4v51ba016837b74be8@mail.gmail.com>
Date: Sat, 25 Aug 2007 00:40:30 -0400
From: "Clark Cooper" <clark.cooper@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Caught SIGFPE exceptions aren't reset
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[1] Caught SIGFPE exceptions aren't reset

[2]
    On an i386, you can set a handler for a SIGFPE signal, and after enabling FP
    exceptions with feenableexceptions(), an FP exception will cause
your handler
    to be called.  However after the handler returns, it is called
again with the
    same FP error.  Control never returns to the point after the
instruction that
    caused the exception.

[3] kernel

[4] Linux version 2.6.15-1.2054_FC5
(bhcompile@hs20-bc1-3.build.redhat.com) (gcc version 4.1.0 20060304
(Red Hat 4.1.0-3)) #1 Tue Mar 14 15:48:33 EST 2006

[5] NA

[6]
/* =================== sigfpe_problem.c ==================================== */
#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <strings.h>
#include <errno.h>
#include <signal.h>
#include <fenv.h>

/*
 * Demonstrates that SIGFPE exceptions don't reset, so that you can never
 * return to your own code. Instead your handler gets called indefinitely.
 * Note that calling feclearexcept or fedisableexcept in your handler does
 * no good since the fpu status and control words get restored when you
 * return from your signal handler.
 */


#define SAME_SIGNAL_LIMIT	5

void
fpe_handler(int sig, siginfo_t *info, void *context) {
	static void *last_addr = NULL;
	static int same_count = 0;

	printf("Got signal %d, si_signo = %d, si_code = %d, si_addr = 0x%x\n",
	       sig, info->si_signo, info->si_code, info->si_addr);

	/* Shouldn't have to do this, but it doesn't work anyway */

	feclearexcept(FE_ALL_EXCEPT);
	fedisableexcept(FE_ALL_EXCEPT);

	if (last_addr == info->si_addr) {
		if (++same_count >= SAME_SIGNAL_LIMIT) {
			printf("Exiting after receiving "
			       "the same signal %d times\n",
				same_count + 1);
			exit(-1);
		}
	}

	last_addr = info->si_addr;
}

int
main(int argc, char **argv) {
	struct sigaction sa;
	double sqrt_minus_one = 0.0;

	bzero((void *) &sa, sizeof(struct sigaction));

	sa.sa_sigaction = fpe_handler;
	sa.sa_flags     = SA_SIGINFO;
	
	if (sigaction(SIGFPE, &sa, NULL)) {
		perror("sigaction failed ");
		exit(-1);
	}

	feenableexcept(FE_ALL_EXCEPT);

	sqrt_minus_one = sqrt(-1.0);

	printf("I never get here\n");
}
/* ================================================================== */

[ccc@bmamba techplay]$ gcc -g -o sigfpe_problem sigfpe_problem.c -lm
[ccc@bmamba techplay]$ ./sigfpe_problem
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Got signal 8, si_signo = 8, si_code = 7, si_addr = 0x80486f2
Exiting after receiving the same signal 6 times

[7.1] Output of scripts/ver_linux:

If some fields are empty or look unusual you may have an old version.
Compare to the current minimal requirements in Documentation/Changes.

Linux bmamba 2.6.15-1.2054_FC5 #1 Tue Mar 14 15:48:33 EST 2006 i686
athlon i386 GNU/Linux

Gnu C                  4.1.0
Gnu make               3.80
binutils               2.16.91.0.6
util-linux             2.13-pre6
mount                  2.13-pre6
module-init-tools      3.2-pre9
e2fsprogs              1.38
reiserfsprogs          3.6.19
reiser4progs           line
quota-tools            3.13.
PPP                    2.4.3
Linux C Library        > libc.2.4
Dynamic linker (ldd)   2.4
Procps                 3.2.6
Net-tools              1.60
Kbd                    1.12
Sh-utils               5.93
udev                   084
Modules Loaded         autofs4 sunrpc reiserfs vfat fat dm_mirror
dm_mod video button battery ac lp parport_pc parport floppy nvram
uhci_hcd snd_cmipci gameport snd_seq_dummy snd_seq_oss
snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss snd_pcm
snd_page_alloc snd_opl3_lib snd_timer snd_hwdep via_rhine
snd_mpu401_uart mii i2c_viapro i2c_core snd_rawmidi snd_seq_device
via_ircc snd soundcore irda crc_ccitt ext3 jbd

[7.2] /proc/cpuinfo

processor       : 0
vendor_id       : AuthenticAMD
cpu family      : 6
model           : 6
model name      : AMD Athlon(tm)
stepping        : 2
cpu MHz         : 1100.068
cache size      : 256 KB
fdiv_bug        : no
hlt_bug         : no
f00f_bug        : no
coma_bug        : no
fpu             : yes
fpu_exception   : yes
cpuid level     : 1
wp              : yes
flags           : fpu vme de tsc msr pae mce cx8 mtrr pge mca cmov pat
pse36 mmx fxsr sse syscall mp mmxext 3dnowext 3dnow ts
bogomips        : 2203.41

[7.3] /proc/modules

autofs4 19013 1 - Live 0xe09ae000
sunrpc 136573 1 - Live 0xe0de1000
reiserfs 221765 1 - Live 0xe09db000
vfat 11969 1 - Live 0xe0980000
fat 47709 1 vfat, Live 0xe098f000
dm_mirror 19985 0 - Live 0xe0969000
dm_mod 50521 1 dm_mirror, Live 0xe0972000
video 14917 0 - Live 0xe093b000
button 6609 0 - Live 0xe0831000
battery 9285 0 - Live 0xe095d000
ac 4933 0 - Live 0xe08d1000
lp 12297 0 - Live 0xe0940000
parport_pc 25445 1 - Live 0xe0945000
parport 34313 2 lp,parport_pc, Live 0xe091e000
floppy 57733 0 - Live 0xe094d000
nvram 8393 0 - Live 0xe08db000
uhci_hcd 28881 0 - Live 0xe0932000
snd_cmipci 32737 0 - Live 0xe0929000
gameport 15177 1 snd_cmipci, Live 0xe08e1000
snd_seq_dummy 3781 0 - Live 0xe0834000
snd_seq_oss 28993 0 - Live 0xe0915000
snd_seq_midi_event 7105 1 snd_seq_oss, Live 0xe08ce000
snd_seq 47153 5 snd_seq_dummy,snd_seq_oss,snd_seq_midi_event, Live 0xe08fa000
snd_pcm_oss 45009 0 - Live 0xe0909000
snd_mixer_oss 16449 1 snd_pcm_oss, Live 0xe08d5000
snd_pcm 76869 2 snd_cmipci,snd_pcm_oss, Live 0xe08e6000
snd_page_alloc 10441 1 snd_pcm, Live 0xe08ca000
snd_opl3_lib 10305 1 snd_cmipci, Live 0xe086f000
snd_timer 22597 3 snd_seq,snd_pcm,snd_opl3_lib, Live 0xe08bb000
snd_hwdep 9541 1 snd_opl3_lib, Live 0xe085d000
via_rhine 22597 0 - Live 0xe08c3000
snd_mpu401_uart 7873 1 snd_cmipci, Live 0xe085a000
mii 5313 1 via_rhine, Live 0xe0857000
i2c_viapro 8277 0 - Live 0xe083e000
i2c_core 20673 1 i2c_viapro, Live 0xe08b4000
snd_rawmidi 24001 1 snd_mpu401_uart, Live 0xe08ad000
snd_seq_device 8909 5
snd_seq_dummy,snd_seq_oss,snd_seq,snd_opl3_lib,snd_rawmidi, Live
0xe083a000
via_ircc 19541 0 - Live 0xe0851000
snd 50501 12 snd_cmipci,snd_seq_oss,snd_seq,snd_pcm_oss,snd_mixer_oss,snd_pcm,snd_opl3_lib,snd_timer,snd_hwdep,snd_mpu401_uart,snd_rawmidi,snd_seq_device,
Live 0xe0861000
soundcore 9377 1 snd, Live 0xe0836000
irda 105977 1 via_ircc, Live 0xe0892000
crc_ccitt 2241 1 irda, Live 0xe081c000
ext3 116169 3 - Live 0xe0874000
jbd 52693 1 ext3, Live 0xe0843000

[7.4] /proc/ioports and /proc/iomem

0000-001f : dma1
0020-0021 : pic1
0040-0043 : timer0
0050-0053 : timer1
0060-006f : keyboard
0070-0077 : rtc
0080-008f : dma page reg
00a0-00a1 : pic2
00c0-00df : dma2
00f0-00ff : fpu
0170-0177 : ide1
01f0-01f7 : ide0
02f8-02ff : serial
0376-0376 : ide1
0378-037a : parport0
03c0-03df : vga+
03f6-03f6 : ide0
03f8-03ff : serial
0cf8-0cff : PCI conf1
4000-4003 : PM1a_EVT_BLK
4008-400b : PM_TMR
4010-4015 : ACPI CPU throttle
4020-4023 : GPE0_BLK
40f0-40f1 : PM1a_CNT_BLK
5000-5007 : vt596_smbus
d000-d0ff : 0000:00:0e.0
  d000-d0ff : CMI8738-MC6
d400-d40f : 0000:00:11.1
  d400-d407 : ide0
  d408-d40f : ide1
d800-d81f : 0000:00:11.2
  d800-d81f : uhci_hcd
e400-e4ff : 0000:00:12.0
  e400-e4ff : via-rhine

00000000-0009fbff : System RAM
  00000000-00000000 : Crash kernel
0009fc00-0009ffff : reserved
000a0000-000bffff : Video RAM area
000c0000-000cc7ff : Video ROM
000f0000-000fffff : System ROM
00100000-1ffeffff : System RAM
  00100000-002dea4f : Kernel code
  002dea50-003a0503 : Kernel data
1fff0000-1fff2fff : ACPI Non-volatile Storage
1fff3000-1fffffff : ACPI Tables
e0000000-e7ffffff : PCI Bus #01
  e0000000-e7ffffff : 0000:01:00.0
e8000000-ebffffff : 0000:00:00.0
ec000000-edffffff : PCI Bus #01
  ec000000-ecffffff : 0000:01:00.0
  ed000000-ed00ffff : 0000:01:00.0
ee000000-ee0000ff : 0000:00:12.0
  ee000000-ee0000ff : via-rhine
ffff0000-ffffffff : reserved

[X]

It may be that SIGFPE signals aren't meant to be caught, although the man pages
don't say that. All my googling only gives examples of enabling exceptions to
get the default action during debugging. Indeed, that's probably all you need
most of the time. If this is the case, then all that's needed is a
documentation change so that other users don't get frustrated trying to
proceed after catching the exception. (They will discover it when their
program goes into an infinite loop.)

I have spent several hours following the handling of SIGFPE signals in the
kernel and while I am not brave enough to submit a patch, I want to give you
my naive take on what should be changed. It seems to me that a small change
to the function math_error in arch/i386/kernel/traps.c is required. I am not
addressing the parallel function simd_math_error, but it looks like a similar
change would be needed there as well.

I see that there is a set_fpu_swd in arch/i386/kernel/i387.c that is
ifdef'd out.  If you could use that and if it properly handled disabling
preemption around the change to the saved i387 state, then here's a proposed
change to matherror:

Changed lines marked with /*C*/

void math_error(void __user *eip)
{
	struct task_struct * task;
	siginfo_t info;
/*C*/	unsigned short cwd, swd, unmskexcp;

	/*
	 * Save the info for the exception handler and clear the error.
	 */
	task = current;
	save_init_fpu(task);
	task->thread.trap_no = 16;
	task->thread.error_code = 0;
	info.si_signo = SIGFPE;
	info.si_errno = 0;
	info.si_code = __SI_FAULT;
	info.si_addr = eip;
	/*
	 * (~cwd & swd) will mask out exceptions that are not set to unmasked
	 * status.  0x3f is the exception bits in these regs, 0x200 is the
	 * C1 reg you need in case of a stack fault, 0x040 is the stack
	 * fault bit.  We should only be taking one exception at a time,
	 * so if this combination doesn't produce any single exception,
	 * then we have a bad program that isn't syncronizing its FPU usage
	 * and it will suffer the consequences since we won't be able to
	 * fully reproduce the context of the exception
	 */
	cwd = get_fpu_cwd(task);
	swd = get_fpu_swd(task);
/*C*/	unmskexcp = swd & ~cwd & 0x3f;
/*C*/	switch (unmskexcp) {
		case 0x000: /* No unmasked exception */
			return;
		default:    /* Multiple exceptions */
			break;
		case 0x001: /* Invalid Op */
			/*
			 * swd & 0x240 == 0x040: Stack Underflow
			 * swd & 0x240 == 0x240: Stack Overflow
			 * User must clear the SF bit (0x40) if set
			 */
			info.si_code = FPE_FLTINV;
			break;
		case 0x002: /* Denormalize */
		case 0x010: /* Underflow */
			info.si_code = FPE_FLTUND;
			break;
		case 0x004: /* Zero Divide */
			info.si_code = FPE_FLTDIV;
			break;
		case 0x008: /* Overflow */
			info.si_code = FPE_FLTOVF;
			break;
		case 0x020: /* Precision */
			info.si_code = FPE_FLTRES;
			break;
	}
/*C*/	/* Reset caught exceptions ** (set_fpu_swd must handle preemption) */
/*C*/	set_fpu_swd(swd & ~ummskexcp);
	force_sig_info(SIGFPE, &info, task);
}


-- 
Clark Cooper
