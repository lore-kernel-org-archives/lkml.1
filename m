Return-Path: <linux-kernel-owner+w=401wt.eu-S1752121AbYI1F6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbYI1F6Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 01:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751073AbYI1F6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 01:58:18 -0400
Received: from rv-out-0506.google.com ([209.85.198.237]:55329 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049AbYI1F6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 01:58:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=c0EThgbYIj+sMSeQv2brhwZflFO34ux3u/LKaT5+qWqhqr971Op9ItVgmdHkTmcJuY
         Uw1WaEngm7B3vHFtcwYKEj+T5ZtU4q6pPpiYTtCl6NM9Z3pqEwE/zT2wSw5u3G9BrZ9i
         FIvhsbEGotlZ9NGUiyx2woVAw5pD6XWMpK3GY=
Message-ID: <86802c440809272258x1c418f0j7f274dfdfd8a87f6@mail.gmail.com>
Date: Sat, 27 Sep 2008 22:58:16 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Dylan Taft" <d13f00l@gmail.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH] x86: mtrr_cleanup hole size should be less than half of chunk_size v2
Cc: linux-kernel@vger.kernel.org, "Yinghai Lu" <yhlu.kernel@gmail.com>
In-Reply-To: <1222572366-24424-1-git-send-email-yhlu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222572366-24424-1-git-send-email-yhlu.kernel@gmail.com>
X-Google-Sender-Auth: 3c65c86ecb041402
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2008 at 8:26 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
> v2: should check with half of range0 size instead of chunk_size
>
> So don't have silly big hole.
>
> in hpa's case we could auto detect instead of adding mtrr_chunk_size in command line
>
> Ingo, please consider to squash this one to previous one
> |  commit 2313c2793d290a8cc37c428f8622c53f3fe1d6dc
> |  Author: Yinghai Lu <yhlu.kernel@gmail.com>
> |  Date:   Sat Sep 27 00:30:08 2008 -0700
> |
> |      x86: mtrr_cleanup optimization, v2
>
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>

Dylan,

please try tip/master after Ingo put this patch into it...

from
reg00: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg01: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg02: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
reg03: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg04: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg05: base=0xc7e00000 (3198MB), size=   2MB: uncachable, count=1
reg06: base=0xc8000000 (3200MB), size= 128MB: uncachable, count=1

you should get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 256M        num_reg: 7      lose RAM: 0M
range0: 0000000000000000 - 00000000d0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
hole: 00000000c7e00000 - 00000000d0000000
Setting variable MTRR 3, base: 3198MB, range: 2MB, type UC
Setting variable MTRR 4, base: 3200MB, range: 128MB, type UC
rangeX: 0000000100000000 - 0000000130000000
Setting variable MTRR 5, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 6, base: 4608MB, range: 256MB, type WB


with mtrr_spare_reg_nr=2 you should get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 4M        num_reg: 6      lose RAM: 0M
range0: 0000000000000000 - 00000000c8000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 128MB, type WB
hole: 00000000c7e00000 - 00000000c8000000
Setting variable MTRR 3, base: 3198MB, range: 2MB, type UC
rangeX: 0000000100000000 - 0000000130000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 256MB, type WB
