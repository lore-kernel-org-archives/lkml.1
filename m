Return-Path: <linux-kernel-owner+w=401wt.eu-S1753511AbYACOjy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753511AbYACOjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 09:39:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbYACOjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 09:39:47 -0500
Received: from fmmailgate05.web.de ([217.72.192.243]:58181 "EHLO
	fmmailgate05.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894AbYACOjq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 09:39:46 -0500
Date: Thu, 03 Jan 2008 15:39:43 +0100
Message-Id: <83783877@web.de>
MIME-Version: 1.0
From: devzero@web.de
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
Organization: http://freemail.web.de/
X-Provags-Id: V01U2FsdGVkX19IkuNZsVISI+cmu/SMlxC/9UNec3Y14W89KHEeZO8X4EXVU
 hzEXoUni7kqtS5uFiCs84Zp2t8Km6Nbl4mDeTcnOeod3gJLSK0=
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fantastic, thanks!

unfortunately......

opensuse103:/home/roland/serialcons # ./mytioccons
ioctl: Device or resource busy

but, it`s not userspace:

opensuse103:/home/roland # lsof |egrep "console|ttyS0"
opensuse103:/home/roland #


in tty_io.c -> ticoccons() there is

        if (redirect) {
                spin_unlock(&redirect_lock);
                return -EBUSY;
        }


but i`m not deep enough into programming to understand this.

-------------------
mytioccons.c

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>
#include <libio.h>
#include <errno.h>
#include <stdio.h>

int main(void)
{
int fd = open("/dev/ttyS0", O_RDWR);
int errno;

ioctl(0, TIOCCONS, NULL);

if (ioctl(fd, TIOCCONS, NULL) < 0)
        printf("ioctl: %s\n", strerror(errno));
}
-------------------




> -----Ursprüngliche Nachricht-----
> Von: "Jan Engelhardt" <jengelh@computergmbh.de>
> Gesendet: 03.01.08 14:28:45
> An: devzero@web.de
> CC: linux-kernel@vger.kernel.org
> Betreff: Re: serial console _after_ boot ? - was: Redirect kernel console


> 
> 
> On Jan 3 2008 13:43, devzero@web.de wrote:
> >
> >hi !
> >
> >i was wondering how to make kernel messages appear on /dev/ttyS0 without a reboot, i.e. kernelparam "console=ttyS0"
> 
> The solution is simple... the following piece of code is inside
> opensuse-10.3/src/sysvinit-2.86-115.src.rpm#showconsole-1.08.tar.bz2#showconsole-1.08/blogd.c
> 
>     (void)ioctl(0, TIOCCONS, NULL);  /* Undo any current map if any */
>     if (ioctl(pts, TIOCCONS, NULL) < 0)
>         error("can not set console device to %s: %s\n", ptsname, strerror(errno));
> 
> so I suppose that's it. Write up a new program that calls the ioctl
> on a tty, and you should be done. IOW:
> 
> #include <sys/ioctl.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <fcntl.h>
> 
> int main(void)
> {
> 	int fd = open("/dev/ttyS0", O_RDWR);
> 	ioctl(0, TIOCCONS, NULL);
> 	ioctl(fd, TIOCCONS, NULL);
> }
> 


__________________________________________________________________________
Erweitern Sie FreeMail zu einem noch leistungsstärkeren E-Mail-Postfach!		
Mehr Infos unter http://produkte.web.de/club/?mc=021131

