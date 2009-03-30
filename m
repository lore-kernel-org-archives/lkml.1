Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbZC3Tl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbZC3Tl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 15:41:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760221AbZC3TlM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:41:12 -0400
Received: from rcsinet13.oracle.com ([148.87.113.125]:28141 "EHLO
	rgminet13.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212AbZC3TlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:41:10 -0400
Cc: linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org
Message-Id: <56E66BF1-FBC8-4727-AB62-3BF2A97979F1@oracle.com>
From: Chuck Lever <chuck.lever@oracle.com>
To: Mans Rullgard <mans@mansr.com>
In-Reply-To: <1238270120-31501-1-git-send-email-mans@mansr.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v930.3)
Subject: Re: [PATCH] NSM: Fix unaligned accesses in nsm_init_private()
Date: Mon, 30 Mar 2009 15:40:49 -0400
References: <1238270120-31501-1-git-send-email-mans@mansr.com>
X-Mailer: Apple Mail (2.930.3)
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.49D12047.0008:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mar 28, 2009, at 3:55 PM, Mans Rullgard wrote:
> This fixes unaligned accesses in nsm_init_private() when
> creating nlm_reboot keys.
>

Reviewed-by: Chuck Lever <chuck.lever@oracle.com>

Did a little testing on x86 as well.

> Signed-off-by: Mans Rullgard <mans@mansr.com>
> ---
> fs/lockd/mon.c |    8 ++++++--
> 1 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/fs/lockd/mon.c b/fs/lockd/mon.c
> index 5e2c4d5..6d5d4a4 100644
> --- a/fs/lockd/mon.c
> +++ b/fs/lockd/mon.c
> @@ -16,6 +16,8 @@
> #include <linux/sunrpc/svc.h>
> #include <linux/lockd/lockd.h>
>
> +#include <asm/unaligned.h>
> +
> #define NLMDBG_FACILITY		NLMDBG_MONITOR
> #define NSM_PROGRAM		100024
> #define NSM_VERSION		1
> @@ -274,10 +276,12 @@ static void nsm_init_private(struct nsm_handle  
> *nsm)
> {
> 	u64 *p = (u64 *)&nsm->sm_priv.data;
> 	struct timespec ts;
> +	s64 ns;
>
> 	ktime_get_ts(&ts);
> -	*p++ = timespec_to_ns(&ts);
> -	*p = (unsigned long)nsm;
> +	ns = timespec_to_ns(&ts);
> +	put_unaligned(ns, p);
> +	put_unaligned((unsigned long)nsm, p + 1);
> }
>
> static struct nsm_handle *nsm_create_handle(const struct sockaddr  
> *sap,
> -- 
> 1.6.2
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs"  
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
Chuck Lever
chuck[dot]lever[at]oracle[dot]com
