Return-Path: <linux-kernel-owner+w=401wt.eu-S1756368AbZECOph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368AbZECOph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 10:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754366AbZECOp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 10:45:27 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:55197 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894AbZECOp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 10:45:27 -0400
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: david@lang.hm
Cc: Willy Tarreau <w@1wt.eu>, Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Philipp Reisner <philipp.reisner@linbit.com>,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Greg KH <gregkh@suse.de>, Neil Brown <neilb@suse.de>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <alpine.DEB.1.10.0905030735500.15782@asgard>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <20090501015902.ed8b56d3.akpm@linux-foundation.org>
	 <e2e108260905020033h457ed97ayfd8392d1249a943a@mail.gmail.com>
	 <20090503053557.GH570@1wt.eu> <alpine.DEB.1.10.0905022239100.15782@asgard>
	 <1241360474.5596.4.camel@mulgrave.int.hansenpartnership.com>
	 <alpine.DEB.1.10.0905030735500.15782@asgard>
Content-Type: text/plain
Date: Sun, 03 May 2009 09:45:25 -0500
Message-Id: <1241361925.5596.27.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-05-03 at 07:36 -0700, david@lang.hm wrote:
> On Sun, 3 May 2009, James Bottomley wrote:
> 
> > Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
> > 
> > On Sat, 2009-05-02 at 22:40 -0700, david@lang.hm wrote:
> >> On Sun, 3 May 2009, Willy Tarreau wrote:
> >>
> >>> On Sat, May 02, 2009 at 09:33:35AM +0200, Bart Van Assche wrote:
> >>>> On Fri, May 1, 2009 at 10:59 AM, Andrew Morton
> >>>> <akpm@linux-foundation.org> wrote:
> >>>>> On Thu, 30 Apr 2009 13:26:36 +0200 Philipp Reisner <philipp.reisner@linbit.com> wrote:
> >>>>>
> >>>>>> This is a repost of DRBD
> >>>>>
> >>>>> Is it being used anywhere for anything?  If so, where and what?
> >>>>
> >>>> One popular application is to run iSCSI and HA software on top of DRBD
> >>>> in order to build a highly available iSCSI storage target.
> >>>
> >>> Confirmed, I have several customers who're doing exactly that.
> >>
> >> I will also say that there are a lot of us out here who would have a use
> >> for DRDB in our HA setups, but have held off implementing it specificly
> >> because it's not yet in the upstream kernel.
> >
> > Actually, that's not a particularly strong reason because we already
> > have an in-kernel replicator that has much of the functionality of drbd
> > that you could use.  The main reason for wanting drbd in kernel is that
> > it has a *current* user base.
> >
> > Both the in kernel md/nbd and drbd do sync and async replication with
> > primary side bitmaps.  The main differences are:
> >
> >      * md/nbd can do 1 to N replication,
> >      * drbd can do active/active replication (useful for cluster
> >        filesystems)
> >      * The chunk size of the md/nbd is tunable
> >      * With the updated nbd-tools, current md/nbd can do point in time
> >        rollback on transaction logged secondaries (a BCS requirement)
> >      * drbd manages the mirror state explicitly, md/nbd needs a user
> >        space helper
> >
> > And probably a few others I forget.
> 
> one very big one:
> 
> DRDB has better support for dealing with split brain situations and 
> recovering from them.

I don't really think so.  The decision about which (or if a) node should
be killed lies with the HA harness outside of the province of the
replication.

One could argue that the symmetric active mode of drbd allows both nodes
to continue rather than having the harness make a kill decision about
one.  However, if they both alter the same data, you get an
irreconcilable data corruption fault which, one can argue, is directly
counter to HA principles and so allowing drbd continuation is arguably
the wrong thing to do.

James


