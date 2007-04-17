Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbXDQMmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbXDQMmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 08:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753927AbXDQMmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 08:42:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:2021 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753897AbXDQMmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 08:42:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=I9R5tckmH6h6uvNI8xU4QkTFPj3z1GVGe9Bu57Ox8o9JfGfE9nYdogq7kODojOR3ZRCH+rrzR1EjMB4linCB0PtEBDr4vObrJASuNTBJ7z9q8TUF4ks/7i8CL6qL6XEsR7VsRXTzEpiFYHsJCAD1cM2XQS3qwqyrfKXTXmteavk=
Message-ID: <4624C0A9.2040804@gmail.com>
Date: Tue, 17 Apr 2007 21:42:17 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: maneesh@in.ibm.com
CC: gregkh@suse.de, dmitry.torokhov@gmail.com, cornelia.huck@de.ibm.com,
       oneukum@suse.de, rpurdie@rpsys.net, James.Bottomley@SteelEye.com,
       stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET #master] sysfs: make sysfs disconnect immediately on
 deletion, take 2
References: <11760923261269-git-send-email-htejun@gmail.com> <20070416082212.GC31874@in.ibm.com>
In-Reply-To: <20070416082212.GC31874@in.ibm.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Maneesh Soni wrote:
> I started looking at these patches and parallely also did some testing on a 
> 8 CPU system. I am using the patches from Greg's tree at
> http://www.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git/
> 
> I ran following loops parallelly
> 
> # while true; do insmod drivers/net/dummy.ko; sleep 1;rmmod dummy; done
> # while true; do find /sys/class/net/dummy0 | xargs cat; sleep 1; done
> # while true; do umount /sys; sleep 1; mount -t sysfs none /sys; done
> # while true; do find /sys | xargs cat > /dev/null; sleep 1; done
> 
> and got the following oops
> 
> Unable to handle kernel NULL pointer dereference at 000000000000004c RIP:
>  [<ffffffff802935b4>] simple_unlink+0x14/0x5c
> PGD 21955c067 PUD 215b52067 PMD 0
> Oops: 0002 [1] SMP
> CPU 6
> Modules linked in: dummy i2c_dev i2c_core
> Pid: 21161, comm: rmmod Not tainted 2.6.21-rc6 #3
> RIP: 0010:[<ffffffff802935b4>]  [<ffffffff802935b4>] simple_unlink+0x14/0x5c
> RSP: 0000:ffff81021b38be28  EFLAGS: 00010292

Okay, got it.  The problem here is the race between dcache shrinking
triggered by umount and sysfs deletion.  It seems to be introduced
when dentries for attr and symlink nodes are made unpinned.
sd->s_entry clearing is done without synchronization and
sysfs_drop_entry() ends up deleting already deleted dentry
(dentry->inode is NULL).

sd->s_entry is broken in other ways too.  Consider the following
scenario.

   thread shrinking dcache		thread looking up sysfs entry
  --------------------------------------------------------------------
1. sysfs dentry for A is chosen as
   victim.
2. prune_one_dentry() drops the dentry
   and calls dentry_iput().
3. dentry_iput() unlinks d_alias and
   releases spin locks.
					4. looks up dentry for A which
					   is not in dcache.
					5. new dentry is created and
					   sysfs_lookup() is invoked,
					   which instantiates the dentry
					   and set sd->s_dentry to it.
6. sysfs_d_iput() is called.
   BUG_ON(sd->s_dentry != dentry)
   triggers and sd->s_dentry is
   cleared.  You're screwed.

I think it can be fixed by making deletion more like conventional
filesystem.  Brewing a patch...

-- 
tejun
