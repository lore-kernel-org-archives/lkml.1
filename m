Return-Path: <linux-kernel-owner+w=401wt.eu-S1757680AbZANJtM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757680AbZANJtM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 04:49:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757431AbZANJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 04:48:55 -0500
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:48503 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488AbZANJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 04:48:54 -0500
Message-ID: <496DB504.8090800@s5r6.in-berlin.de>
Date: Wed, 14 Jan 2009 10:48:52 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.19) Gecko/20081204 SeaMonkey/1.1.14
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
       Manfred Spraul <manfred@colorfullife.com>, krh@redhat.com, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com, stable@kernel.org
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	<49686465.70501@s5r6.in-berlin.de>	<20090110011557.9d94e111.akpm@linux-foundation.org>	<496872E0.9030007@s5r6.in-berlin.de>	<1231773620.6365.21.camel@gaara.bos.redhat.com>	<496B9FC7.3090108@colorfullife.com>	<1231792712.6365.31.camel@gaara.bos.redhat.com>	<496BAD1C.5060201@colorfullife.com>	<20090113144802.39dc4c23.akpm@linux-foundation.org>	<84144f020901132319g50dc9e50o283b0d263f287eea@mail.gmail.com>	<20090114001745.9575ab02.akpm@linux-foundation.org>	<496DA95B.6070401@s5r6.in-berlin.de> <20090114012234.bce79d7b.akpm@linux-foundation.org>
In-Reply-To: <20090114012234.bce79d7b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Wed, 14 Jan 2009 09:59:07 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> 
>> > --- a/lib/idr.c~lib-idrc-use-kmem_cache_zalloc-for-the-idr_layer-cache
>> > +++ a/lib/idr.c
>> > @@ -121,7 +121,7 @@ int idr_pre_get(struct idr *idp, gfp_t g
>> >  {
>> >  	while (idp->id_free_cnt < IDR_FREE_MAX) {
>> >  		struct idr_layer *new;
>> > -		new = kmem_cache_alloc(idr_layer_cache, gfp_mask);
>> > +		new = kmem_cache_zalloc(idr_layer_cache, gfp_mask);
>> >  		if (new == NULL)
>> >  			return (0);
>> >  		move_to_free_list(idp, new);
>> ...
>> 
>> I wonder if it would be more robust --- or even necessary --- to instead
>> add proper initialization code to get_from_free_list().
>> 
>> As far as David and I tested the new idr using code in firewire, we
>> called idr_remove_all() *and* idr_destroy() before any subsequent
>> idr_get_new().  But in practice, idr_get_new() may of course also happen
>> between idr_remove_all() and idr_destroy().
>> 
>> And then this fix won't be sufficient, would it?
> 
> Maybe I'm having a thick day, but I'm not following you at all here.
> 
> What do you think the remaining problem is?  get_from_free_list()
> starts out with a not-fully-zeroed object?  Something else?

AFAICS:

Before the faulty commit, all code sites which moved something into the
per-idr free list cleared the respective idr_layer.

After the faulty commit, idr_remove_all() forgot to do so.

After your patch, idr_remove_all() still doesn't clear anything.  But
there will typically be idr_destroy() called right after an
idr_remove_all().  idr_destroy() moves all idr_layers out of this idr's
free list back into the kernel-global idr_layer_cache.

Your fix only clears idr_layers which an idr_get_new*() pulls out of the
idr_layer_cache, but not any one which it pulls out of the idr's own
free list.

Hmm, OK.  Seems to be harmless as long as idr users don't start to add
new entries to an idr after they did idr_remove_all().

I presume there is none such user, is there?  Such a usage would be
unusual but not illegal, I suppose.

(Furthermore, I may by thoroughly mistaken about how lib/idr.c works.)
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
