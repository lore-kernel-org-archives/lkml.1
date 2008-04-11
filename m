Return-Path: <linux-kernel-owner+w=401wt.eu-S1759595AbYDKXLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759595AbYDKXLV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2008 19:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757540AbYDKXLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Apr 2008 19:11:11 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:36418 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756866AbYDKXLK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2008 19:11:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=x0kaKfrXaf+ZsMUhn8hIXn7GbxOodZ/D3G0lCxT29P1rxEAuPWKhGtV75NTPGeeEB/Pr7SKzHDoKmsSoKDzS9i4ZZIa/z5HCxxTubgYn/gejOL2pm0teWYj4b9sv2VmRF0FCcJHQulsEIV2nLVsCEm1jSGJkkKhDyjMg0IOOAMM=
Message-ID: <1f1b08da0804111611i39a8c4ddh9cda7dd68edac791@mail.gmail.com>
Date: Fri, 11 Apr 2008 16:11:09 -0700
From: "john stultz" <johnstul@us.ibm.com>
To: "James Courtier-Dutton" <James@superbug.co.uk>
Subject: Re: gettimeofday() jumping into the future
Cc: "Andi Kleen" <andi@firstfloor.org>, "Tim Ricketts" <tr@earth.li>,
       "Michael Smith" <msmith@xiph.org>, linux-kernel@vger.kernel.org,
       "Andy Wingo" <wingo@fluendo.com>, tglx@linutronix.de,
       "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <47F4D147.7060605@superbug.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <3c1737210708230408i7a8049a9m5db49e6c4d89ab62@mail.gmail.com>
	 <Pine.LNX.4.64.0803302210060.3056@falcon.foo>
	 <87r6dr8iq3.fsf@basil.nowhere.org> <47F4C3C2.8030004@superbug.co.uk>
	 <47F4CBF2.8020802@superbug.co.uk> <47F4D147.7060605@superbug.co.uk>
X-Google-Sender-Auth: 7b0637d7ebf6a0c6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 3, 2008 at 5:44 AM, James Courtier-Dutton
<James@superbug.co.uk> wrote:
>  It should be:
>  treat cycle_now and cycle_last as unsigned.
>  unsigned tmp;
>  tmp = cycle_now - cycle_last;
>  if (tmp > max_difference_threshold) cycle_now = cycle_last;
>
>  This correctly handles cycle_now going backwards as well as wrap around.
>
>  The only way to catch all edge cases is to be able to make an assumption
>  on the maximum acceptable difference between cycle_now and cycle_last,
>  where difference is the shortest distance between values if they were
>  pointers into a ring buffer. The other assumption made here is that the
> wrap around only happens at max_uint of cycle_now.

Yea. I see Thomas' patch was applied then reverted as it caused
problems with the TSC reseting over suspend and resume (since the
timekeeping core doesn't have a hook into the tsc clocksource to
inform it that the comparision is invalid, so the resume-time read
will always return the cycle_last value and not the actual smaller TSC
value).

This suggested bounding of how much a negative value is considered
valid would resolve this issue, since really the scope of this fix is
very small negative offsets due to the TSC being ever so slightly out
of sync between processors (but not enough to warrent throwing the TSC
out as a valid clock source).

-john
