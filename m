Return-Path: <linux-kernel-owner+w=401wt.eu-S1754065AbZKQRqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065AbZKQRqb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 12:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753714AbZKQRqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 12:46:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753589AbZKQRq3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 12:46:29 -0500
Date: Tue, 17 Nov 2009 12:44:41 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: Corrado Zoccolo <czoccolo@gmail.com>, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com
Subject: Re: [RFC] Block IO Controller V2 - some results
Message-ID: <20091117174441.GG22462@redhat.com>
References: <1258404660.3533.150.camel@cail> <20091116221827.GL13235@redhat.com> <1258461527.2862.2.camel@cail> <20091117141411.GA22462@redhat.com> <4e5e476b0911170817s39286103g3796f25cba9f623c@mail.gmail.com> <20091117164026.GE22462@redhat.com> <1258479007.6084.162.camel@cail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258479007.6084.162.camel@cail>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 17, 2009 at 12:30:07PM -0500, Alan D. Brunelle wrote:
> On Tue, 2009-11-17 at 11:40 -0500, Vivek Goyal wrote:
> > On Tue, Nov 17, 2009 at 05:17:53PM +0100, Corrado Zoccolo wrote:
> > > Hi Vivek,
> > > the performance drop reported by Alan was my main concern about your
> > > approach. Probably you should mention/document somewhere that when the
> > > number of groups is too large, there is large decrease in random read
> > > performance.
> > > 
> > 
> > Hi Corrodo,
> > 
> > I thought more about it. We idle on sync-noidle group only in case of 
> > rotational media not supporting NCQ (hw_tag = 0). So for all the fast
> > hardware out there (SSD and fast arrays), we should not be idling on 
> > sync-noidle group hence should not additional idling per group.
> > 
> > This is all subjected to the fact that we have done a good job in
> > detecting the queue depth and have updated hw_tag accordingly.
> > 
> > On slower rotational hardware, where we will actually do idling on
> > sync-noidle per group, idling can infact help you because it will reduce
> > the number of seeks (As it does on my locally connected SATA disk).
> > 
> > > However, we can check few things:
> > > * is this kernel built with HZ < 1000? The smallest idle CFQ will do
> > > is given by 2/HZ, so running with a small HZ will increase the impact
> > > of idling.
> > > 
> > > On Tue, Nov 17, 2009 at 3:14 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > Regarding the reduced throughput for random IO case, ideally we should not
> > > > idle on sync-noidle group on this hardware as this seems to be a fast NCQ
> > > > supporting hardware. But I guess we might not be detecting the queue depth
> > > > properly which leads to idling on per group sync-noidle workload and
> > > > forces the queue depth to be 1.
> > > 
> > > * This can be ruled out testing my NCQ detection fix patch
> > > (http://groups.google.com/group/linux.kernel/browse_thread/thread/3b62f0665f0912b6/34ec9456c7da1bb7?lnk=raot)
> > 
> > This will be a good patch to test here. Alan, can you also apply this
> > patch and see if we see any improvement.
> 
> Vivek: Do you want me to move this over to the V3 version & apply this
> patch, or stick w/ V2?

Alan,

Anthing is good. V3 is not very different from V2. May be move to V3 with
above patch applied and see if helps.

At the end of the day, you will not see improvement with group_idle=1 as
each group gets exclusive access to underlying array. But I am expecting
to see improvement with group_idle=0.

Thanks
Vivek
