Return-Path: <linux-kernel-owner+w=401wt.eu-S1754604AbYBKNi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbYBKNi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 08:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbYBKNiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 08:38:19 -0500
Received: from an-out-0708.google.com ([209.85.132.242]:10424 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYBKNiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 08:38:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:content-type:content-transfer-encoding;
        b=Y1Vx0vHy/qTRh9Sr/G4pIXwMsCh6hcJ+SmMrO9b3fmI6jXPpqayXubQuPfPTuuUUXeR0KHblRaP4lTOndEdZxk8lG9QV10o1sdsm+Y62JH/fGAvEESTS8B6XPbH86ZYhkUVyoL9jQwj82EfGB1mHmrxD6Ad6Mv5IpDYLNEnUkPU=
Message-ID: <47B0509E.1040100@gmail.com>
Date: Mon, 11 Feb 2008 11:41:50 -0200
From: "Carlos R. Mafra" <crmafra@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: [2.6.25-rc1] Strange regression with CONFIG_HZ_300=y
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I apologize in advance if I am crazy about this, but I noticed
a strange regression wrt 2.6.24 in cpufreq (I think) in 2.6.25-rc1, which
goes away if I revert the following commit:

commit bdc807871d58285737d50dc6163d0feb72cb0dc2
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Feb 8 04:21:26 2008 -0800

    avoid overflows in kernel/time.c

    When the conversion factor between jiffies and milli- or microseconds is
    not a single multiply or divide, as for the case of HZ == 300, we currently
    do a multiply followed by a divide.  The intervening result, however, is
    subject to overflows, especially since the fraction is not simplified (for
    HZ == 300, we multiply by 300 and divide by 1000).

    This is exposed to the user when passing a large timeout to poll(), for
    example.

    This patch replaces the multiply-divide with a reciprocal multiplication on
    32-bit platforms.  When the input is an unsigned long, there is no portable
    way to do this on 64-bit platforms there is no portable way to do this
    since it requires a 128-bit intermediate result (which gcc does support on
    64-bit platforms but may generate libgcc calls, e.g.  on 64-bit s390), but
    since the output is a 32-bit integer in the cases affected, just simplify
    the multiply-divide (*3/10 instead of *300/1000).

    The reciprocal multiply used can have off-by-one errors in the upper half
    of the valid output range.  This could be avoided at the expense of having
    to deal with a potential 65-bit intermediate result.  Since the intent is
    to avoid overflow problems and most of the other time conversions are only
    semiexact, the off-by-one errors were considered an acceptable tradeoff.

[...]
[more text follows]

The problem in vanilla 2.6.25-rc1 happens with CONFIG_HZ_300=y (and doesn't
with CONFIG_HZ_250=y or with the above commit reverted). The cpu frequency doesn't
change anymore regardless of the load, and it stays high (2.0 GHz or 1.2 GHz) even
when idle (I checked with 'top'), when the usual is to go to 800 Mhz when idle (I
always use the ondemand governor compiled in and as the default governor).

The laptop is a Vaio VGN-FZ240E, core 2 duo T7250 @ 2.0 GHz and the kernel is x86_64.

If someone needs more information about this I will be happy to provide.

Carlos R. Mafra



