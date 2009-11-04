Return-Path: <linux-kernel-owner+w=401wt.eu-S1755013AbZKDJjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbZKDJjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 04:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbZKDJjK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 04:39:10 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:48760 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753699AbZKDJjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 04:39:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=O7Ct63QYvDBPdoCD7WuZSE1I1p93eOel58NI1CyXou8hndwxv3Q3bDagmFpDWcSYyA
         I3PdfoEUKJVZTdcbxk+udQ4dg4Tkl/z4Sfq2byJ1WCvxCKaN26gXRGBToApHcEZkozRX
         qAYomJ75oqVuJzON6QRhc9Rl8sTdusg31nifI=
MIME-Version: 1.0
In-Reply-To: <20090915054259.5282e5ba@infradead.org>
References: <20090915054259.5282e5ba@infradead.org>
Date: Wed, 4 Nov 2009 10:39:13 +0100
Message-ID: <4e5e476b0911040139h1f471627la4262a5fa66abab0@mail.gmail.com>
Subject: Re: [PATCH v2] cpuidle: Fix the menu governor to boost IO performance
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       lenb@kernel.org, mingo@elte.hu, yanmin_zhang@linux.intel.com,
       jens.axboe@oracle.com, Ivan Kokshaysky <ink@jurassic.park.msu.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arjan,
On Tue, Sep 15, 2009 at 4:42 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> From: Arjan van de Ven <arjan@linux.intel.com>
> Subject: cpuidle: Fix the menu governor to boost IO performance
>
> Fix the menu idle governor which balances power savings, energy efficiency
> and performance impact.

I've tested this patch on an Atom based netbook with SSD, and I see
10% improvement in latencies for reading a single 4k block from disk.

During this test, while looking at powertop, I found that my CPU was
sitting in polling mode for milliseconds (percentage was however
negligible).
I never recalled seeing a non-zero time spent polling, so I looked at
the patch and found:
> +       /*
> +        * We want to default to C1 (hlt), not to busy polling
> +        * unless the timer is happening really really soon.
> +        */
> +       if (data->expected_us > 5)
> +               data->last_state_idx = CPUIDLE_DRIVER_STATE_START;
Commenting the if, (the previous behaviour), I no longer see the
polling, while I still get the performance improvement.

I wonder if that '5' is a bit too much. According to my BIOS ACPI
table, the Atom latency for C1 is ~ 1us, so there is very little
payback in polling on such processors. Should the check use the ACPI
declared C1 latency to decide whether we should poll or go to C1?

An other consideration is that sometimes, even if we expect to idle
for a short time, we end up idling for more (otherwise I would never
have seen ms polling, when expecting at most 5us). Should we set up a
timer, that would fire when switching to an higher C state would
conserve more energy?

Thanks,
Corrado
