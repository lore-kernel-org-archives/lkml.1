Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbXJYCYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbXJYCYd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 22:24:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758245AbXJYCXv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 22:23:51 -0400
Received: from smtp107.mail.mud.yahoo.com ([209.191.85.217]:34922 "HELO
	smtp107.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757103AbXJYCXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 22:23:49 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=C0Sl4Zid0aUeYOqbxdZvcwmSfDIy7frXtfezuihf2GOOEKMigQUGtbTkSQGfqoFeb43Yt6jH61FUnjMDafuPyYLiJF5uA9Zpki5xoh4JsYaKG55CSIxkENut+3lc5bE9e8/qDHFqxtmeDQOcF+eUT920FQqmGgu54pfoXApC1Es=  ;
X-YMail-OSG: lTkuGKUVM1mksx_Ur9Ky33iXCev6yC300IiZfT.wqhdwlysoFsLuDyZCvWv0PXmpAmWLYx1Kyg--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch 1/5] wait: use lock bitops for __wait_on_bit_lock
Date: Thu, 25 Oct 2007 12:17:10 +1000
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20071024081305.906617000@nick.local0.net> <20071024081405.094887000@nick.local0.net> <20071024181428.1d25299a.akpm@linux-foundation.org>
In-Reply-To: <20071024181428.1d25299a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710251217.10704.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 25 October 2007 11:14, Andrew Morton wrote:
> On Wed, 24 Oct 2007 18:13:06 +1000 npiggin@nick.local0.net wrote:
> > Signed-off-by: Nick Piggin <npiggin@suse.de>
> >
> > ---
> >  kernel/wait.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: linux-2.6/kernel/wait.c
> > ===================================================================
> > --- linux-2.6.orig/kernel/wait.c
> > +++ linux-2.6/kernel/wait.c
> > @@ -195,7 +195,7 @@ __wait_on_bit_lock(wait_queue_head_t *wq
> >  			if ((ret = (*action)(q->key.flags)))
> >  				break;
> >  		}
> > -	} while (test_and_set_bit(q->key.bit_nr, q->key.flags));
> > +	} while (test_and_set_bit_lock(q->key.bit_nr, q->key.flags));
> >  	finish_wait(wq, &q->wait);
> >  	return ret;
> >  }
>
> Sorry, I'm just not going to apply a patch like that.
>
> I mean, how the heck is anyone else supposed to understand what you're up
> to?

Hmm, I might just withdraw this patch 1/5. This is generally a slowpath,
and it's hard to guarantee that any exported user doesn't rely on the
full barrier here (not that they would know whether they do or not, let
alone document the fact).

I think all the others are pretty clear, though? (read on if no)


> There's a bit of documentation in Documentation/atomic_ops.txt 
> (probably enough, I guess) but it is totally unobvious to 98.3% of kernel
> developers when they should use test_and_set_bit() versus
> test_and_set_bit_lock() and it is far too much work to work out why it was
> used in __wait_on_bit_lock(), whether it is correct, what advantages it
> brings and whether and where others should emulate it.

If you set a bit for the purpose of opening a critical section, then
you can use this. And clear_bit_unlock to close it.

The advantages are that it is faster, and the hapless driver writer
doesn't have to butcher or forget about doing the correct
smp_mb__before_clear_bit(), or have reviewers wondering exactly WTF
that barrier is for, etc.

Basically, it is faster, harder to get wrong, and more self-docuemnting.

In general, others should not emulate it, because they should be
using our regular locking primitives instead. If they really must
roll their own, then using these would be nice, IMO.


> So in my opinion this submission isn't of sufficient quality to be
> included in Linux.
>
> IOW: please write changelogs.  Preferably good ones.

2/5: "tasklet_trylock opens a critical section. tasklet_unlock closes it.
      hence, _lock bitops can be used for the bitops"

5/5: "trylock_page opens a critical section. unlock_page closes it. hence,
      _lock bitops can be used for the bitops"

5/5: "trylock_buffer opens a critical section. unlock_buffer closes it.
      hence, _lock bitops can be used for the bitops"

Are those helpful?
