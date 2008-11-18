Return-Path: <linux-kernel-owner+w=401wt.eu-S1752286AbYKREkW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752286AbYKREkW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 23:40:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKREkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 23:40:09 -0500
Received: from smtp120.mail.mud.yahoo.com ([209.191.84.77]:41334 "HELO
	smtp120.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751327AbYKREkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 23:40:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=eHK1tHfGZML/hdVBPvDkd3/yG2a8tjrOVvLHaJDo4jxnfy/im1TkmgbzyvVu/k9TvKxdBdFS7W0qVcvStKQPstARM9inDWSbH9r9gIN2Kwxnu/ssnCGElxQCF13mLJwx8B6ljy7NBWG60jWDVRRZZAcVlEtd6zRURWF/jZ3n4aw=  ;
X-YMail-OSG: vdT.X1cVM1mLtagNgRZoJcjt3MWPYQLOekWnBzAxJnE_Wjy4K54VKw1oOd6t5v4qOHlAn9HoRMQA633X7ULdzrXOijEl5nvR.oexgTWL3003GNRYXGty0GFEudPvxF9HVsBnKsILsnzYiMkMd8ziORs1DGFTqCsEOQK62cCkvRFe8H6ppMJE7IenSPhT
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Date: Tue, 18 Nov 2008 15:39:59 +1100
User-Agent: KMail/1.9.5
Cc: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Airlie" <airlied@gmail.com>, "David Miller" <davem@davemloft.net>,
       menage@google.com, jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       "Alexey Dobriyan" <adobriyan@gmail.com>
References: <491FA28B.2070003@cn.fujitsu.com> <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com> <20081116231301.c6b0da95.akpm@linux-foundation.org>
In-Reply-To: <20081116231301.c6b0da95.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811181540.00011.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 November 2008 18:13, Andrew Morton wrote:
> On Mon, 17 Nov 2008 15:43:59 +0900 "KOSAKI Motohiro" 
<kosaki.motohiro@jp.fujitsu.com> wrote:
> > >> > (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
> > >>
> > >> I would prefer to find a way to say that one cannot select gfp_mask
> > >> with this API.
> > >
> > > I think gfp_mask must be passed explicitly.
> >
> > Agreed.
>
> It would only make sense if __vmalloc() can be called in atomic contexts.
>
> __vmalloc() cannot be called from irq contexts due to it taking
> non-irq-safe spinlocks.
>
> __vmalloc() kinda looks like it could be called from non-irq atomic
> contexts with GFP_ATOMIC, but I think it lies.  For example,
> pud_alloc_one/pmd_alloc_one/etc use hard-wired GFP_KERNEL.

vmalloc/vfree / vmap/vunmap I think could now be made to be usable even
in irq context, I think. Freeing up vmalloc space with global tlb flush
can't be done from interrupt context, but now with the lazy unmapping,
you only have to mark the area as freed (and possibly kick off a thread
to do the actual unmapping).

I didn't actually add that, because yes it would increase overheads a
bit, and I would still prefer to wait for a real nice problem it solves
before adding such a capability...


> In which case this new allocation function can only be called from
> contexts where GFP_KERNEL can be used, hence we don't need to pass that
> in - it would be misleading to do so.
>
> In fact it's not immediately clear why __vmalloc() takes a gfp_t
> argument either?

Possibly a bugcheck for !GFP_WAIT || !GFP_FS || !GFP_IO, or a might_sleep()
or something would be a good idea to add...
