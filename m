Return-Path: <linux-kernel-owner+w=401wt.eu-S1757664Ab0AOABT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757664Ab0AOABT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757158Ab0AOABS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:01:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45330 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757109Ab0AOABS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:01:18 -0500
Date: Fri, 15 Jan 2010 00:01:16 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, InKi Dae <inki.dae@samsung.com>,
       Kyungmin Park <kmpark@infradead.org>,
       Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH 2.6.33] s3c-fb: Fix divide by zero and broken output
Message-ID: <20100115000115.GA27344@opensource.wolfsonmicro.com>
References: <20100114102027.GC437@rakim.wolfsonmicro.main> <1263464783-14434-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20100114150658.643294f1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100114150658.643294f1.akpm@linux-foundation.org>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 14, 2010 at 03:06:58PM -0800, Andrew Morton wrote:

> Why on earth would you revert someone's patch and not tell them that
> you're doing it?

Through oversight, sorry - the original patch was an incremental update
to the driver rather than a reversion so I CCed the relevant maintainers
then and maintained the same CC list for the followup.

> This reversion will presumably break the Samsung SoC Framebuffer again.
> How about we not do that?

It's not entirely clear that there is any breakage to fix.  Certainly
the SMDK6410 I have works perfectly fine with the reversion, and I've
had a report that the hct board does too (which makes two out of the
three mainline users AFAICT).  Since none of the boards in mainline
supply a refresh parameter they'll all be failing with the current code.

Ben's analysis, which seemed reasonable to me, was that the patch is
based on a misunderstanding of the units in which the pixclk parameter
is specified.  He wrote:

| Thirdly he's changed the code to calculate the divider to assume pixclk
| is a frequency, and not a time-period. It clearly stats in the docs
| that pixclk is in picoseconds. Our clock rate is in Hz.

My understanding is that the breakage that was believed to exist was
based on the driver misbehaving if you supply the pixclk as a frequency,
which isn't surprising since that's what it's looking for.  The effect
of the patch is to change the interpretation of pixclk value so that a
refresh rate must also be specified but either way it should be possible
to specify a working configuration.

There's possibly a case to be made for changing the platform data over
to specify things differently, I'm not sufficiently familiar with the
area to say one way or another, but given that the original method works 
and existing machine are broken by the change it seems safer to revert
at least for -rc.
