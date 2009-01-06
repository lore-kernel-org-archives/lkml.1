Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZAFFum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZAFFum (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 00:50:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751421AbZAFFuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 00:50:19 -0500
Received: from mx1.suse.de ([195.135.220.2]:57517 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751104AbZAFFuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 00:50:16 -0500
Date: Mon, 5 Jan 2009 21:48:58 -0800
From: Greg KH <gregkh@suse.de>
To: Robin Getz <rgetz@blackfin.uclinux.org>
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: debugfs & vfs file permission issue?
Message-ID: <20090106054858.GA9040@suse.de>
References: <200901052157.07306.rgetz@blackfin.uclinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901052157.07306.rgetz@blackfin.uclinux.org>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 05, 2009 at 09:57:07PM -0500, Robin Getz wrote:
> On 2.6.28-rc2, If I create a debugfs file with
> 
>     debugfs_create_x16("SPORT1_TX", 0200 , parent, 0xFFC00910);

Um, are you are passing in a pointer to a known memory location
properly?  Why would it be ok for the kernel to directly read that
location?

> Although the file shows up as write only (no read):
> 
> root:/> ls -l /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> --w-------    1 root     root            0 Jan  1  
> 2007 /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> 
> root:/> cat /sys/kernel/debug/blackfin/SPORT/SPORT1_TX
> 
> Still works - and causes the read to occur, which crashes :(

You're root, you can do anything :)


> System MMR Error
> .....
> 
> I can do the same to any file by hand too.
> 
> root:/> ls -l /sys/kernel/debug/blackfin/RTC/RTC_STAT
> -rw-------    1 root     root            0 Jan  1  
> 2007 /sys/kernel/debug/blackfin/RTC/RTC_STAT
> root:/> cat /sys/kernel/debug/blackfin/RTC/RTC_STAT
> 0xb81d3181
> root:/> chmod 0000 /sys/kernel/debug/blackfin/RTC/RTC_STAT
> root:/> ls -l /sys/kernel/debug/blackfin/RTC/RTC_STAT
> ----------    1 root     root            0 Jan  1  
> 2007 /sys/kernel/debug/blackfin/RTC/RTC_STAT
> root:/> cat /sys/kernel/debug/blackfin/RTC/RTC_STAT
> 0xb81d31a5
> 
> ?
> 
> From what I can tell from the call trace:
> 
> cat (userspace)
>   system_call (into kernel)
>     sys_read
>       vfs_read
>         simple_attr_read
>           debugfs_u16_get
>             crash
> 
> 
> I would think that vfs_read should fail....
> 
> ./fs/read_write.c:vfs_read()
> 
>         if (!(file->f_mode & FMODE_READ))
>                 return -EBADF; 

I think f_mode is the mode of the file descriptor, not the inode you are
looking at.  You told userspace to open the file in read mode, right?
So this is why it passes.

Hope this helps,

greg k-h
