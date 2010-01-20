Return-Path: <linux-kernel-owner+w=401wt.eu-S1753277Ab0ATXGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab0ATXGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 18:06:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986Ab0ATXGU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 18:06:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38405 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207Ab0ATXGT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 18:06:19 -0500
Message-ID: <4B578C0E.5090709@zytor.com>
Date: Wed, 20 Jan 2010 15:04:46 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-4.fc12 Thunderbird/3.0
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: mingo@elte.hu, tglx@linutronix.de, andreas.herrmann3@amd.com,
       x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86, cacheinfo: Fix disabling of L3 cache indexes
References: <1263899279-30739-1-git-send-email-bp@amd64.org> <1263899279-30739-2-git-send-email-bp@amd64.org>
In-Reply-To: <1263899279-30739-2-git-send-email-bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/19/2010 03:07 AM, Borislav Petkov wrote:
>  
> +static void __wbinvd(void *dummy)
> +{
> +	asm volatile("wbinvd" : : : "memory");
> +}
> +

[...]

> +	smp_call_function_single(cpu, __wbinvd, NULL, 1);

I really don't like this combination.

First of all, it's an asm version of an instruction we already have
macros for.  This should probably just be wbinvd(), or *possibly*
native_wbinvd(), although that would have to be justified -- especially
since the preexisting code used wbinvd().

Second, it's pretty obvious that the only reason for this function at
all is to provide a wrapper that can be passed to smp_call_function*().
 It would be a lot cleaner to have a small function wbinvd_on_cpu(cpu)
as a wrapper for the higher-order functionality.

	-hpa
