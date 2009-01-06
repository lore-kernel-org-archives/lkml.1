Return-Path: <linux-kernel-owner+w=401wt.eu-S1752559AbZAFC5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752559AbZAFC5Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 21:57:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750890AbZAFC5Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 21:57:16 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:40617 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738AbZAFC5P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 21:57:15 -0500
X-IronPort-AV: E=Sophos;i="4.36,334,1228107600"; 
   d="scan'208";a="64807936"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Greg KH" <gregkh@suse.de>, viro@zeniv.linux.org.uk
Subject: debugfs & vfs file permission issue?
Date: Mon, 5 Jan 2009 21:57:07 -0500
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200901052157.07306.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 06 Jan 2009 02:56:56.0249 (UTC) FILETIME=[6F7F0A90:01C96FAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.6.28-rc2, If I create a debugfs file with

    debugfs_create_x16("SPORT1_TX", 0200 , parent, 0xFFC00910);

Although the file shows up as write only (no read):

root:/> ls -l /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
--w-------    1 root     root            0 Jan  1  
2007 /sys/kernel/debug/blackfin/SPORT/SPORT1_TX

root:/> cat /sys/kernel/debug/blackfin/SPORT/SPORT1_TX

Still works - and causes the read to occur, which crashes :(

System MMR Error
.....

I can do the same to any file by hand too.

root:/> ls -l /sys/kernel/debug/blackfin/RTC/RTC_STAT
-rw-------    1 root     root            0 Jan  1  
2007 /sys/kernel/debug/blackfin/RTC/RTC_STAT
root:/> cat /sys/kernel/debug/blackfin/RTC/RTC_STAT
0xb81d3181
root:/> chmod 0000 /sys/kernel/debug/blackfin/RTC/RTC_STAT
root:/> ls -l /sys/kernel/debug/blackfin/RTC/RTC_STAT
----------    1 root     root            0 Jan  1  
2007 /sys/kernel/debug/blackfin/RTC/RTC_STAT
root:/> cat /sys/kernel/debug/blackfin/RTC/RTC_STAT
0xb81d31a5

?

>From what I can tell from the call trace:

cat (userspace)
  system_call (into kernel)
    sys_read
      vfs_read
        simple_attr_read
          debugfs_u16_get
            crash


I would think that vfs_read should fail....

./fs/read_write.c:vfs_read()

        if (!(file->f_mode & FMODE_READ))
                return -EBADF; 

I don't understand while the inode that is created 

fs/debugfs/inode.c:debugfs_get_inode()

     inode->i_mode = mode; 

isn't setting the f_mode properly.

Any suggestions?

Thanks
