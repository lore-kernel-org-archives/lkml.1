Return-Path: <linux-kernel-owner+w=401wt.eu-S933062AbYBNUbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933062AbYBNUbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 15:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755616AbYBNUbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 15:31:33 -0500
Received: from wx-out-0506.google.com ([66.249.82.226]:3184 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754395AbYBNUbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 15:31:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=CpdstN6UF6V9JTPE2ybJVrGYGrdH99Dz4hZkK/xAHwsW1CgBdwlcoHd678j0HZLYmSBmmkNajhWo1Q4SNSWyfy6iIQV55UMHWPA+rdjMpOnJf7xuen7vgk7M6M0IZhBYh3qRyL85tYTdDqiAvk6OkchsjKPy2PRgI2WwnQLS2pE=
Message-ID: <19f34abd0802141231q1b574157g24cf7d148599640d@mail.gmail.com>
Date: Thu, 14 Feb 2008 21:31:30 +0100
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 4/4] kmemcheck v4
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Daniel Walker" <dwalker@mvista.com>, "Ingo Molnar" <mingo@elte.hu>,
       "Richard Knutsson" <ricknu-0@student.ltu.se>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <47B4A0A4.90404@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47B49DB2.2090402@gmail.com> <47B49E71.4040900@gmail.com>
	 <47B4A0A4.90404@cs.helsinki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/14/08, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> Hi,
>
>
>  Vegard Nossum wrote:
>  > diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
>  > index 412672a..7bdb37f 100644
>  > --- a/include/linux/skbuff.h
>  > +++ b/include/linux/skbuff.h
>  > @@ -1294,7 +1294,11 @@ static inline void __skb_queue_purge(struct
>  > sk_buff_head *list)
>  >  static inline struct sk_buff *__dev_alloc_skb(unsigned int length,
>  >                            gfp_t gfp_mask)
>  >  {
>  > -    struct sk_buff *skb = alloc_skb(length + NET_SKB_PAD, gfp_mask);
>  > +    struct sk_buff *skb;
>  > +#ifdef CONFIG_KMEMCHECK
>  > +    gfp_mask |= __GFP_ZERO;
>  > +#endif
>
>
> Use __GFP_NOTRACK here (no need to wrap it in CONFIG_KMEMCHECK either).
>
>  > +    skb = alloc_skb(length + NET_SKB_PAD, gfp_mask);
>
> >      if (likely(skb))
>  >          skb_reserve(skb, NET_SKB_PAD);
>  >      return skb;
>
>
> > diff --git a/init/do_mounts.c b/init/do_mounts.c
>  > index f865731..87b1b0f 100644
>  > --- a/init/do_mounts.c
>  > +++ b/init/do_mounts.c
>  > @@ -201,9 +201,13 @@ static int __init do_mount_root(char *name, char
>  > *fs, int flags, void *data)
>  >      return 0;
>  >  }
>  >
>  > +#if PAGE_SIZE < PATH_MAX
>  > +# error increase the fs_names allocation size here
>  > +#endif
>  > +
>  >  void __init mount_block_root(char *name, int flags)
>  >  {
>  > -    char *fs_names = __getname();
>  > +    char *fs_names = (void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
>  >      char *p;
>  >  #ifdef CONFIG_BLOCK
>  >      char b[BDEVNAME_SIZE];
>  > @@ -251,7 +255,7 @@ retry:
>  >  #endif
>  >      panic("VFS: Unable to mount root fs on %s", b);
>  >  out:
>  > -    putname(fs_names);
>  > +    free_pages((unsigned long)fs_names, 1);
>
>
> As discussed before, I don't think kmemcheck should be complaining about
>  this (even though this is a potential bug). Have you tried with the
>  current patches to see if it still triggers? Could have been one of the
>  kmemcheck bugs, no?
>
>
>  > @@ -255,6 +258,9 @@ struct sk_buff *__netdev_alloc_skb(struct net_device
>  > *dev,
>  >      int node = dev->dev.parent ? dev_to_node(dev->dev.parent) : -1;
>  >      struct sk_buff *skb;
>  >
>  > +#ifdef CONFIG_KMEMCHECK
>  > +    gfp_mask |= __GFP_ZERO;
>  > +#endif
>
>
> __GFP_NOTRACK here
>
>
>                         Pekka
>

Will fix those, thanks!


Vegard
