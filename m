Return-Path: <linux-kernel-owner+w=401wt.eu-S1753415AbYKQHOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbYKQHOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 02:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYKQHOQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 02:14:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38744 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751048AbYKQHOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 02:14:16 -0500
Date: Sun, 16 Nov 2008 23:13:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       balbir@linux.vnet.ibm.com, "Lai Jiangshan" <laijs@cn.fujitsu.com>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "Dave Airlie" <airlied@gmail.com>, "David Miller" <davem@davemloft.net>,
       menage@google.com, jens.axboe@oracle.com, jack@suse.cz, jes@sgi.com,
       linux-kernel@vger.kernel.org, dada1@cosmosbay.com,
       "Alexey Dobriyan" <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] mm: introduce simple_malloc()/simple_free()
Message-Id: <20081116231301.c6b0da95.akpm@linux-foundation.org>
In-Reply-To: <2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com>
References: <491FA28B.2070003@cn.fujitsu.com>
	<20081115205229.765f7ee3@infradead.org>
	<20081116.001926.150424480.davem@davemloft.net>
	<20081116105725.12458b13@infradead.org>
	<21d7e9970811161339x174d6041x1622d478f8e4247e@mail.gmail.com>
	<20081116135130.5e8b4e13@infradead.org>
	<4920D238.8090905@cn.fujitsu.com>
	<4920F8C4.30209@linux.vnet.ibm.com>
	<20081117142539.9b2c6bfc.kamezawa.hiroyu@jp.fujitsu.com>
	<2f11576a0811162243r7527d271ya8ab2fc3a9be9f7d@mail.gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Nov 2008 15:43:59 +0900 "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com> wrote:

> >> > (I'll rename simple_malloc/simple_free to kvmalloc/kvfree)
> >> >
> >>
> >> I would prefer to find a way to say that one cannot select gfp_mask with this API.
> >>
> > I think gfp_mask must be passed explicitly.
> 
> Agreed.

It would only make sense if __vmalloc() can be called in atomic contexts.

__vmalloc() cannot be called from irq contexts due to it taking
non-irq-safe spinlocks.

__vmalloc() kinda looks like it could be called from non-irq atomic
contexts with GFP_ATOMIC, but I think it lies.  For example,
pud_alloc_one/pmd_alloc_one/etc use hard-wired GFP_KERNEL.

In which case this new allocation function can only be called from
contexts where GFP_KERNEL can be used, hence we don't need to pass that
in - it would be misleading to do so.

In fact it's not immediately clear why __vmalloc() takes a gfp_t
argument either?
