Return-Path: <linux-kernel-owner+w=401wt.eu-S1758862AbZCMPeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758862AbZCMPeb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 11:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755518AbZCMPeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 11:34:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:55787 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753073AbZCMPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 11:34:20 -0400
Subject: Re: [tip:x86/mtrr] x86: more MTRR debug printouts
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, tglx@linutronix.de, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
References: <49B9BA5A.40108@kernel.org>
	 <tip-8ad9790588ee2e69118b2b294ddab6f3f0379ad9@git.kernel.org>
Content-Type: text/plain
Date: Fri, 13 Mar 2009 21:03:23 +0530
Message-Id: <1236958403.2646.1.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-03-13 at 02:34 +0000, Yinghai Lu wrote:
> Commit-ID:  8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> Gitweb:     http://git.kernel.org/tip/8ad9790588ee2e69118b2b294ddab6f3f0379ad9
> Author:     Yinghai Lu <yinghai@kernel.org>
> AuthorDate: Thu, 12 Mar 2009 18:43:54 -0700
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 02:52:18 +0100
> 
> x86: more MTRR debug printouts
> 
> Impact: improve MTRR debugging messages
> 
> There's still inefficiencies suspected with the MTRR sanitizing
> code, so make sure we get all the info we need from a dmesg.
> 
> - Remove unneeded mtrr_show
> 
>  (It will only printout one time by first cpu, so it is no big deal.)
> 
> - Also print out directly from get_mtrr, because it doesn't update mtrr_state.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> LKML-Reference: <49B9BA5A.40108@kernel.org>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
>  		*base = 0;
> @@ -407,6 +410,10 @@ static void generic_get_mtrr(unsigned int reg, unsigned long *base,
>  	*size = -mask_lo;
>  	*base = base_hi << (32 - PAGE_SHIFT) | base_lo >> PAGE_SHIFT;
>  	*type = base_lo & 0xff;
> +
> +	printk(KERN_DEBUG "  get_mtrr: cpu%d reg%02d base=%010lx size=%010lx %s\n",
> +			smp_processor_id(), reg, *base, *size,
> +			mtrr_attrib_to_str(*type & 0xff));
>  }
>  

This leads to:

Kernel failure message 1:
BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
caller is generic_get_mtrr+0x12a/0x146
Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
13 20:43:36 IST 2009
Call Trace:
 [<c0412cc3>] ? printk+0x14/0x16
 [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
 [<c010f0c3>] generic_get_mtrr+0x12a/0x146
 [<c010e351>] mtrr_add_page+0x154/0x332
 [<c010e7b1>] mtrr_file_add+0x72/0x86
 [<c010e9e0>] mtrr_ioctl+0x21b/0x309
 [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
 [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
 [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
 [<c0194101>] vfs_ioctl+0x27/0x6e
 [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
 [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
 [<c01898b0>] ? fget_light+0x40/0x130
 [<c01946ee>] sys_ioctl+0x34/0x61
 [<c0102c73>] sysenter_do_call+0x12/0x25


Kernel failure message 2:
BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
caller is generic_get_mtrr+0x12a/0x146
Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
13 20:43:36 IST 2009
Call Trace:
 [<c0412cc3>] ? printk+0x14/0x16
 [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
 [<c010f0c3>] generic_get_mtrr+0x12a/0x146
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c010e96f>] mtrr_ioctl+0x1aa/0x309
 [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
 [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
 [<c0194101>] vfs_ioctl+0x27/0x6e
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
 [<c017bfa5>] ? do_mmap_pgoff+0x1e3/0x22e
 [<c01898b0>] ? fget_light+0x40/0x130
 [<c01946ee>] sys_ioctl+0x34/0x61
 [<c0102c73>] sysenter_do_call+0x12/0x25
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90


Kernel failure message 3:
BUG: using smp_processor_id() in preemptible [00000000] code: Xorg/1983
caller is generic_get_mtrr+0x12a/0x146
Pid: 1983, comm: Xorg Not tainted 2.6.29-rc8-tip #81 SMP PREEMPT Fri Mar
13 20:43:36 IST 2009
Call Trace:
 [<c0412cc3>] ? printk+0x14/0x16
 [<c02357e3>] debug_smp_processor_id+0xbb/0xd4
 [<c010f0c3>] generic_get_mtrr+0x12a/0x146
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c010e96f>] mtrr_ioctl+0x1aa/0x309
 [<c01bc07d>] proc_reg_unlocked_ioctl+0x67/0xb2
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c010e7c5>] ? mtrr_ioctl+0x0/0x309
 [<c01bc016>] ? proc_reg_unlocked_ioctl+0x0/0xb2
 [<c0194101>] vfs_ioctl+0x27/0x6e
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90
 [<c0194680>] do_vfs_ioctl+0x46f/0x4a9
 [<c01898b0>] ? fget_light+0x40/0x130
 [<c01946ee>] sys_ioctl+0x34/0x61
 [<c0102c73>] sysenter_do_call+0x12/0x25
 [<c0104d03>] ? is_valid_bugaddr+0x7b/0x90

Thanks,
--
JSR

