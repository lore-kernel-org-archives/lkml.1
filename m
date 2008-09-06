Return-Path: <linux-kernel-owner+w=401wt.eu-S1753817AbYIFWJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817AbYIFWJx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 18:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752600AbYIFWJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 18:09:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53407 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbYIFWJn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 18:09:43 -0400
Message-Id: <200809062208.m86M8hJM016685@terminus.zytor.com>
MIME-Version: 1.0
content-class: 
From: "H. Peter Anvin" <hpa@zytor.com>
Subject: RE: [PATCH] Ghost EDD devices in /sys again
Date: Sat, 6 Sep 2008 15:08:59 -0700
Importance: normal
X-Priority: 3
To: Andrey Borzenkov <arvidjaar@newmail.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think this is closer to what we really want; after all, memory being written is the "first principles" test that applies here.

-- 
Sent from my mobile phone (pardon any lack of formatting)


-----Original Message-----
From: Andrey Borzenkov <arvidjaar@newmail.ru>
Sent: Saturday, September 06, 2008 10:46
To: H. Peter Anvin <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>; Rafael J. Wysocki <rjw@sisk.pl>; Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Ghost EDD devices in /sys again

On Saturday 06 September 2008, H. Peter Anvin wrote:
> 
> Andrey Borzenkov wrote:
> > 
> > Was it really that simple?
> > 
> > Subject: [PATCH] Fix ghost devices under /sys/firmware/edd
> > From: Andrey Borzenkov <arvidjaar@mail.ru>
> > 
> > Some BIOSes do not always set CF on error before return from int13.
> > The patch adds additional check for status being zero (AH == 0).
> > 
> 
> Do you have any evidence that there aren't any BIOSes which leave AH != 
> 0 on legitimate success?  If so, you have turned a nuisance bug into 
> something that could cause install failures.
> 

Hmm ... if install depends on having valid MBR, it will break right
now as well, because it will have duplicated signatures. So at least
something like following is needed.

diff --git a/arch/x86/boot/edd.c b/arch/x86/boot/edd.c
index d93cbc6..4c20d31 100644
--- a/arch/x86/boot/edd.c
+++ b/arch/x86/boot/edd.c
@@ -58,6 +58,7 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
        if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
                return -1;

+       memset(mbrbuf_ptr, 0, sector_size);
        if (read_mbr(devno, mbrbuf_ptr))
                return -1;


