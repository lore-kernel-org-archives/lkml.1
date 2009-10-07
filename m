Return-Path: <linux-kernel-owner+w=401wt.eu-S1759868AbZJGTNh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759868AbZJGTNh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 15:13:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758079AbZJGTNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 15:13:36 -0400
Received: from mail-fx0-f227.google.com ([209.85.220.227]:52383 "EHLO
	mail-fx0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759869AbZJGTNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 15:13:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=jq86y4DLSdQndXsvUfNvwx8uIYNCe7tlF8hAAH25PF5ZNxbraenJjO79QrdgyA8QPZ
         lmS73eZDkuRlIeQxFWPv5xfYCmv2in2hx084gFfeGF4cBy+n7y7VMc1IFl1SGrybrflP
         N1puf4qlbywij63wrntnLwPZJoyIIGN/daWcs=
Date: Wed, 7 Oct 2009 21:12:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: John Kacur <jkacur@redhat.com>
Cc: tglx@linutronix.de, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       Clark Williams <williams@redhat.com>
Subject: Re: [PATCH RFC] BKL not necessary in cpuid_open
Message-ID: <20091007191255.GD5903@nowhere>
References: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0910072016190.15183@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 07, 2009 at 08:19:32PM +0200, John Kacur wrote:
> 
> I've been staring at the BKL lock in cpuid_open, and I can't see what it 
> is protecting. However, I may have missed something - even something 
> obvious, so comments are welcome.
> 
> From 25c0f07b3ec5533c0e690e06198baa4300ee4a8c Mon Sep 17 00:00:00 2001
> From: John Kacur <jkacur@redhat.com>
> Date: Wed, 7 Oct 2009 20:06:12 +0200
> Subject: [PATCH] The BKL is not necessary in cpuid_open
>  Most of the variables are local to the function. It IS possible that for
>  struct cpuinfo_x86 *c
>  c could point to the same area. However, this is used read only.
> 
> Signed-off-by: John Kacur <jkacur@redhat.com>
> ---
>  arch/x86/kernel/cpuid.c |    3 ---
>  1 files changed, 0 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/kernel/cpuid.c b/arch/x86/kernel/cpuid.c
> index 6a52d4b..8bb8401 100644
> --- a/arch/x86/kernel/cpuid.c
> +++ b/arch/x86/kernel/cpuid.c
> @@ -118,8 +118,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
>  	struct cpuinfo_x86 *c;
>  	int ret = 0;
>  
> -	lock_kernel();
> -
>  	cpu = iminor(file->f_path.dentry->d_inode);
>  	if (cpu >= nr_cpu_ids || !cpu_online(cpu)) {
>  		ret = -ENXIO;	/* No such CPU */
> @@ -129,7 +127,6 @@ static int cpuid_open(struct inode *inode, struct file *file)
>  	if (c->cpuid_level < 0)
>  		ret = -EIO;	/* CPUID not supported */
>  out:
> -	unlock_kernel();
>  	return ret;
>  }



Everything look safe there.

Looking at what happens if the targeted cpu is removed:
I don't know if device_destroy() waits for the last reader to
complete on the given device file, but if it does, it's really
safe, if not:

- The cpu_data(cpu) won't be released anyway, only some values inside
  c will be changed, wich is not that a big issue, and the bkl
  doesn't help about that either

- We just checked if the cpu is online. It can be put offline
  just after. Whatever the bkl or not, it can also be put offline
  between open and read calls.

So I think this bkl doesn't protect anything.

Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

PS: We have the exact same pattern in arch/x86/kernel/msr.c:msr_open()

