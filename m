Return-Path: <linux-kernel-owner+w=401wt.eu-S1753191AbZHTGHq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbZHTGHq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Aug 2009 02:07:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbZHTGHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Aug 2009 02:07:46 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:40895 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752913AbZHTGHo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Aug 2009 02:07:44 -0400
To: <linux-kernel@vger.kernel.org>
Cc: x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg Kroah-Hartman <gregkh@suse.de>
References: <m163cjhwa4.fsf@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 19 Aug 2009 23:07:36 -0700
In-Reply-To: <m163cjhwa4.fsf@fess.ebiederm.org> (Eric W. Biederman's message of "Wed\, 19 Aug 2009 22\:46\:59 -0700")
Message-ID: <m1skfnggrb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: linux-kernel@vger.kernel.org, gregkh@suse.de, alan@lxorguk.ukuu.org.uk, torvalds@linux-foundation.org, hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, x86@kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 FVGT_m_MULTI_ODD Contains multiple odd letter combinations
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: v2.6.31-rc6: BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=


ebiederm@xmission.com (Eric W. Biederman) writes:

> I'm not certain who I should route this too, but I just had 2.6.31-rc6
> fall over on me.  I don't know how reproducible this will be but
> I have a full crash dump if someone is interested in looking into this.

Looks like I was wrong.  This is appears trivial to reproduce,
I have just reproduced it two more times in a row.  I think
the problem is pty related.

I was looking into a change in behavior on 2.6.31-rc6 where
data was being lost, and it appears one variant of my test program
kills the kernel.

The following program run as an unprivileged user causes a kernel
panic in about a minute:

aka

while :; do ./KernelTtyTest ; done


I'm not certain where to start digging into this beyond that.

Eric



--=-=-=
Content-Type: text/x-csrc
Content-Disposition: inline; filename=KernelTtyTest.c

/* gcc -o KernelTtyTest KernelTtyTest.c -Wall -O2 -lutil */
#define _GNU_SOURCE 1
#include <stdio.h>
#include <pty.h>
#include <unistd.h>
#include <sys/ioctl.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <signal.h>
#include <poll.h>
#include <setjmp.h>
#include <ctype.h>

#define POLL_TIMEOUT (10*1000)  /* in milliseconds */
#define LASTBUFSZ  10000
#define CMDBUFSZ 10000

#define SIGINT_LONGJMP 0
#define SIGINT_VAR 1
static void putstr(char *str, FILE *out)
{
	int c;
	for (c = *str++; c; c = *str++) {
		if (iscntrl(c)) {
			putc('\\', out);
			switch(c) {
			case '\n':  putc('n', out); break;
			case '\r':  putc('r', out); break;
			default: printf("%03o", c); break;
			}
		} else {
			putc(c, out);
		}
	}
}

static void print_lastbytes(char *lastbytes, size_t totalbytes, FILE *out)
{
	char *start = lastbytes;
	if (totalbytes < LASTBUFSZ)
		start = &lastbytes[LASTBUFSZ - totalbytes];
	fprintf(out, "lastbytes: '");
	putstr(start, out);
	fprintf(out, "'");
}
static void expect(int masterfd, char *str, size_t len)
{
	char lastbytes[LASTBUFSZ + 1];
	size_t totalbytes = 0;

	memset(lastbytes, sizeof(lastbytes), 0);

	for (;;) {
	  	char buf[1];
		ssize_t bytes;
		int ret;
		struct pollfd fds = {
			.fd = masterfd,
			.events = POLLIN | POLLERR | POLLHUP,
			.revents = 0,
		};
		ret = poll(&fds, 1, POLL_TIMEOUT);
		if (ret == 0) {
			fprintf(stderr, "Timeout while waiting for '");
			putstr(str, stderr);
			fprintf(stderr, "' ");
			print_lastbytes(lastbytes, totalbytes, stderr);
			fprintf(stderr,"\n");
			exit(5);
		}
		else if (ret < 0) {
			fprintf(stderr, "poll failed: %s\n", strerror(errno));
			exit(4);
		}
		bytes = read(masterfd, buf, 1);
		if (bytes == 1) {
			totalbytes++;
			memmove(lastbytes, lastbytes +1, LASTBUFSZ);
			lastbytes[LASTBUFSZ - 1] = buf[0];
			lastbytes[LASTBUFSZ] = '\0';
			if (memcmp(&lastbytes[LASTBUFSZ - len], str, len) == 0)
				return;
		}
		else if (bytes < 0) {
			fprintf(stderr, "read failed: %s\n",
				strerror(errno));
			print_lastbytes(lastbytes, totalbytes, stderr);
			fprintf(stderr,"\n");
			abort();
			exit(3);
		}
	}
}

static void resync(int masterfd)
{
	static unsigned count;
	char cookie[100];
	char cmd[1000];
	char reply[1000];
	ssize_t written, bytes;

	snprintf(cookie, sizeof(cookie), "_%u_", ++count);
	bytes = snprintf(cmd, sizeof(cmd), "echo %s\n", cookie);
	written = 0;
	while (bytes) {
		ssize_t sent;
		sent = write(masterfd, cmd + written, bytes);
		if (sent >= 0) {
			written += sent;
			bytes -= sent;
		} else if ((errno != EAGAIN) && (errno != EINTR)) {
			fprintf(stderr, "Write to child failed: %s\n", strerror(errno));
			exit(2);  
		}
	}
	snprintf(reply, sizeof(reply), "\n%s", cookie);
	expect(masterfd, reply, strlen(reply));
}

#if SIGINT_VAR
static volatile sig_atomic_t saw_sigint;
#endif

static void process_cmd(void)
{
	char cmdbuf[CMDBUFSZ];
	size_t cmdlen;
	char buf[1];

	cmdlen = 0;
	for (;;) {
		ssize_t bytes;
#if SIGINT_VAR
		if (saw_sigint) {
			saw_sigint = 0;
			printf("^C\n");
			fflush(stdout);
			return;
		}
#endif
		bytes = read(STDIN_FILENO, buf, 1);
		if (bytes == 1) {
			cmdbuf[cmdlen] = '\0';
			putchar(buf[0]);
			fflush(stdout);
			if (buf[0] == '\n') {
				if (cmdlen == 0) {
					printf("> ");
					fflush(stdout);
				}
				else if (memcmp("echo ", cmdbuf, 5) == 0) {
				  	printf("%s\n", cmdbuf + 5);
					fflush(stdout);
					return;
				} else {
					fprintf(stdout, "unknown cmd: '");
					putstr(cmdbuf, stdout);
					printf("'\n");
					fflush(stdout);
					return;
				}
			}
			cmdlen += 1;
			if (cmdlen >= CMDBUFSZ) {
				fprintf(stderr, "command too long!\n");
				_exit(3);
			}
			cmdbuf[cmdlen - 1] = buf[0];
			cmdbuf[cmdlen] = '\0';
		}
		if (bytes == 0) {
			/* EOF terminate */
			_exit(0);
		}
		if (bytes < 0) {
			fprintf(stderr, "%s read failed: %s\n",
				__func__, strerror(errno));
			_exit(4);
		}
	}
}

#if SIGINT_LONGJMP
static sigjmp_buf sigint_dest;
#endif
static void sigint_handler(int signum)
{
#if SIGINT_LONGJMP
	siglongjmp(sigint_dest, 1);
#endif
#if SIGINT_VAR
	saw_sigint = 1;
#endif

}

static void process_cmds(void)
{
	sigset_t signal_set;
#if 1
	struct sigaction act;
#endif

	sigemptyset( &signal_set);
	sigaddset( &signal_set, SIGINT);

	/* Block sigint until I reinstall the handler */
	sigprocmask(SIG_BLOCK, &signal_set, NULL);
#if 0
	signal(SIGINT, sigint_handler);
#else
	memset(&act, sizeof(act), 0);
	act.sa_handler = &sigint_handler;
	act.sa_flags = SA_NODEFER;
	sigaction(SIGINT, &act, NULL);
#endif
#if SIGINT_LONGJMP
	if (sigsetjmp(sigint_dest, 1)) {
		printf("^C\n");
		fflush(stdout);
	}
#endif
	sigprocmask(SIG_UNBLOCK, &signal_set, NULL);
	for (;;)
		process_cmd();
}

int main(int argc, char *argv[], char *environ[])
{
	pid_t pid;
	int masterfd;
	struct winsize terminal_size;
	int i;

	terminal_size.ws_row = 80;
	terminal_size.ws_col = 25;
	terminal_size.ws_xpixel = 0;
	terminal_size.ws_ypixel = 0;

	pid = forkpty(&masterfd, NULL, NULL, &terminal_size);
	if (pid == 0) { /* child */
		char *args[] = {  "/bin/sh",  NULL };
		char *env[] = { NULL };
#if 0
		execve("/bin/bash", args, env);
#endif
#if 1
		process_cmds();
#endif
		_exit(1);
	}
	resync(masterfd);
#if 1
	for (i = 0; i < 10; i++) {
		usleep(100);
		kill(pid, SIGINT);
	}
#endif
#if 0
	usleep(1000);
#endif
	resync(masterfd);
	return 0;
}

--=-=-=




>
> Eric
>
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
> IP: [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
> PGD 0 
> Thread overran stack, or stack corrupted
> Oops: 0002 [#1] SMP 
> last sysfs file: /sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq
> CPU 0 
> Modules linked in: veth macvlan nfsd lockd nfs_acl auth_rpcgss exportfs sco bridge stp bnep l2cap bluetooth sunrpc ipv6 cpufreq_ondemand acpi_cpufreq freq_table ext4 jbd2 crc16 dm_mirror dm_region_hash dm_log dm_multipath dm_mod uinput kvm_intel kvm fuse xt_multiport iptable_nat ip_tables nf_nat x_tables nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 tun 8021q ixgbe iTCO_wdt iTCO_vendor_support i2c_i801 mdio e1000e pcspkr serio_raw sg ata_generic pata_acpi ata_piix libata sd_mod scsi_mod ext3 jbd mbcache uhci_hcd ohci_hcd ehci_hcd i915 drm i2c_algo_bit i2c_core video output [last unloaded: microcode]
> Pid: 0, comm: swapper Not tainted 2.6.31-rc6-172084.2009.AroraKernelBeta.fc11.x86_64 #1 PDSBM
> RIP: 0010:[<ffffffff8105be8b>]  [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
> RSP: 0018:ffff8800017cfe30  EFLAGS: 00010006
> RAX: ffff8800365b2928 RBX: ffffffff81744e40 RCX: 0000000000000000
> RDX: ffff8800017cfe50 RSI: 0000000000000246 RDI: 0000000000000000
> RBP: ffff8800017cfea0 R08: ffff8800017d8c00 R09: ffff8800017cff08
> R10: 6b40fbe55cdd76b4 R11: ffffffff81744e40 R12: ffff8800017cfe50
> R13: 0000000000000000 R14: ffffffff81746658 R15: ffffffff81746258
> FS:  0000000000000000(0000) GS:ffff8800017cc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
> CR2: 0000000000000008 CR3: 0000000001001000 CR4: 00000000000026f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process swapper (pid: 0, threadinfo ffffffff815b2000, task ffffffff8153f020)
> Stack:
>  6b40fbe55cdd76b4 ffff880000000100 ffffffff81746a58 ffffffff81745e58
> <0> ffff8800365b2928 ffff8800abcd6128 ffffffff81023733 6b40fbe55cdd76b4
> <0> 6b40fbe55cdd76b4 0000000000000008 0000000000000001 0000000000000100
> Call Trace:
>  <IRQ> 
>  [<ffffffff81023733>] ? lapic_next_event+0x23/0x3b
>  [<ffffffff81056893>] __do_softirq+0xe7/0x1cd
>  [<ffffffff8100cfac>] call_softirq+0x1c/0x28
>  [<ffffffff8100e8e5>] do_softirq+0x51/0xae
>  [<ffffffff810564c6>] irq_exit+0x52/0xa3
>  [<ffffffff81024080>] smp_apic_timer_interrupt+0x94/0xb9
>  [<ffffffff8100c973>] apic_timer_interrupt+0x13/0x20
>  <EOI> 
>  [<ffffffff810143f2>] ? mwait_idle+0x9b/0xcc
>  [<ffffffff81014394>] ? mwait_idle+0x3d/0xcc
>  [<ffffffff8100ad4f>] ? enter_idle+0x33/0x49
>  [<ffffffff8100ae15>] ? cpu_idle+0xb0/0xf3
>  [<ffffffff81391c75>] ? rest_init+0x79/0x8f
>  [<ffffffff815bbf8e>] ? start_kernel+0x3dc/0x3fd
>  [<ffffffff815bb2b4>] ? x86_64_start_reservations+0xbb/0xd6
>  [<ffffffff815bb3d4>] ? x86_64_start_kernel+0x105/0x128
> Code: 49 8b 54 1d 20 48 89 55 b8 4c 89 22 49 89 44 1d 20 49 89 44 1d 18 eb 7e 4c 8b 68 18 48 8b 78 20 48 89 43 08 48 8b 08 48 8b 50 08 <48> 89 51 08 48 89 0a 48 c7 40 08 00 02 20 00 48 c7 00 00 00 00 
> RIP  [<ffffffff8105be8b>] run_timer_softirq+0x13a/0x1fa
>  RSP <ffff8800017cfe30>
> CR2: 0000000000000008

--=-=-=--
