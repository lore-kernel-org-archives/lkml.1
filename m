Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZKRXfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZKRXfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 18:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756827AbZKRXfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 18:35:08 -0500
Received: from mail-yw0-f202.google.com ([209.85.211.202]:48793 "EHLO
	mail-yw0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756563AbZKRXfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 18:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=xDbf9bLT+h44hfrwIJG3GGwnXwUTvdIth5kEgGgEVlJrs4SkK3QASJYN/nBXFML9SM
         kjNY//J6pyP5aeF5TJowL/CbmMbpFOUkcqkVui9NuKuqHtBGzVwe8fetZZaQI5T673/i
         OkdONj0NKw7oOz9vjUm8L4bGk4ec0CXzxnVJ0=
MIME-Version: 1.0
In-Reply-To: <20091118225626.GA2974@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091118153227.GA5796@redhat.com>
	 <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
	 <20091118225626.GA2974@redhat.com>
Date: Thu, 19 Nov 2009 00:35:12 +0100
Message-ID: <4e5e476b0911181535y4d73d381s14b54c6d787d2b46@mail.gmail.com>
Subject: Re: [RFC] Block IO Controller V2 - some results
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,
On Wed, Nov 18, 2009 at 11:56 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Moving all the queues to root group is one way to solve the issue. Though
> problem still remains if there are 7-8 sequential workload groups operating
> with low_latency=0. In that case after every dispatch round of sync-noidle
> workload in root group, next round might be much more than 300ms, hence
> bumping up the max latencies of sync-noidle workload.

I think that this is the desired behaviour: low_latency=0 means that
latency is less important than throughput, so I wouldn't worry about
it.

>
> I think one of the core problem seems to be that I always put the group at
> the end of service tree. Instead I should let the group delete from
> service tree if it does not have sufficient IO, and when it comes back
> again, try to put it in the beginning of tree according to weight so
> that not all is lost and it gets to dispatch IO sooner.

It is similar to how the queues are put in service tree in cfq without groups.
If a queue had some remaining slice, it is prioritized w.r.t. ones
that consumed their slice completely, by giving it a lower key.

> This way, the groups which have been using long slices (either because
> they are running sync-idle workload or because they have sufficient IO
> to keep the disk busy), will be towards later end of service tree and the
> groups which are new or which have lost their share because they have
> dispatched a small IO and got deleted, will be put at the front of tree.
>
> This way sync-noidle queues in a group will not loose out because of
> sync-idle IO happening in other groups.

It is ok if you have group idling, but if you disable it (and end of
tree idle), it will be similar to how CFQ was before my patch set (and
experiments showed that the approach was inferior to grouping no-idle
together), without the service differentiation benefit introduced by
your idling.
So I still prefer the binary choice: either you want fairness (by
idling) or performance (by putting all no-idle queues together).

>
> I have written couple of small patches and still testing it out to see
> whether it is working fine in various configurations.
>
> Will post patches after some testing.
>
> Thanks
> Vivek
>

Thanks
Corrado
