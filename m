Return-Path: <linux-kernel-owner+w=401wt.eu-S1753075AbZLWB1M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbZLWB1M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 20:27:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZLWB1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 20:27:10 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:18293 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbZLWB1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 20:27:10 -0500
Message-ID: <4B3171DF.4070903@caviumnetworks.com>
Date: Tue, 22 Dec 2009 17:26:55 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Alexander Beregalov <a.beregalov@gmail.com>
CC: arnd@arndb.de, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, sam@ravnborg.org,
       dhowells@redhat.com
Subject: Re: [PATCH] BUG(): CONFIG_BUG=n version of BUG() should be unreachable()
References: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
In-Reply-To: <1261531032-15225-1-git-send-email-a.beregalov@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Dec 2009 01:26:56.0442 (UTC) FILETIME=[03F421A0:01CA836F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Beregalov wrote:
> Previouss definition of BUG() as 'do {} while(0)' produced compilation
> warnings when BUG() was used in default branch of switch() statement
> (control reaches end of non-void function).
> 
> Example:
> unsigned long function()
> {
> 	switch() {
> 	case 1:
> 		return 1;
> 	case 2:
> 		return 2;
> 	default:
> 		BUG();
> }
> 
> Using unreachable() fixes the problem.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> 

NAK.


> diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
> index 18c435d..1106439 100644
> --- a/include/asm-generic/bug.h
> +++ b/include/asm-generic/bug.h
> @@ -89,7 +89,7 @@ extern void warn_slowpath_null(const char *file, const int line);
>  
>  #else /* !CONFIG_BUG */
>  #ifndef HAVE_ARCH_BUG
> -#define BUG() do {} while(0)
> +#define BUG() unreachable() 
>  #endif
>  
>  #ifndef HAVE_ARCH_BUG_ON

You can only use 'unreachable()' in situations where it is truly 
unreachable.  In the case above you will reach it in the default case.

I would suggest one of the following instead:

#define BUG() BUILD_BUG_ON(1)

#define BUG() do {} while(1)


David Daney
