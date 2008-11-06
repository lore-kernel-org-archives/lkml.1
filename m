Return-Path: <linux-kernel-owner+w=401wt.eu-S1754179AbYKFHDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754179AbYKFHDS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2008 02:03:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752005AbYKFHDE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Nov 2008 02:03:04 -0500
Received: from el-out-1112.google.com ([209.85.162.177]:37813 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367AbYKFHDC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2008 02:03:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=T/5Lod2JZfByJcNtPPwEc6azX2e/9PSVVnYPhcefQPylDKJ9Z4Ew3N+l5j9gXnC6Gl
         gLSG4cqUNLxCqiCQwc+XMM16ndBM4QJKDE3n0HjQmJQ7lh6cYc/bUaxpusG9P87v0x7x
         +lCt2R9ri/VvYH+fEptcvmB0qoFyXXrcfgoa8=
Message-ID: <21d7e9970811052303k188a50eewdc65c5fa9a2debc2@mail.gmail.com>
Date: Thu, 6 Nov 2008 17:03:00 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "eric@anholt.net" <eric@anholt.net>,
       "Arjan van de Ven" <arjan@linux.intel.com>,
       "Keith Packard" <keithp@keithp.com>
Subject: agp PAE issue (was Re: [git pull] AGP patches for 2.6.28-rc4)
Cc: torvalds@linux-foundation.org, "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> PAE kernel + AGP + GEM fix. The patch contains more explaination, but
>> since GEM uses shmem to allocate pages it can pass highmem pages into AGP,
>> AGP just needs to pass those addressess around cleanly in dma_addr_t. The
>> correct answer is to use struct page *, but that is way too invasive for
>> this stage of a kernel release.
>>

So we have calls to set_memory_array_uc that used to take unsigned
long *, they now take
dma_addr_t *... this would be an issue.

Dave.

>> Dave.
>>
>>  drivers/char/agp/agp.h          |    8 ++++----
>>  drivers/char/agp/efficeon-agp.c |    2 +-
>>  drivers/char/agp/generic.c      |   15 ++++++---------
>>  drivers/char/agp/hp-agp.c       |    2 +-
>>  drivers/char/agp/i460-agp.c     |    2 +-
>>  drivers/char/agp/intel-agp.c    |   11 +++++++++--
>>  drivers/char/agp/parisc-agp.c   |    2 +-
>>  drivers/char/agp/sgi-agp.c      |    2 +-
>>  drivers/gpu/drm/drm_memory.c    |    3 ++-
>>  drivers/gpu/drm/drm_vm.c        |    4 ++--
>>  include/linux/agp_backend.h     |    4 ++--
>>  11 files changed, 30 insertions(+), 25 deletions(-)
>>
>> commit d5e4cc00c911a72709a8d012179980a6157ba552
>> Author: Brandon Philips <bphilips@suse.de>
>> Date:   Tue Oct 28 22:22:18 2008 -0700
>>
>>    intel-agp: Avoid oops for G33 on 1MB stolen case
>>
>>    This is similar to f443675affe3f16dd428e46f0f7fd3f4d703eeab which was
>>    reverted because it broke older X.org driver. This patch only fixes
>>    the 1MB stolen case since it causes an oops.
>>
>>    Xorg will not work without the accompanying patch[1] but avoiding an
>>    oops and making it possible to work with patched xorg driver is
>>    reasonable.
>>
>>    [1] http://ifup.org/~philips/review/xf86-video-intel-G33-1mb.patch
>>
>>    Explanation of the oops:
>>
>>    > static void intel_i830_init_gtt_entries(void)
>>    ...
>>    >         } else if (IS_G33) {
>>    >         /* G33's GTT size defined in gmch_ctrl */
>>    >                 switch (gmch_ctrl & G33_PGETBL_SIZE_MASK) {
>>    >                 case G33_PGETBL_SIZE_1M:
>>    >                         size = 1024;
>>    >                         break;
>>    ...
>>    >                 size += 4;
>>
>>    size = 1028
>>
>>    Then since we have the BIOS setting 1MB for the device in the GMCH
>>    control we get to here:
>>
>>    >         } else {
>>    >                 switch (gmch_ctrl & I855_GMCH_GMS_MASK) {
>>    >                 case I855_GMCH_GMS_STOLEN_1M:
>>    >                         gtt_entries = MB(1) - KB(size);
>>    >                         break;
>>
>>    MB(1) = 1 * 1024 * 1024
>>    KB(1028) = 1028 * 1024
>>
>>    MB(1) - KB(1028) = -4096
>>
>>    >         gtt_entries /= KB(4);
>>    >         intel_private.gtt_entries = gtt_entries;
>>
>>    We end up with -1 in gtt_entries.
>>
>>    This leads to intel_i915_configure reading/writing to areas outside of
>>    mapped memory and the oops.
>>
>>    Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=391261
>>
>>    Signed-off-by: Brandon Philips <bphilips@suse.de>
>>    Signed-off-by: Dave Airlie <airlied@linux.ie>
>>
>> commit b4f5dfa4b12efeea816a6f16ddb4c8851adbd39a
>> Author: Pierre Willenbrock <pierre@pirsoft.de>
>> Date:   Mon Nov 3 21:14:56 2008 -0800
>>
>>    agp: change physical address type from unsigned long to dma_addr_t
>>
>>    This fixes enough of the interface for i915 DRM with CONFIG_HIGHMEM64. It
>>    doesn't fix the physical addresses when passed to intelfb, mtrr or userspace.
>>
>>    airlied: This patch is sufficent to fix GEM use cases, we should overhaul AGP
>>    later to make it use struct page *, instead of this. AGP allocated pages are
>>    safe because we never use highmem pages, GEM allocated pages never use
>>    virt_to_*.
>>
>>    Signed-off-by: Pierre Willenbrock <pierre@pirsoft.de>
>>    Signed-off-by: Eric Anholt <eric@anholt.net>
>>    Signed-off-by: Dave Airlie <airlied@linux.ie>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
