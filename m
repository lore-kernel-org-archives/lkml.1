Return-Path: <linux-kernel-owner+w=401wt.eu-S1762604AbXIZU6f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762604AbXIZU6f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 16:58:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbXIZU61
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 16:58:27 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:48415 "EHLO
	outbound7-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759962AbXIZU6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 16:58:25 -0400
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 139.95.251.8;Service: EHS
X-Server-Uuid: C391E81C-6590-4A2B-9214-A04D45AF4E95
Date: Wed, 26 Sep 2007 14:58:25 -0600
From: "Jordan Crouse" <jordan.crouse@amd.com>
To: "H. Peter Anvin" <hpa@zytor.com>
cc: "Joerg Pommnitz" <pommnitz@yahoo.com>, cebbert@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: Regression in 2.6.23-pre Was: Problems with 2.6.23-rc6 on
 AMD Geode LX800
Message-ID: <20070926205825.GA14877@cosmic.amd.com>
References: <637040.99806.qm@web51411.mail.re2.yahoo.com>
 <46FA6858.5060908@zytor.com> <20070926154106.GG7582@cosmic.amd.com>
 <46FAAFA7.50106@zytor.com>
MIME-Version: 1.0
In-Reply-To: <46FAAFA7.50106@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 26 Sep 2007 20:58:05.0615 (UTC)
 FILETIME=[EF53C3F0:01C8007F]
X-WSS-ID: 6AE418541DW327462-01-01
Content-Type: multipart/mixed;
 boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

On 26/09/07 12:14 -0700, H. Peter Anvin wrote:
> Please try the following debug patch to let us know what is going on.
> 
> 	-hpa

> diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
> index 1a2e62d..a0ccf29 100644
> --- a/arch/i386/boot/memory.c
> +++ b/arch/i386/boot/memory.c
> @@ -33,6 +33,12 @@ static int detect_memory_e820(void)
>  		      "=m" (*desc)
>  		    : "D" (desc), "a" (0xe820));
>  
> +		printf("e820: err %d id 0x%08x next %u %08x:%08x %u\n",
> +		       err, id, next,
> +		       (unsigned int)desc->addr,
> +		       (unsigned int)desc->size,
> +		       desc->type);
> +
>  		if (err || id != SMAP)
>  			break;

Okay, we have clarity.   Here is the output

e820: err 0 id 0x534d4150 next 15476 00000000:0009fc00 1
e820: err 0 id 0x534d4150 next 15496 0009fc00:00000400 2
e820: err 0 id 0x534d4150 next 15516 000e0000:00020000 2
e820: err 0 id 0x0e7b0000 next 11536 00100000:0e6b0000 1

In the last entry,  id is obviously wrong (it should be 'SMAP' or
0x534d4150).  This is the BIOS bug.

Here's the reason why this bothers us now.  In the old assembly code,
if the returned ID wasn't equal to 'SMAP', we jumped straight to the e801
code.  In the new code in memory.c, if id != SMAP, we break out of the
int15 loop, and return boot_params.e820_entries, which in our case is
3.  detect_memory() considers this to be successful, and no attempt to
parse e801 is made.

So thats where the problem is - in the old code with the buggy BIOS, we
punted to reading the e801 information, and that was enough to keep us 
going.   In the new code, we allow a partial table to be used, and we
blow up.

Attached is a patch to fix this - it returns -1 on error, and only sets
boot_params.e820_entries to be non-zero if we have something useful
in it.  This punts the detection to the e801 code, which then is
then successful.

This fixes the problem with the DB800, and so it probably should
with the other Geode platforms affected by this.

Many thanks to hpa for the guiding hand.

Jordan

-- 
Jordan Crouse
Systems Software Development Engineer 
Advanced Micro Devices, Inc.

--HcAYCG3uE/tztfnV
Content-Type: text/plain;
 charset=us-ascii
Content-Disposition: inline;
 filename=memory-bail-on-error.patch
Content-Transfer-Encoding: 7bit

[i386]: Return an error if the e820 detection goes bad

From: Jordan Crouse <jordan.crouse@amd.com>

Change the e820 code to always return an error if something
bad happens while reading the e820 map.  This matches the
old code behavior, and allows brain-dead e820 implementations
to still work.

Signed-off-by: Jordan Crouse <jordan.crouse@amd.com>
---

 arch/i386/boot/memory.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/i386/boot/memory.c b/arch/i386/boot/memory.c
index 1a2e62d..4c7f0f6 100644
--- a/arch/i386/boot/memory.c
+++ b/arch/i386/boot/memory.c
@@ -22,7 +22,7 @@ static int detect_memory_e820(void)
 {
 	u32 next = 0;
 	u32 size, id;
-	u8 err;
+	u8 err, count = 0;
 	struct e820entry *desc = boot_params.e820_map;
 
 	do {
@@ -34,13 +34,14 @@ static int detect_memory_e820(void)
 		    : "D" (desc), "a" (0xe820));
 
 		if (err || id != SMAP)
-			break;
+			return -1;
 
-		boot_params.e820_entries++;
+		count++;
 		desc++;
 	} while (next && boot_params.e820_entries < E820MAX);
 
-	return boot_params.e820_entries;
+	boot_params.e820_entries = count;
+	return count;
 }
 
 static int detect_memory_e801(void)

--HcAYCG3uE/tztfnV--


