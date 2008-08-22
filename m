Return-Path: <linux-kernel-owner+w=401wt.eu-S1752848AbYHVPVb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbYHVPVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2008 11:21:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752214AbYHVPU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Aug 2008 11:20:59 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:59330 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751574AbYHVPU5 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2008 11:20:57 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH 00/10] AXFS: Advanced XIP filesystem
Date: Fri, 22 Aug 2008 17:19:06 +0200
User-Agent: KMail/1.9.9
Cc: Jared Hulbert <jaredeh@gmail.com>, Linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       =?iso-8859-15?q?J=F6rn_Engel?= <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
References: <48AD00C4.6060302@gmail.com> <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
In-Reply-To: <Pine.LNX.4.64.0808221650500.17105@vixen.sonytel.be>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>=?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808221719.07660.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19mR6Er45SuhWkszDFdcCXA0XRgGEK4lm8ER7J
 9fB5bkC+6Kw94mZEUJBLXFrIaG2Y26mqMH+OdJ6ARS0f8B3M8r
 JooyMariomVD4Fm0Exh8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008, Geert Uytterhoeven wrote:
> I gave AxFS a try on PS3 (ppc64, always use big-endian 64-bit for testing new
> code ;-).
> When mounting the image, I got the crash below:
> 
> | attempt to access beyond end of device
> | loop0: rw=0, want=4920, limit=4912
> | Unable to handle kernel paging request for data at address 0x00000028


Offset 0x28 is buffer_head->b_data, so it seems like sb_bread returns NULL,
which it does for out of range block numbers. I guess axfs_copy_block
should check for that condition, as it can happen on malicious file system
images.
I agree that this is likely to get caused by an endianess bug.
A good help for finding endianess bugs is to use __be64 like data types
everywhere and test with sparse -D__CHECK_ENDIAN__.

	Arnd 
