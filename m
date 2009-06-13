Return-Path: <linux-kernel-owner+w=401wt.eu-S1754838AbZFMVUE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838AbZFMVUE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 17:20:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752586AbZFMVT4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 17:19:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:58928 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZFMVTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 17:19:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] asm-generic: hard_irqs: handle NR_IRQS > 256 automatically
Date: Sat, 13 Jun 2009 23:18:18 +0200
User-Agent: KMail/1.11.90 (Linux/2.6.30-8-generic; KDE/4.2.85; x86_64; ; )
Cc: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
References: <1244903447-23579-1-git-send-email-vapier@gentoo.org> <1244903447-23579-2-git-send-email-vapier@gentoo.org> <4A33E892.6010704@zytor.com>
In-Reply-To: <4A33E892.6010704@zytor.com>
X-Face: I@=L^?./?$U,EK.)V[4*>`zSqm0>65YtkOe>TFD'!aw?7OVv#~5xd\s,[~w]-J!)|%=]>
 =?utf-8?q?+=0A=09=7EohchhkRGW=3F=7C6=5FqTmkd=5Ft=3FLZC=23Q-=60=2E=60Y=2Ea=5E?=
 =?utf-8?q?3zb?=)
 =?utf-8?q?+U-JVN=5DWT=25cw=23=5BYo0=267C=26bL12wWGlZi=0A=09=7EJ=3B=5Cwg?=
 =?utf-8?q?=3B3zRnz?=,J"CT_)=\H'1/{?SR7GDu?WIopm.HaBG=QYj"NZD_[zrM\Gip^U
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200906132318.19208.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19YYMUeaJjUKqTh+Xx9D3Tpy6S3pMZSqoW10UB
 PfMR45Lq0kQ9QsMWwRse0n/XAUzICCNC2J8/9pGHsanLijmM9H
 Aodehnr9WL88zo6Ng0o1j6kCprS4ezf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 June 2009, H. Peter Anvin wrote:
> Mike Frysinger wrote:
> > If we're going to automatically set HARDIRQ_BITS for the arch, might as
> > well be a little bit smart about it and set it to 9 automatically if
> > NR_IRQS is larger than 8 bits.
> > 
> 
> Why would the only possible values be 8 or 9?

All architectures that define this either set it to 8 or 9, I chose
8 because it is the more common constant, but I now realized that
we also have (in include/linux/hardirq.h, last touched by Steven):

#define MAX_HARDIRQ_BITS 10
#ifndef HARDIRQ_BITS
# define HARDIRQ_BITS   MAX_HARDIRQ_BITS
#endif
#if HARDIRQ_BITS > MAX_HARDIRQ_BITS
#error HARDIRQ_BITS too high!
#endif

Not sure why we even need to make this overridable from the architecture,
10 still seems like a reasonable default that should always work.

I'd suggest we either drop the definition for HARDIRQ_BITS from
asm-generic/hardirq.h, or we use

 #ifndef HARDIRQ_BITS
-#define HARDIRQ_BITS   8
+# if NR_IRQS > 255
+#  define HARDIRQ_BITS 9
+# elif NR_IRQS > 511
+#  define HARDIRQ_BITS 10
+# elif NR_IRQS > 1023
+#  warning too many interrupts for HARDIRQ_BITS
+# endif
 #endif

	Arnd <><
