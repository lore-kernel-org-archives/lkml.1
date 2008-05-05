Return-Path: <linux-kernel-owner+w=401wt.eu-S1761433AbYEEWX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761433AbYEEWX2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 18:23:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754143AbYEEWXU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 18:23:20 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:17105 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754028AbYEEWXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 18:23:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=swPKRU3H+qTo0JPVlMWqG78bWW2nLnLJwaTqr48zG++XmkxLw9dym0AQFKZy62DWsR7kVLGiDd16bTc8X7qAB+ytgPC8qef8BcKBKgnQ+xj5SQEhXudxkPkVvusaWY2IgP0w+5n5Ww87wt3NLWIUlMCWmIB40IUqmClps62b2lE=
Message-ID: <2f11576a0805051523h730fce0foa51f1fdbf9c46cbe@mail.gmail.com>
Date: Tue, 6 May 2008 07:23:18 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [-mm][PATCH 4/5] core of reclaim throttle
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20080505175142.7de3f27b@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080504201343.8F52.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504215819.8F5E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080504221043.8F64.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080505175142.7de3f27b@cuia.bos.redhat.com>
X-Google-Sender-Auth: e76715540c8a2f6a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  > +     throttle_on = 1;
>  > +     current->flags |= PF_RECLAIMING;
>  > +     wait_event(zone->reclaim_throttle_waitq,
>  > +              atomic_add_unless(&zone->nr_reclaimers, 1, MAX_RECLAIM_TASKS));
>
>  This is a problem.  Processes without __GFP_FS or __GFP_IO cannot wait on
>  processes that have those flags set in their gfp_mask, and tasks that do
>  not have __GFP_IO set cannot wait for tasks with it.  This is because the
>  tasks that have those flags set may grab locks that the tasks without the
>  flag are holding, causing a deadlock.

hmmm, AFAIK,
on current kernel, sometimes __GFP_IO task wait for non __GFP_IO task
by lock_page().
Is this wrong?

therefore my patch care only recursive reclaim situation.
I don't object to your opinion. but I hope understand exactly your opinion.

>  The easiest fix would be to only make tasks with both __GFP_FS and __GFP_IO
>  sleep.  Tasks that call try_to_free_pages without those flags are relatively
>  rare and should hopefully not cause any issues.

Agreed it's easy.
