Return-Path: <linux-kernel-owner+w=401wt.eu-S935884AbYEURJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935884AbYEURJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 13:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751616AbYEURJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 13:09:46 -0400
Received: from main.gmane.org ([80.91.229.2]:39499 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYEURJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 13:09:45 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: [BISECTED] linux-next-20080519 does not boot on x86 (ACPI)
Date: Wed, 21 May 2008 18:09:32 +0100
Message-ID: <g11l0c$jji$1@ger.gmane.org>
References: <g0s6pv$va4$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cpc1-cwma5-0-0-cust137.swan.cable.ntl.com
User-Agent: KNode/0.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

<posted & mailed>

Sitsofe Wheeler wrote:

> While trying to boot this kernel the kernel seems to be going well until
> it comes to time to mount disks at which point it starts going very slow.
> It doesn't respond to the keyboard (caps lock does not work), sysrq is
> inoperable and the ATA tests timeout and over the course of minutes start
> negotiating slower speeds. Using nmi_watchdog=1 or nmi_watchdog=2 does not
> make any difference. next-20080516 booted correctly.
> 
> Config is downloadable from http://sucs.org/~sits/test/config-20080519 .

OK I've finally bisected this down to the following commit:
commit 86a2e1a7ec8c6363e502ac8ccf5fe50dd46b39c2
Author: Alexey Starikovskiy <astarikovskiy@suse.de>
Date:   Wed May 14 19:02:57 2008 +0400

    x86: complete move ACPI from mpparse.c

    Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

Reverting that commit made the problem go away.

Here's the bisection log:
# bad: [d8a43554b5bf7e53b20d9cbcdbb3cb3b3548efb3] Add linux-next specific files
# good: [f1d3dea84b7db920eba269ae35c286947c01385f] Add linux-next specific files
git-bisect start 'next-20080519' 'next-20080516'
# bad: [9b9c66d50701d9e9ce20babc2ba6fee13e5bf165] Merge branch 'scratch' into auto-latest
git-bisect bad 9b9c66d50701d9e9ce20babc2ba6fee13e5bf165
# good: [8d5902b9d9cdd4d91d41e6078f909994ae13b5a1] Merge branch 'linus' into ftrace
git-bisect good 8d5902b9d9cdd4d91d41e6078f909994ae13b5a1
# good: [468d3c898eef22cc43b28e7da1f166a972678956] x86: boot/printfc use NULL instead 0
git-bisect good 468d3c898eef22cc43b28e7da1f166a972678956
# bad: [9cba8dc9383ab1c49c500754becdfd2b65c46f2a] Merge branch 'x86/pat' into auto-x86-next
git-bisect bad 9cba8dc9383ab1c49c500754becdfd2b65c46f2a
# bad: [a2b7bd1ca537b6975554f6f2762412829d814ca3] Merge branch 'x86/gart' into auto-x86-next
git-bisect bad a2b7bd1ca537b6975554f6f2762412829d814ca3
# good: [1c79873486c6adf464fe4a581e89676e885d20db] x86: move es7000_plat out of mpparse.c
git-bisect good 1c79873486c6adf464fe4a581e89676e885d20db
# bad: [0f95f8c5ab32555450ff317817be2dbb9dca887d] Merge branch 'x86/cleanups' into auto-x86-next
git-bisect bad 0f95f8c5ab32555450ff317817be2dbb9dca887d
# bad: [898edd00a974951e89d749251a7581855e51c675] arch/x86/mm/pat.c: use boot_cpu_has()
git-bisect bad 898edd00a974951e89d749251a7581855e51c675
# bad: [e29b4ee46a2dd0274a8022b55d286491a6184197] x86: make config_irqsrc not MPspec specific
git-bisect bad e29b4ee46a2dd0274a8022b55d286491a6184197
# bad: [8fafd462213ee315db6192104e456f4c6e724aa7] x86: make mp_ioapic_routing definition local
git-bisect bad 8fafd462213ee315db6192104e456f4c6e724aa7
# bad: [86a2e1a7ec8c6363e502ac8ccf5fe50dd46b39c2] x86: complete move ACPI from mpparse.c
git-bisect bad 86a2e1a7ec8c6363e502ac8ccf5fe50dd46b39c2

-- 
Sitsofe | http://sucs.org/~sits/

