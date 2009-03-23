Return-Path: <linux-kernel-owner+w=401wt.eu-S1758408AbZCWIm2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758408AbZCWIm2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 04:42:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758235AbZCWIlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 04:41:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:57720 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758374AbZCWIlx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 04:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=ZjJ2TE0T1cJS9pmVt8+J9qc5Hl+ti0dbWyAtaQ8gn/lX+UfdRUMf41+PVM6W8lrM83
         oyCggaVnNsf3ka49TYaO1JaPnfs5AUehCxpPAU9rz4mEyDhIgn1vcUy803ypXfx7JjaJ
         MPOkkOLZSPqeOsBzppPQVhDHIlK5+DrvPTz3c=
Message-ID: <49C74B4D.2060003@gmail.com>
Date: Mon, 23 Mar 2009 10:41:49 +0200
From: roma1390 <roma1390@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090212)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: raid6 grow "hangs" on 2.6.27 with mounted FS
References: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com> <18887.6136.84328.602390@notabene.brown>
In-Reply-To: <18887.6136.84328.602390@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
 > On Saturday March 21, roma1390@gmail.com wrote:
 > I can almost reproduce this.
 > However when I run it, the "mdadm --grow" prints     mdadm: Need to 
backup 384K of critical section..
 > (as expected) and then hangs.
 >
 > If I interrupt it and proceed, then the umount hangs.
 >
 > Is this the case for you?

Yes, mdadm hangs by itself, If i start mdadm in background and wait some 
time for reconstrucion, umount still hangs. I didn't touch mdadm, and 
mdadm likes to stop...

 > The umount hangs because there is something important that mdadm needs
 > to do which it didn't do because it was interrupted.  During the
 > 'critical section', mdadm causes all writes to the start of the device
 > to be blocked.  The umount tries to write the filesystem superblock
 > and hangs.
 > You can test if this is the problem by running the command
 >
 >  cat /sys/block/md2/md/suspend_hi > /sys/block/md2/md/suspend_lo

First try was:

   mdadm --grow /dev/md2 --raid-devices=5 &
   sleep 3
   cat /sys/block/md2/md/suspend_hi
   # output: 768
   cat /sys/block/md2/md/suspend_lo
   # output: 0
   cat /sys/block/md2/md/suspend_hi > /sys/block/md2/md/suspend_lo
   sleep 20
   umount /dev/md2

And this works! mdadm unhangs, and umount doesn't block any more.

 > That should allow the 'umount' to complete.
 >
 > This will only happen on very small arrays that take less than a
 > couple of seconds for the reshape to complete.  I have a patch for
 > mdadm which makes it more robust in this situation.  It will be in
 > future releases.
 >
 > Does this explain what is happening to you?

Yes, thanks. May be if I retest this situation with same kernel and 
limited recovery bandwith, then may be i can't hit same problem again?

 > Thanks,
 > NeilBrown

Thanks.


