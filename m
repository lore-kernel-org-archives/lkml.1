Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab0BCJZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 04:25:32 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:43832 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab0BCJZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 04:25:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=date:from:to
	:subject:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=b0w56A9LVDEsuDJ2jeT
	5H5nYHyD/vxOexsGUhhDDPPCHcSIakhgRRh99BWsue2LQ8jYchpF9R2voeFARKql
	ryznYP/R0q7jlNg1B1AkSs22CX9r1VIepsbRootEPletpTQ314OoBEdJxYq6Qghx
	iEPc7mPcW9GOZMIP9udGbvq4=
Date: Wed, 3 Feb 2010 03:24:52 -0600
From: Corey Wright <undefined@pobox.com>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       stable@kernel.org, linux-kernel@vger.kernel.org
Subject: regression in 2.6.27.45 with usb and suspend-to-disk
Message-Id: <20100203032452.4c215f9f.undefined@pobox.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Pobox-Relay-ID: FF139F5C-10A5-11DF-8702-6AF7ED7EF46B-06295150!a-pb-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.45 will only suspend-to-disk once without rebooting.  every attempt
to suspend-to-disk after the first attempt results in "pm_op():
usb_dev_freeze +0x0/0xa returns -16" and "PM: Device usb1 failed to freeze:
error -16".  reverting commit 4fbebe26d7a5eed6c1900bf2142b68af7df38462
(http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.27.y.git;a=commit;h=4fbebe26d7a5eed6c1900bf2142b68af7df38462)
fixes the problem.

this problem exhibits itself on both a x86-64 desktop and i386 netbook
(though the reverted commit was only tested on the x86-64 desktop).  the
affected computers are different architectures, different distributions
(debian lenny vs ubuntu hardy), and different kernel configs (but unchanged
since 2.6.27.23), so i am fairly certain this is a regression in 2.6.27.45
and not the result of an environment change.

i normally use the pm-hibernate command to suspend to disk, but to isolate
the problem i used the kernel interfaces directly (as demonstrated in the
transcript below).

i can provide any other information necessary (eg .config, dmesg, lsusb)
and i am willing to test patches.

transcript of problem:

root@computer:~# uname -a
Linux computer 2.6.27.45+1-k8 #1 SMP Wed Feb 3 07:06:38 UTC 2010 x86_64
GNU/Linux
root@computer:~# cat /sys/power/disk
[platform] test testproc shutdown reboot
root@computer:~# cat /sys/power/state
standby mem disk
root@computer:~# echo disk >/sys/power/state
<suspends to disk, powers off, and is manually powered back on>
root@computer:~# echo disk >/sys/power/state
bash: echo: write error: Device or resource busy
root@computer:~# tail /var/log/kern.log | grep -i pm
Feb  3 01:45:25 computer kernel: [  263.666343] PM: Syncing filesystems ...
done.
Feb  3 01:45:25 computer kernel: [  263.887504] PM: Shrinking memory...
done (4347 pages freed)
Feb  3 01:45:25 computer kernel: [  268.023515] PM: Freed 17388 kbytes in
4.11 seconds (4.23 MB/s)
Feb  3 01:45:25 computer kernel: [  268.061753] pm_op(): usb_dev_freeze
+0x0/0xa returns -16
Feb  3 01:45:25 computer kernel: [  268.061769] PM: Device usb1 failed to
freeze: error -16
<revert commit 4fbebe26d7a5eed6c1900bf2142b68af7df38462, rebuild kernel,
install, and reboot>
root@computer:~# uname -a
Linux computer 2.6.27.45+2-k8-revert-as1321 #1 SMP Wed Feb 3 07:56:46 UTC
2010 x86_64 GNU/Linux
root@computer:~# cat /sys/power/disk
[platform] test testproc shutdown reboot 
root@computer:~# cat /sys/power/state
standby mem disk
root@computer:~# echo disk >/sys/power/state
<suspends to disk, powers off, and is manually powered back on>
root@computer:~# echo disk >/sys/power/state
<suspends to disk, powers off, and is manually powered back on>

thanks for maintaining and contributing to the 2.6.27 stable kernel series!

corey
-- 
undefined@pobox.com
