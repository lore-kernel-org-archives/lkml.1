Return-Path: <linux-kernel-owner+w=401wt.eu-S1764811AbYBZUGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764811AbYBZUGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 15:06:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754327AbYBZUGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 15:06:05 -0500
Received: from sandeen.net ([209.173.210.139]:12300 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYBZUGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 15:06:03 -0500
Message-ID: <47C47127.7040700@sandeen.net>
Date: Tue, 26 Feb 2008 12:05:59 -0800
From: Eric Sandeen <sandeen@sandeen.net>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: xfs-masters@oss.sgi.com
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Christoph Hellwig <hch@lst.de>,
       xfs@oss.sgi.com, johannes@sipsolutions.net,
       linux-kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [xfs-masters] Re: filesystem corruption on xfs after	2.6.25-rc1
 (bisected, powerpc related?)
References: <20080225112310.GA5516@soziologie.ch> <200802260052.57875.rjw@sisk.pl> <20080225235703.GA17530@lst.de> <200802260113.57875.rjw@sisk.pl> <20080226114419.GA5353@soziologie.ch>
In-Reply-To: <20080226114419.GA5353@soziologie.ch>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gaudenz Steinlin wrote:
> On Tue, Feb 26, 2008 at 01:13:56AM +0100, Rafael J. Wysocki wrote:
>> On Tuesday, 26 of February 2008, Christoph Hellwig wrote:
>>> On Tue, Feb 26, 2008 at 12:52:56AM +0100, Rafael J. Wysocki wrote:
>>>>> I'm not suggesting a partial revert; I just wonder which part of the
>>>>> change is causing the problem, as part of the debugging process.
> 
> I debuged this a bit further by testing the 4 changed functions
> individually. The problem only occurs with the new version of
> xfs_lowbit64. 

FWIW, Dave & I did some testing/debugging on 32-bit powerpc, and it is
indeed only xfs_lowbit64 which is doing the wrong thing on that arch,
because generic find_next_bit is doing the wrong thing on big-endian
32-bit systems, for sizes > 32 bits, near as I can tell.

Rather than reverting it all, I think just changing xfs_lowbit64 back to:

int
xfs_lowbit64(
       __uint64_t      v)
{
       __uint32_t      w = (__uint32_t)v;
       int             n = 0;

       if (w) {        /* lower bits */
               n = ffs(w);
       } else {        /* upper bits */
               w = (__uint32_t)(v >> 32);
               if (w && (n = ffs(w)))
                       n += 32;
       }
       return n - 1;
}

for now should fix it (this is essentially just ffs64())

-Eric
