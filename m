Return-Path: <linux-kernel-owner+w=401wt.eu-S1754202AbZBDJYg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202AbZBDJYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 04:24:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbZBDJYS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 04:24:18 -0500
Received: from smtp113.mail.mud.yahoo.com ([209.191.84.66]:47943 "HELO
	smtp113.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751234AbZBDJYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 04:24:17 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=TX7/30f5heqLyD9A5Twkw5/ZG7rno6Zbx/6XaupZ1PKa3NVP6UA25M4xu9hCjuM16erdhDW6+AqZvXdvqRzqerGOMoLbMDfVQm7fAPCfPSxAOZeUvs4vNPXdmNzc4ql9oz0UGGT6I/LmJQSR5eijBoQboVWXDB/OgAN1vMzRk44=  ;
X-YMail-OSG: ByqFdSkVM1ly8AzaXCMLt1YGaUOxVE8yFEPPGWLaA1KMtUlSfp0DvJ8EG4oj_7hcS5Qu0i7Hxp3VR_JUOlNP3DyWSrkHndsJ72hZiapfqBQszfXfs1oqQkqXLNakOnv4nBZycJINVMJobojZHt98QCPeEjLDF_lDHMjTJsOx9OC.NQ.pqyEKznwbf9VHGQpfQ7EICuN4flN4cJNZgOCvTjEZ3s4gKtGrP9M-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Evgeniy Polyakov <zbr@ioremap.net>
Subject: Re: [PATCH v2] tcp: splice as many packets as possible at once
Date: Wed, 4 Feb 2009 20:23:46 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: David Miller <davem@davemloft.net>, jarkao2@gmail.com,
       herbert@gondor.apana.org.au, w@1wt.eu, dada1@cosmosbay.com,
       ben@zeus.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, jens.axboe@oracle.com
References: <20090202.235017.253437221.davem@davemloft.net> <20090203.164609.160183741.davem@davemloft.net> <20090204080851.GA10445@ioremap.net>
In-Reply-To: <20090204080851.GA10445@ioremap.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042023.47916.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 19:08:51 Evgeniy Polyakov wrote:
> On Tue, Feb 03, 2009 at 04:46:09PM -0800, David Miller (davem@davemloft.net) 
wrote:
> > > NTA tried to solve this by not allowing to free the data allocated on
> > > the different CPU, contrary to what SLAB does. Modulo cache coherency
> > > improvements,
> >
> > This could kill performance on NUMA systems if we are not careful.
> >
> > If we ever consider NTA seriously, these issues would need to
> > be performance tested.
>
> Quite contrary I think. Memory is allocated and freed on the same CPU,
> which means on the same memory domain, closest to the CPU in question.
>
> I did not test NUMA though, but NTA performance on the usual CPU (it is
> 2.5 years old already :) was noticebly good.

I had a quick look at NTA... I didn't understand much of it yet, but
the remote freeing scheme is kind of like what I did for slqb. The
freeing CPU queues objects back to the CPU that allocated them, which
eventually checks the queue and frees them itself.

I don't know how much cache coherency gains you get from this -- in
most slab allocations, I think the object tends to be cache on on the
CPU that frees it. I'm doing it mainly to try avoid locking... I guess
that makes for cache coherency benefit itself.

If NTA does significantly better than slab allocator, I would be quite
interested. It might be something that we can learn from and use in
the general slab allocator (or maybe something more network specific
that NTA does).

