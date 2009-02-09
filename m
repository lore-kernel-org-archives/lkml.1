Return-Path: <linux-kernel-owner+w=401wt.eu-S1755030AbZBILTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030AbZBILTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 06:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754713AbZBILTX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 06:19:23 -0500
Received: from wine.ocn.ne.jp ([122.1.235.145]:55472 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754445AbZBILTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 06:19:20 -0500
To: frederik.deweerdt@xprog.eu, rjw@sisk.pl
Cc: linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       akataria@vmware.com, dhecht@vmware.com
Subject: Re: [Bug #12409] NULL pointer dereference at get_stats()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <KTnguC9mFUC.A.VNB.TJRdJB@chimera>
	<cX2gZ6Cy9nC.A.N0B.pJRdJB@chimera>
	<20090121161828.GA2739@gambetta>
	<200902071133.AJJ09378.MOHLFFtOSOVQFJ@I-love.SAKURA.ne.jp>
In-Reply-To: <200902071133.AJJ09378.MOHLFFtOSOVQFJ@I-love.SAKURA.ne.jp>
Message-Id: <200902092019.CHE32301.JLFVFMtQSOOFHO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Mon, 9 Feb 2009 20:19:16 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12409
> Subject		: NULL pointer dereference at get_stats()
> Submitter	: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
> Date		: 2008-12-30 12:53 (21 days old)
> References	: http://marc.info/?l=linux-kernel&m=123064167008695&w=4
> Handled-By	: Frederik Deweerdt <frederik.deweerdt@xprog.eu>

I made custom initramfs and tested on native environment and KVM and VMware.
This problem happened only in VMware.

Alok and Daniel (cc: added), can you reproduce this problem?

Problem description:

  Compiling 2.6.28.4 using config at http://I-love.SAKURA.ne.jp/tmp/config-2.6.28-bug
  and booting with "nolapic" option on x86 machine with 2 CPUs, NULL pointer
  dereference happens at get_stats() because for_each_possible_cpu() reaches
  CPU 1 while "nolapic" option should prevent for_each_possible_cpu() from
  reaching CPU 1.

  Compiling 2.6.28.4 using config at http://I-love.SAKURA.ne.jp/tmp/config-2.6.28-nobug
  (all options in "Power management and ACPI options" section disabled)
  solves this problem.

  Also, this problem seems to be VMware specific.
  I couldn't reproduce this problem on native environment and KVM.

Native environment (no problem):

  CentOS 5.2 (x86_64) and Ubuntu 8.04 (i386) on ThinkPad X60

KVM environment (no problem):

  kvm -kernel /boot/vmlinuz-2.6.28.4 -initrd /boot/init -net none -hda /var/tmp/image.img -vnc xx.xx.xx.xx:0 --append "ro nolapic" -smp 2
  on Ubuntu 8.04 (i386) on ThinkPad X60

VMware environment (problematic):

  Debian Sarge (i386) / CentOS 5.2 (i386) on VMware workstation 6.5.1 (x86_64)
  on CentOS 5.2 (x86_64) on ThinkPad X60

Problematic kernel versions:

  2.6.27.x and 2.6.28.x .

Regards.

----- Custom initramfs -----
/*
  gcc -Wall -O3 -static -o init init.c
  echo init | cpio -o -H newc | gzip -9 > /boot/init
 */
#include <sys/mount.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
	FILE *fp;
	char buffer[1024];
	memset(buffer, 0, sizeof(buffer));
	mkdir("/proc", 0755);
	mount("none", "/proc", "proc", 0, NULL);
	fp = fopen("/proc/cpuinfo", "r");
	while (fgets(buffer, sizeof(buffer) - 1, fp))
		if (strstr(buffer, "processor"))
			printf("%s", buffer);
	fclose(fp);
	fp = fopen("/proc/cmdline", "r");
	fgets(buffer, sizeof(buffer) - 1, fp);
	fclose(fp);
	printf("%s", buffer);
	fflush(stdout);
	if (mkdir("/sys", 0755) || mount("/sys/", "/sys/", "sysfs", 0, NULL)) {
		printf("mount failed\n");
		while (1)
			sleep(1);
	}
	fp = fopen("/sys/class/net/lo/statistics/rx_packets", "r");
	if (!fp) {
		printf("open failed\n");
		while (1)
			sleep(1);
	}
	while (fgets(buffer, sizeof(buffer) - 1, fp))
		;
	fclose(fp);
	printf("done\n");
	while (1)
		sleep(1);
	return 0;
}
