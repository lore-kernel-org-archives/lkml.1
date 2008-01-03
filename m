Return-Path: <linux-kernel-owner+w=401wt.eu-S1756811AbYACN2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756811AbYACN2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 08:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbYACN2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 08:28:00 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:34063 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYACN17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 08:27:59 -0500
Date: Thu, 3 Jan 2008 14:27:57 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: devzero@web.de
cc: linux-kernel@vger.kernel.org
Subject: Re: serial console _after_ boot ? - was: Redirect kernel console
In-Reply-To: <83531397@web.de>
Message-ID: <Pine.LNX.4.64.0801031423070.26693@fbirervta.pbzchgretzou.qr>
References: <83531397@web.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 3 2008 13:43, devzero@web.de wrote:
>
>hi !
>
>i was wondering how to make kernel messages appear on /dev/ttyS0 without a reboot, i.e. kernelparam "console=ttyS0"

The solution is simple... the following piece of code is inside
opensuse-10.3/src/sysvinit-2.86-115.src.rpm#showconsole-1.08.tar.bz2#showconsole-1.08/blogd.c

    (void)ioctl(0, TIOCCONS, NULL);  /* Undo any current map if any */
    if (ioctl(pts, TIOCCONS, NULL) < 0)
        error("can not set console device to %s: %s\n", ptsname, strerror(errno));

so I suppose that's it. Write up a new program that calls the ioctl
on a tty, and you should be done. IOW:

#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <fcntl.h>

int main(void)
{
	int fd = open("/dev/ttyS0", O_RDWR);
	ioctl(0, TIOCCONS, NULL);
	ioctl(fd, TIOCCONS, NULL);
}
