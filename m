Return-Path: <linux-kernel-owner+w=401wt.eu-S1753502AbZEYWWH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbZEYWWH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 18:22:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbZEYWV4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 18:21:56 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:53548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715AbZEYWVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 18:21:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: monstr@monstr.eu, linux-arch@vger.kernel.org
Subject: Re: ipc64_perm - generic
Date: Mon, 25 May 2009 22:21:43 +0000
User-Agent: KMail/1.11.2 (Linux/2.6.29; KDE/4.2.2; x86_64; ; )
Cc: John Williams <john.williams@petalogix.com>, linux-kernel@vger.kernel.org,
       Arnd Bergmann <arnd@arndb.de>
References: <4A1AE972.9010905@monstr.eu>
In-Reply-To: <4A1AE972.9010905@monstr.eu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905252221.44082.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+DF0wAeLU7JXPhjXKjd/z74iZ3kO8bbu4mhQu
 nFDDmid5EUzb6n0Mjzdq3UbBm2d/y88KsQUfhCTGEZqy/MTwBk
 cfqhhISk8BFXtkvW2egaA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 May 2009 18:54:42 Michal Simek wrote:
> 
> Hi Arnd, cc: John
> 
> From asm-generic/posix_types.h
> 
> 17 #ifndef __kernel_mode_t
> 18 typedef unsigned int    __kernel_mode_t;
> 19 #endif
> 
> This structure is not aligned properly because of pad2.
> 
> 19 struct ipc64_perm {
> 20         __kernel_key_t          key;
> 21         __kernel_uid32_t        uid;
> 22         __kernel_gid32_t        gid;
> 23         __kernel_uid32_t        cuid;
> 24         __kernel_gid32_t        cgid;
> 25         __kernel_mode_t         mode;
> 26         unsigned short          __pad1;
> 27         unsigned short          seq;
> 28         unsigned short          __pad2;
> 29         unsigned long           __unused1;
> 30         unsigned long           __unused2;
> 31 };
> 
> I think we should remove __pad1.
> What do you think?

Right, well spotted.

I'd like to keep the struct ipc64_perm compatible with most architectures, so
maybe we can play a little trick here:

> Here is proposed struct.
>  struct ipc64_perm {
>          __kernel_key_t          key;
>          __kernel_uid32_t        uid;
>          __kernel_gid32_t        gid;
>          __kernel_uid32_t        cuid;
>          __kernel_gid32_t        cgid;
>          __kernel_mode_t         mode;

+	unsigned char __pad1[4 - sizeof(__kernel_mode_t)];

>          unsigned short          seq;
>          unsigned short          __pad2;
>          unsigned long           __unused1;
>          unsigned long           __unused2;
>  };

If that's too much of a hack, we could also change the default __kernel_mode_t
in asm-generic/posix_types.h to unsigned short, which it is on all 32-bit architectures
except mips and xtensa. For some reason, all 64 bit architechtures use unsigned
int for mode_t, but I couldn't find out why. Glibc uses unsigned int externally.

	Arnd <><
