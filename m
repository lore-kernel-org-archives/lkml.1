Return-Path: <linux-kernel-owner+w=401wt.eu-S1756783AbYFHVHZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783AbYFHVHZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 17:07:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755232AbYFHVHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 17:07:13 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:44807 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbYFHVHM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 17:07:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=PwpgWqxvlM9iTVLjYfpp8G9LoZfSPOcOlj6lPVXts/SFIDYvXY8VvpY+bRNIOEr9wC
         vzEHNoIWAoAtlMFDupOFgAeqijDJWKsP/j4rV4AquRoyRE3S3rsy+QkGlViU32frgpJ/
         zwscCdW9aTwdZXbiYO9olqGHGxHfrQ2ZsrkLE=
Message-ID: <2f11576a0806081407l5d26d229ye252ff378434e787@mail.gmail.com>
Date: Mon, 9 Jun 2008 06:07:09 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH -mm 13/25] Noreclaim LRU Infrastructure
Cc: "Andrew Morton" <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       lee.schermerhorn@hp.com, linux-mm@kvack.org, eric.whitney@hp.com
In-Reply-To: <20080608163413.08d46427@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080606202838.390050172@redhat.com>
	 <20080606202859.291472052@redhat.com>
	 <20080606180506.081f686a.akpm@linux-foundation.org>
	 <20080608163413.08d46427@bree.surriel.com>
X-Google-Sender-Auth: 4f01c7e3296cc6d5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> > +#ifdef CONFIG_NORECLAIM_LRU
>> > +   PG_noreclaim,           /* Page is "non-reclaimable"  */
>> > +#endif
>>
>> I fear that we're messing up the terminology here.
>>
>> Go into your 2.6.25 tree and do `grep -i reclaimable */*.c'.  The term
>> already means a few different things, but in the vmscan context,
>> "reclaimable" means that the page is unreferenced, clean and can be
>> stolen.  "reclaimable" also means a lot of other things, and we just
>> made that worse.
>>
>> Can we think of a new term which uniquely describes this new concept
>> and use that, rather than flogging the old horse?
>
> Want to reuse the BSD term "pinned" instead?

I like this term :)
but I afraid to somebody confuse Xen/KVM term's pinned page.
IOW, I guess somebody imazine from "pinned page" to below flag.

#define PG_pinned               PG_owner_priv_1 /* Xen pinned pagetable */

I have no idea....


>> > +/**
>> > + * add_page_to_noreclaim_list
>> > + * @page:  the page to be added to the noreclaim list
>> > + *
>> > + * Add page directly to its zone's noreclaim list.  To avoid races with
>> > + * tasks that might be making the page reclaimble while it's not on the
>> > + * lru, we want to add the page while it's locked or otherwise "invisible"
>> > + * to other tasks.  This is difficult to do when using the pagevec cache,
>> > + * so bypass that.
>> > + */
>>
>> How does a task "make a page reclaimable"?  munlock()?  fsync()?
>> exit()?
>>
>> Choice of terminology matters...
>
> Lee?  Kosaki-san?

IFAIK, moving noreclaim list to reclaim list happend at below situation.

mlock'ed page
  - all mlocked process exit.
  - all mlocked process call munlock().
  - page related vma vanished
    (e.g. mumap, mmap, remap_file_page)

SHM_LOCKed page
  -  sysctl(SHM_UNLOCK) called.
