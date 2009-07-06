Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbZGFPF7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbZGFPF7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 11:05:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753815AbZGFPFv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 11:05:51 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64494 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZGFPFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 11:05:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: michal.simek@petalogix.com
Subject: Re: mmap syscall problem
Date: Mon, 6 Jul 2009 17:05:50 +0200
User-Agent: KMail/1.12.0 (Linux/2.6.30-9-generic; KDE/4.2.95; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>,
       John Williams <john.williams@petalogix.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Grant Likely <grant.likely@secretlab.ca>, subrata@linux.vnet.ibm.com
References: <4A4DFB77.1080700@petalogix.com> <200907061616.12220.arnd@arndb.de> <4A520DA6.2040107@petalogix.com>
In-Reply-To: <4A520DA6.2040107@petalogix.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200907061705.50308.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19fWuOnOVuiisby0pzstDqm273CBg/sg0kAPJO
 sWjfvdjUWxsWIhlsISN3tRa7/en1NhT2BpSvBtYPkex6KTTUou
 OGA0r8+mVIhqEbpLDXjTA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 06 July 2009, Michal Simek wrote:
> >       *p1 = 0xaa; *p2 = 0x55;
> >   
> I closed fd too.
>     close(fd);
> >       return *p1; /* returns 0xaa if broken, 0x55 if correct */
> > }

If you close the fd between the assignment and reading
from the pointer again, the test case becomes invalid because of
timing. Closing the fd before the '*p1 = 0xaa' should be fine,
but unnecessary.

I also realized that you might need to mark the pointers
as 'volatile' so that the compiler has to do the operations
in order.

> >   
> # ls -la existing-4k-file
> -rw-rw-r--    1 monstr   monstr       4096 Jul  6  2009 existing-4k-file
> 
> # ./test-arnd
> # echo $?
> 85

Ok, so inside a single task, this does not happen.

> # dd if=existing-4k-file of=/dev/console count=1 2>/dev/null
> U#
> 
> in file is first char U (0x55) which is IMO correct.

Right, though that was not part of the test, I'd expect this in
the file even if the return value was broken.

	Arnd <><
