Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZGVWhF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZGVWhF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 18:37:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754707AbZGVWhF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 18:37:05 -0400
Received: from nox.protox.org ([88.191.38.29]:41120 "EHLO nox.protox.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754684AbZGVWhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 18:37:04 -0400
Subject: Re: TTM page pool allocator
From: Jerome Glisse <glisse@freedesktop.org>
To: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas@shipmail.org>
Cc: Michel =?ISO-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net
In-Reply-To: <4A6764E0.7080302@shipmail.org>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <4A439D7D.9030401@shipmail.org>  <1248197676.2368.11.camel@localhost>
	 <1248199231.2368.17.camel@localhost>  <1248204128.2368.20.camel@localhost>
	 <1248268607.4703.450.camel@thor> <1248269490.2336.2.camel@localhost>
	 <4A6764E0.7080302@shipmail.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 23 Jul 2009 00:35:43 +0200
Message-Id: <1248302143.2336.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 21:13 +0200, Thomas Hellström wrote:
> Jerome Glisse wrote:
> > On Wed, 2009-07-22 at 15:16 +0200, Michel Dänzer wrote:
> >   
> >> On Tue, 2009-07-21 at 21:22 +0200, Jerome Glisse wrote:
> >>     
> >>> On Tue, 2009-07-21 at 20:00 +0200, Jerome Glisse wrote:
> >>>       
> >>>> On Tue, 2009-07-21 at 19:34 +0200, Jerome Glisse wrote:
> >>>>         
> >>>>> On Thu, 2009-06-25 at 17:53 +0200, Thomas Hellström wrote:
> >>>>>           
> >>>>>> 4) We could now skip the ttm_tt_populate() in ttm_tt_set_caching, since 
> >>>>>> it will always allocate cached pages and then transition them.
> >>>>>>
> >>>>>>             
> >>>>> Okay 4) is bad, what happens (my brain is a bit meltdown so i might be
> >>>>> wrong) :
> >>>>> 1 - bo get allocated tt->state = unpopulated
> >>>>> 2 - bo is mapped few page are faulted tt->state = unpopulated
> >>>>> 3 - bo is cache transitioned but tt->state == unpopulated but
> >>>>>     they are page which have been touch by the cpu so we need
> >>>>>     to clflush them and transition them, this never happen if
> >>>>>     we don't call ttm_tt_populate and proceed with the remaining
> >>>>>     of the cache transitioning functions
> >>>>>
> >>>>> As a workaround i will try to go through the pages tables and
> >>>>> transition existing pages. Do you have any idea for a better
> >>>>> plan ?
> >>>>>
> >>>>> Cheers,
> >>>>> Jerome
> >>>>>           
> >>>> My workaround ruin the whole idea of pool allocation what happens
> >>>> is that most bo get cache transition page per page. My thinking
> >>>> is that we should do the following:
> >>>> 	- is there is a least one page allocated then fully populate
> >>>> 	the object and do cache transition on all the pages.
> >>>> 	- otherwise update caching_state and leaves object unpopulated
> >>>>
> >>>> This needs that we some how reflect the fact that there is at least
> >>>> one page allocated, i am thinking to adding a new state for that :
> >>>> ttm_partialy_populated
> >>>>
> >>>> Thomas what do you think about that ?
> >>>>
> >>>> Cheers,
> >>>> Jerome
> >>>>         
> >>> Attached updated patch it doesn't introduce ttm_partialy_populated
> >>> but keep the populate call in cache transition. So far it seems to
> >>> work properly on AGP platform
> >>>       
> >> Yeah, this one works for me as well.
> >>
> >>     
> >>> and helps quite a lot with performances.
> >>>       
> >> Can't say I've noticed that however. How did you measure?
> >>     
> >
> > gears 
> Hmm,
> In gears there shouldn't really be any buffer allocation / freeing going 
> on at all once the display lists are set up, and gears should really be 
> gpu bound in most cases.
> 
> what's the source of the buffer allocations / frees when gears is run?
> 
> /Thomas

We free reallocate vertex buffer each frame iirc.

Cheers,
Jerome

