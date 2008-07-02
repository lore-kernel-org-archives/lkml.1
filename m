Return-Path: <linux-kernel-owner+w=401wt.eu-S1754609AbYGBSlL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbYGBSlL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:41:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752571AbYGBSk5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:40:57 -0400
Received: from nf-out-0910.google.com ([64.233.182.184]:65097 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268AbYGBSk4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:40:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gHkrvWOxAgHo6GhFoO0Ipx4VwaGmdU3W2sMkG8ThpRYr1S7SBBi39egWqVSp+p+jl5
         BIVl5zKdOrev9V2VW/9Wew93mddMIv32f2qtDMczEx0j1oaKm//lO28VR7EOwhOw/3+B
         99JtemODSD4CFAbp5Tfg/iLOOKjn8MDRJ4u/c=
Date: Wed, 2 Jul 2008 22:40:24 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [Q] Is 64bit LVTT screwed
Message-ID: <20080702184024.GC7003@cvg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maciej,

while I'm in path of unification apic code I found a bit
strange code snippet

apic_32.c
---------
#define APIC_DIVISOR 16
static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
{
	...
	if (!oneshot)
		apic_write_around(APIC_TMICT, clocks / APIC_DIVISOR);

}

apic_64.c
---------
static void __setup_APIC_LVTT(unsigned int clocks, int oneshot, int irqen)
{
        ...
	if (!oneshot)
		apic_write_around(APIC_TMICT, clocks);
}

but in both cases we use "divide by 16" in divide register. The only
explanation I imagine - for 64bit mode we are required to 'stuck'
for a bit longer (by 16 times longer to be precise). Am I right?
Or there is another reason why we dont use APIC_DIVISOR here. Actually,
as I see it not fair to a caller. For 64bit mode APIC timer is requested
to count 250000000 ticks but in real it will count 250000000 * 16.
Not sure who is right there. I think the better would be to
use 4000000000 and APIC_DIVISOR in 64bit mode. How do you think?

		- Cyrill -
