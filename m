Return-Path: <linux-kernel-owner+w=401wt.eu-S1753292AbZCIX5S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753292AbZCIX5S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:57:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752395AbZCIX5I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:57:08 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:44175 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbZCIX5H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:57:07 -0400
Date: Mon, 9 Mar 2009 23:56:58 +0000
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: dri-devel@lists.sf.net, LKML <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Anholt <eric@anholt.net>,
       Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       Timo Aaltonen <tjaalton@cc.hut.fi>, Dave Airlie <airlied@redhat.com>
Subject: Re: [REGRESSION,BISECTED] i915 VT switch with AIGLX causes X lock up
Message-ID: <20090309235658.GA26529@silver.sucs.org>
References: <20090221153822.GA4571@silver.sucs.org> <20090223223226.GA23763@silver.sucs.org> <200902240844.09424.jbarnes@virtuousgeek.org> <20090224225930.GA3745@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090224225930.GA3745@silver.sucs.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is still here in 2.6.29-rc7. I got around to bisecting this
and here's the commit that was fingered:

commit 14d200c5e5bd19219d930bbb9a5a22758c8f5bec
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Fri Feb 6 13:04:49 2009 -0800

    drm/i915: capture last_vblank count at IRQ uninstall time too
    
    In dc1336ff4fe08ae7cfe8301bfd7f0b2cfd31d20a (set vblank enable flag correctly
    across IRQ uninstall), we made sure drivers that uninstall their interrupt
    handler set the vblank enabled flag correctly, so that when interrupts are
    re-enabled, vblank interrupts & counts work as expected.  However I missed the
    last_vblank field:  it needs to be updated as well, otherwise, at the next
    drm_update_vblank_count we'll end up comparing a current count to a stale
    one (the last one captured by the disable function), which may trigger the
    wraparound handling, leading to a jumpy counter and hangs in drm_wait_vblank.
    
    The jumpy counter can prevent the DRM_WAIT_ON from returning success if the
    difference between the current count and the requested count is greater than
    2^23, leading to timeouts or hangs, if the ioctl is restarted in a loop (as
    is the case in libdrm < 2.4.4).
    
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Acked-by: Michel Dänzer <michel@daenzer.net>
    Tested-by: Timo Aaltonen <tjaalton@cc.hut.fi>
    Signed-off-by: Dave Airlie <airlied@redhat.com>

Reverting the above made the problem go away. Here's the bisect log:

# bad: [d2f8d7ee1a9b4650b4e43325b321801264f7c37a] Linux 2.6.29-rc5
# good: [832fb4a01ca27ded735421de2b090f03e20039fc] Merge branch 'drm-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
git bisect start 'v2.6.29-rc5' '832fb4a01ca27ded735421de2b090f03e20039fc'
# good: [ac048e1734699dd98f4bdf4daf2b9592d4a4d38e] i915: fix unneeded locking in i915 LVDS get modes code.
git bisect good ac048e1734699dd98f4bdf4daf2b9592d4a4d38e
# good: [725e30ad6601d7fe443d9215d6331758a9d7e0c8] drm/i915: Skip SDVO/HDMI init when the chipset tells us it's not present.
git bisect good 725e30ad6601d7fe443d9215d6331758a9d7e0c8
# bad: [d2f59357700487a8b944f4f7777d1e97cf5ea2ed] drm/i915: select framebuffer support automatically
git bisect bad d2f59357700487a8b944f4f7777d1e97cf5ea2ed
# good: [e2f0ba97d60e59fe5c6237851933a9c38a8f9a24] drm/i915: sync SDVO code with stable userland modesetting driver
git bisect good e2f0ba97d60e59fe5c6237851933a9c38a8f9a24
# good: [7d8d58b23fd01e60ed44d8d8c10b2df86e638faa] drm/i915: Unlock mutex on i915_gem_fault() error path
git bisect good 7d8d58b23fd01e60ed44d8d8c10b2df86e638faa
# bad: [9880b7a527ffbb52f65c2de0a8d4eea86e24775e] drm/i915: add get_vblank_counter function for GM45
git bisect bad 9880b7a527ffbb52f65c2de0a8d4eea86e24775e
# bad: [14d200c5e5bd19219d930bbb9a5a22758c8f5bec] drm/i915: capture last_vblank count at IRQ uninstall time too
git bisect bad 14d200c5e5bd19219d930bbb9a5a22758c8f5bec

-- 
Sitsofe | http://sucs.org/~sits/
