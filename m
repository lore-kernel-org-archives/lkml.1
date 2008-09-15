Return-Path: <linux-kernel-owner+w=401wt.eu-S1754639AbYIOMqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639AbYIOMqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2008 08:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753342AbYIOMqo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Sep 2008 08:46:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:8257 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbYIOMqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2008 08:46:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=yDjWCVfE+wseloUSp1GSdiwcM7M3TJwYnhMiNzsoHPoTai4lcS52Njxr9UYQME1ntF
         XNFJQIDIEXFT19JjYRpSpSh+CqnCudxMPcLU4Zf9U+IDLLqk3WPtF5AIG5sf5Xw6E9tC
         yP2mMCvjLpfbJSU/wZhDc6BAYQ6JJV8sTLlkI=
Message-ID: <ac9c93b10809150546w7644316bk53122b0ce5021ff4@mail.gmail.com>
Date: Mon, 15 Sep 2008 14:46:41 +0200
From: "Frans Meulenbroeks" <fransmeulenbroeks@gmail.com>
To: "Rob Landley" <rob@landley.net>
Subject: Re: [PATCH] init: bzip2 or lzma -compressed kernels and initrds
Cc: "Willy Tarreau" <w@1wt.eu>, "Alain Knaff" <alain@knaff.lu>,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
In-Reply-To: <200809142037.48204.rob@landley.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200809062119.m86LJ5Of026101@hitchhiker.org.lu>
	 <20080907054831.GA2244@1wt.eu> <200809142037.48204.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/15 Rob Landley <rob@landley.net>:
> On Sunday 07 September 2008 00:48:31 Willy Tarreau wrote:
>> Hi Alain,
>> > +config KERNEL_LZMA
>> > +       bool "LZMA"
>> > +       help
>> > +         The most recent compression algorithm.
>> > +    Its ratio is best, decompression speed is between the other
>> > +    2. Compression is slowest.
>> > +    The kernel size is about 33 per cent smaller with lzma,
>> > +    in comparison to gzip.
>>
>> isn't memory usage in the same range as bzip2 ?
>
> Last I checked it was more.  (I very vaguely recall somebody saying 16 megs
> working space back when this was first submitted to busybox, but that was a
> few years ago...)
>
> A quick Google found a page that benchmarks them.  Apparently it depends
> heavily on which compression option you use:
>
> http://tukaani.org/lzma/benchmarks
>

[...]

Apologies if I'm sidetracking the discussion, but I'd like to coin a remark.

For kernel/ramfsimage etc the best choice is the one that has the
fastest decompression (info on tukaani.org says gzip).
Rationale: as it uncompresses faster the system will boot faster.

Of course this only holds if the background memory can hold that
image. For disk based systems, I assume this is not a problem at all,
but for embedded systems with all software in flash a higher
compression ration (e.g. lzma) can just make the difference between
fit and not fit (so in those cases lzma could just make your day).

Side note: although I think the conclusion at the tukaani website
holds, the data themselves are questionable.
I guess this is done on the internal hard disk of the laptop (this is
not specified). It would be better to do this on a ramfs to avoid
effects from data still being in the buffer cache (or not yet it).

Also the actual time in the tests is spent on three things: read from
disk, decompress, write to disk. (i'll only talk about decompress
here, guess an additional second or so to compress is not that
important).
You can argue that the latter is a constant as the same amount of data
is written, but the first one (the read time) depends on the actual
amount of data and the transfer rate of the device.
In case of slower devices it could well be that higher compression
yields a smaller image. If the reduction in read time is bigger than
the additional cost for the slower decompress, the net effect still
would be a win when it comes to boot time.

and finally: I've seen substantial timing differences when comparing
algorithms on different architectures (arm/mips/x86), so processor
might also make a difference on what is best. (and so will the
compiler).

FM
