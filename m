Return-Path: <linux-kernel-owner+w=401wt.eu-S1761386AbYCFJ6V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761386AbYCFJ6V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 04:58:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753948AbYCFJ6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 04:58:12 -0500
Received: from n21.bullet.mail.mud.yahoo.com ([68.142.200.112]:39534 "HELO
	n21.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753843AbYCFJ6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 04:58:11 -0500
X-Yahoo-Newman-Id: 916082.18187.bm@omp425.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=dLIFNqI42AU8Tlqd5i3PigoAhwLBl8ZqC6Dy9nRftsEl3Ibavg1rWH4J63V+DGZH7rukNFlPcfFKyHRfyAqr0ROub3GZC7apAvvq+xt2uU+8ZCyqAxGmVzhDGkpM+Lqj7H3u7h2DxQ+N8vBv3qQIKX6K0wKDzKPg0UA/fGupdkI=  ;
X-YMail-OSG: vrowjicVM1lOpxuLp8rSCiopoGGAqVbbl_IyqnUfjPG4VXxh4lYm2AQGhIGZ_XMURj7Xwjj9MQ--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Laurent Vivier <Laurent.Vivier@bull.net>
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of the disk image
Date: Thu, 6 Mar 2008 20:57:50 +1100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
In-Reply-To: <1204796612842-git-send-email-Laurent.Vivier@bull.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803062057.50181.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 06 March 2008 20:43, Laurent Vivier wrote:
> This patch allows to use loop device with partitionned disk image.
>
> Original behavior of loop is not modified.
>
> A new parameter is introduced to define how many partition we want to be
> able to manage per loop device. This parameter is "max_part".
>
> For instance, to manage 63 partitions / loop device, we will do:
> # modprobe max_part=63
> # ls -l /dev/loop?*
> brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
>
> And to attach a raw partitionned disk image, the original losetup is used:
>
> # losetup -f etch.img
> # ls -l /dev/loop?*
> brw-rw---- 1 root disk 7,   0 2008-03-05 14:55 /dev/loop0
> brw-rw---- 1 root disk 7,   1 2008-03-05 14:57 /dev/loop0p1
> brw-rw---- 1 root disk 7,   2 2008-03-05 14:57 /dev/loop0p2
> brw-rw---- 1 root disk 7,   5 2008-03-05 14:57 /dev/loop0p5
> brw-rw---- 1 root disk 7,  64 2008-03-05 14:55 /dev/loop1
> brw-rw---- 1 root disk 7, 128 2008-03-05 14:55 /dev/loop2
> brw-rw---- 1 root disk 7, 192 2008-03-05 14:55 /dev/loop3
> brw-rw---- 1 root disk 7, 256 2008-03-05 14:55 /dev/loop4
> brw-rw---- 1 root disk 7, 320 2008-03-05 14:55 /dev/loop5
> brw-rw---- 1 root disk 7, 384 2008-03-05 14:55 /dev/loop6
> brw-rw---- 1 root disk 7, 448 2008-03-05 14:55 /dev/loop7
> # mount /dev/loop0p1 /mnt
> # ls /mnt
> bench  cdrom  home        lib         mnt   root     srv  usr
> bin    dev    initrd      lost+found  opt   sbin     sys  var
> boot   etc    initrd.img  media       proc  selinux  tmp  vmlinuz
> # umount /mnt
> # losetup -d /dev/loop0
>
> Of course, the same behavior can be done using kpartx on a loop device,
> but modifying loop avoids to stack several layers of block device (loop +
> device mapper), this is a very light modification (40% of modifications
> are to manage the new parameter). Moreover all partition tables known
> by the kernel are managed (kpartx implements only a subset).

Do you think we do something similar for drivers/block/brd.c too? I'd
like to try to maintain parity between them where possible...

