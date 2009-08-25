Return-Path: <linux-kernel-owner+w=401wt.eu-S1755357AbZHYRDn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357AbZHYRDn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 13:03:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755297AbZHYRDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 13:03:42 -0400
Received: from mail-px0-f182.google.com ([209.85.216.182]:35870 "EHLO
	mail-px0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755286AbZHYRDm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 13:03:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iAy+yyR6hCunEcmXcj6mGV0g6NGDtUUPn/NH6JHhVhUbEhOfS6YEKwovmV7Cvz2vaX
         pzWaGf/PYT6QlmGQxgnW0dYsumaW/yp96mIQIdn1xKSdNOqrqcbfgogewBss65LWZJsN
         KVdAbhc2oci47DPtGB06/syX/mbKLBdVO0RfI=
MIME-Version: 1.0
In-Reply-To: <200908241008.02184.ngupta@vflare.org>
References: <200908241008.02184.ngupta@vflare.org>
Date: Tue, 25 Aug 2009 22:33:43 +0530
X-Google-Sender-Auth: cd309ace919e66d7
Message-ID: <661de9470908251003y3db1fb3awb648f9340cd0beb4@mail.gmail.com>
Subject: Re: [PATCH 4/4] compcache: documentation
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, linux-mm-cc@laptop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 24, 2009 at 10:08 AM, Nitin Gupta<ngupta@vflare.org> wrote:
> Short guide on how to setup and use ramzswap.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> ---
>
>  Documentation/blockdev/00-INDEX     |    2 +
>  Documentation/blockdev/ramzswap.txt |   52 +++++++++++++++++++++++++++++++++++
>  2 files changed, 54 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/blockdev/00-INDEX b/Documentation/blockdev/00-INDEX
> index c08df56..c1cb074 100644
> --- a/Documentation/blockdev/00-INDEX
> +++ b/Documentation/blockdev/00-INDEX
> @@ -16,3 +16,5 @@ paride.txt
>        - information about the parallel port IDE subsystem.
>  ramdisk.txt
>        - short guide on how to set up and use the RAM disk.
> +ramzswap.txt
> +       - short guide on how to setup compressed in-memory swap device.
> diff --git a/Documentation/blockdev/ramzswap.txt b/Documentation/blockdev/ramzswap.txt
> new file mode 100644
> index 0000000..463dd2d
> --- /dev/null
> +++ b/Documentation/blockdev/ramzswap.txt
> @@ -0,0 +1,52 @@
> +ramzswap: Compressed RAM based swap device
> +-------------------------------------------
> +
> +Project home: http://compcache.googlecode.com/
> +
> +* Introduction
> +
> +It creates RAM based block devices which can be used (only) as swap disks.
> +Pages swapped to these devices are compressed and stored in memory itself.
> +See project home for use cases, performance numbers and a lot more.
> +
> +It consists of three modules:
> + - xvmalloc.ko: memory allocator

I've seen your case for a custom allocator, but why can't we

1) Refactor slob and use it
2) Do we care about the optimizations in SLUB w.r.t. scalability in
your module? If so.. will xvmalloc meet those requirements?

> + - ramzswap.ko: virtual block device driver
> + - rzscontrol userspace utility: to control individual ramzswap devices
> +
> +* Usage
> +
> +Following shows a typical sequence of steps for using ramzswap.
> +
> +1) Load Modules:
> +       modprobe ramzswap NUM_DEVICES=4
> +       This creates 4 (uninitialized) devices: /dev/ramzswap{0,1,2,3}
> +       (NUM_DEVICES parameter is optional. Default: 1)
> +
> +2) Initialize:
> +       Use rzscontrol utility to configure and initialize individual
> +       ramzswap devices. Example:
> +       rzscontrol /dev/ramzswap2 --init # uses default value of disksize_kb
> +
> +       *See rzscontrol manpage for more details and examples*
> +
> +3) Activate:
> +       swapon /dev/ramzswap2 # or any other initialized ramzswap device
> +
> +4) Stats:
> +       rzscontrol /dev/ramzswap2 --stats
> +
> +5) Deactivate:
> +       swapoff /dev/ramzswap2
> +
> +6) Reset:
> +       rzscontrol /dev/ramzswap2 --reset
> +       (This frees all the memory allocated for this device).

What level of compression have you observed? Any speed trade-offs?

Balbir
