Return-Path: <linux-kernel-owner+w=401wt.eu-S1759485AbZDXNw3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759485AbZDXNw3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 09:52:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756571AbZDXNwV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 09:52:21 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55734 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756546AbZDXNwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 09:52:21 -0400
Date: Fri, 24 Apr 2009 09:51:21 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Daney <ddaney@caviumnetworks.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Introduce a boolean "single_bit_set" function.
In-Reply-To: <20090423165723.16c9f566.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.2.00.0904240948550.17112@localhost.localdomain>
References: <alpine.LFD.2.00.0904231339080.13089@localhost.localdomain> <49F0C817.8050407@caviumnetworks.com> <20090423165723.16c9f566.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Apr 2009, Andrew Morton wrote:

> On Thu, 23 Apr 2009 12:57:11 -0700
> David Daney <ddaney@caviumnetworks.com> wrote:
>
> > > +static inline __attribute__((const))
> > > +bool single_bit_set(unsigned long n)
> > > +{
> > > +        return (n != 0 && ((n & (n - 1)) == 0));
> > > +}
> > > +
> > > +
> >
> >
> > It would be nice to be able to override this per architecture.
> >
> > For example a more efficient implementation on CPUs that have a
> > population count instruction (__builtin_popcountl()) might be:
> >
> > static inline __attribute__((const))
> > bool singe_bit_set(unsigned long n)
> > {
> > 	return __builtin_popcountl(n) == 1;
> > }
>
> Already done, via hweight_long().

  i'm guessing that taking advantage of helper functions like that
might simplify code like, say, this from fs/nfs/internal.h:

/*
 * Determine the actual block size (and log2 thereof)
 */
static inline
unsigned long nfs_block_bits(unsigned long bsize, unsigned char *nrbitsp)
{
        /* make sure blocksize is a power of two */
        if ((bsize & (bsize - 1)) || nrbitsp) {
                unsigned char   nrbits;

                for (nrbits = 31; nrbits && !(bsize & (1 << nrbits)); nrbits--)
                        ;
                bsize = 1 << nrbits;
                if (nrbitsp)
                        *nrbitsp = nrbits;
        }

        return bsize;
}


  surely, there's a simpler way to write that.

rday
--

========================================================================
Robert P. J. Day                               Waterloo, Ontario, CANADA

        Linux Consulting, Training and Annoying Kernel Pedantry.

Web page:                                          http://crashcourse.ca
Linked In:                             http://www.linkedin.com/in/rpjday
Twitter:                                       http://twitter.com/rpjday
========================================================================
