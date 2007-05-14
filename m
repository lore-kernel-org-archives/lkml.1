Return-Path: <linux-kernel-owner+w=401wt.eu-S1756709AbXENS5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709AbXENS5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 14:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754471AbXENS5h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 14:57:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXENS5h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 14:57:37 -0400
Date: Mon, 14 May 2007 14:57:34 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: tracking down disk spinups.
Message-ID: <20070514185734.GM27604@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I was curious why my firewall box never spins down its disk.
Given it rarely writes stuff to logs, it's odd that it always
seems to have something to write out.
killing syslogd, and enabling /proc/sys/vm/block_dump
gets me a periodic spew in /proc/kmsg like..

<7>[2695397.990000] kjournald(366): WRITE block 243056 on dm-0
<7>[2695397.990000] kjournald(366): WRITE block 243064 on dm-0
<7>[2695397.990000] kjournald(366): WRITE block 243072 on dm-0
<7>[2695397.990000] kjournald(366): WRITE block 243080 on dm-0

How do I map those blocks back to files ?
I tried mapping these from blocks->inodes->names using debugfs
but that doesn't get me very far..

debugfs:  icheck 243056
Block   Inode number
243056  <block not found>



Given the dirtying process name is kinda useless, I wondered if I'd get
something more useful if I used ext2 instead of ext3, when I found
this oddness..

(14:49:52:root@firewall:~)# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)
(14:49:56:root@firewall:~)# mount /dev/mapper/VolGroup00-LogVol00 / -t ext2 -o remount,rw
(14:50:37:root@firewall:~)# mount
/dev/mapper/VolGroup00-LogVol00 on / type ext3 (rw)

Why did the kernel ignore what I told it to do ?
I'm sure it thinks it knows better than me for a reason, but
I'd like to know what it is.

	Dave

-- 
http://www.codemonkey.org.uk
