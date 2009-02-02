Return-Path: <linux-kernel-owner+w=401wt.eu-S1756570AbZBBMTX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbZBBMTX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 07:19:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZBBMTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 07:19:14 -0500
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:36029 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810AbZBBMTN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 07:19:13 -0500
Date: Mon, 2 Feb 2009 12:12:31 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.anvils
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jgarzik@redhat.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       Mikael Pettersson <mikpe@it.uu.se>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
In-Reply-To: <4986DDA9.6010903@ru.mvista.com>
Message-ID: <Pine.LNX.4.64.0902021152220.17261@blonde.anvils>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
 <20090126191151.18b094e6@lxorguk.ukuu.org.uk> <Pine.LNX.4.64.0902012050190.16351@blonde.anvils>
 <4986DDA9.6010903@ru.mvista.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Feb 2009, Sergei Shtylyov wrote:
> Hugh Dickins wrote:
> > But this patch works as well for me as the patch I posted before
> > (though much more verbose: please simplify if you see a better way).
> 
>   How about the following?
> 
> 		unsigned char *tail = buf + buflen - slop;
> 		unsigned char pad[4];
> 
> 		if (rw == READ) {
> 			if (slop <= 2)
> 				ioread16_rep(data_addr, pad, 1);
> 			else
> 				ioread32_rep(data_addr, pad, 1);
> 					memcpy(tail, pad, slop);

Too many tabs on the memcpy.

> 		} else {
> 			memcpy(pad, tail, slop);
> 			memset(pad + slop, 0, 4 - slop);

And we could make that line even more complicated!
But I think unsigned char pad[4] = {0, 0, 0, 0} would be better.
Though Alan didn't have it initialized at all: I don't know if
that was oversight or superior knowledge.  In Alan's case, one
should usually assume the latter.

> 			if (slop <= 2)
> 				iowrite16_rep(data_addr, pad, 1);
> 			else
> 				iowrite32_rep(data_addr, pad, 1);
> 		}

Well, I don't know.  I felt really pleased with using ioread16_rep
and the char array in my original patch, where slop might be 1 or 2
or 3; but once it comes down to always one single PIO op, I felt
it too lazy to be using the _rep form.

I really don't care, whatever works and best satisfies Alan.

> > -	return words << 2;
> > +
> > +	return buflen + (buflen & 1);
> >   
> 
>    return (buflen + 1) & ~1;
> 
>   Well, I guess I could just have posted my own patch... :-)

Yes, do go ahead, I'm not desperate to get my name in there!

Hugh
