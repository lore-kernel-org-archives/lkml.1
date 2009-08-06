Return-Path: <linux-kernel-owner+w=401wt.eu-S1752703AbZHFIH1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703AbZHFIH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 04:07:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbZHFIH0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 04:07:26 -0400
Received: from mail-bw0-f213.google.com ([209.85.218.213]:34523 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZHFIHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 04:07:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=E1KSMInxmkh/5QHM/K/tp06nt5Yd97wTx1ajZfVOWhXL69J2t2xHN9YqStn3o7daMP
         k3tj3QCo0gR+CEc0FE6dsTpqzOaQnQXNF/xNIjGF+co7eoCm9qr7j9t8tueVgdmVjG/A
         n7+MHSIS3wfWsUXVtte8S3BXjuGAXFdtgl9oI=
Date: Thu, 6 Aug 2009 10:07:19 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Borislav Petkov <borislav.petkov@amd.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Li Zefan <lizf@cn.fujitsu.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: linux-next: manual merge of the edac-amd tree with the rr tree
Message-ID: <20090806080719.GB13566@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@googlemail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Borislav Petkov <borislav.petkov@amd.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	Li Zefan <lizf@cn.fujitsu.com>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Andreas Herrmann <andreas.herrmann3@amd.com>
References: <20090806175152.1e0b96cf.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20090806175152.1e0b96cf.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Aug 06, 2009 at 05:51:52PM +1000, Stephen Rothwell wrote:
> Hi Borislav,
> 
> Today's linux-next merge of the edac-amd tree got a conflict in
> arch/x86/kernel/smpboot.c between commit
> d39044d21e1a2d3713f1329ad22d23df5d20140b ("cpumask: use zalloc_cpumask_var
> () where possible") from the rr tree and commit
> a763af6587fbead6cee75ad3ae14709fa67e7dbb ("x86: provide CPU topology
> information for multi-node processors") from the edac-amd tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

I guess this is the best solution for now. Andreas' latest patches went
out yesterday and they too contain the

alloc_cpumask_var
cpumask_clear

order. Which means, this fix will have to be applied then between the
tip and the rr trees after Ingo merges Andreas' stuff, so please hold on
to it until after the merge window.

Thanks.

> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/x86/kernel/smpboot.c
> index 70bd79b,5428337..0000000
> --- a/arch/x86/kernel/smpboot.c
> +++ b/arch/x86/kernel/smpboot.c
> @@@ -1057,9 -1068,14 +1068,10 @@@ void __init native_smp_prepare_cpus(uns
>   #endif
>   	current_thread_info()->cpu = 0;  /* needed? */
>   	for_each_possible_cpu(i) {
>  -		alloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>  -		alloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
>  -		alloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
>  -		alloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
>  -		cpumask_clear(per_cpu(cpu_core_map, i));
>  -		cpumask_clear(per_cpu(cpu_node_map, i));
>  -		cpumask_clear(per_cpu(cpu_sibling_map, i));
>  -		cpumask_clear(cpu_data(i).llc_shared_map);
>  +		zalloc_cpumask_var(&per_cpu(cpu_sibling_map, i), GFP_KERNEL);
>  +		zalloc_cpumask_var(&per_cpu(cpu_core_map, i), GFP_KERNEL);
> ++		zalloc_cpumask_var(&per_cpu(cpu_node_map, i), GFP_KERNEL);
>  +		zalloc_cpumask_var(&cpu_data(i).llc_shared_map, GFP_KERNEL);
>   	}
>   	set_cpu_sibling_map(0);
>   
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Regards/Gruss,
    Boris.
