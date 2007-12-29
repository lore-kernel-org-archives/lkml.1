Return-Path: <linux-kernel-owner+w=401wt.eu-S1756530AbXL2S6v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530AbXL2S6v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2007 13:58:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755402AbXL2S6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Dec 2007 13:58:43 -0500
Received: from pasmtpb.tele.dk ([80.160.77.98]:49597 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755309AbXL2S6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2007 13:58:43 -0500
Date: Sat, 29 Dec 2007 19:58:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <ak@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: unify x86 Makefile(s)
Message-ID: <20071229185842.GA20099@uranus.ravnborg.org>
References: <20071228212341.GA6939@uranus.ravnborg.org> <20071229125412.GE27360@does.not.exist> <20071229182241.GA19919@uranus.ravnborg.org> <200712291924.52077.ak@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200712291924.52077.ak@suse.de>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2007 at 07:24:51PM +0100, Andi Kleen wrote:
> 
> > 
> > This is the version that should exhibit the behaviour with increased text size.
> 
> The issue was not text size (u-a-a-t generally decreases that) but maximum stack usage.
> You need to check make checkstack output.

gcc 3.4.5 with: -fno-unit-at-a-time:
0xc0173b9a do_sys_poll [vmlinux]:			852
0xc0173cc2 do_sys_poll [vmlinux]:			852
0xc0206f8e nlmclnt_reclaim [vmlinux]:			704
0xc020701e nlmclnt_reclaim [vmlinux]:			704
0xc01a2c83 reiserfs_rename [vmlinux]:			668
0xc01a34a0 reiserfs_rename [vmlinux]:			668
0xc0173052 do_select [vmlinux]:				656
0xc0173320 do_select [vmlinux]:				656
0xc0417ceb do_ipv6_setsockopt [vmlinux]:		608
0xc0418746 do_ipv6_setsockopt [vmlinux]:		608

gcc 3.4.5 with: -funit-at-a-time:
0xc02926e8 lo_ioctl [vmlinux]:				1336
0xc0293055 lo_ioctl [vmlinux]:				1336
0xc03bf222 dev_ethtool [vmlinux]:			908
0xc03c00e5 dev_ethtool [vmlinux]:			908
0xc036adf9 cdrom_open [vmlinux]:			892
0xc036b78d cdrom_open [vmlinux]:			892
0xc0172445 do_sys_poll [vmlinux]:			860
0xc01726e9 do_sys_poll [vmlinux]:			860
0xc020fca3 sys_semctl [vmlinux]:			796
0xc0210447 sys_semctl [vmlinux]:			796
0xc02058af nlmclnt_reclaim [vmlinux]:			704
0xc020593f nlmclnt_reclaim [vmlinux]:			704
0xc01719d4 do_select [vmlinux]:				668
0xc0171d59 do_select [vmlinux]:				668
0xc01a121a reiserfs_rename [vmlinux]:			668
0xc01a1a54 reiserfs_rename [vmlinux]:			668
0xc0412e39 ipv6_setsockopt [vmlinux]:			612
0xc04138ca ipv6_setsockopt [vmlinux]:			612

So here we indeed see the expected (bad) behaviour.
unit-at-a-time causes much higher stack usage in some spots.
Above is listed only the hits above 600 bytes.

Until we are on par with stack usage I recommend to keep
-fno-unit-at-a-time disabled for gcc less than 4.00 as
suggested by Adrian (as is what we have today).

	Sam
