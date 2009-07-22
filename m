Return-Path: <linux-kernel-owner+w=401wt.eu-S1755296AbZGVX1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755296AbZGVX1P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jul 2009 19:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754799AbZGVX1P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Jul 2009 19:27:15 -0400
Received: from mail-pz0-f192.google.com ([209.85.222.192]:40537 "EHLO
	mail-pz0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754229AbZGVX1O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jul 2009 19:27:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hYkg865kDzBBmoDL/PC1YM0zcIXzu0sWyrKos6mdPIUfOD0UPrZvGHOQkzI+D4pomc
         GtXzOWUPlEFS7GKzETx1rUtEKAuMriLwGAcwNFT8vk+GLLh6l5zwcZD9ht+h8bhtIOxN
         ixMNryiNTf/ggO4By48x3jno5Jlaex3Dofjnk=
MIME-Version: 1.0
In-Reply-To: <1248305055.25100.4.camel@toffee>
References: <1245931298.13359.8.camel@localhost.localdomain>
	 <4A439D7D.9030401@shipmail.org> <1248197676.2368.11.camel@localhost>
	 <1248199231.2368.17.camel@localhost>
	 <1248204128.2368.20.camel@localhost> <1248268607.4703.450.camel@thor>
	 <1248269490.2336.2.camel@localhost> <4A6764E0.7080302@shipmail.org>
	 <1248302143.2336.3.camel@localhost> <1248305055.25100.4.camel@toffee>
Date: Thu, 23 Jul 2009 09:27:13 +1000
Message-ID: <21d7e9970907221627p5ebbef0di8748bb132b7e6d2c@mail.gmail.com>
Subject: Re: TTM page pool allocator
From: Dave Airlie <airlied@gmail.com>
To: Keith Whitwell <keithw@vmware.com>
Cc: Jerome Glisse <glisse@freedesktop.org>,
       =?ISO-8859-1?Q?Thomas_Hellstr=F6m?= <thomas@shipmail.org>,
       =?ISO-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "dri-devel@lists.sf.net" <dri-devel@lists.sf.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 23, 2009 at 9:24 AM, Keith Whitwell<keithw@vmware.com> wrote:
> On Wed, 2009-07-22 at 15:35 -0700, Jerome Glisse wrote:
>> On Wed, 2009-07-22 at 21:13 +0200, Thomas Hellström wrote:
>> > Jerome Glisse wrote:
>> > > On Wed, 2009-07-22 at 15:16 +0200, Michel Dänzer wrote:
>> > >
>> > >> On Tue, 2009-07-21 at 21:22 +0200, Jerome Glisse wrote:
>> > >>
>> > >>> On Tue, 2009-07-21 at 20:00 +0200, Jerome Glisse wrote:
>> > >>>
>> > >>>> On Tue, 2009-07-21 at 19:34 +0200, Jerome Glisse wrote:
>> > >>>>
>> > >>>>> On Thu, 2009-06-25 at 17:53 +0200, Thomas Hellström wrote:
>> > >>>>>
>> > >>>>>> 4) We could now skip the ttm_tt_populate() in ttm_tt_set_caching, since
>> > >>>>>> it will always allocate cached pages and then transition them.
>> > >>>>>>
>> > >>>>>>
>> > >>>>> Okay 4) is bad, what happens (my brain is a bit meltdown so i might be
>> > >>>>> wrong) :
>> > >>>>> 1 - bo get allocated tt->state = unpopulated
>> > >>>>> 2 - bo is mapped few page are faulted tt->state = unpopulated
>> > >>>>> 3 - bo is cache transitioned but tt->state == unpopulated but
>> > >>>>>     they are page which have been touch by the cpu so we need
>> > >>>>>     to clflush them and transition them, this never happen if
>> > >>>>>     we don't call ttm_tt_populate and proceed with the remaining
>> > >>>>>     of the cache transitioning functions
>> > >>>>>
>> > >>>>> As a workaround i will try to go through the pages tables and
>> > >>>>> transition existing pages. Do you have any idea for a better
>> > >>>>> plan ?
>> > >>>>>
>> > >>>>> Cheers,
>> > >>>>> Jerome
>> > >>>>>
>> > >>>> My workaround ruin the whole idea of pool allocation what happens
>> > >>>> is that most bo get cache transition page per page. My thinking
>> > >>>> is that we should do the following:
>> > >>>>        - is there is a least one page allocated then fully populate
>> > >>>>        the object and do cache transition on all the pages.
>> > >>>>        - otherwise update caching_state and leaves object unpopulated
>> > >>>>
>> > >>>> This needs that we some how reflect the fact that there is at least
>> > >>>> one page allocated, i am thinking to adding a new state for that :
>> > >>>> ttm_partialy_populated
>> > >>>>
>> > >>>> Thomas what do you think about that ?
>> > >>>>
>> > >>>> Cheers,
>> > >>>> Jerome
>> > >>>>
>> > >>> Attached updated patch it doesn't introduce ttm_partialy_populated
>> > >>> but keep the populate call in cache transition. So far it seems to
>> > >>> work properly on AGP platform
>> > >>>
>> > >> Yeah, this one works for me as well.
>> > >>
>> > >>
>> > >>> and helps quite a lot with performances.
>> > >>>
>> > >> Can't say I've noticed that however. How did you measure?
>> > >>
>> > >
>> > > gears
>> > Hmm,
>> > In gears there shouldn't really be any buffer allocation / freeing going
>> > on at all once the display lists are set up, and gears should really be
>> > gpu bound in most cases.
>> >
>> > what's the source of the buffer allocations / frees when gears is run?
>> >
>> > /Thomas
>>
>> We free reallocate vertex buffer each frame iirc.
>
> Gears does everything in display lists which means geometry is held in
> VBOs retained for the life of the application.  Once the first frame is
> rendered there shouldn't be any more uploads.
>

I don't think the r300 driver does proper vbo's yet.

Dave.
