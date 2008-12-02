Return-Path: <linux-kernel-owner+w=401wt.eu-S1752337AbYLBJH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbYLBJH3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 04:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYLBJGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 04:06:38 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:28444 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbYLBJGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 04:06:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=EqQfy7/08xmI8H4+cf+je04yupLqc4Lk6RByTm2E6S0e31U3ltP0lZ/BRp/TKi1Rxs
         uxVgfhbJcva6uYc6u/cZRLoxm68EDMR88gTUphNZSZDNuWt7xK7X0FvmdRjLOeRnp3mb
         Zo3muZEB5xmW2XwvdZW6vJKXzFdnPw6MVAo90=
Message-ID: <3da2c0120812020100u66a94f9bk3c0e8a705bb6347e@mail.gmail.com>
Date: Tue, 2 Dec 2008 14:30:14 +0530
From: "sudhir kumar" <imsudhirkumar@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: BUG: CGROUPS [2.6.28-rc6] Task migration does not clean reference to group
Cc: vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       skumar@linux.vnet.ibm.com, Peter <a.p.zijlstra@chello.nl>,
       "Paul Menage" <menage@google.com>, mingo@elte.hu
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
I see an interesting bug in the cgroups. I found that cat /proc/cgroups
does not decrease the num_cgroups field when a group is deleted. It looks
to me that somewhere we miss to delete the reference, which leads to a failure
to unmount the cgroups filesystem.
The steps to produce the bug are:

mkdir /cpu
mount -t cgroup -ocpu cgroup /cpu
cd cpu
mkdir group1;
cd group1;
/./while &              # an infinite loop
echo pid > tasks        # pid is of infinite task
cd ..                   # we are now in root group
echo pid > /tasks       # move the task to root group
rmdir group1;           # Succeeds even when I was inside this group
in another shell
cd ..
umount /cpu;    # this fails for me as below
[root@malik-laptop /]# umount cpu/
umount: cpu/: device is busy

And I see that cat /proc/cgroups shows me still num_cgroups as 2;

I checked it on two kernels.
[root@malik-laptop cpu]# uname -a
Linux malik-laptop.in.ibm.com 2.6.26 #1 SMP Tue Aug 12 16:39:18 IST
2008 i686 i686 i386 GNU/Linux

[root@e325b sudhir]# uname -a
Linux e325b.in.ibm.com 2.6.28-rc6 #1 SMP Mon Dec 1 15:53:09 IST 2008
i686 athlon i386 GNU/Linux

A look on /proc/cgroups
root@e325b sudhir]# cat /proc/cgroups
#subsys_name    hierarchy       num_cgroups     enabled
#cpuset  0       1       1
#debug   0       1       1
#ns      0       1       1
#cpu     8       2       1
#cpuacct 0       1       1
#freezer 0       1       1
#

Please let me know if further information is required or I am doing
something wrong ?

Thanks
Sudhir
