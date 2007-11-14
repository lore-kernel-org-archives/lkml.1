Return-Path: <linux-kernel-owner+w=401wt.eu-S1756971AbXKNMab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971AbXKNMab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 07:30:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbXKNMaX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 07:30:23 -0500
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:38721 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754714AbXKNMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 07:30:22 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Disposition:Message-Id:Content-Type:Content-Transfer-Encoding;
  b=q/dz+ykCMCCkbTKfawDcBE9HalzS9R0VKr4lKyxCFUTh0w7AV0+3h1nU9560q2o/Jea/phAPiNIOnUEHO1ByInpH3uZGzqGtY6cUsM+XsgwUt+JbapJiFPKMHLi9CBIT4/2wB3oVNNEziyOFzX/8/VZwqqSdvDgDc5W0VCbJnXM=  ;
X-YMail-OSG: 8jaaltEVM1nHKk6SWtB4sgW161yzUX61UpYVM_35hzfly7hf2zWkyCx0kldQUcuBqsncQTDsrw--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: David Miller <davem@davemloft.net>
Subject: Re: [perfmon] Re: [perfmon2] perfmon2 merge news
Date: Wed, 14 Nov 2007 11:25:17 +1100
User-Agent: KMail/1.9.5
Cc: paulus@samba.org, hch@infradead.org, akpm@linux-foundation.org,
       gregkh@suse.de, mucci@cs.utk.edu, eranian@hpl.hp.com, wcohen@redhat.com,
       robert.richter@amd.com, linux-kernel@vger.kernel.org,
       andi@firstfloor.org
References: <20071114.031216.11725447.davem@davemloft.net> <200711141049.49154.nickpiggin@yahoo.com.au> <20071114.035850.202836100.davem@davemloft.net>
In-Reply-To: <20071114.035850.202836100.davem@davemloft.net>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200711141125.18568.nickpiggin@yahoo.com.au>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 November 2007 22:58, David Miller wrote:
> From: Nick Piggin <nickpiggin@yahoo.com.au>
> Date: Wed, 14 Nov 2007 10:49:48 +1100
>
> > On Wednesday 14 November 2007 22:44, Paul Mackerras wrote:
> > > David Miller writes:
> > > > This is my impression too, all of the things being done with
> > > > a slew of system calls would be better served by real special
> > > > files and appropriate fops.
> > >
> > > Special files and fops really only work well if you can coerce the
> > > interface into one where data flows predominantly one way.  I don't
> > > think they work so well for something that is more like an RPC across
> > > the user/kernel barrier.  For that a system call is better.
> > >
> > > For instance, if you have something that kind-of looks like
> > >
> > > 	read_pmds(int n, int *pmd_numbers, u64 *pmd_values);
> > >
> > > where the caller supplies an array of PMD numbers and the function
> > > returns their values (and you want that reading to be done atomically
> > > in some sense), how would you do that using special files and fops?
> >
> > Could you implement it with readv()?
>
> Sure, why not?  Just cook up an iovec.  pmd_numbers goes to offset
> X and pmd_values goes to offset Y, with some helpers like what
> we have in the networking already for recvmsg.
>
> But why would you want readv() for this?  The syscall thing
> Paul asked me to translate into a read() doesn't provide
> iovec-like behavior so I don't see why readv() is necessary
> at all.

Ah sorry, that's what I get for typing before I think: of course
readv doesn't vectorise the right part of the equation.

What I really mean is a readv-like syscall, but one that also
vectorises the file offset. Maybe this is useful enough as a generic
syscall that also helps Paul's example...

Of course, I guess this all depends on whether the atomicity is an
important requirement. If not, you can obviously just do it with
multiple read syscalls...
