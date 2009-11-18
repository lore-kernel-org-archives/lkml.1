Return-Path: <linux-kernel-owner+w=401wt.eu-S1757500AbZKRW6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500AbZKRW6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 17:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756190AbZKRW6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 17:58:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756151AbZKRW6I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 17:58:08 -0500
Date: Wed, 18 Nov 2009 17:56:26 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Corrado Zoccolo <czoccolo@gmail.com>
Cc: "Alan D. Brunelle" <Alan.Brunelle@hp.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091118225626.GA2974@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091118153227.GA5796@redhat.com> <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4e5e476b0911180820y5d99a81et6be7f6f94442d0d5@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 05:20:12PM +0100, Corrado Zoccolo wrote:
> Hi Vivek,
> On Wed, Nov 18, 2009 at 4:32 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > o Currently we wait on sync-noidle service tree so that sync-noidle type of
> >  workload does not get swamped by sync-idle or async type of workload. Don't
> >  do this idling if there are no sync-idle or async type of queues in the group
> >  and there are other groups to dispatch the requests from and user has decided
> >  not to wait on slow groups to achieve better throughput. (group_idle=0).
> >
> >  This will make sure if some group is doing just random IO and does not
> >  have sufficient IO to keep the disk busy, we will move onto other groups to
> >  dispatch the requests from and utilize the storage better.
> >
> This group will be treated unfairly, if the other groups are doing
> sequential I/O:
> It will dispatch one request every 100ms (at best), and every 300ms at worst.
> I can't see how this is any better than having a centralized service
> tree for all sync-noidle queues.
> 
> Probably it is better to just say:
> * if the user wants isolation (group_idle should be named
> group_isolation), the no-idle queues go into the group no-idle tree,
> and a proper idling is ensured
> * if the user doesn't want isolation, but performance, then the
> no-idle queues go into the root group no-idle tree, for which the end
> of tree idle should be ensured. This won't affect the sync-idle
> queues, for which group weighting will still work unaffected.

Moving all the queues to root group is one way to solve the issue. Though
problem still remains if there are 7-8 sequential workload groups operating
with low_latency=0. In that case after every dispatch round of sync-noidle
workload in root group, next round might be much more than 300ms, hence
bumping up the max latencies of sync-noidle workload.

I think one of the core problem seems to be that I always put the group at
the end of service tree. Instead I should let the group delete from
service tree if it does not have sufficient IO, and when it comes back
again, try to put it in the beginning of tree according to weight so
that not all is lost and it gets to dispatch IO sooner.

This way, the groups which have been using long slices (either because
they are running sync-idle workload or because they have sufficient IO
to keep the disk busy), will be towards later end of service tree and the
groups which are new or which have lost their share because they have
dispatched a small IO and got deleted, will be put at the front of tree.

This way sync-noidle queues in a group will not loose out because of
sync-idle IO happening in other groups.

I have written couple of small patches and still testing it out to see
whether it is working fine in various configurations.

Will post patches after some testing.

Thanks
Vivek
