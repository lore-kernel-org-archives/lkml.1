Return-Path: <linux-kernel-owner+w=401wt.eu-S1754929AbZDOIq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929AbZDOIq0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 04:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753172AbZDOIqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 04:46:17 -0400
Received: from smtp118.mail.mud.yahoo.com ([209.191.84.167]:30332 "HELO
	smtp118.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752384AbZDOIqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 04:46:16 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=GZDTgzWt6sx+84VcNJXYDHDUCdrgjtYEbl2/z39iHhpFhRIjYDRenKKAUPAmQ+e3OajziFSt2QU4STGgLP8gr6EtRQVfEV8BvDBdmhgc5vyf3E7F3x/tOJ5hRWLN+/l/yakXwEVOsxnJMoMXAcTYEUunzVzERkYPZSgiXG+ojZ4=  ;
X-YMail-OSG: kgKxwOoVM1l9zMHXYYrzjzMW6osddaJFNg3iPgLBVRVFwvxBuj04oSGa3R5ygRphmdmwe9u8wgjBF1FtGxpHw9Ng6jRMndeQR2SyWDUcirbUsE2Bngx87eBm4DiZYthYkgTERe4vsvgYQZU2isTVXFDl4U1NPp2xeZSkBZ3_fGzC2k5WiCS0M2Go4vZPPGH_ckWzkXTANeVYnvQ30l.jSbCldCtQItZzIYFCLJQkg8tJdRM7K69O2k3kBIMQO28IY9S3qOK9FU1L5J.OfCxslo67dI5s_Yselpms4MfLZKdUhx907plhwvb7UOhUhbJ5lAxrX9hCzQHjcE.9qT0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] Handle bio_alloc failure
Date: Wed, 15 Apr 2009 18:46:06 +1000
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Theodore Tso <tytso@mit.edu>, knikanth@suse.de, jens.axboe@oracle.com,
       neilb@suse.de, linux-kernel@vger.kernel.org, chris.mason@oracle.com,
       shaggy@austin.ibm.com, xfs-masters@oss.sgi.com
References: <200904141636.26557.knikanth@novell.com> <20090414181632.GI955@mit.edu> <20090414114604.2d552cbb.akpm@linux-foundation.org>
In-Reply-To: <20090414114604.2d552cbb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904151846.08044.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 15 April 2009 04:46:04 Andrew Morton wrote:
> On Tue, 14 Apr 2009 14:16:32 -0400
> Theodore Tso <tytso@mit.edu> wrote:
> 
> > In include/linux/page_alloc.h,
> > __GFP_NOFAIL is documented as "will never fail", but it says
> > absolutely nothing about __GFP_WAIT.
> 
> In the present implementation, a __GFP_WAIT allocation for order <=3
> will only fail if the caller was oom-killed.
> 
> Which raises the question "what happens when a mempool_alloc() caller
> gets oom-killed?".
> 
> Seems that it will loop around in mempool_alloc() doing weak attempts
> to allocate memory, not doing direct reclaim while waiting for someone
> else to free something up.  hm.  I guess it'll recover eventually.

Yes, it doesn't have to reclaim anything (quite likely if we've
been OOM killed, reclaim is very difficult or impossible at this
point anyway). It will recover when an object gets returned to
the mempool by someone else. No point in using page allocator
reserve when we have guaranteed forward progress anyway.
