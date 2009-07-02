Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbZGBXhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbZGBXhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 19:37:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZGBXhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 19:37:23 -0400
Received: from mail.samba.org ([66.70.73.150]:45977 "EHLO lists.samba.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752684AbZGBXhX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 19:37:23 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <19021.17576.808138.476600@samba.org>
Date: Fri, 3 Jul 2009 09:37:12 +1000
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Theodore Tso <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Rusty Russell <rusty@rustcorp.com.au>, Pavel Machek <pavel@ucw.cz>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, john.lanza@linux.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>, corbet@lwn.net
Subject: Re: CONFIG_VFAT_FS_DUALNAMES regression
In-Reply-To: <alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
References: <19013.8005.541836.436991@samba.org>
	<20090630063102.GB1351@ucw.cz>
	<200907012019.53932.rusty@rustcorp.com.au>
	<20090701122558.3a7c80d3@lxorguk.ukuu.org.uk>
	<20090701140503.GA21185@mit.edu>
	<alpine.LSU.2.00.0907030056210.17183@fbirervta.pbzchgretzou.qr>
X-Mailer: VM 8.0.12 under 22.2.1 (x86_64-pc-linux-gnu)
Reply-To: tridge@samba.org
From: tridge@samba.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

 > Yes, here is your precedent case. The DUALNAMES patch breaks the
 > operation on my Fujifilm Finepix A210 digital camera.

interesting, but I think you may have been trapped by differences in
the VFAT mounting options between the two examples.

Would you mind retesting again, but looking carefully at the VFAT
mount options. I don't think what you've described can happen without
differing VFAT options between your two examples.

I'll try and expain:

 > Here, dscf4159.jpg is a preexisting file created by the camera itself 
 > (and subsequently, Finepix's FAT code) as a result of taking a picture. 
 > Then I just copied that file with two different kernels in succession.

ok, dscf4159.jpg may or may not be a 8.3 name depending on the
"shortname=" mount option. As this is a digital camera, I suspect that
it was created as an 8.3 name, although you'd have to confirm that by
inspecting the disk image. If you made a copy of the image available
to me somewhere (please don't email it unless it compresses to a small
size!) then I can tell you what the camera did in this case.

 >  * 2.6.31-rc1 + dualnames=n
 >    # mount /dev/sdc1 /mnt
 >    # cd /mnt/dcim/100_fuji/; cp dscf4159.jpg dscf3000.jpg
 >    # umount /mnt

Now we would need to know what shortname= option was used here. If the
shortname= option was such that the lowercase name dscf3000.jpg was
considered as 8.3, then the patch I have posted would have had zero
effect on what was stored on disk. If it was not considered a short
name (because you have the shortname= option set to not allow
lowercase short names) then it would have been created as a long
name. As you said the file became invisible then I suspect that for
this test you had the shortname= option set to treat lowercase names
as not being allowed in 8.3.

 >  * 2.6.29.5 w/o patch
 >    # same procedure
 >    cp dscf4159.jpg dscf3001.jpg
 > 
 > End result is that picture ID 3000 is not selectable in the camera's
 > built-in menu (OSD), as if the file did not exist. 3001 was shown,
 > however.

ok, if 3001 was shown, then in this case you must have had different
VFAT mount options. I don't know if this is because the different base
kernel has different defaults, or if perhaps you used a different
system that had different mounting options.

If you had used the same mount options as the previous test, then the
3001 name could not have shown up I think. It would have shown up as
something like DSCF3~01.JPG. 

So I think all you've found is two things we already knew:

 1) VFAT mount options make for an easy trap to fall into :-)

 2) as the config text in the patch explains:

        "That means that long filenames created with this option
	 disabled will not be accessible at all to operating systems
	 that do not understand the VFAT extensions."

If you mount with the right shortname= options then I think you'll
find that your above test will work (for some value of work!)

But please do keep testing. We want to eliminate the possibility that
you have found a real example of where the patch causes a problem with
some embedded systems.

Cheers, Tridge
