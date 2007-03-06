Return-Path: <linux-kernel-owner+w=401wt.eu-S965402AbXCFSAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965402AbXCFSAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:00:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965419AbXCFSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:00:32 -0500
Received: from terminus.zytor.com ([192.83.249.54]:36213 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965402AbXCFSAb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:00:31 -0500
Message-ID: <45EDABC8.8040901@zytor.com>
Date: Tue, 06 Mar 2007 09:58:32 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20070212)
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order()
References: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
In-Reply-To: <20070306173929.2708.37191.stgit@warthog.cambridge.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells wrote:
> From: David Howells <dhowells@redhat.com>
> 
> Fix get_order() to use ilog2() properly.
> 
> Signed-Off-By: David Howells <dhowells@redhat.com>
> ---
> 
>  include/asm-generic/page.h |   14 +++++++++++---
>  include/linux/log2.h       |   20 ++++++++++++++++++--
>  2 files changed, 29 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/page.h b/include/asm-generic/page.h
> index b55052c..c37571d 100644
> --- a/include/asm-generic/page.h
> +++ b/include/asm-generic/page.h
> @@ -17,10 +17,18 @@ static inline __attribute__((const))
>  int __get_order(unsigned long size, int page_shift)
>  {
>  #if BITS_PER_LONG == 32 && defined(ARCH_HAS_ILOG2_U32)
> -	int order = __ilog2_u32(size) - page_shift;
> +	int order;
> +	if (size <= 1)
> +		order = 0;
> +	else
> +		order = __ilog2_u32(size - 1) + 1 - page_shift;
>  	return order >= 0 ? order : 0;

This seems a lot more complex than it should be.

Assuming page_shift is usually constant, it would seem to make more 
sense to do:

	if (size <= (1UL << page_shift))
		return 0;
	else
		return __ilog2_u32(size-1)+1-page_shift;

... instead of having *two* conditionals...

	-hpa
