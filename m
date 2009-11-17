Return-Path: <linux-kernel-owner+w=401wt.eu-S1752774AbZKQQRt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774AbZKQQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 11:17:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbZKQQRs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 11:17:48 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:38271 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbZKQQRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 11:17:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UrnsC/+3YmaWKWyUR6xlg9lki5qL3jG6mtRQkZZ5ZkhGDcX6E3YrvGp3pLqt6iJaLU
         wVqdMDOTqN8YElLwOuGa6rvNosUqMnQe7XrMG+x2s1kurt9OMkbgJSCo5U0wHE5Ev3dH
         Y63daOFfX3SyJpdvKoCbGU8gvD8+IBiaF2D/A=
MIME-Version: 1.0
In-Reply-To: <20091117141411.GA22462@redhat.com>
References: <1258404660.3533.150.camel@cail>
	 <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail>
	 <20091117141411.GA22462@redhat.com>
Date: Tue, 17 Nov 2009 17:17:53 +0100
Message-ID: <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com>
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
the performance drop reported by Alan was my main concern about your
approach. Probably you should mention/document somewhere that when the
number of groups is too large, there is large decrease in random read
performance.

However, we can check few things:
* is this kernel built with HZ < 1000? The smallest idle CFQ will do
is given by 2/HZ, so running with a small HZ will increase the impact
of idling.

On Tue, Nov 17, 2009 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Regarding the reduced throughput for random IO case, ideally we should not
> idle on sync-noidle group on this hardware as this seems to be a fast NCQ
> supporting hardware. But I guess we might not be detecting the queue depth
> properly which leads to idling on per group sync-noidle workload and
> forces the queue depth to be 1.

* This can be ruled out testing my NCQ detection fix patch
(http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot)

However, my feeling is that the real problem is having multiple
separate sync-noidle trees.
Inter group idle is marginal, since each sync-noidle tree already has
its end-of-tree idle enabled for rotational devices (The difference in
the table is in fact small).
> ---- ---- - ----------- ----------- ----------- -----------
> Mode RdWr N    base       ioc off   ioc no idle  ioc idle
> ---- ---- - ----------- ----------- ----------- -----------
>  rnd   rd 2        17.3        17.1         9.4         9.1
>  rnd   rd 4        27.1        27.1         8.1         8.2
>  rnd   rd 8        37.1        37.1         6.8         7.1

2 random readers without groups have bw = 17.3 ; this means that a
single random reader will have bw > 8.6 (since the two readers go
usually in parallel when no groups are involved, unless two random
reads are actually queued to the same disk).

When the random readers are in separate groups, we give the full disk
to only one at a time, so the max aggregate bw achievable is the bw of
a single random reader less the overhead proportional to number of
groups. This is compatible with the numbers.

So, an other thing to mention in the docs is that having one process
per group is not a good idea (cfq already has I/O priorities to deal
with single processes). Groups are coarse grain entities, and they
should really be used when you need to get fairness between groups of
processes.

* An other thing to do is to try setting rotational = 0, since even
with NCQ correctly detected, if the device is rotational, we still
introduce some idle delays (that are good in the root group, but not
when you have multiple groups).

>
> I am also trying to setup a higher end system here and will do some
> experiments.
>
> Thanks
> Vivek

Thanks,
Corrado
