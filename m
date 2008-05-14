Return-Path: <linux-kernel-owner+w=401wt.eu-S1761989AbYENLAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761989AbYENLAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 07:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYENLAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 07:00:22 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64964 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754985AbYENLAU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 07:00:20 -0400
To: devzero@web.de
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel hangs in SMP + VMware environment.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <001e01c8b523$fd89d2d0$6400a8c0@bui.materna.com>
In-Reply-To: <001e01c8b523$fd89d2d0$6400a8c0@bui.materna.com>
Message-Id: <200805142000.EIC65187.FOFJVLQSOHOMFt@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.50 PL2]
X-Accept-Language: ja,en
Date: Wed, 14 May 2008 20:00:15 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Roland wrote:
> maybe related to http://bugzilla.kernel.org/show_bug.cgi?id=9834  ?
Thank you for URL.
My bug seems to be timer related.

> you say "recent" , so this does happen from 2.6.21 to 2.6.26rc2 ?
I don't know exact version, but I don't experience this problem
in earlier kernels (e.g. Fedora Core 5 which uses kernel 2.6.20).

> does that happen only on a dedicated vmware box, or on different ones?
> vmware-tools active? ->stop -> different ?
vmware-tools is not installed for my Fedora 8.

> could you provide some more information about your hardware/vmware 
> environment ?
> does that happen on esx or on hosted products (workstation, server, 
> player..) ?

Hardware: ThinkPad X60 (Intel Core 2 Duo, 2048MB RAM, No swap partition)
VMware host environment: CentOS 5.1 (x86_64)
VMware version: VMware Workstation 6.0.2 (x86_64)
VMware guest environment: many distro using recent kernels (all i386)

I don't have ESX server environment.



Today, I tried to reproduce this problem using 2.6.24.5-85.fc8 kernel and
I got 2 patterns.


http://I-love.SAKURA.ne.jp/tmp/hangup-3.png      (10kB)
http://I-love.SAKURA.ne.jp/tmp/messages-3.txt   (174kB)

hangup-3.png is the screenshot of hang up and messages-3.txt is the sysrq logs.
Funny thing is that "tar" process sleeps for minutes at blk_remove_plug()
(while "tar" finishes within a minute if 1 CPU).


http://I-love.SAKURA.ne.jp/tmp/dmesg-4.txt      (120kB)

dmesg-4.txt is a partial output of "dmesg".
Since rsyslog sometimes cannot save logs to /var/log/messages by some reason,
I tried to directly save from /proc/kmsg using "a.out",
but "a.out" couldn't save logs neither.
Funny thing is that "a.out" process sleeps for minutes at getnstimeofday().
The source code of "a.out" is

  #include <stdio.h>
  #include <unistd.h>
  #include <time.h>
  #include <sys/types.h>
  #include <sys/stat.h>
  #include <fcntl.h>
  #include <string.h>
  
  int main(int argc, char *argv[]) {
  	FILE *fp = fopen("/proc/sys/kernel/sysrq", "w");
  	if (!fp) return 1;
  	fprintf(fp, "1\n");
  	fclose(fp);
  	fp = fopen("/proc/sysrq-trigger", "w");
  	if (!fp) return 1;
  	if (fork() == 0) {
  		int fd_r = open("/proc/kmsg", O_RDONLY);
  		int fd_w = open("/root/messages", O_WRONLY | O_TRUNC | O_CREAT, 0600);
  		char buffer[4096];
  		char timebuf[80];
  		memset(timebuf, 0, sizeof(timebuf));
  		memset(buffer, 0, sizeof(buffer));
  		while (1) {
  			const int len = read(fd_r, buffer, sizeof(buffer));
  			static time_t prev = 0;
  			const time_t now = time(NULL);
  			if (now != prev) {
  				static int counter = 0;
  				prev = now;
  				snprintf(timebuf, sizeof(timebuf) - 1, "****************************** %d %lu ******************************\n", counter++, now);
  				write(fd_w, timebuf, strlen(timebuf));
  			}
  			write(fd_w, buffer, len);
  		}
  		_exit(0);
  	}
  	while (1) {
  		sleep(60);
  		fprintf(fp, "t\n");
  		fflush(fp);
  	}
  	return 0;
  }


Other patterns that hanged up are

(1) # time sync

(2) # top

(3) # dmesg > ~/log

Regards.
