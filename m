Return-Path: <linux-kernel-owner+w=401wt.eu-S1754968AbXIZFVZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968AbXIZFVZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 01:21:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751375AbXIZFVR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 01:21:17 -0400
Received: from smtpoutm.mac.com ([17.148.16.77]:59225 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750961AbXIZFVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 01:21:16 -0400
In-Reply-To: <20070926005551.GS6800@stusta.de>
References: <46F83474.5040503@davidnewall.com> <20070924230008.GA3160@vino.hallyn.com> <46F8BC8A.7080006@davidnewall.com> <20070925114947.GA9721@vino.hallyn.com> <46F91417.9050600@davidnewall.com> <46F924E3.50205@davidnewall.com> <20070925163040.12a3c2f8@the-village.bc.nu> <46F92AAB.1060903@davidnewall.com> <20070925164806.4cadc6a5@the-village.bc.nu> <46F99EDE.70905@davidnewall.com> <20070926005551.GS6800@stusta.de>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <F23AFB4D-E989-4F06-A256-4D12D852DFA2@mac.com>
Cc: David Newall <david@davidnewall.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       "Serge E. Hallyn" <serge@hallyn.com>, Bill Davidsen <davidsen@tmr.com>,
       Philipp Marek <philipp@marek.priv.at>, 7eggert@gmx.de,
       majkls <majkls@prepere.com>, bunk@fs.tum.de,
       linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Chroot bug
Date: Wed, 26 Sep 2007 01:21:08 -0400
To: Adrian Bunk <bunk@kernel.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sep 25, 2007, at 20:55:51, Adrian Bunk wrote:
> On Wed, Sep 26, 2007 at 09:20:54AM +0930, David Newall wrote:
>> Good call.  Though I suppose, since it's used 24x7 to aid security  
>> on countless production servers, that security dwarfs testing.   
>> Still, debugging, yes that's valid.
>
> Incompetent people implementing security solutions are a real problem.
>
>> I don't suppose it makes and difference; whatever the purpose, a  
>> chroot that doesn't change the root is buggy.
>
> It does change the root.
>
> But it does not limit what the root user can do after the root was  
> changed.

This is required for most distro installers to work:

*Procedure to install files*
chroot /target
mount -t proc proc /proc
mount -t sysfs sysfs /sys
mount -t tmpfs tmpfs /dev
udevd --daemon
udevtrigger
udevsettle
mount /dev/cdrom0 /media/cdrom0
*Load more kernel modules*
*Procedure to configure newly-installed system*
*Do other highly-privileged operations*
*Configure networking and submit installation report*
*Reboot*

David, please do tell myself and Adrian how "locking down" chroot()  
the way you want will avoid letting root break out through any of the  
above ways?

Hell, after you chroot one could probably just run:
   mount --bind /minimal_root /minimal_root
   cd /minimal_root
   mkdir old
   pivot_root . old
   cd /old
   mkdir old_minimal_root
   pivot_root . old_minimal_root
   umount /old_minimal_root
   rmdir /old_minimal_root
Now, like magic, the entire system is once more accessible.

Alternatively you could:
   mount -t proc proc /proc
   cat /proc/1/mounts
   mount -t $ROOTFS_FROM_PROC $ROOTDEV_FROM_PROC /

Either way root can trivially break out of any chroot using  
FUNDAMENTAL PRIMITIVES that he/she always has access to.  If you want  
to take those away you have to use SELinux or capabilities, in which  
case you could just take away the CAP_SYS_CHROOT capability in the  
first place!

Cheers,
Kyle Moffett

