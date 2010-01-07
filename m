Return-Path: <linux-kernel-owner+w=401wt.eu-S1752583Ab0AGR4V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0AGR4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 12:56:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752443Ab0AGR4U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 12:56:20 -0500
Received: from mail-fx0-f225.google.com ([209.85.220.225]:57210 "EHLO
	mail-fx0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409Ab0AGR4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 12:56:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iMiThzQ+I9D5Iq2Lj+Ti3aWiq+oh1pNyDFTYmob0vrdfQGy1omzopIcBr7T1fWQ3vY
         FGF1d/eJ5umjYRf1/pmDaqrSywezZwaw9rtIsXNU7wHWwqLvqnl2abUxZt3O88VZFVFg
         j0qVGgYexwVRK7oIF1ZS5FytFiOjOkcy2JJPY=
Date: Thu, 7 Jan 2010 18:56:10 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Michael Breuer <mbreuer@majjas.com>
Cc: Stephen Hemminger <shemminger@linux-foundation.org>,
       David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
       flyboy@gmail.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] af_packet: Don't use skb after dev_queue_xmit()
Message-ID: <20100107175610.GA3088@del.dom.local>
References: <4B454A16.3030909@majjas.com>
 <4B455C62.6030504@majjas.com>
 <20100106205343.5460d658@nehalam>
 <4B4571D5.30002@majjas.com>
 <4B457711.1040008@majjas.com>
 <4B458B36.6050509@majjas.com>
 <20100107074756.GB6258@ff.dom.local>
 <4B459368.2000503@majjas.com>
 <20100107082140.GB7229@ff.dom.local>
 <4B45F7D7.3060308@majjas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B45F7D7.3060308@majjas.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 10:03:51AM -0500, Michael Breuer wrote:
> On 1/7/2010 3:21 AM, Jarek Poplawski wrote:
> >On Thu, Jan 07, 2010 at 02:55:20AM -0500, Michael Breuer wrote:
> >>Unless I misread the code, I think that in some cases e skb is actually
> >>freed if the cfq (among others perhaps) scheduler returns an error on
> >>enqueue (flow control perhaps).  Thus with alternative 1, it is possible
> >>that the skb is acted upon after being freed - this would be consistent
> >>with the DMAR errors I saw.
> >I can't see your point: could you give some scenario?
> >
> >Jarek P.
> With NET_CLS_ACT set, net_dev_enqueue can return an error after
> freeing the skb. Alternative 1 disregards the error and assumes the
> skb is still valid. The original code and alternative 2 exit the
> loop assuming the skb has been freed.

Not exactly: alternative 1 disregards the error, and tries to send
next skbs if the message was longer. After consuming all the message
it returns without err code (at least wrt. dev_queue_xmit). This is
quite often practice to skip dev_queue_xmit() return (try to grep in
net\). It should never touch any part of an earlier sent skb.

Jarek P.
