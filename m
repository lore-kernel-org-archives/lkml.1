Return-Path: <linux-kernel-owner+w=401wt.eu-S1755836AbZKMABb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836AbZKMABb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 19:01:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755660AbZKMABZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 19:01:25 -0500
Received: from mail.gmx.net ([213.165.64.20]:51290 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754789AbZKMABZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 19:01:25 -0500
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19ypXBbTPJyuWWjpaVSCn8GQ/r4dQ5uoFXNLW3ph3
	R9A0uHpo93S/X6
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: V4L/DVB (12859): go7007: semaphore -> mutex conversion
Date: Fri, 13 Nov 2009 01:01:27 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-6.slh.1-sidux-amd64; KDE/4.3.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       Hans Verkuil <hverkuil@xs4all.nl>, Greg KH <gregkh@suse.de>,
       Ross Cohen <rcohen@snurgle.org>
References: <200909211659.n8LGxVXZ000601@hera.kernel.org>
In-Reply-To: <200909211659.n8LGxVXZ000601@hera.kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911130101.29882.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Friday 13 November 2009, Linux Kernel Mailing List wrote:
> Gitweb:     http://git.kernel.org/linus/fd9a40da1db372833e1af6397d2f6c94ceff3dad
> Commit:     fd9a40da1db372833e1af6397d2f6c94ceff3dad
> Parent:     028d4c989ab9e839471739332d185f8f158b0043
> Author:     Mauro Carvalho Chehab <mchehab@redhat.com>
> AuthorDate: Tue Sep 15 11:07:59 2009 -0300
> Committer:  Mauro Carvalho Chehab <mchehab@redhat.com>
> CommitDate: Sat Sep 19 00:13:37 2009 -0300
> 
>     V4L/DVB (12859): go7007: semaphore -> mutex conversion
>     
>     Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
>     Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

As already noticed by Pascal Terjan <pterjan@gmail.com>
	http://lkml.indiana.edu/hypermail/linux/kernel/0909.3/00062.html
go7007 currently fails to build in 2.6.32-rc6-git5

  LD      drivers/staging/go7007/built-in.o                                                      
  CC [M]  drivers/staging/go7007/go7007-v4l2.o                                                   
  CC [M]  drivers/staging/go7007/go7007-driver.o                                                 
  CC [M]  drivers/staging/go7007/go7007-i2c.o                                                    
  CC [M]  drivers/staging/go7007/go7007-fw.o                                                     
  CC [M]  drivers/staging/go7007/snd-go7007.o                                                    
  CC [M]  drivers/staging/go7007/s2250-board.o                                                   
drivers/staging/go7007/s2250-board.c:24:26: error: s2250-loader.h: No such file or directory     
drivers/staging/go7007/s2250-board.c: In function 'read_reg_fp':                                 
drivers/staging/go7007/s2250-board.c:264: warning: passing argument 1 of 'down_interruptible' from incompatible pointer type                                                                      
drivers/staging/go7007/s2250-board.c:273: warning: passing argument 1 of 'up' from incompatible pointer type                                                                                      
drivers/staging/go7007/s2250-board.c: In function 's2250_init':                                  
drivers/staging/go7007/s2250-board.c:670: error: implicit declaration of function 's2250loader_init'                                                                                              
drivers/staging/go7007/s2250-board.c:676: error: implicit declaration of function 's2250loader_cleanup'                                                                                           
make[6]: *** [drivers/staging/go7007/s2250-board.o] Error 1                                      
make[5]: *** [drivers/staging/go7007] Error 2                                                    
make[4]: *** [drivers/staging] Error 2                                                           
make[3]: *** [drivers] Error 2        

>  drivers/staging/go7007/go7007-driver.c |   12 +++---
>  drivers/staging/go7007/go7007-i2c.c    |   12 +++---
>  drivers/staging/go7007/go7007-priv.h   |    6 +-
>  drivers/staging/go7007/go7007-usb.c    |   10 ++--
>  drivers/staging/go7007/go7007-v4l2.c   |   66 ++++++++++++++++----------------
>  drivers/staging/go7007/go7007.txt      |    4 +-
>  drivers/staging/go7007/s2250-board.c   |   18 ++++-----
>  drivers/staging/go7007/s2250-loader.c  |    8 ++--
>  drivers/staging/go7007/snd-go7007.c    |    2 +-
>  9 files changed, 68 insertions(+), 70 deletions(-)

[...]
> diff --git a/drivers/staging/go7007/s2250-board.c b/drivers/staging/go7007/s2250-board.c
> index b398db4..f35f077 100644
> --- a/drivers/staging/go7007/s2250-board.c
> +++ b/drivers/staging/go7007/s2250-board.c
> @@ -21,12 +21,10 @@
>  #include <linux/i2c.h>
>  #include <linux/videodev2.h>
>  #include <media/v4l2-common.h>
> +#include "s2250-loader.h"

s2250-loader.h is neither available in 
	git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
nor
	git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
although it seems to have been included in Hans' initial pull request 
	http://www.mail-archive.com/linux-media@vger.kernel.org/msg09506.html

>  #include "go7007-priv.h"
>  #include "wis-i2c.h"
>  
> -extern int s2250loader_init(void);
> -extern void s2250loader_cleanup(void);
> -
>  #define TLV320_ADDRESS      0x34
>  #define VPX322_ADDR_ANALOGCONTROL1	0x02
>  #define VPX322_ADDR_BRIGHTNESS0		0x0127
[...]

This is a regression since 2.6.31.

Regards
	Stefan Lippers-Hollmann
