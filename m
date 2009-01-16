Return-Path: <linux-kernel-owner+w=401wt.eu-S932518AbZAPKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518AbZAPKh7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 05:37:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755060AbZAPKhl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 05:37:41 -0500
Received: from mail-out2.uio.no ([129.240.10.58]:40926 "EHLO mail-out2.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754050AbZAPKhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 05:37:38 -0500
X-Greylist: delayed 1422 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Jan 2009 05:37:38 EST
Message-ID: <e5152d316be79cafaf55fcf7bff64d46.squirrel@webmail.uio.no>
In-Reply-To: <Pine.LNX.4.64.0901121705010.1889@wrl-59.cs.helsinki.fi>
References: <496B59B7.3010302@simula.no>
    <Pine.LNX.4.64.0901121705010.1889@wrl-59.cs.helsinki.fi>
Date: Fri, 16 Jan 2009 11:13:53 +0100 (CET)
Subject: Re: RFC: Latency reducing TCP modifications for thin-stream 
     interactive applications
From: kristrev@simula.no
To: Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>
Cc: "Andreas Petlund" <apetlund@simula.no>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       linux-net@vger.kernel.org, "LKML" <linux-kernel@vger.kernel.org>,
       linux-rt-users@vger.kernel.org, mdavem@davemloft.net, jgarzik@pobox.com,
       kohari@novell.com, peterz@infradead.org, jzemlin@linux-foundation.org,
       mrexx@linux-foundation.org, tytso@mit.edu, mingo@elte.hu,
       kristrev@simula.no, griff@simula.no, paalh@ifi.uio.no,
       "Netdev" <netdev@vger.kernel.org>, shemminger@vyatta.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 68CD77A596A49D0EA67131FEB0EE5385157B858D
X-UiO-SPAM-Test: remote_host: 129.240.4.214 spam_score: -49 maxlevel 200 minaction 1 bait 0 mail/h: 112 total 726867 max/h 678 blacklist 0 greylist 1 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ilpo,

>> We have to admit we don't quite see the problem. Since a page can never
>> be removed before all owners have decleared that they no longer needs
>> it, all data will be correctly present. Also, since the packets are
>> placed linearly on the queue and we don't support when SACK is enabled,
>> no gaps will occur. But maybe we have misunderstood your comment, please
>> let us know if that is the case.
>
> Yes, the problems _may_ arise because you create afaict:
> skb->end_seq > next_skb->seq situations which is something that certainly
> needs an audit over every single seqno operation to see that they don't
> implicitly assume otherwise (ie., omit redundant compares)! There are
> certainly places I know of already which will break... I'm afraid
> that using the approach you've select you'll end up having very many
> places needing some extra tweaking, that's why I suggested the alternative
> approach to just construct the redundant things on-the-fly while keeping
> the write queue as is.
>

>> As far as we understand this comment, you want us to do it on the
>> application layer instead? Do you mean as a middleware,
>> application-specific solution or something similar? Also, we believe
>> doing it on the application layer will lead to the same delays that we
>> try to prevent, since sent data will be delayed on the transport layer
>> in case of loss.
>
> No but at the time we're supposed to actually send an skb to the lower
> layer and keeping the rest intact.

I have a small question regarding these two comments. Are you allowed to
modify the packet data stored in a clone? Based on my understanding of the
code and what a clone is, I thought the data was shared between the
original and the clone. Thus, any data appended/inserted into the clone
will also be appended to the original.

If I have understood the code correctly, what will then be the difference
between our current solution and the one you suggest (except we can remove
one of the bundling methods and when a packet is retransmitted)? If I have
not understood the code correctly, feel free to yell :) (if it is a
misunderstanding, it also explains all the checks for skb->cloned).

-Kristian

