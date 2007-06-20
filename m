Return-Path: <linux-kernel-owner+w=401wt.eu-S1757353AbXFTTvP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbXFTTvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2007 15:51:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756788AbXFTTu7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jun 2007 15:50:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:36934 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216AbXFTTu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2007 15:50:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:from:x-x-sender:to:cc:subject:in-reply-to:
	message-id:references:mime-version:content-type;
	b=xhyBbRt3oJUXwZza1jMXSj3dKwgOqBBPjEerLqvn6XQ3b3xFSJJMgrhNVXcwS2Y+G
	YdQFX99lvb+2qcsyRIp4A==
Date: Wed, 20 Jun 2007 12:45:35 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Robert Richter <robert.richter@amd.com>
cc: Stephane Eranian <eranian@hpl.hp.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 1/8] 2.6.22-rc3 perfmon2 : Barcelona CPU detection
In-Reply-To: <20070620184102.GB5874@erda.amd.com>
Message-ID: <alpine.DEB.0.99.0706201244160.4562@chino.kir.corp.google.com>
References: <20070620182126.248753000@amd.com>
 <20070620184102.GB5874@erda.amd.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Jun 2007, Robert Richter wrote:

> Index: linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> ===================================================================
> --- linux-2.6.22-rc3.orig/arch/x86_64/perfmon/perfmon_k8.c
> +++ linux-2.6.22-rc3/arch/x86_64/perfmon/perfmon_k8.c
> @@ -307,7 +307,12 @@ static int pfm_k8_probe_pmu(void)
>  		return -1;
>  	}
>  
> -	if (current_cpu_data.x86 != 15) {
> +	switch (current_cpu_data.x86) {
> +	case 15:
> +	case 16:
> +		PFM_INFO("found family=%d", current_cpu_data.x86);
> +		break;
> +	default:
>  		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
>  		return -1;
>  	}

This still shouldn't be a switch clause because you're hiding the return 
-1; in the default label.  I think it would be better to write:

	if (current_cpu_data.x86 == 15 || current_cpu_data.x86 == 16)
		PFM_INFO("found family=%d", current_cpu_data.x86);
	else {
		PFM_INFO("unsupported family=%d", current_cpu_data.x86);
		return -1;
	}
