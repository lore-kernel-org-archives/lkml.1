Return-Path: <linux-kernel-owner+w=401wt.eu-S1760057AbYG3WBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760057AbYG3WBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757483AbYG3WBL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:01:11 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:54742 "EHLO
	IE1EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757404AbYG3WBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:01:08 -0400
X-BigFish: VPS-37(z1857rz1432R98dR936eQ4015M1805M936fQzz10d3izzz2fh6bh61h)
X-Spam-TCS-SCL: 0:0
Message-ID: <4890E539.6060905@am.sony.com>
Date: Wed, 30 Jul 2008 15:03:37 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
       Lennert Buytenhek <kernel@wantstofly.org>,
       Dave Jones <davej@codemonkey.org.uk>, Paul Jackson <pj@sgi.com>,
       Tony Luck <tony.luck@intel.com>,
       Tigran Aivazian <tigran@aivazian.fsnet.co.uk>,
       Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Robert Richter <robert.richter@amd.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Sam Creasey <sammy@sammy.net>, Greg Banks <gnb@sgi.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Andreas Schwab <schwab@suse.de>, Johannes Weiner <hannes@saeurebad.de>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 1/1] cpumask: Change cpumask_of_cpu to use cpumask_of_cpu_map
 - build breakage
References: <20080723171841.815234000@polaris-admin.engr.sgi.com> <20080723171841.997896000@polaris-admin.engr.sgi.com> <4890C8E4.50503@am.sony.com> <4890DC09.2020700@sgi.com>
In-Reply-To: <4890DC09.2020700@sgi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 30 Jul 2008 22:00:47.0786 (UTC) FILETIME=[B8FC80A0:01C8F28F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Travis wrote:
> There was a later update that fixed this.  You should have the following
> in include/linux/cpumask.h particularly line 291.
> 
> 
> e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 285) /*
> e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 286)  * In cases where we take the address of the cpumask immediately,
> e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 287)  * gcc optimizes it out (it's a constant) and there's no huge stack
> e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 288)  * variable created:
> e56b3bc7 (Linus Torvalds         2008-07-28 11:32:33 -0700 289)  */
> 1eddd657 (Stephen Rothwell       2008-07-29 16:07:37 +1000 290) #define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))
> ^1da177e (Linus Torvalds         2005-04-16 15:20:36 -0700 291)
> 
> If 1eddd657 is there, would you send the config?

I was working out of a linux-2.6.27-rc1.tar.bz2 I got off of kernel.org,
so my working tree doesn't have the commit information.


However, comparing my source with the source above shows a difference.
In a Linus' 2.6 tree I downloaded outside my firewall, I have the following:
3dd730f2        (Stephen Rothwell       2008-07-29 16:07:37 +1000       290)#define cpumask_of_cpu(cpu) (*get_cpu_mask(cpu))

It doesn't appear to have the change you mention.  But 3dd730f2 looks
promising:
commit 3dd730f2b49f101b90d283c3efc4e6cd826dd8f6
Author: Stephen Rothwell <sfr@canb.auug.org.au>
Date:   Tue Jul 29 16:07:37 2008 +1000

    cpumask: statement expressions confuse some versions of gcc

    when you take the address of the result.  Noticed on a sparc64 compile
    using a version 3.4.5 cross compiler.

     kernel/time/tick-common.c: In function `tick_check_new_device':
     kernel/time/tick-common.c:210: error: invalid lvalue in unary `&'
     ...

    Just make it a regular expression.

    Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
    Acked-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

This looks like it's only 4 hours old.  I'll give this a spin.

I don't see 1eddd657 anywhere in the commit log for cpumask.h
Is it in linux-next?

Thanks,
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Linux Forum
Senior Staff Engineer, Sony Corporation of America
=============================

