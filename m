Return-Path: <linux-kernel-owner+w=401wt.eu-S1753344AbZBRICa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbZBRICa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 03:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751649AbZBRICW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 03:02:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61019 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751550AbZBRICW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 03:02:22 -0500
Message-ID: <499BC08C.5000603@cn.fujitsu.com>
Date: Wed, 18 Feb 2009 16:02:20 +0800
From: Wang Chen <wangchen@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.19 (Windows/20081209)
MIME-Version: 1.0
To: Eric Anholt <eric@anholt.net>
CC: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
Subject: Re: [PATCH] drm: Fix lock order reversal between mmap_sem and struct_mutex.
References: <1234918786-854-1-git-send-email-eric@anholt.net>
In-Reply-To: <1234918786-854-1-git-send-email-eric@anholt.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Anholt said the following on 2009-2-18 8:59:
> The basic problem was
> mmap_sem (do_mmap()) -> struct_mutex (drm_gem_mmap(), i915_gem_fault())
> struct_mutex (i915_gem_execbuffer()) -> mmap_sem (copy_from/to_user())
> 
> We have plenty of places where we want to hold device state the same
> (struct_mutex) while we move a non-trivial amount of data
> (copy_from/to_user()), such as i915_gem_pwrite().  Solve this by moving the
> easy things that needed struct_mutex with mmap_sem held to using a lock to
> cover just those data structures (offset hash and offset manager), and do
> trylock and reschedule in fault.
> 

Eric, I tested the patch.
But following bug still doesn't disappear.
http://bugzilla.kernel.org/show_bug.cgi?id=12419

