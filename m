Return-Path: <linux-kernel-owner+w=401wt.eu-S1758471AbZFNMey@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbZFNMey (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:34:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754324AbZFNMeq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:34:46 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:50155 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753609AbZFNMep convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:34:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:message-id:to:cc:subject:from:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=Cgrgl1h+NFO9YvoHnQ7kqItDbi3raW66Ds8bDZS2INAO0RPpXqA6Bc0Uq++tWoV9BL
         px5FhiOMBWY9d0IztT2Cjqaoe0FQRH6WASe3bdu7lXVWmiui/fJZXPLaE/znUH0YQekP
         94Derh+/17T397KkRZOYkP0iDd/+nLj/6Nv8Q=
Date: Sun, 14 Jun 2009 21:34:19 +0900 (JST)
Message-Id: <20090614.213419.35998061.konishi.ryusuke@gmail.com>
To: penberg@cs.helsinki.fi
Cc: konishi.ryusuke@lab.ntt.co.jp, albertito@blitiri.com.ar, llucax@gmail.com,
       linux-kernel@vger.kernel.org, users@nilfs.org
Subject: Re: NILFS2 get stuck after bio_alloc() fail
From: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
In-Reply-To: <84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
References: <20090614015240.GW30412@blitiri.com.ar>
	<20090614.153046.25768784.konishi.ryusuke@gmail.com>
	<84144f020906140000v7b38f520rc5d9849b8ea8ad7e@mail.gmail.com>
X-Mailer: Mew version 6.2 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
On Sun, 14 Jun 2009 10:00:06 +0300, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> On Sun, Jun 14, 2009 at 9:30 AM, Ryusuke
> Konishi<konishi.ryusuke@lab.ntt.co.jp> wrote:
>> The original GFP flag was GFP_NOIO, but replaced to GFP_NOWAIT at a
>> preliminary release in February 2008.  It was because a user
>> experienced system memory shortage by the bio_alloc() call.
>>
>> Even though nilfs_alloc_seg_bio() repeatedly calls bio_alloc()
>> reducing the number of bio vectors in case of failure, this fallback
>> did not work well.
>>
>> I'm in two minds whether I should change it back to GFP_NOIO.
>> Or should I switch the gfp as follows?
> 
> As far as I can tell, the only difference with GFP_NOIO and GFP_NOWAIT
> here is that the former will trigger the mempool_alloc() page reclaim
> path. But I am not sure I understand why switching to GFP_NOWAIT
> helped with memory shortage. What exactly was the problem there?
> 
>                                  Pekka

I will confirm the details later.  I cannot dig into the record due to
planned outage at office now.  The version I replaced GFP_NOIO with
GFP_NOWAIT is considerably old.  A true problem might have been in
other places somewhere.

For reference, the retry loop in question is as follows.  It is to
allocate bio for log writing.

        bio = bio_alloc(GFP_NOWAIT, nr_vecs);
        if (bio == NULL) {
                while (!bio && (nr_vecs >>= 1))
                       bio = bio_alloc(GFP_NOWAIT, nr_vecs);
        }

where nr_vecs is less than or equal to bio_get_nr_vecs(bdev).


Thanks,
Ryusuke Konishi
