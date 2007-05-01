Return-Path: <linux-kernel-owner+w=401wt.eu-S1423718AbXEAE0c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423718AbXEAE0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 00:26:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423647AbXEAE0c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 00:26:32 -0400
Received: from gw1.cosmosbay.com ([86.65.150.130]:47900 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423673AbXEAE0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 00:26:31 -0400
Message-ID: <4636C16F.204@cosmosbay.com>
Date: Tue, 01 May 2007 06:26:23 +0200
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: Andi Kleen <ak@suse.de>
CC: ebiederm@xmission.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [30/30] x86_64: Add missing !X86_PAE dependincy to the
 2G/2G split.
References: <20070501557.815359000@suse.de> <20070501035829.1C93D13CAF@wotan.suse.de>
In-Reply-To: <20070501035829.1C93D13CAF@wotan.suse.de>
Content-Type: multipart/mixed;
 boundary="------------040005090102030506060801"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [86.65.150.130]); Tue, 01 May 2007 06:26:29 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040005090102030506060801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit

Andi Kleen a écrit :
> From: ebiederm@xmission.com
> 
> When in PAE mode we require that the user kernel divide to be
> on a 1G boundary.  The 2G/2G split does not have that property
> so require !X86_PAE
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> ---
>  arch/i386/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
> index 1a94a73..80003de 100644
> --- a/arch/i386/Kconfig
> +++ b/arch/i386/Kconfig
> @@ -570,6 +570,7 @@ choice
>  		depends on !HIGHMEM
>  		bool "3G/1G user/kernel split (for full 1G low memory)"
>  	config VMSPLIT_2G
> +		depends on !X86_PAE
>  		bool "2G/2G user/kernel split"
>  	config VMSPLIT_1G
>  		bool "1G/3G user/kernel split"

Hum... We lose a usefull 2G/2G split. Should'nt we use a patch to change 
PAGE_OFFSET to 0x8000000 instead of 0x78000000 and keep 2G/2G split ?

Maybe the following patch is better ?

[PATCH] i386 : Adjust CONFIG_PAGE_OFFSET in case of 2G/2G split and X86_PAE

When in PAE mode we require that the user kernel divide to be
on a 1G boundary.  We must therefore make sure PAGE_OFFSET is correctlty 
defined in the 2G/2G split and PAE mode.

Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>

--------------040005090102030506060801
Content-Type: text/plain;
 name="i386_CONFIG_PAGE_OFFSET.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="i386_CONFIG_PAGE_OFFSET.patch"

diff --git a/arch/i386/Kconfig b/arch/i386/Kconfig
index 53d6237..32356f2 100644
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -578,7 +578,8 @@ endchoice
 config PAGE_OFFSET
 	hex
 	default 0xB0000000 if VMSPLIT_3G_OPT
-	default 0x78000000 if VMSPLIT_2G
+	default 0x78000000 if (VMSPLIT_2G && !X86_PAE)
+	default 0x80000000 if (VMSPLIT_2G && X86_PAE)
 	default 0x40000000 if VMSPLIT_1G
 	default 0xC0000000
 

--------------040005090102030506060801--
