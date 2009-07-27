Return-Path: <linux-kernel-owner+w=401wt.eu-S1753633AbZG0SSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbZG0SSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 14:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752240AbZG0SSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 14:18:38 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:60542 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522AbZG0SSh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 14:18:37 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu
Subject: Re: generic uaccess.h
Date: Mon, 27 Jul 2009 20:18:33 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.31-3-generic; KDE/4.2.96; x86_64; ; )
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>,
       John Williams <john.williams@petalogix.com>
References: <4A69651E.7040305@monstr.eu> <200907241120.22483.arnd@arndb.de> <4A6D76DB.1050902@monstr.eu>
In-Reply-To: <4A6D76DB.1050902@monstr.eu>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?iso-8859-1?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60?=
 =?iso-8859-1?q?Y=2Ea=5E3zb?=)
 =?iso-8859-1?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5C?=
 =?iso-8859-1?q?wg=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907272018.33516.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19D1OKxvhhb5jQBZSbmpOe9C6hGtjThNRfyxsH
 gY0uQL3AmqLWQq5C8tWOFafMi5Y0kfpHa9FIMZ3UN47/+c5gNt
 P+J2wGGDfiXLdOe4aRriU3SFVIkElEd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 July 2009, Michal Simek wrote:
> I am getting any short write error. It is caused with adding access_ok macro.
> It is weird.

Your implementation of access_ok() is minimal, but should be ok
in theory. Note that even on nommu, it might make sense
to check for kernel addresses here and implement get_fs/set_fs,
e.g.

int access_ok(int type, unsigned long addr, size_t len)
{
	/* check wraparound */
	if (addr + len < addr)
		return 0;

	if (addr < memory_start || addr + len > memory_start)
		return 0;

	/* don't allow access to kernel memory */
	if (get_fs() == USER_DS) {
		if (is_kernel(addr) || is_kernel(addr + len))
			return 0;
	}

	return 1;
}

> I have more important work in front of me - I take a look at it later.

ok. When you get to debug this, I guess the easiest way is to stick
some printk into your access_ok() function.

	Arnd <><
