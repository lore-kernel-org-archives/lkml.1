Return-Path: <linux-kernel-owner+w=401wt.eu-S932624AbYA2Nej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932624AbYA2Nej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 08:34:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932447AbYA2NeS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 08:34:18 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:54401 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438AbYA2NeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:34:15 -0500
Message-ID: <479F2B52.7010004@tiscali.nl>
Date: Tue, 29 Jan 2008 14:34:10 +0100
From: Roel Kluin <12o3l@tiscali.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Joe Perches <joe@perches.com>, jwboyer@linux.vnet.ibm.com,
       lkml <linux-kernel@vger.kernel.org>, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH][ppc] logical/bitand typo in powerpc/boot/4xx.c
References: <4797C1AD.3040307@tiscali.nl> <1201129527.4988.69.camel@localhost> <4797D968.1030101@tiscali.nl> <20080129105531.GA651@shadowen.org>
In-Reply-To: <20080129105531.GA651@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Wed, 2008-01-23 at 23:37 +0100, Roel Kluin wrote:
>>>> -		if (val && 0x1)
>>>> +		if (val & 0x1)

>> Joe Perches wrote:
>>> I think this pattern should be added to checkpatch
>>> +		if ($line =~ /\&\&\s*0[xX]/) {

> On Thu, Jan 24, 2008 at 01:18:48AM +0100, Roel Kluin wrote:
>> I agree but there will be false positives, i'd propose to change that to
>> +		if ($line =~ /(?:(?:\(|\&\&|\|\|)\s*0[xX]\s*(?:&&|\|\|)|
>> +				(?:\&\&|\|\|)\s*0[xX]\s*(?:\)|&&|\|\|))/) {

Andy Whitcroft wrote:
> That one doesn't even match the original example.  Seems to be missing
> some number matching.  The concept seems sound though.  Basically
> looking for numbers which are definatly adjacent to a boolean or a brace
> on both sides.

You are right. here's a version that does work. It works the same as
git-grep -E "((\(|&&|\|\|)[[:space:]]*(0[xX][0-9a-fA-F]+|[0-9]+)[[:space:]]*(&&|\|\|)|(&&|\|\|)[[:space:]]*(0[xX][0-9a-fA-F]+|[0-9]+)[[:space:]]*(\)|&&|\|\|))"

---
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 579f50f..62276f7 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1337,6 +1337,11 @@ sub process {
 			}
 		}
 
+# Check for bitwise tests written as boolean
+		if ($line =~ /((\(|&&|\|\|)\s*(0[xX][0-9a-fA-F]+|[0-9]+)\s*(&&|\|\|)|(&&|\|\|)\s*(0[xX][0-9a-fA-F]+|[0-9]+)\s*(\)|&&|\|\|))/) {
+			WARN("boolean test with hexadecimal, perhaps just \'&\' or \'|\'?\n" . $herecurr);
+		}
+
 # if and else should not have general statements after it
 		if ($line =~ /^.\s*(?:}\s*)?else\b(.*)/ &&
 		    $1 !~ /^\s*(?:\sif|{|\\|$)/) {

