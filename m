Return-Path: <linux-kernel-owner+w=401wt.eu-S1755415AbZHKTuA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755415AbZHKTuA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 15:50:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755086AbZHKTt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 15:49:59 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:59025 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbZHKTt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 15:49:58 -0400
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-ia64@vger.kernel.org,
       Neil Horman <nhorman@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
References: <20090811104144.5154.77871.sendpatchset@localhost.localdomain>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 11 Aug 2009 12:49:52 -0700
In-Reply-To: <20090811104144.5154.77871.sendpatchset@localhost.localdomain> (Amerigo Wang's message of "Tue\, 11 Aug 2009 06\:39\:22 -0400")
Message-ID: <m163cub067.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Rcpt-To: amwang@redhat.com, mingo@elte.hu, akpm@linux-foundation.org, andi@firstfloor.org, nhorman@redhat.com, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Amerigo Wang <amwang@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: Re: [RFC Patch 1/2] kexec: show memory info in /proc/iomem
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amerigo Wang <amwang@redhat.com> writes:

> This patch implements showing kexec memory area via /proc/iomem.
> For example, with this patch we can see:
>
> # cat /proc/iomem
> ...
> 00100000-7ffeffff : System RAM
>   01000000-012e1424 : Kernel code
>   012e1425-015f1aff : Kernel data
>   0166b000-01b4b88f : Kernel bss
>   02000000-083fffff : Crash kernel
>     02000000-028fffff : Used
>     02900000-083fffff : Unused
> ...
>
> So that user can know how much memory the kernel uses for crash kernel.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

We can inspect the image we are going to load to get this information.
In fact /sbin/kexec already inspects the image we are going to load
to get this information.  Putting this in the kernel adds kernel
complexity for no gain.


>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Neil Horman <nhorman@redhat.com>
> Cc: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Andi Kleen <andi@firstfloor.org>
>
>
> ---
> diff --git a/kernel/kexec.c b/kernel/kexec.c
> index f336e21..01673ad 100644
> --- a/kernel/kexec.c
> +++ b/kernel/kexec.c
> @@ -931,6 +931,8 @@ static int kimage_load_segment(struct kimage *image,
>   */
>  struct kimage *kexec_image;
>  struct kimage *kexec_crash_image;
> +struct resource *kexec_res = NULL;
> +struct resource *kexec_free_res = NULL;
>  
>  static DEFINE_MUTEX(kexec_mutex);
>  
> @@ -939,6 +941,8 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  {
>  	struct kimage **dest_image, *image;
>  	int result;
> +	unsigned long kexec_start = crashk_res.start;
> +	unsigned long kexec_end = kexec_start;
>  
>  	/* We only trust the superuser with rebooting the system. */
>  	if (!capable(CAP_SYS_BOOT))
> @@ -994,6 +998,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  			kimage_free(xchg(&kexec_crash_image, NULL));
>  			result = kimage_crash_alloc(&image, entry,
>  						     nr_segments, segments);
> +			kexec_end += KEXEC_CONTROL_PAGE_SIZE;
>  		}
>  		if (result)
>  			goto out;
> @@ -1008,6 +1013,42 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
>  			result = kimage_load_segment(image, &image->segment[i]);
>  			if (result)
>  				goto out;
> +			if (flags & KEXEC_ON_CRASH)
> +				kexec_end += image->segment[i].memsz;
> +		}
> +		if (flags & KEXEC_ON_CRASH) {
> +			if (kexec_res) {
> +				release_resource(kexec_res);
> +				release_resource(kexec_free_res);
> +				kfree(kexec_res);
> +				kfree(kexec_free_res);
> +			}
> +			kexec_res = kzalloc(sizeof(*kexec_res), GFP_KERNEL);
> +			if (!kexec_res) {
> +				result = -ENOMEM;
> +				goto out;
> +			}
> +			kexec_free_res = kzalloc(sizeof(*kexec_free_res), GFP_KERNEL);
> +			if (!kexec_free_res) {
> +				result = -ENOMEM;
> +				goto out_free;
> +			}
> +			kexec_res->name = "Used";
> +			kexec_res->start = kexec_start;
> +			kexec_res->end = roundup(kexec_end, 1<<20) - 1;
> +			kexec_res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
> +			if (insert_resource(&crashk_res, kexec_res)) {
> +				result = -EBUSY;
> +				goto out_free;
> +			}
> +			kexec_free_res->name = "Unused";
> +			kexec_free_res->start = kexec_res->end + 1;
> +			kexec_free_res->end = crashk_res.end;
> +			kexec_free_res->flags = IORESOURCE_BUSY | IORESOURCE_MEM;
> +			if (insert_resource(&crashk_res, kexec_free_res)) {
> +				result = -EBUSY;
> +				goto out_release;
> +			}
>  		}
>  		kimage_terminate(image);
>  	}
> @@ -1019,6 +1060,13 @@ out:
>  	kimage_free(image);
>  
>  	return result;
> +
> +out_free:
> +	kfree(kexec_free_res);
> +	kfree(kexec_res);
> +out_release:
> +	release_resource(kexec_res);
> +	goto out;
>  }
>  
>  #ifdef CONFIG_COMPAT
