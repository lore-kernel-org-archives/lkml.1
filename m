Return-Path: <linux-kernel-owner+w=401wt.eu-S1761785AbYBLIw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761785AbYBLIw5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 03:52:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754460AbYBLIwt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 03:52:49 -0500
Received: from mailservice.tudelft.nl ([130.161.131.5]:4334 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769AbYBLIwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 03:52:47 -0500
X-Greylist: delayed 1576 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2008 03:52:47 EST
X-Spam-Flag: NO
X-Spam-Score: -4.389
Message-ID: <47B15834.6010704@tudelft.nl>
Date: Tue, 12 Feb 2008 09:26:28 +0100
From: Eric Piel <E.A.B.Piel@tudelft.nl>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.9) Gecko/20080207 Mandriva/2.0.0.9-5mdv2008.1 (2008.1) Thunderbird/2.0.0.9 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: "Carlos R. Mafra" <crmafra@gmail.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [2.6.25-rc1] Strange regression with CONFIG_HZ_300=y
References: <47B0509E.1040100@gmail.com>
In-Reply-To: <47B0509E.1040100@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------050106060803050604040801"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050106060803050604040801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Carlos R. Mafra wrote:
> I apologize in advance if I am crazy about this, but I noticed
> a strange regression wrt 2.6.24 in cpufreq (I think) in 2.6.25-rc1, which
> goes away if I revert the following commit:
> 
> commit bdc807871d58285737d50dc6163d0feb72cb0dc2
> Author: H. Peter Anvin <hpa@zytor.com>
> Date:   Fri Feb 8 04:21:26 2008 -0800
> 
>     avoid overflows in kernel/time.c
> 
>     When the conversion factor between jiffies and milli- or microseconds is
>     not a single multiply or divide, as for the case of HZ == 300, we currently
>     do a multiply followed by a divide.  The intervening result, however, is
>     subject to overflows, especially since the fraction is not simplified (for
>     HZ == 300, we multiply by 300 and divide by 1000).
> 
>     This is exposed to the user when passing a large timeout to poll(), for
>     example.
> 
>     This patch replaces the multiply-divide with a reciprocal multiplication on
>     32-bit platforms.  When the input is an unsigned long, there is no portable
>     way to do this on 64-bit platforms there is no portable way to do this
>     since it requires a 128-bit intermediate result (which gcc does support on
>     64-bit platforms but may generate libgcc calls, e.g.  on 64-bit s390), but
>     since the output is a 32-bit integer in the cases affected, just simplify
>     the multiply-divide (*3/10 instead of *300/1000).
> 
>     The reciprocal multiply used can have off-by-one errors in the upper half
>     of the valid output range.  This could be avoided at the expense of having
>     to deal with a potential 65-bit intermediate result.  Since the intent is
>     to avoid overflow problems and most of the other time conversions are only
>     semiexact, the off-by-one errors were considered an acceptable tradeoff.
> 
> [...]
> [more text follows]
> 
> The problem in vanilla 2.6.25-rc1 happens with CONFIG_HZ_300=y (and doesn't
> with CONFIG_HZ_250=y or with the above commit reverted). The cpu frequency doesn't
> change anymore regardless of the load, and it stays high (2.0 GHz or 1.2 GHz) even
> when idle (I checked with 'top'), when the usual is to go to 800 Mhz when idle (I
> always use the ondemand governor compiled in and as the default governor).
> 
> The laptop is a Vaio VGN-FZ240E, core 2 duo T7250 @ 2.0 GHz and the kernel is x86_64.

Hi, it's great you found out the culprit commit because I was really 
wondering where this bug was coming from...
As a data point, my machine has a core 2 duo @ 1.2GHz and x86_64 arch. 
Do you also have the tickless option activated? (it could play a role)

See you,
Eric

--------------050106060803050604040801
Content-Type: text/x-vcard; charset=utf-8;
 name="E_A_B_Piel.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="E_A_B_Piel.vcf"

begin:vcard
fn;quoted-printable:=C3=89ric Piel
n;quoted-printable:Piel;=C3=89ric
org:Technical University of Delft;Software Engineering Research Group
adr:HB 08.080;;Mekelweg 4;Delft;;2628 CD;The Netherlands
email;internet:E.A.B.Piel@tudelft.nl
tel;work:+31 15 278 6338
x-mozilla-html:FALSE
url:http://pieleric.free.fr
version:2.1
end:vcard


--------------050106060803050604040801--
