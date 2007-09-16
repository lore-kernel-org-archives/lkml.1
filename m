Return-Path: <linux-kernel-owner+w=401wt.eu-S1753459AbXIPQKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459AbXIPQKd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 12:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbXIPQKZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 12:10:25 -0400
Received: from highlandsun.propagation.net ([66.221.212.168]:2311 "EHLO
	highlandsun.propagation.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751303AbXIPQKY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 12:10:24 -0400
Message-ID: <46ED54EF.3040209@symas.com>
Date: Sun, 16 Sep 2007 09:08:15 -0700
From: Howard Chu <hyc@symas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; rv:1.9a8pre) Gecko/2007082216 SeaMonkey/2.0a1pre
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: MTRR initialization
References: <46EAB7DA.10507@symas.com> <86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
In-Reply-To: <86802c440709141012w1e85e4caue0d2c7f849dba1cb@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------070307040808030904010802"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070307040808030904010802
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Yinghai Lu wrote:
> On 9/14/07, Howard Chu <hyc@symas.com> wrote:
>> Hi, was wondering if anyone else has been tripped up by this... I've got 4GB of
>> RAM in my Asus A8V Deluxe and memory hole mapping enabled in the BIOS. By
>> default, my system boots up with these MTRR settings:
>>
>> reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
>> reg01: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
>> reg02: base=0xc0000000 (3072MB), size=1024MB: uncachable, count=1
>> reg03: base=0xc0000000 (3072MB), size= 256MB: write-combining, count=1
> 
> BIOS should have another setup option about MTRR (continous?)
> then you could get
> 
>> reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
>> reg01: base=0x100000000 (2048MB), size=1024MB: write-back, count=1
> reg02: base=0x100000000 (4096MB), size=1024MB: write-back, count=1
> ===> if you have rev E...instead of rev F.

Thanks for the reply. Unfortunately this BIOS doesn't seem to have any other options related to the 
MTRRs. I guess I'll just live with this hack.
-- 
   -- Howard Chu
   Chief Architect, Symas Corp.  http://www.symas.com
   Director, Highland Sun        http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP     http://www.openldap.org/project/

--------------070307040808030904010802
Content-Type: text/plain;
 name="dif.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dif.txt"

--- generic.c.O	2007-08-30 23:21:01.000000000 -0700
+++ generic.c	2007-09-16 09:09:34.000000000 -0700
@@ -78,6 +78,8 @@
 			base, base + step - 1, mtrr_attrib_to_str(*types));
 }
 
+static int set_mtrr_var_ranges(unsigned int index, struct mtrr_var_range *vr);
+
 /*  Grab all of the MTRR state for this CPU into *state  */
 void get_mtrr_state(void)
 {
@@ -105,6 +107,21 @@
 	mtrr_state.def_type = (lo & 0xff);
 	mtrr_state.enabled = (lo & 0xc00) >> 10;
 
+	/* Check for initial 4GB range, it should only be 3GB */
+	if (!mtrr_state.var_ranges[0].base_hi && !(mtrr_state.var_ranges[0].base_lo & 0xffffff00) &&
+		!(mtrr_state.var_ranges[0].mask_lo & 0x80000000)) {
+		/* split initial 4GB range into 2GB and 1GB */
+		for (i = num_var_ranges-1; i>0; i--)
+			mtrr_state.var_ranges[i] = mtrr_state.var_ranges[i-1];
+		mtrr_state.var_ranges[0].mask_lo |= 0x80000000;
+		mtrr_state.var_ranges[1].base_hi = 0;
+		mtrr_state.var_ranges[1].base_lo = 0x80000000 | MTRR_TYPE_WRBACK ;
+		mtrr_state.var_ranges[1].mask_hi = mtrr_state.var_ranges[2].mask_hi;
+		mtrr_state.var_ranges[1].mask_lo = mtrr_state.var_ranges[2].mask_lo;
+		for (i = 0; i < num_var_ranges; i++)
+			set_mtrr_var_ranges(i, &mtrr_state.var_ranges[i]);
+	}
+
 	if (mtrr_show) {
 		int high_width;
 

--------------070307040808030904010802--
