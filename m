Return-Path: <linux-kernel-owner+w=401wt.eu-S1754530AbZANSGY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbZANSGY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:06:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754273AbZANSF6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:05:58 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53184 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbZANSF5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:05:57 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <496E2956.7050308@s5r6.in-berlin.de>
Date: Wed, 14 Jan 2009 19:05:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.19) Gecko/20090104 SeaMonkey/1.1.14
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Kristian_H=F8gsberg?= <krh@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Manfred Spraul <manfred@colorfullife.com>, dcm@acm.org,
       Nadia.Derbey@bull.net, linux1394-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, paulmck@us.ibm.com
Subject: Re: [PATCH] lib/idr.c: Zero memory properly in idr_remove_all
References: <1231571060.3538.18.camel@localhost.localdomain>	 <49686465.70501@s5r6.in-berlin.de>	 <20090110011557.9d94e111.akpm@linux-foundation.org>	 <496872E0.9030007@s5r6.in-berlin.de>	 <1231773620.6365.21.camel@gaara.bos.redhat.com>	 <496B9FC7.3090108@colorfullife.com>	 <1231792712.6365.31.camel@gaara.bos.redhat.com>	 <496BAD1C.5060201@colorfullife.com>	 <20090113144802.39dc4c23.akpm@linux-foundation.org>	 <1231942990.8542.7.camel@gaara.bos.redhat.com>	 <496E111A.9010808@s5r6.in-berlin.de> <1231950802.9435.4.camel@gaara.bos.redhat.com>
In-Reply-To: <1231950802.9435.4.camel@gaara.bos.redhat.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kristian Høgsberg wrote:
> On Wed, 2009-01-14 at 17:21 +0100, Stefan Richter wrote:
>> Kristian Høgsberg wrote:
>>> On Tue, 2009-01-13 at 14:48 -0800, Andrew Morton wrote:
>>>> What do we think of just removing the constructor and using
>>>> kmem_cache_zalloc()?
>>> We still need to zero out the idr_layer before returning it to the idr's
>>> internal free list.
>> I think so too.  But a more robust solution would IMO be to initialize
>> an idr_layer /before/ use, not /after/ use.  Will send a patch later.
> 
> The reason it was done this way is that normally, when the layers are
> returned to the free list they're already zero'ed out (since their
> elements have been removed one by one), so no need to do this on later
> re-initialization or when freeing.  It's a silly little
> sup-optimization.

Ah, right.

> idr_remove_all() is different in that it doesn't
> incrementally zero out the layer, and so it has to do it using a memset.
> 
> If you want rework how this works, I'd suggest just not using the free
> list except for in the idr_pre_get()+idr_get() sequence.  When a layer
> is no longer used, just free it, don't put it back on the free list.
> And use kmem_cache_zalloc() in idr_pre_get() as Andrew suggests.

Wait a moment:  Nadia's change (which introduced the bug) also already
implements your suggestion.  idr_remove_all feeds to the kmem cache now,
not to the free list anymore.

So, Andrew, I take back my assertion that the sequence

	idr_remove_all(idr);

	if (idr_pre_get(idr, GFP_KERNEL))
		id = idr_get_new(idr, p, h);

would be unsafe.  Your fix has this covered as well.
-- 
Stefan Richter
-=====-==--= ---= -===-
http://arcgraph.de/sr/
