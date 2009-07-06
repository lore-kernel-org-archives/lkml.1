Return-Path: <linux-kernel-owner+w=401wt.eu-S1755653AbZGFOQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653AbZGFOQc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 10:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754031AbZGFOQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 10:16:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:51692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbZGFOQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 10:16:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: mmap syscall problem
Date: Mon, 6 Jul 2009 16:16:11 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
References: <4A4DFB77.1080700@petalogix.com> <20090706121455.GA16908@linux-sh.org> <4A51F3F3.6040501@petalogix.com>
In-Reply-To: <4A51F3F3.6040501@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061616.12220.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19T9sstvn5SpBZn7Kleq7KLF9I8uoygHYoecKO
 R1c2nZ18cn7Gy8FEgWDm/pn/9Klw+1NOh31M1Mdyo7L4+Ongn0
 8v9SRhHYWFCoUixsQ7gUA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, Michal Simek wrote:
> 
> > Not necessarily, even on platforms that manage aliases in hardware
> > mappings that violate the aliasing constraints can still result in
> > undefined behaviour, this really depends more on your cache controller
> > and MMU than anything else. I notice that microblaze sets SHMLBA to
> > PAGE_SIZE, you may want to see if this test still breaks after bumping it
> > up to something like PAGE_SIZE * 4.
> >   
> Yes, test still break - behavior is the same. I don't have accurate
> information about MMU unit
> but I will ask a question about. We are able to turn off cache
> controller directly in HW.

There may still be a problem with data being queued in some write
buffers that don't get flushed before reading back from another
address.

What happens in a simple user space program that mmaps the same
page to two addresses? Something like

#include <sys/mman.h>
#include <fcntl.h>
int main(void)
{
	int fd = open("existing-4k-file", O_RDWR);
	char *p1 = mmap(0, 4096, PROT_READ | PROT_WRITE,
				MAP_SHARED, fd, 0);
	char *p2 = mmap(p1 + 4096, 4096, PROT_READ | PROT_WRITE,
				MAP_SHARED | MAP_FIXED, fd, 0);

	*p1 = 0xaa; *p2 = 0x55;

	return *p1; /* returns 0xaa if broken, 0x55 if correct */
}

	Arnd <><
