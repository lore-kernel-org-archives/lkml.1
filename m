Return-Path: <linux-kernel-owner+w=401wt.eu-S1760187AbYGGBWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760187AbYGGBWT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 21:22:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbYGGBWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 21:22:09 -0400
Received: from wf-out-1314.google.com ([209.85.200.174]:36785 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757461AbYGGBWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 21:22:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=oAmIw5egerQyJrt9nCJGIFIlXVuiUhzehZ69IFwIC6YigPoQIQCeHUajQduTrQVqYw
         LIkO5XnqCTFUOphD7Y5O254jcAPiHPR9tPbA61z65PjIq1SEcc2LLG9z9gvpuH8Es1cS
         9j+CNcRe1VmGObVVEOEGWqEhREVXv494yLq+c=
Message-ID: <9871ee5f0807061822l2871765bhd92aa177c0d5d55b@mail.gmail.com>
Date: Sun, 6 Jul 2008 21:22:07 -0400
From: "Timothy Normand Miller" <theosib@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: HELP: Getting unexpected fakeraid behavior. Fix?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <9871ee5f0807061307ncc55104y477c57be3e91b75f@mail.gmail.com>
	 <20080706131937.13065312@infradead.org>
	 <9871ee5f0807061424o535c6d7eg3071da6e31e0b58e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have absolutely no idea what I'm doing, but the kernel source is
well formatted.  Here's what I found.  I'm looking in
"drivers/md/dm-raid1.c".

There's this function that seems to be involved in initiating reads:

static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 970{
 971        region_t region;
 972        struct bio *bio;
 973        struct mirror *m;
 974
 975        while ((bio = bio_list_pop(reads))) {
 976                region = bio_to_region(&ms->rh, bio);
 977                m = get_default_mirror(ms);
 978
 979                /*
 980                 * We can only read balance if the region is in sync.
 981                 */
 982                if (likely(rh_in_sync(&ms->rh, region, 1)))
 983                        m = choose_mirror(ms, bio->bi_sector);
 984                else if (m && atomic_read(&m->error_count))
 985                        m = NULL;
 986
 987                if (likely(m))
 988                        read_async_bio(m, bio);
 989                else
 990                        bio_endio(bio, -EIO);
 991        }
 992}

It calls this function:

866static struct mirror *choose_mirror(struct mirror_set *ms, sector_t sector)
 867{
 868        struct mirror *m = get_default_mirror(ms);
 869
 870        do {
 871                if (likely(!atomic_read(&m->error_count)))
 872                        return m;
 873
 874                if (m-- == ms->mirror)
 875                        m += ms->nr_mirrors;
 876        } while (m != get_default_mirror(ms));
 877
 878        return NULL;
 879}

which seems to always choose the default mirror unless there's an
error on the default mirror.  I have absolutely no idea where to put
it, but it seems to me that a solution would be to keep track of the
last mirror and select the next one each time this function is called.

That would be a simple and blind round-robin, which isn't necessarily
the smartest thing to do, so it would require testing.  It also occurs
to me, given how long this code has been around (since 2003), that the
idea of distributing the read load may have been considered and
rejected.  Was it?  If not, this could be a valuable boost to Linux
RAID performance.  (I chose RAID1 both for the redundancy AND the read
performance boost, and so I was surprised to find that there was no
read performance boost under Linux.)

What is dm-round-robin.c for?  Is there a place where the kernel
source is heavily annotated so that a newbie can navigate it and
figure out what does what?

Cheers.

-- 
Timothy Normand Miller
http://www.cse.ohio-state.edu/~millerti
Open Graphics Project
