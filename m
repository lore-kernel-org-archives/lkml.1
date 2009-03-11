Return-Path: <linux-kernel-owner+w=401wt.eu-S1754192AbZCKW5R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192AbZCKW5R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:57:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbZCKW5D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:57:03 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55250 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751095AbZCKW5B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:57:01 -0400
Subject: Re: X/gnome hang on EeePC with DRM and PAE
From: Dave Airlie <airlied@redhat.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Cc: linux-kernel@vger.kernel.org, jbarnes@virtuousgeek.org, eric@anholt.net
In-Reply-To: <1236811716.4529.70.camel@localhost.localdomain>
References: <1236811716.4529.70.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 12 Mar 2009 08:56:49 +1000
Message-Id: <1236812210.22993.2.camel@clockmaker.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-11 at 15:48 -0700, Pallipadi, Venkatesh wrote:
> X/gnome hangs on my EeePC (900HA) with latest git kernel when PAE is
> enabled. X seems to start OK. I see the login screen and after entering
> the password, I see initial gnome loading with desktop icons and stuff
> and the desktops refreshed after a couple of seconds with complete white
> background. I only see the mouse pointer on desktop which I can move
> around. The system is alive in general and ssh-able. I see no errors in
> dmesg. Attached is the config that reproduces the problem for me. I have
> FC10 userspace.
> 
> If I disable PAE from this config, things work fine.
> 
> Initially, I saw the problem with latest git. But, I later saw the same
> problem with .28 as well. Rolling back further, the problem was not
> present in 2.6.28-rc3 and git bisect narrowed this regression to below
> commit.

Go further back maybe before the GEM merge and see if its still broken.

All this commit did was disable GEM when PAE is enabled, so I suspect
it was broken pre-GEM, and GEM sort of worked.

Dave.

> 
> Thanks,
> Venki
> 
> 
> ac5c4e76180a74c7f922f6fa71ace0cef45fa433 is first bad commit
> commit ac5c4e76180a74c7f922f6fa71ace0cef45fa433
> Author: Dave Airlie <airlied@redhat.com>
> Date:   Fri Dec 19 15:38:34 2008 +1000
> 
>     drm/i915: GEM on PAE has problems - disable it for now.
>     
>     On PAE systems, GEM allocates pages using shmem, and passes these
>     pages to be bound into AGP, however the AGP interfaces + the x86
>     set_memory interfaces all take unsigned long not dma_addr_t.
>     
>     The initial fix for this was a mess, so we need to do this correctly
>     for 2.6.29.
>     
>     Signed-off-by: Dave Airlie <airlied@redhat.com>
> 
> :040000 040000 d468c858e0cf3f8b7f100004ed767cf7c005deef
> 8dfa48f29e9685f4cf2dd9b6655b21ec92525171 M      drivers
> 
> 
> git bisect start
> # good: [45beca08dd8b6d6a65c5ffd730af2eac7a2c7a03] Linux v2.6.28-rc3
> git bisect good 45beca08dd8b6d6a65c5ffd730af2eac7a2c7a03
> # bad: [4a6908a3a050aacc9c3a2f36b276b46c0629ad91] Linux 2.6.28
> git bisect bad 4a6908a3a050aacc9c3a2f36b276b46c0629ad91
> # good: [ee11940f8e7a2f064af22d52180cb5f9643eef61] cirrusfb: remove
> unused variables
> git bisect good ee11940f8e7a2f064af22d52180cb5f9643eef61
> # good: [e1825e7515010053e44287e6e78f9078cd1916a9] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-2.6
> git bisect good e1825e7515010053e44287e6e78f9078cd1916a9
> # good: [061afe9fe1a295ef950cf7e6c92fa7d4ae226f28] Merge branch
> 'release' of
> git://git.kernel.org/pub/scm/linux/kernel/git/aegl/linux-2.6
> git bisect good 061afe9fe1a295ef950cf7e6c92fa7d4ae226f28
> # good: [3797455fd269f6ae0bc228d5206b502830af03f4] Merge
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6
> git bisect good 3797455fd269f6ae0bc228d5206b502830af03f4
> # bad: [8837e341cc76372716b1576dd88fbf832acd29d4] Merge branch
> 'for-linus' of
> git://git.kernel.org/pub/scm/linux/kernel/git/tiwai/sound-2.6
> git bisect bad 8837e341cc76372716b1576dd88fbf832acd29d4
> # good: [69098bac169d630a777b362470f20451b9446e39] Merge branch 'fixes'
> of git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6
> git bisect good 69098bac169d630a777b362470f20451b9446e39
> # good: [db873cfc7c0a6f34ab0f1c811fc245273adf35af] Merge branch
> 'for-linus' of git://neil.brown.name/md
> git bisect good db873cfc7c0a6f34ab0f1c811fc245273adf35af
> # good: [5bd9c69649754cd4b1a96cdbe5caa4e5d1d35eb5] Merge branch
> 'fix/asoc' into for-linus
> git bisect good 5bd9c69649754cd4b1a96cdbe5caa4e5d1d35eb5
> # bad: [f3485c82f75eeb951162dda663f45714627a85f5] Merge branch
> 'drm-fixes' of
> git://git.kernel.org/pub/scm/linux/kernel/git/airlied/drm-2.6
> git bisect bad f3485c82f75eeb951162dda663f45714627a85f5
> # bad: [ac5c4e76180a74c7f922f6fa71ace0cef45fa433] drm/i915: GEM on PAE
> has problems - disable it for now.
> git bisect bad ac5c4e76180a74c7f922f6fa71ace0cef45fa433
> # good: [c4de0a5d671e3af38dc3496538e391782aecc3a5] drm/i915: Don't
> return busy for buffers left on the flushing list.
> git bisect good c4de0a5d671e3af38dc3496538e391782aecc3a5
> 
> 
> 
> 

