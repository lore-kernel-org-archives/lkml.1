Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYI1JK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYI1JK6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2008 05:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751423AbYI1JKr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Sep 2008 05:10:47 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:8496 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbYI1JKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2008 05:10:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Piab+aDzeQ22aqAWGp0boLUvpMi/qxwe1LqyzGnqC+2WHhRg3TEqtXvC1w9hD+nA1E
         1pWPZAgT409HeTT2SjroO4yGLnarIP6U5qPar1S3x0X/RKBiA0NSqMKD6GKgl466XHex
         cYcZqQYflPRHXT2fQDnchl/9Irdhbvr6de7xE=
Message-ID: <86802c440809280210l4de854e6xf7416007034820d6@mail.gmail.com>
Date: Sun, 28 Sep 2008 02:10:45 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>, "Gabriel C" <nix.or.die@googlemail.com>
Subject: Re: [PATCH] x86: mtrr_cleanup hole size should be less than half of chunk_size v2
Cc: "Dylan Taft" <d13f00l@gmail.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080928071350.GA3624@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222572366-24424-1-git-send-email-yhlu.kernel@gmail.com>
	 <86802c440809272258x1c418f0j7f274dfdfd8a87f6@mail.gmail.com>
	 <20080928071350.GA3624@elte.hu>
X-Google-Sender-Auth: bbbdf5d38885a156
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2008 at 12:13 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> On Sat, Sep 27, 2008 at 8:26 PM, Yinghai Lu <yhlu.kernel@gmail.com> wrote:
>> > v2: should check with half of range0 size instead of chunk_size
>> >
>> > So don't have silly big hole.
>> >
>> > in hpa's case we could auto detect instead of adding mtrr_chunk_size in command line
>> >
>> > Ingo, please consider to squash this one to previous one
>> > |  commit 2313c2793d290a8cc37c428f8622c53f3fe1d6dc
>> > |  Author: Yinghai Lu <yhlu.kernel@gmail.com>
>> > |  Date:   Sat Sep 27 00:30:08 2008 -0700
>> > |
>> > |      x86: mtrr_cleanup optimization, v2
>> >
>> > Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> >
>>
>> Dylan,
>>
>> please try tip/master after Ingo put this patch into it...
>
> applied to tip/x86/mtrr, thanks Yinghai! I've also propagated it to
> tip/master and pushed it out, so Dylan could do a one-stop testing of
> tip/master.

Gabriel, can you check tip/mater too?
http://people.redhat.com/mingo/tip.git/readme.txt

from
reg00: base=0xd0000000 (3328MB), size= 256MB: uncachable, count=1
reg01: base=0xe0000000 (3584MB), size= 512MB: uncachable, count=1
reg02: base=0x00000000 (   0MB), size=4096MB: write-back, count=1
reg03: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg04: base=0x120000000 (4608MB), size= 128MB: write-back, count=1
reg05: base=0x128000000 (4736MB), size=  64MB: write-back, count=1
reg06: base=0xcf600000 (3318MB), size=   2MB: uncachable, count=1

you should get
Found optimal setting for mtrr clean up
gran_size: 1M   chunk_size: 16M         num_reg: 7      lose RAM: 0M
range0: 0000000000000000 - 00000000d0000000
Setting variable MTRR 0, base: 0MB, range: 2048MB, type WB
Setting variable MTRR 1, base: 2048MB, range: 1024MB, type WB
Setting variable MTRR 2, base: 3072MB, range: 256MB, type WB
hole: 00000000cf600000 - 00000000cf800000
Setting variable MTRR 3, base: 3318MB, range: 2MB, type UC
rangeX: 0000000100000000 - 000000012c000000
Setting variable MTRR 4, base: 4096MB, range: 512MB, type WB
Setting variable MTRR 5, base: 4608MB, range: 128MB, type WB
Setting variable MTRR 6, base: 4736MB, range: 64MB, type WB

instead of

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0x80000000 (2048MB), size=1024MB: write-back, count=1
reg02: base=0xc0000000 (3072MB), size= 256MB: write-back, count=1
reg03: base=0xcfe00000 (3326MB), size=   2MB: uncachable, count=1
reg04: base=0x100000000 (4096MB), size= 512MB: write-back, count=1
reg05: base=0x120000000 (4608MB), size= 256MB: write-back, count=1
reg06: base=0x12c000000 (4800MB), size=  64MB: uncachable, count=1

YH
