Return-Path: <linux-kernel-owner+w=401wt.eu-S1753664AbZKEXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753664AbZKEXAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbZKEXAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:00:37 -0500
Received: from mail-gx0-f212.google.com ([209.85.217.212]:35895 "EHLO
	mail-gx0-f212.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752114AbZKEXAg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:00:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Y7oro7hcPe1qI62jB1iwsRDW3TzNx+eWvVL7lILXNc20gj13N0VFJUuTSO1lQeNpos
         hZhNkTlYkrhzCs2OhYn9AZSx4JN6la/7TOn8ygomIXthi1DsvQANFDv8W7+sqH05NOEU
         8bQ/Xy6r9fFAGLlSeSXyQCPYm0cWDfyM1kV70=
MIME-Version: 1.0
In-Reply-To: <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
References: <20091026172012.GC7233@duck.suse.cz>
	 <x49zl7020mr.fsf@segfault.boston.devel.redhat.com>
Date: Fri, 6 Nov 2009 00:00:40 +0100
Message-ID: <4e5e476b0911051500j7587dd6dh975148475418efcf@mail.gmail.com>
Subject: Re: Performance regression in IO scheduler still there
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Jan Kara <jack@suse.cz>, jens.axboe@oracle.com,
       LKML <linux-kernel@vger.kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jeff,
what hardware are you using for tests?
I see aggregated random read bandwidth is larger than sequential read
bandwidth, and write bandwidth greater than read.
Is this a SAN with multiple independent spindles?

On Thu, Nov 5, 2009 at 9:10 PM, Jeff Moyer <jmoyer@redhat.com> wrote:
> Jan Kara <jack@suse.cz> writes:
>
>>   Hi,
>>
>>   I took time and remeasured tiobench results on recent kernel. A short
>> conclusion is that there is still a performance regression which I reported
>> few months ago. The machine is Intel 2 CPU with 2 GB RAM and plain SATA
>> drive. tiobench sequential write performance numbers with 16 threads:
>> 2.6.29:              AVG       STDERR
>> 37.80 38.54 39.48 -> 38.606667 0.687475
>>
>> 2.6.32-rc5:
>> 37.36 36.41 36.61 -> 36.793333 0.408928
>>
>> So about 5% regression. The regression happened sometime between 2.6.29 and
>> 2.6.30 and stays the same since then... With deadline scheduler, there's
>> no regression. Shouldn't we do something about it?
>
> Sorry it took so long, but I've been flat out lately.  I ran some
> numbers against 2.6.29 and 2.6.32-rc5, both with low_latency set to 0
> and to 1.  Here are the results (average of two runs):
>
>                                                            rlat      |     rrlat       |     wlat       |  rwlat
> kernel     | Thr | read  | randr  | write  | randw  |    avg, max     |    avg, max     |   avg, max     | avg,max
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.29     |  8  | 72.95 |  20.06 | 269.66 | 231.59 |  6.625, 1683.66 | 23.241, 1547.97 | 1.761,  698.10 | 0.720, 443.64
>           | 16  | 72.33 |  20.03 | 278.85 | 228.81 | 13.643, 2499.77 | 46.575, 1717.10 | 3.304, 1149.29 | 1.011, 140.30
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.32-rc5 |  8  | 86.58 |  19.80 | 198.82 | 205.06 |  5.694, 977.26  | 22.559,  870.16 | 2.359,  693.88 | 0.530,  24.32
>           | 16  | 86.82 |  21.10 | 199.00 | 212.02 | 11.010, 1958.78 | 40.195, 1662.35 | 4.679, 1351.27 | 1.007,  25.36
> ------------------------------------------------------------------------------------------------------------------------
> 2.6.32-rc5 |  8  | 87.65 | 117.65 | 298.27 | 212.35 |  5.615,  984.89 |  4.060,   97.39 | 1.535,  311.14 | 0.534,  24.29
> low_lat=0  | 16  | 95.60 | 119.95*| 302.48 | 213.27 | 10.263, 1750.19 | 13.899, 1006.21 | 3.221,  734.22 | 1.062,  40.40
> ------------------------------------------------------------------------------------------------------------------------
>
> Legend:
> rlat - read latency
> rrlat - random read latency
> wlat - write lancy
> rwlat - random write latency
> * - the two runs reported vastly different numbers: 67.53 and 172.46
>
> So, as you can see, if we turn off the low_latency tunable, we get
> better numbers across the board with the exception of random writes.
> It's also interesting to note that the latencies reported by tiobench
> are more favorable with low_latency set to 0, which is
> counter-intuitive.
>
> So, now it seems we don't have a regression in sequential read
> bandwidth, but we do have a regression in random read bandwidth (though
> the random write latencies look better).  So, I'll look into that, as it
> is almost 10%, which is significant.
>

Sorry, I don't see a 10% regression in random read from your numbers.
I see a larger one  in sequential write for low_latency=1 (this was
the regression Jan reported in the original message), but not for
low_latency=0. And a 10% regression in random writes, that is not
completely fixed even by disabling low_latency.

I guess your seemingly counter-intuitive results for low_latency are
due to the uncommon hardware (low_latency was intended mainly for
desktop-class disks). Luckily, the patches queued for 2.6.33 already
address this low_latency misbehaviour.

Thanks,
Corrado.

> Cheers,
> Jeff
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
