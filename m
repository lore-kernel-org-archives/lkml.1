Return-Path: <linux-kernel-owner+w=401wt.eu-S1759010AbYB1S3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759010AbYB1S3f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 13:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbYB1S32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 13:29:28 -0500
Received: from smtp-104-thursday.nerim.net ([62.4.16.104]:64562 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751509AbYB1S31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 13:29:27 -0500
Date: Thu, 28 Feb 2008 19:29:24 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Marcin Slusarz <marcin.slusarz@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Mauro Carvalho Chehab <mchehab@infradead.org>, i2c@lm-sensors.org,
       video4linux-list@redhat.com
Subject: Re: [PATCH] video: limit stack usage of ir-kbd-i2c.c
Message-ID: <20080228192924.1ab1dc66@hyperion.delvare>
In-Reply-To: <20080227102309.GA6698@joi>
References: <20080225205055.GA27455@joi>
	<20080226133222.7af260b2@hyperion.delvare>
	<20080226210307.GA6085@joi>
	<20080226232320.2df756d6@hyperion.delvare>
	<20080227102309.GA6698@joi>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008 11:23:26 +0100, Marcin Slusarz wrote:
> On Tue, Feb 26, 2008 at 11:23:20PM +0100, Jean Delvare wrote:
> > * You can move the handling of some ioctls to dedicated functions, just
> > like I did in i2c-dev:
> > http://lists.lm-sensors.org/pipermail/i2c/2008-February/003010.html
> > However there is a risk that gcc will inline these functions (that's
> > what happened to me...) Not sure how to prevent gcc from inlining.
>
> There's "noinline" attribute in linux/compiler.h (compiler-gcc.h actually)
> for these situations.

I didn't know about noinline, thanks for the tip. It works as expected,
however in the case of i2cdev_ioctl I'm not sure if it's worth it.
Without it, I have:

0x02ae i2cdev_ioctl [i2c-dev]:                          192

With noinline, I have:

0x02ac i2cdev_ioctl_smbus [i2c-dev]:                    112
0x05bc i2cdev_ioctl_rdrw [i2c-dev]:                     112
0x087e i2cdev_ioctl [i2c-dev]:                          32

32 + 112 = 144, 192 - 144 = only 48 bytes saved on the stack, at the
price of some performance loss. OTOH this makes the binary slightly
smaller (not sure why), which is always nice:

add/remove: 2/0 grow/shrink: 0/1 up/down: 1121/-1182 (-61)
function                                     old     new   delta
i2cdev_ioctl_rdrw                              -     696    +696
i2cdev_ioctl_smbus                             -     425    +425
i2cdev_ioctl                                1482     300   -1182

-- 
Jean Delvare
