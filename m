Return-Path: <linux-kernel-owner+w=401wt.eu-S933349AbZLPMTk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933349AbZLPMTk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 07:19:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933023AbZLPMTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 07:19:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:63124 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932904AbZLPMTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 07:19:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=aR0R+7JEjQ7DdLmiZlY9pJl7UPbf+Y40+OajKCdW/4f1TAgP6/oXti3+EgdzRGdcGH
         ch1ku385vQTWQYA1NDVNXmXfqRiNKdqq2UhlnivQomeR1/QwlWvq0UfMHdK9aipXgXZT
         p9f1Jdyxwu0XR39m2+Uhg1Q4Zq0mR1jGMCevY=
Message-ID: <4B28D052.4040303@gmail.com>
Date: Wed, 16 Dec 2009 13:19:30 +0100
From: Mathieu Taillefumier <mathieu.taillefumier@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Fedora/3.0-3.9.b4.fc12 Lightning/1.0pre Thunderbird/3.0
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Dave Airlie <airlied@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
       Daniel Vetter <daniel@ffwll.ch>, Adam Jackson <ajax@redhat.com>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net,
       keithp@keithp.com, eric@anholt.net,
       Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [BISECTED] drm: random hang since 620f378 "drm: prune modes when
 ..."
References: <200912071830.14697.arnd@arndb.de>	<200912131230.25781.arnd@arndb.de>	<20091213200017.GA3522@viiv.ffwll.ch>	<200912132131.07100.arnd@arndb.de>	<1260741245.3123.0.camel@t60prh> <20091214102015.2f43f5b4@jbarnes-piketon>
In-Reply-To: <20091214102015.2f43f5b4@jbarnes-piketon>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> You can disable most of that code by loading i915 with 'powersave=0'.
> If that patch really is at fault the powersave=0 should work around the
> issue as well.
>
> It's been implicated in another issue (some display flicker and
> underruns) so I'm pretty sure there's something wrong with it in some
> configurations at least...
>    
Could it be also that the powersave feature produces gpu hangs when 
xserver is run the first time (after a cold boot). I have serious issues 
the intel drm starting at v2.6.32-rc2 (I can not use the v2.6.32 series 
on my laptop) while the same xorg stack works well with the v2.6.31 
series. I try to bisect this problem and obtained this (sorry it is a 
bit long):

  git bisect start 'drivers/gpu' 'arch/x86_64/'
# bad: [053fe57ac249a9531c396175778160d9e9509399] Merge 
git://git.kernel.org/pub
/scm/linux/kernel/git/davem/net-2.6
git bisect bad 053fe57ac249a9531c396175778160d9e9509399
# good: [74fca6a42863ffacaf7ba6f1936a9f228950f657] Linux 2.6.31
git bisect good 74fca6a42863ffacaf7ba6f1936a9f228950f657
# bad: [d8a2d0e00c0d5a0d55e14b884bff034205015e51] drm/i915: HDMI 
hardware workar
ound for Ironlake
git bisect bad d8a2d0e00c0d5a0d55e14b884bff034205015e51
# bad: [d50ba256b5f1478e15accfcfda9b72fd7a661364] drm/kms: start adding 
command
line interface using fb.
git bisect bad d50ba256b5f1478e15accfcfda9b72fd7a661364
# good: [551ebd837c75fc75df81811a18b7136c39cab487] drm/radeon/kms: add 
rn50/r100
/r200 CS tracker.
git bisect good 551ebd837c75fc75df81811a18b7136c39cab487
# good: [fdd5cace733370ab7a518a98ef084e02aa76fdea] drm/radeon/kms: Don't 
kzalloc
  memory which is immediately overwritten.
git bisect good fdd5cace733370ab7a518a98ef084e02aa76fdea
# good: [698443d9ec1a33eff65b27b9514e06998bf57eb3] drm/radeon/kms: 
disable VGA r
endering engine before taking over VRAM
git bisect good 698443d9ec1a33eff65b27b9514e06998bf57eb3
# good: [c214271563c00f2721c5111e27b53bf06dabc6e4] drm/radeon: 
consolidate famil
y flags used in pciids.
git bisect good c214271563c00f2721c5111e27b53bf06dabc6e4
# good: [93dc6c2b0d97a55508144073838e041140b206cd] drm/edid: Detailed 
standard t
iming blocks have six timings, not five.
git bisect good 93dc6c2b0d97a55508144073838e041140b206cd
# good: [4bbd4973703bf8a5f00f05eff30a99cd9814f37f] drm/radeon/kms: 
enable r600 t
v outputs.
git bisect good 4bbd4973703bf8a5f00f05eff30a99cd9814f37f
# good: [513bcb4655e68706594e45dfa1d4b181500110ba] drm/radeon/kms: don't 
require
  up to 64k allocations. (v2)
git bisect good 513bcb4655e68706594e45dfa1d4b181500110ba

Regards

Mathieu
