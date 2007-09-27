Return-Path: <linux-kernel-owner+w=401wt.eu-S1760566AbXI0X1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760566AbXI0X1i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 19:27:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXI0X1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 19:27:31 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34063 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833AbXI0X1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 19:27:31 -0400
Message-ID: <46FC3C5A.2010902@zytor.com>
Date: Thu, 27 Sep 2007 16:27:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jordan Crouse <jordan.crouse@amd.com>
CC: jkeating@redhat.com, Joerg Pommnitz <pommnitz@yahoo.com>,
       Chuck Ebbert <cebbert@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andi Kleen <ak@suse.de>
Subject: Re: More E820 brokenness
References: <46FC2BFD.6070200@zytor.com> <20070927223336.GB4755@cosmic.amd.com> <46FC32FE.9070302@zytor.com> <20070927231552.GC4755@cosmic.amd.com>
In-Reply-To: <20070927231552.GC4755@cosmic.amd.com>
X-Enigmail-Version: 0.95.0
Content-Type: multipart/mixed;
 boundary="------------030000080705080603020004"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030000080705080603020004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Jordan Crouse wrote:
> On 27/09/07 15:47 -0700, H. Peter Anvin wrote:
>> Jordan Crouse wrote:
>>> Breaks on the Geode - original behavior.
>>>
>>> I think that having boot_prams.e820_entries != 0 makes the kernel
>>> assume the e820 data is correct.
>>>
>> Okay, now I'm utterly baffled how 2.6.22 ever worked on this Geode,
>> because this, to the best of my reading, mimics the 2.6.22 behavior
>> exactly.  DID IT REALLY, and/or did you make any kind of configuration
>> changes?
> 
> I copied in a 2.6.22 kernel to see that it really did work, and it did.
> But here's the crazy part - I did a dmesg, and it looks like it
> *is* using e820 data, and it looks complete (I see the entire map - 
> including the ACPI and reserved blocks way up high).
> 
> So apparently it was the 2.6.22 code that was buggy, but reading it,
> I don't immediately see how. 
> 

Oh bugger, looks like this one might be genuinely my fault after all.
The ID check in the new code is buggy.

Can you please test this revised patch out (against current -git)?

	-hpa




--------------030000080705080603020004
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index bccaa1c..84939b7 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -34,17 +34,7 @@ static int detect_memory_e820(void)
 		      "=m" (*desc)
 		    : "D" (desc), "a" (0xe820));
 
-		/* Some BIOSes stop returning SMAP in the middle of
-		   the search loop.  We don't know exactly how the BIOS
-		   screwed up the map at that point, we might have a
-		   partial map, the full map, or complete garbage, so
-		   just return failure. */
-		if (id != SMAP) {
-			count = 0;
-			break;
-		}
-
-		if (err)
+		if (id != SMAP || err)
 			break;
 
 		count++;

--------------030000080705080603020004--
