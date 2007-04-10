Return-Path: <linux-kernel-owner+w=401wt.eu-S1031405AbXDJScX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031405AbXDJScX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:32:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031409AbXDJScW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:32:22 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:47776 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031405AbXDJScV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:32:21 -0400
Date: Tue, 10 Apr 2007 20:20:35 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Oleg Nesterov <oleg@tv-sign.ru>
cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Davide Libenzi <davidel@xmailserver.org>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Robin Holt <holt@sgi.com>, Roland McGrath <roland@redhat.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [RFC, PATCH 1/3] introduce SYS_CLONE_MASK
In-Reply-To: <Pine.LNX.4.61.0704101743550.21664@yvahk01.tjqt.qr>
Message-ID: <Pine.LNX.4.61.0704102017580.32056@yvahk01.tjqt.qr>
References: <20070408155337.GA126@tv-sign.ru> <m1lkh23kkb.fsf@ebiederm.dsl.xmission.com>
 <20070408165750.GA149@tv-sign.ru> <Pine.LNX.4.61.0704101743550.21664@yvahk01.tjqt.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 10 2007 17:47, Jan Engelhardt wrote:
>On Apr 8 2007 20:57, Oleg Nesterov wrote:
>>
>>Anyway, re-parenting to swapper breaks pstree, it doesn't show kernel
>>threads. And if ->parent == /sbin/init, we can't remove us from ->children
>>(unless we forbid sub-thread-of-init exec). So the only safe change is
>>set ->exit_state = -1.
>
>Then we have to fix pstree and all that. (In fact, I'm
>trying to patch `ps f` to DTRT ;p)

Done that and the result is that `ps afwx` now looks like:

  PID TTY      STAT   TIME COMMAND
 2722 ?        S      0:00 [lockd]
 2721 ?        S<     0:00 [rpciod/0]
  749 ?        S<     0:00 [ata_aux]
  748 ?        S<     0:00 [ata/0]
  496 ?        S<     0:00 [xfssyncd]
  495 ?        S<     0:00 [xfsbufd]
  484 ?        S<     0:00 [xfsdatad/0]
  482 ?        S<     0:00 [xfslogd/0]
  427 ?        S<     0:00 [scsi_eh_0]
  204 ?        S<     0:00 [kpsmoused]
  110 ?        S<     0:00 [aio/0]
  109 ?        S<     0:00 [kswapd0]
  108 ?        S      0:00 [pdflush]
  107 ?        S      0:00 [pdflush]
   85 ?        S<     0:00 [kseriod]
   21 ?        S<     0:00 [kacpid]
   20 ?        S<     0:00 [kblockd/0]
    5 ?        S<     0:00 [kthread]
    4 ?        S<     0:00 [khelper]
    3 ?        S<     0:00 [events/0]
    2 ?        SN     0:00 [ksoftirqd/0]
    1 ?        Ss     0:02 init [3]  
  537 ?        S<s    0:02  \_ /sbin/udevd --daemon
 1600 ?        Ss     0:00  \_ /usr/bin/dbus-daemon --system
 1692 ?        Ss     0:00  \_ /sbin/acpid
 1923 ?        Ss     0:00  \_ /sbin/resmgrd
 1985 ?        Ss     0:00  \_ /usr/sbin/polkitd
 2014 ?        Ss     0:02  \_ /usr/sbin/hald --daemon=yes
 2022 ?        S      0:00  |   \_ hald-runner
 2051 ?        S      0:00  |       \_ hald-addon-keyboard: listening on /d
 2061 ?        S      0:00  |       \_ hald-addon-keyboard: listening on /d
 2085 ?        S      0:00  |       \_ hald-addon-acpi: listening on acpid 
 2086 ?        S      0:00  |       \_ hald-addon-storage: polling /dev/hdc
 2601 ?        Ss     0:00  \_ /sbin/syslog-ng
 2602 ?        Ss     0:00  \_ /usr/sbin/sshd -o PidFile=/var/run/sshd.init
 2607 ?        Ss     0:00  \_ /sbin/klogd -c 1 -x -x
 2617 ?        Ss     0:00  \_ /usr/sbin/gpm -m /dev/input/mice -t ps2
 2623 ?        Ss     0:00  \_ /sbin/portmap
 2634 ?        Ss     0:00  \_ login -- root     
 2688 tty1     Ss+    0:00  |   \_ -bash
 2635 ?        Ss     0:00  \_ login -- jengelh     
 2733 tty2     Ss     0:00  |   \_ -bash
 2850 tty2     R+     0:00  |       \_ ./ps afwx
 2636 tty3     Ss+    0:00  \_ /sbin/mingetty tty3
 2637 tty4     Ss+    0:00  \_ /sbin/mingetty tty4
 2638 tty5     Ss+    0:00  \_ /sbin/mingetty tty5
 2651 tty6     Ss+    0:00  \_ /sbin/mingetty tty6

Except for the unsorted bunch before process 1, this looks good, and
of course it only took a single line change.

Index: procps-3.2.7/ps/display.c
===================================================================
--- procps-3.2.7.orig/ps/display.c
+++ procps-3.2.7/ps/display.c
@@ -482,7 +482,7 @@ static void show_tree(const int self, co
       more_children = 0;
     else
       if(processes[i+1]->ppid != self_pid) more_children = 0;
-    if(self_pid==1 && ADOPTED(processes[i]) && forest_type!='u')
+    if(ADOPTED(processes[i]) && forest_type!='u')
       show_tree(i++, n, level,   more_children);
     else
       show_tree(i++, n, level+1, more_children);


Jan
-- 
