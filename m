Return-Path: <linux-kernel-owner+w=401wt.eu-S1758823AbZLNXbX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758823AbZLNXbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 18:31:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbZLNXbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 18:31:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55337 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757582AbZLNXbT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 18:31:19 -0500
Date: Tue, 15 Dec 2009 10:31:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Kumar Gala <galak@kernel.crashing.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the 52xx-and-virtex tree with the  tree
Message-Id: <20091215103117.dab34f72.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

Today's linux-next merge of the 52xx-and-virtex tree got a conflict in
arch/powerpc/mm/fsl_booke_mmu.c between commit
8b27f0b61db57f5555fc2d3fc95c3ea9fd1a9d6c ("powerpc/fsl-booke: Rework TLB
CAM code") from Linus' tree and commit
ae4cec4736969ec2196a6bbce4ab263ff7cb7eef ("powerpc: fix up for
mmu_mapin_ram api change") from the 52xx-and-virtex tree.

I fixed it up (see below) and can carry the fix for a while.  Grant, you
can (of course) fix this by merging with Linus' tree.  (Or Linus, if you
merge Grant's tree, I think this fixup is correct).

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/powerpc/mm/fsl_booke_mmu.c
index fcfcb6e,6da4b90..0000000
--- a/arch/powerpc/mm/fsl_booke_mmu.c
+++ b/arch/powerpc/mm/fsl_booke_mmu.c
@@@ -172,44 -148,27 +172,44 @@@ static void settlbcam(int index, unsign
  	loadcam_entry(index);
  }
  
 -void invalidate_tlbcam_entry(int index)
 -{
 -	TLBCAM[index].MAS0 = MAS0_TLBSEL(1) | MAS0_ESEL(index);
 -	TLBCAM[index].MAS1 = ~MAS1_VALID;
 -
 -	loadcam_entry(index);
 -}
 -
 -unsigned long __init mmu_mapin_ram(unsigned long top)
 +unsigned long map_mem_in_cams(unsigned long ram, int max_cam_idx)
  {
 +	int i;
  	unsigned long virt = PAGE_OFFSET;
  	phys_addr_t phys = memstart_addr;
 +	unsigned long amount_mapped = 0;
 +	unsigned long max_cam = (mfspr(SPRN_TLB1CFG) >> 16) & 0xf;
 +
 +	/* Convert (4^max) kB to (2^max) bytes */
 +	max_cam = max_cam * 2 + 10;
  
 -	while (tlbcam_index < ARRAY_SIZE(cam) && cam[tlbcam_index]) {
 -		settlbcam(tlbcam_index, virt, phys, cam[tlbcam_index], PAGE_KERNEL_X, 0);
 -		virt += cam[tlbcam_index];
 -		phys += cam[tlbcam_index];
 -		tlbcam_index++;
 +	/* Calculate CAM values */
 +	for (i = 0; ram && i < max_cam_idx; i++) {
 +		unsigned int camsize = __ilog2(ram) & ~1U;
 +		unsigned int align = __ffs(virt | phys) & ~1U;
 +		unsigned long cam_sz;
 +
 +		if (camsize > align)
 +			camsize = align;
 +		if (camsize > max_cam)
 +			camsize = max_cam;
 +
 +		cam_sz = 1UL << camsize;
 +		settlbcam(i, virt, phys, cam_sz, PAGE_KERNEL_X, 0);
 +
 +		ram -= cam_sz;
 +		amount_mapped += cam_sz;
 +		virt += cam_sz;
 +		phys += cam_sz;
  	}
 +	tlbcam_index = i;
 +
 +	return amount_mapped;
 +}
  
- unsigned long __init mmu_mapin_ram(void)
 -	return virt - PAGE_OFFSET;
++unsigned long __init mmu_mapin_ram(unsigned long top)
 +{
 +	return tlbcam_addrs[tlbcam_index - 1].limit - PAGE_OFFSET + 1;
  }
  
  /*
