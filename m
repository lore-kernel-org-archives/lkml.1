Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759107Ab0CMUCv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 15:02:51 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756284Ab0CMUCr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 15:02:47 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "M. Vefa Bicakci" <bicave@superonline.com>,
       Chris Wilson <chris@chris-wilson.co.uk>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [Bisected Regression in 2.6.32.8] i915 with KMS enabled causes memorycorruption when resuming from suspend-to-disk
Date: Sat, 13 Mar 2010 21:05:27 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc1-rjw; KDE/4.3.5; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net,
       pm list <linux-pm@lists.linux-foundation.org>
References: <4B9B1E8F.5090806@superonline.com>
In-Reply-To: <4B9B1E8F.5090806@superonline.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201003132105.27127.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 13 March 2010, M. Vefa Bicakci wrote:
> Hello,
> 
> As you can guess from the subject, I have noticed that enabling the
> KMS feature of the i915 module with any kernel version after 2.6.32.7
> causes memory corruption after one resumes from suspend-to-disk.
> 
> My hardware is a Toshiba Satellite A100, with an Intel graphics card.
> I am using an up-to-date version of Debian Sid. Here are the lspci 
> entries for my graphics card:
> 
> === 8< ===
> 00:02.0 VGA compatible controller [0300]: Intel Corporation Mobile 945GM/GMS, 943/940GML Express Integrated Graphics Controller [8086:27a2] (rev 03) (prog-if 00 [VGA controller])
> 00:02.1 Display controller [0380]: Intel Corporation Mobile 945GM/GMS/GME, 943/940GML Express Integrated Graphics Controller [8086:27a6] (rev 03)
> === >8 ===
> 
> I have noticed that after upgrading from 2.6.32.7 to 2.6.32.9, I started
> to get a lot of segfaults from different programs when I resume from
> suspend-to-disk. After searching the Internet for this problem, I have
> seen that some other people also had it, and that it wasn't a new problem
> either: 
> 
> http://bbs.archlinux.org/viewtopic.php?id=91375
> https://bugzilla.redhat.com/show_bug.cgi?id=537494
> http://bugzilla.kernel.org/show_bug.cgi?id=13811
> 
> Even though some people say that they have had this problem for a long time,
> I have only noticed it after upgrading to 2.6.32.9.
> 
> After booting with "nomodeset" and confirming that the problem doesn't
> happen with that kernel option, I have determined that the problem was
> with i915.
> 
> Then I used the following command to bisect the changes that i915 has
> seen between 2.6.32.7 and 2.6.32.9:
> 
> git bisect start v2.6.32.9 v2.6.32.7 -- ./drivers/gpu/drm/
> 
> With each iteration in the bisection, I have tried at least 3 cycles
> of suspend-to-disk and resume operations. I saw that all of the tried
> versions had memory corruption issues after resume from suspend-to-disk.
> 
> Then, git told me that the culprit is the first change to i915 after the
> release 2.6.32.7. So 2.6.32.8 introduced the regression I am experiencing.
> Here's the "git bisect log" output:
> 
> === 8< ===
> # bad: [7f5e918e62cbc9ac27c2f47d3c3dd4b86f67ff0e] Linux 2.6.32.9
> # good: [b4bdd73ce865213a5653dc424873e8da37e858cc] Linux 2.6.32.7
> git bisect start 'v2.6.32.9' 'v2.6.32.7' '--' './drivers/gpu/drm/'
> # bad: [192ff23a2206eb5136c779bfed73171a4d214ad6] drm/i915: Add HP nx9020/SamsungSX20S to ACPI LID quirk list
> git bisect bad 192ff23a2206eb5136c779bfed73171a4d214ad6
> # bad: [6240058ce3725f5e708e1c17c3a676217e44ba9b] drm/i915: disable hotplug detect before Ironlake CRT detect
> git bisect bad 6240058ce3725f5e708e1c17c3a676217e44ba9b
> # bad: [61d4374b51386dd40c03fd15df5a7f97347de688] drm/i915: Reload hangcheck timer too for Ironlake
> git bisect bad 61d4374b51386dd40c03fd15df5a7f97347de688
> # bad: [d8e0902806c0bd2ccc4f6a267ff52565a3ec933b] drm/i915: Selectively enable self-reclaim
> git bisect bad d8e0902806c0bd2ccc4f6a267ff52565a3ec933b
> 
> d8e0902806c0bd2ccc4f6a267ff52565a3ec933b is the first bad commit
> commit d8e0902806c0bd2ccc4f6a267ff52565a3ec933b
> Author: Chris Wilson <chris@chris-wilson.co.uk>
> Date:   Wed Jan 27 13:36:32 2010 +0000
> 
>     drm/i915: Selectively enable self-reclaim
> 
>     commit 4bdadb9785696439c6e2b3efe34aa76df1149c83 upstream.
> 
>     Having missed the ENOMEM return via i915_gem_fault(), there are probably
>     other paths that I also missed. By not enabling NORETRY by default these
>     paths can run the shrinker and take memory from the system (but not from
>     our own inactive lists because our shrinker can not run whilst we hold
>     the struct mutex) and this may allow the system to survive a little longer
>     whilst our drivers consume all available memory.
> 
>     References:
>       OOM killer unexpectedly called with kernel 2.6.32
>       http://bugzilla.kernel.org/show_bug.cgi?id=14933
> 
>     v2: Pass gfp into page mapping.
>     v3: Use new read_cache_page_gfp() instead of open-coding.
> 
>     ...
> === >8 ===
> 
> For the record, just to confirm that this commit is actually the culprit,
> I took a vanilla 2.6.32.9 source tree and reverted only this commit. I am
> happy to let you know that with this commit reverted, I can no longer
> reproduce the memory corruption issue.
> 
> However, as I noted above, some people have had this problem for a longer
> time. So I am not sure if the commit above causes the bug or if it makes
> the bug easier to trigger.
> 
> Finally, I would like to note that this regression is going to be important,
> because, as you know, Intel's X11 drivers are not going to support mode-setting
> in user mode starting with version 2.10.0.
> 
> If there is any help I can provide in fixing this regression, please let me
> know. I am willing to try patches.

If I remember correctly, this has been fixed in the mainline, but I don't
remember the exact commit right now.

Chris, Jesse, can you please help?

Rafael
