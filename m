Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbYFBQ1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbYFBQ1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 12:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbYFBQ1a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 12:27:30 -0400
Received: from mailbox2.myri.com ([64.172.73.26]:1882 "EHLO myri.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752913AbYFBQ13 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 12:27:29 -0400
Message-ID: <48441F73.5040005@myri.com>
Date: Mon, 02 Jun 2008 18:27:31 +0200
From: Brice Goglin <brice@myri.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       "venkatesh.pallipadi@intel.com" <venkatesh.pallipadi@intel.com>
Subject: Re: howto use ioremap_wc?
References: <4841143E.5080003@myri.com> <20080531185424.1cd18220@infradead.org>
In-Reply-To: <20080531185424.1cd18220@infradead.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arjan van de Ven wrote:
> Brice Goglin <brice@myri.com> wrote
>> We're looking at using ioremap_wc() in myri10ge. No drivers seem to be
>> using it yet, so I'd like to get some clarification regarding
>> ioremap_wc failures, MTRR and so on.
>>
>> What we currently do is mtrr_add() and then ioremap. Depending on the
>> mtrr_add() success, we use the "wc_fifo" or regular PIO with fences to
>> submit requests to the NIC. 
>>     
>
> Ok this leads to a question: since write combining is effectively an
> extension (eg relaxation) to uncached, how much do you care if you
> actually get uncached? Eg can you just use the "WC" function even for
> the case where you get an uncached mapping ?
>   

WC is strictly required for our "wcfifo" path, but this path is actually
not so important nowadays. It is disabled by default and might even be
removed in the future. So, no, myri10ge itself does not really need to
know whether the mapping is actually WC.

The only case I see where it would be helpful is to avoid calling
mtrr_add when WC got enabled through PAT. See below.

> Actually it would make sense for the ioremap_wc() implementation to try
> to add an mtrr I suppose... it's better to be done there than trying to
> do it in some driver....
>   

Agreed, that would be nice!

>From what we discussed here after your reply, our plan is now to just
replace
    ioremap+mtrr_add
with
    ioremap_wc+mtrr_add

If mtrr_add() is moved into ioremap_wc(), we'll remove it from myri10ge.
For now, when PAT is enabled, we may have PAT + MTRR both doing WC, but
I don't think it can break anything, right?

thanks,
Brice

