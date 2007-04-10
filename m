Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbXDJV5l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbXDJV5l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 17:57:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753926AbXDJV5l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 17:57:41 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:15352 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbXDJV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 17:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=qiBx03+778+USjzQ8cbLmbyaNENXKzv54PwaPJPN1vWYhqHpbJQ4uoqmTLPN6+OUSYVpzcPD78Dkx9m1Ir4mgxpFCKzIVMe6+0wJZ1UblkQLCKLXQXOj6D+9eBC1hsn8E6pCBppReEKUXoB+7i16BHP1YIo5LJrYFGEfvYaBhQ0=
Message-ID: <b6c5339f0704101457x294d36bfg11088f807e9e2c48@mail.gmail.com>
Date: Tue, 10 Apr 2007 17:57:37 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Neil Brown" <neilb@suse.de>
Subject: Re: If not readdir() then what?
Cc: "Trond Myklebust" <trond.myklebust@fys.uio.no>,
       "Theodore Tso" <tytso@mit.edu>,
       "=?ISO-8859-1?Q?J=F6rn_Engel?=" <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Christoph Hellwig" <hch@infradead.org>,
       "Ulrich Drepper" <drepper@gmail.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <17948.916.464492.881283@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070407233037.GA16508@infradead.org>
	 <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
	 <1176127395.6210.34.camel@heimdal.trondhjem.org>
	 <20070410135641.GG13650@thunk.org>
	 <1176215836.14442.37.camel@heimdal.trondhjem.org>
	 <17947.64947.649081.411561@notabene.brown>
	 <1176239914.309.54.camel@heimdal.trondhjem.org>
	 <17948.916.464492.881283@notabene.brown>
X-Google-Sender-Auth: 32d6ef921488b97f
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/10/07, Neil Brown <neilb@suse.de> wrote:
> 2/ Some data structure using an ordered search key that is based on
>   the filename (e.g. a B-tree with a search key that is a hash of the
>   filename).
>
> In the first case, you just use a fixed opaque cookie for location in
> a directory.
> In the second you use the filename.  If the file has been deleted,
> that shouldn't stop you finding the place where it would have been in
> the overall sort order.

I can think of one (admittedly insane) FS that is between those two:

3/ an unsorted hash table, where each directory entry has an indirect
pointer to its neighbor in case of hash collisions.

   a
   b -> d -> c -> e
   g
   f -> x

Given 'c' as the "last" thing returned, you can hash c to find out
that you are in the bucket with 'b', but if 'c' was deleted, the best
you can do is return b twice or skip the chain entirely.  I maintain
an out-of-tree driver for such an fs (I promise I did not invent it);
the best I could come up with is to encode the hash chain index in the
top byte of f_pos.   Needless to say, readdir is very not performant
with all the seeking this hash scheme entails.

-Bob
