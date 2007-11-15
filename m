Return-Path: <linux-kernel-owner+w=401wt.eu-S932244AbXKOVD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932244AbXKOVD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 16:03:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754726AbXKOVDV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 16:03:21 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:35154 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753756AbXKOVDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 16:03:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=OmKIg+aE5g5CEmqho52ZalId4OFxHouqCdjK8ND3d8VKydYcXbfTQVYthWzzcXR51LwDMR+4PE0XJ6+ReYW87Th2MB5i28EDgfyoVLlnqEI5IgNXZK8ttyVhWvYVf/CnL7xmnQbrBdUOOCUsNCmlU+S4deotlZ6NX3uh0quoPwI=  ;
X-YMail-OSG: nPAIZPsVM1mabjGLwcwENc73YQPbX8dvvL6FHUHyZEa1b2fbyfSDAfXzHHODkM.Q8WmUjoFf0w--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] slob: fix memory corruption
Date: Fri, 16 Nov 2007 07:25:12 +1100
User-Agent: KMail/1.9.5
Cc: David Miller <davem@davemloft.net>, mpm@selenic.com, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
References: <20071114225335.GV19691@waste.org> <20071115113204.GA24463@elte.hu> <20071115124844.GA6606@elte.hu>
In-Reply-To: <20071115124844.GA6606@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711160725.13067.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2007 23:48, Ingo Molnar wrote:
> > From: Nick Piggin <npiggin@suse.de>
> >
> > -		if (free_slob_pages.next != prev->next)
> > +		if (prev != free_slob_pages.prev &&
> > +				free_slob_pages.next != prev->next)
> >  			list_move_tail(&free_slob_pages, prev->next);
>
> btw., exactly how did you find this bug? User-space simulation of SLOB?

Yes. It was very useful in developing the improvements to the freelist
handling. The only reason why I don't release/run the code more often
is that my test harness work is pretty ugly (ie. it isn't just a simple
cp mm/slob.c ../blah/).

After that, just a loop of N iterations, within each iteration, there is
a chance of a single allocation of a random size, a single free of a
random outstanding allocation, a run of allocating MAX allocations, or
a run of freeing all previously allocated memory. It's a bit crude, but
it showed up your list head corruption in a second or two.
