Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXIZTPS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXIZTPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:15:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756947AbXIZTPE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:15:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:37332 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875AbXIZTPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:15:01 -0400
Message-ID: <46FAAFA7.50106@zytor.com>
Date: Wed, 26 Sep 2007 12:14:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: Joerg Pommnitz <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on AMD
 Geode LX800
References: <637040.99806.qm@web51411.mail.re2.yahoo.com> <46FA6858.5060908@zytor.com> <20070926154106.GG7582@cosmic.amd.com>
In-Reply-To: <20070926154106.GG7582@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------080801070908030309070604"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080801070908030309070604
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jordan Crouse wrote:
> 
> Its the latter - max_pfn as read by find_max_pfn() in arch/i386/e820.c
> is being set to 9F (640k) in the broken case, this due to the
> the e820 map looking something like this:
> 
> Address   Size      Type
> 00000000  0009FC00  1
> 0009FC00  00000400  2
> 000E0000  00002000  2
> 
> (Yep, thats it - thats the list.  e820.nr_map is indeed 3). 
> 
> Long story short, bdata->node_low_pfn gets set to 9F, and When we 
> try to allocate the bootmem bitmap (at _pa_symbol(_text), which is 
> page 0x100), then the system gets appropriately angry.
> 
> As background, I'm using syslinux 3.36 as my loader here - I've used this
> exact same version for a very long time, so I don't blame it in the least.
> Something is getting confused in the early kernel, and whatever that
> something is, a still unknown change in a newer version of the BIOS
> fixed it.  The search goes on.
> 

Please try the following debug patch to let us know what is going on.

	-hpa

--------------080801070908030309070604
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index 1a2e62d..a0ccf29 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -33,6 +33,12 @@ static int detect_memory_e820(void)
 		      "=m" (*desc)
 		    : "D" (desc), "a" (0xe820));
 
+		printf("e820: err %d id 0x%08x next %u %08x:%08x %u\n",
+		       err, id, next,
+		       (unsigned int)desc->addr,
+		       (unsigned int)desc->size,
+		       desc->type);
+
 		if (err || id != SMAP)
 			break;
 

--------------080801070908030309070604--
