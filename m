Return-Path: <linux-kernel-owner+w=401wt.eu-S1754944AbYLBNHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944AbYLBNHh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 08:07:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753364AbYLBNH2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 08:07:28 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50579 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbYLBNH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 08:07:27 -0500
Message-ID: <49353322.6090802@cn.fujitsu.com>
Date: Tue, 02 Dec 2008 21:07:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: sudhir kumar <imsudhirkumar@gmail.com>
CC: linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
       bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, skumar@linux.vnet.ibm.com,
       Peter <a.p.zijlstra@chello.nl>, Paul Menage <menage@google.com>,
       mingo@elte.hu
Subject: Re: BUG: CGROUPS [2.6.28-rc6] Task migration does not clean reference
 to group
References: <3da2c0120812020100u66a94f9bk3c0e8a705bb6347e@mail.gmail.com>
In-Reply-To: <3da2c0120812020100u66a94f9bk3c0e8a705bb6347e@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sudhir kumar wrote:
> Hi,
> I see an interesting bug in the cgroups. I found that cat /proc/cgroups
> does not decrease the num_cgroups field when a group is deleted. It looks
> to me that somewhere we miss to delete the reference, which leads to a failure
> to unmount the cgroups filesystem.

Ah, it's not a bug. :)

> The steps to produce the bug are:
> 
> mkdir /cpu
> mount -t cgroup -ocpu cgroup /cpu
> cd cpu
> mkdir group1;
> cd group1;
> /./while &              # an infinite loop

Seems whenever we create a background job, we'll have a pin to the directory where
the job is created. So though rmdir() removed the directory, the dentry's refcnt
is still >0, so cgroup_diput() in which number_of_cgroups is decreased is not called.
This explains why 'num_cgroups' showed in /proc/cgroups is not 1, and why umount failed.

You can try:
# mount -t ext3 /dev/sda6 /mnt
# cd /mnt
# sleep 10000 &
# cd ..
# umount /mnt
umount: /mnt: device is busy

And umount is OK for the below example:
# mount -t ext3 /dev/sda6 /mnt
# sleep 10000 &
# umount /mnt

> echo pid > tasks        # pid is of infinite task
> cd ..                   # we are now in root group
> echo pid > /tasks       # move the task to root group
> rmdir group1;           # Succeeds even when I was inside this group
> in another shell
> cd ..
> umount /cpu;    # this fails for me as below
> [root@malik-laptop /]# umount cpu/
> umount: cpu/: device is busy
> 
> And I see that cat /proc/cgroups shows me still num_cgroups as 2;
> 
> I checked it on two kernels.
> [root@malik-laptop cpu]# uname -a
> Linux malik-laptop.in.ibm.com 2.6.26 #1 SMP Tue Aug 12 16:39:18 IST
> 2008 i686 i686 i386 GNU/Linux
> 
> [root@e325b sudhir]# uname -a
> Linux e325b.in.ibm.com 2.6.28-rc6 #1 SMP Mon Dec 1 15:53:09 IST 2008
> i686 athlon i386 GNU/Linux
> 
> A look on /proc/cgroups
> root@e325b sudhir]# cat /proc/cgroups
> #subsys_name    hierarchy       num_cgroups     enabled
> #cpuset  0       1       1
> #debug   0       1       1
> #ns      0       1       1
> #cpu     8       2       1
> #cpuacct 0       1       1
> #freezer 0       1       1
> #
> 
> Please let me know if further information is required or I am doing
> something wrong ?
> 
> Thanks
> Sudhir
