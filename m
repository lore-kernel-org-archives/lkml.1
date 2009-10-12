Return-Path: <linux-kernel-owner+w=401wt.eu-S933071AbZJLTGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933071AbZJLTGi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 15:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933061AbZJLTGh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 15:06:37 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:58705 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933036AbZJLTGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 15:06:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=X5Hd5rBwqtFCHh6OPo1N82BZP78m1mvNkObP3X/2Pk/XojNgeA5U8tzQemsYLHK0jF
         SjWpORMxwrXvWr8mpp/hxG3Jk3GE8VRIBDxxrBYuI4rcXaMBl+kSQU4/glqvsgLyDSSZ
         hiC5esD+AIurq6IXKaN1mkAzgdx58inzdYIMM=
MIME-Version: 1.0
In-Reply-To: <20091012072642.3a06a271@infradead.org>
References: <bb145bd20910120701p70c176d9p85028da7afec094c@mail.gmail.com>
	 <20091012072642.3a06a271@infradead.org>
Date: Mon, 12 Oct 2009 21:05:59 +0200
Message-ID: <bb145bd20910121205t201b0eb5g74e9d31c82e3e4fa@mail.gmail.com>
Subject: Re: *Really* bad I/O latency with md raid5+dm-crypt+lvm
From: Christian Pernegger <pernegger@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> [Please keep me CCed as I'm not subscribed to LKML]
>>
>> Summary: I was hoping to use a layered storage setup, namely lvm on
>> dm-crypt on md raid5 for a new box I'm setting up, but that isn't
>> looking so good since a single heavyish writer will monopolise any and
>> all I/O on the "device". F. ex. while cp'ing a few GB of data from an
>> external disk to the array it takes ~10sec to run ls and ~2min to
>> start aptitude. Clueless attempts at a diagnosis below.

> Also note that dm-crypt is not "SMP-ready", so whatever hardware you have,
> it will only use once CPU - this may seriously limit the performance,
> depending on your usage and hardware.

The crypto performance itself is fine. Yes, it limits throughput to a
little over 100MiB/s but so what, that's plenty. Multi-core support
will come in time, I can wait. What I can't live with is a single
streaming write singlehandedly starving all reads. Linux has never
been great at this and it has been getting worse since ~2.6.18 but it
was never more than a nuisance (say <1sec delay).

It's as if the I/O scheduler weren't there.

> [latencytop? regular top?]

Actually I hadn't heard of latencytop but it looks nifty. Will have to
compile a custom kernel for it, though, since Debian kernels don't
have CONFIG_LATENCYTOP set.

Regular top has kcryptd (67%), mv (36%), md1_raid5 (36%), pdflush
(7%), kjournald (5%) at the top. Seems a bit much for md, doesn't it?
This is while mv'ing in some data from an sdditional SATA disk, lateny
isn't *too* bad, ~3s for an ls. According to iostat mv is writing to
the array at 50-60 MB/s. The fun part: it's using ~15000tps averaging
out to 4k per transaction as observed via btrace.

That can't be normal, can it?

Thanks,

C.
