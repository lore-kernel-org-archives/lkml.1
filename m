Return-Path: <linux-kernel-owner+w=401wt.eu-S966172AbXJPVnc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966172AbXJPVnc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 17:43:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934009AbXJPVnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 17:43:17 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:36160 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933800AbXJPVnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 17:43:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=eo/wgbvwyvBFJgee0YjzBiSLziLDaqzjrOTo7DfX0fdFBp1Lq/NdcmZ9aLBMr7Qj4iX5jZNY3KmSriipUzjZ86qIelk+bjjQF7IAAA5wJcAsQssGlUGYDg0TC+HoewUBtDUl1lNO73hlAaiTvol7+7HGpZq6fl1+YlTmXJ/+tmg=
Date: Tue, 16 Oct 2007 23:43:09 +0200
From: Luca Tettamanti <kronos.it@gmail.com>
To: Thomas Meyer <thomas@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: kexec: Cannot determine the file type of arch/x86/boot/bzImage
Message-ID: <20071016214309.GA19630@dreamland.darkstar.lan>
References: <47151631.9000307@m3y3r.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47151631.9000307@m3y3r.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sam, please take a look at this:

Il Tue, Oct 16, 2007 at 09:51:13PM +0200, Thomas Meyer ha scritto: 
> Look at this:
> 
> $ file arch/x86/boot/bzImage (tree 821f3eff7cdb9d6c7076effabd46c96c322daed1)
> arch/x86/boot/bzImage: Linux kernel x86 boot executable zImage, version
> 2.6.23 (thomas@hotzenplotz) #39, RO-rootFS, root_dev 0x803, swap_dev
> 0x1, Prompt for Videomode

I just noticed the same problem when grub refused to load that thing.

The issue is that the build system created a zImage (and not a bzImage);
even passing the target explicitly doesn't solve the problem.

git bisect says:

f77bf01425b11947eeb3b5b54685212c302741b8 is first bad commit
commit f77bf01425b11947eeb3b5b54685212c302741b8
Author: Sam Ravnborg <sam@neptun.(none)>
--- (Ops, you have a problem on you git setup)
Date:   Mon Oct 15 22:25:06 2007 +0200

    kbuild: introduce ccflags-y, asflags-y and ldflags-y

    Introduce ccflags-y, asflags-y and ldflags-y so we soon can
    deprecate use of EXTRA_CFLAGS, EXTRA_AFLAGS and EXTRA_LDFLAGS.
    This patch does not touch any in-tree users - thats next round.
    Lets get this committed first and then fix the users of the
    soon to be deprecated variants next.

    The rationale behind this change is to introduce support for
    makefile fragments like:

    ccflags-$(CONFIG_WHATEVER_DEBUG) := -DDEBUG

    As a replacement for the uglier:
    ifeq ($(CONFIG_WHATEVER_DEBUG),y)
            EXTRA_CFLAGS := -DDEBUG
    endif

    Signed-off-by: Sam Ravnborg <sam@ravnborg.org>

:040000 040000 03915c7c738eefa31f2327521130df23b7dfe95e e2a1677df3709813ff793fdfa77d80fff9b838a7 M      Documentation
:040000 040000 ff4ad149975df39509a18782341f1f8f6a32f07a 663bce3c08a0f2e107cecb0b29edc4fe9d5735a0 M      scripts

I'm building a x86_64 image, using an external directory (O=...) in case
it matters.

Bisect log:

git-bisect start
# bad: [821f3eff7cdb9d6c7076effabd46c96c322daed1] Merge git://git.kernel.org/pub/scm/linux/kernel/git/sam/kbuild
git-bisect bad 821f3eff7cdb9d6c7076effabd46c96c322daed1
# good: [bbf25010f1a6b761914430f5fca081ec8c7accd1] Linux 2.6.23
git-bisect good bbf25010f1a6b761914430f5fca081ec8c7accd1
# good: [4d5709a7b7d54fc5882d2943a14988a92d48c00a] Merge master.kernel.org:/pub/scm/linux/kernel/git/davej/cpufreq
git-bisect good 4d5709a7b7d54fc5882d2943a14988a92d48c00a
# good: [b5869ce7f68b233ceb81465a7644be0d9a5f3dbb] Merge git://git.kernel.org/pub/scm/linux/kernel/git/mingo/linux-2.6-sched
git-bisect good b5869ce7f68b233ceb81465a7644be0d9a5f3dbb
# good: [11370ee2c1c578a704f47d5513d57274c335db43] [ALSA] hda-codec: Add two new systems to ALC883
git-bisect good 11370ee2c1c578a704f47d5513d57274c335db43
# good: [05440dfcfcabde6fcf7297dfa5a29f0355b78ffb] rtc-cmos probe() cleanup
git-bisect good 05440dfcfcabde6fcf7297dfa5a29f0355b78ffb
# good: [f20bf6125605acbbc7eb8c9420d7221c91aa83eb] time: introduce xtime_seconds
git-bisect good f20bf6125605acbbc7eb8c9420d7221c91aa83eb
# good: [92d15c2ccbb3e31a3fc71ad28fdb55e1319383c0] Merge branch 'for-linus' of git://git.kernel.dk/data/git/linux-2.6-block
git-bisect good 92d15c2ccbb3e31a3fc71ad28fdb55e1319383c0
# good: [fc8a327db6c46de783b1a4276d846841b9abc24c] Merge branch 'linus' of master.kernel.org:/pub/scm/linux/kernel/git/perex/alsa
git-bisect good fc8a327db6c46de783b1a4276d846841b9abc24c
# good: [3b16cc2d4ccc3949455432241fe378448e77d911] kbuild: move Kai Germaschewski to CREDITS
git-bisect good 3b16cc2d4ccc3949455432241fe378448e77d911
# good: [2f7055c5932ecc02159be375ebda1eee64665d17] [MIPS] MIPSsim: Fix booting from NFS root
git-bisect good 2f7055c5932ecc02159be375ebda1eee64665d17
# good: [52bcc3308ae3344266f55bf98a22c1ac0201eda7] kbuild: enable use of AFLAGS and CFLAGS on commandline
git-bisect good 52bcc3308ae3344266f55bf98a22c1ac0201eda7
# good: [8bb00d83d8fc2de5c0614f5d55780107e0c375fe] [MIPS] Increase cp0 compare clockevent min_delta_ns from 0x30 to 0x300.
git-bisect good 8bb00d83d8fc2de5c0614f5d55780107e0c375fe
# bad: [f77bf01425b11947eeb3b5b54685212c302741b8] kbuild: introduce ccflags-y, asflags-y and ldflags-y
git-bisect bad f77bf01425b11947eeb3b5b54685212c302741b8
# good: [06c5040cdb13d27adad118f2fbfae905a1911b37] kbuild: enable 'make CPPFLAGS=...' to add additional options to CPP
git-bisect good 06c5040cdb13d27adad118f2fbfae905a1911b37


Luca
-- 
The trouble with computers is that they do what you tell them, 
not what you want.
D. Cohen
