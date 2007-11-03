Return-Path: <linux-kernel-owner+w=401wt.eu-S1761137AbXKCXld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761137AbXKCXld (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 19:41:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757239AbXKCXlZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 19:41:25 -0400
Received: from outbound04.telus.net ([199.185.220.223]:37989 "EHLO
	outbound04.telus.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179AbXKCXlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 19:41:25 -0400
X-Greylist: delayed 10305 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Nov 2007 19:41:25 EDT
Message-ID: <472CAEDC.5000607@telusplanet.net>
Date: Sat, 03 Nov 2007 11:24:44 -0600
From: Bob Gill <gillb4@telusplanet.net>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: High cpu load due to pdflush
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.  My computer is constipated.  The load average when idle never goes 
below 100%.  Top shows this:
top - 11:01:27 up 5 min,  2 users,  load average: 2.63, 1.73, 0.76
Tasks:  91 total,   2 running,  89 sleeping,   0 stopped,   0 zombie
Cpu(s): 13.5%us,  4.4%sy,  1.6%ni,  9.9%id, 70.2%wa,  0.3%hi,  0.2%si,  
0.0%st
Note that we are at 70% for the wait state, 9.9% idle.  Now when I run  
ps aux | grep pdflush | grep -v grep  ...I get:
root       144  0.0  0.0      0     0 ?        S    10:56   0:00 [pdflush]
root       145  0.0  0.0      0     0 ?        D    10:56   0:00 [pdflush]
the second pdflush is dirty (and won't write).  I haven't changed 
anything in /proc/sys/vm and am running the 2.6.24-rc1-git12 kernel on 
Ubuntu Gutsy.  The original Gutsy kernel worked fine.  The only way I 
can get around the problem is to go into a terminal and run:
 >while true
 >do
 >sync
 >sleep 10
 >done
...which will force writes and give me (from top)
top - 11:06:55 up 10 min,  3 users,  load average: 0.42, 1.23, 0.85
Tasks:  93 total,   2 running,  91 sleeping,   0 stopped,   0 zombie
Cpu(s):  3.0%us,  0.9%sy,  0.0%ni, 95.6%id,  0.3%wa,  0.3%hi,  0.0%si,  
0.0%st
(on the very same load as before and the load is still dropping).

The only real change I made to Ubuntu was in 
/etc/init.d/mountdevsubfs.sh where I uncommented:
# Magic to make /proc/bus/usb work
 #
 mkdir -p /dev/bus/usb/.usbfs
 domount usbfs "" /dev/bus/usb/.usbfs 
-obusmode=0700,devmode=0600,listmode=0644
 ln -s .usbfs/devices /dev/bus/usb/devices
 mount --rbind /dev/bus/usb /proc/bus/usb

...so that usb would work with a custom kernel...

Oh, and btw, my cpu is an Intel P4.
Also, I applied the following patch and build/ran a kernel (but it did 
not reduce the cpu load on my system):
 >/> -------------------------- fs/jbd/transaction.c 
-----------------------------/
 >/> index cceaf57..d38e0d5 100644/
 >/> @@ -55,7 +55,7 @@ get_transaction(journal_t *journal, transaction_t 
*transaction)/
 >/> spin_lock_init(&transaction->t_handle_lock);/
 >/> /
 >/> /* Set up the commit timer for the new transaction. *//
 >/> - journal->j_commit_timer.expires = 
round_jiffies(transaction->t_expires);/
 >/> + journal->j_commit_timer.expires = transaction->t_expires;/
 >/> add_timer(&journal->j_commit_timer);/
 >/> /
 >/> J_ASSERT(journal->j_running_transaction == NULL);

/Any ideas?  Please mail me if you need more information. 
Thanks in Advance,
Bob
