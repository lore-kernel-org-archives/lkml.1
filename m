Return-Path: <linux-kernel-owner+w=401wt.eu-S1755005AbYAXATc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755005AbYAXATc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 19:19:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752505AbYAXATZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 19:19:25 -0500
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:59661 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbYAXATY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 19:19:24 -0500
Message-ID: <4797D968.1030101@tiscali.nl>
Date: Thu, 24 Jan 2008 01:18:48 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@shadowen.org>, jwboyer@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
References: <4797C1AD.3040307@tiscali.nl> <1201129527.4988.69.camel@localhost>
In-Reply-To: <1201129527.4988.69.camel@localhost>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:
> On Wed, 2008-01-23 at 23:37 +0100, Roel Kluin wrote:
>> Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
>> ---
>> diff --git a/arch/powerpc/boot/4xx.c b/arch/powerpc/boot/4xx.c
>> index ebf9e21..dcfb459 100644
>> --- a/arch/powerpc/boot/4xx.c
>> +++ b/arch/powerpc/boot/4xx.c
>> @@ -104,7 +104,7 @@ void ibm4xx_denali_fixup_memsize(void)
>>  	val = DDR_GET_VAL(val, DDR_CS_MAP, DDR_CS_MAP_SHIFT);
>>  	cs = 0;
>>  	while (val) {
>> -		if (val && 0x1)
>> +		if (val & 0x1)
>>  			cs++;
>>  		val = val >> 1;
> 
> I think this pattern should be added to checkpatch

I agree but...

> Signed-off-by: Joe Perches <joe@perches.com>
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 579f50f..147e573 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1337,6 +1337,11 @@ sub process {
>  			}
>  		}
>  
> +# Check for bitwise tests written as boolean
> +		if ($line =~ /\&\&\s*0[xX]/) {
> +			WARN("boolean test with hexadecimal, perhaps just 1 \&?\n" . $herecurr);
> +		}
> +

when you use git-grep -n "\(&&\|||\)${s}0x\([A-Z0-9]*\|[a-z0-9]*\)",
(with s="[[:space:]]*") there will be false positives like

if (relocation < -0x20000 || 0x1fffc < relocation)
if (ARCH_SUN4C_SUN4 && addr < 0xe0000000 && 0x20000000 - len < addr) {
(and more)

However, if you search with
git-grep -n " \(&&\|||\)${s}0x\([A-Z0-9]*\|[a-z0-9]*\)$s\()\|&&\|||\)"
you won't get these false positives, but you do get the one I fixed.

Also there is the same logic flipped (though it did not give matches at
this time):
git-grep -n " \(&&\|||\|(\)${s}0x\([A-Z0-9]*\|[a-z0-9]*\)$s\(&&\|||\)"

so i'd propose to change that to
--
Catch boolean tests with hexadecimals, based on suggestion by Joe Perches

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..8ac7c7b 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1337,6 +1337,12 @@ sub process {
 			}
 		}
 
+# Check for bitwise tests written as boolean
+		if ($line =~ /(?:(?:\(|\&\&|\|\|)\s*0[xX]\s*(?:&&|\|\|)|
+				(?:\&\&|\|\|)\s*0[xX]\s*(?:\)|&&|\|\|))/) {
+			WARN("boolean test with hexadecimal, perhaps just 1 \& or \|?\n" . $herecurr);
+		}
+
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
 		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {
