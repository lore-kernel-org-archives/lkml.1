Return-Path: <linux-kernel-owner+w=401wt.eu-S1755847AbZKTUyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755847AbZKTUyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 15:54:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZKTUyO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 15:54:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754918AbZKTUyL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 15:54:11 -0500
Date: Fri, 20 Nov 2009 15:54:16 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: dm-devel@redhat.com
Cc: Mikulas Patocka <mpatocka@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 06/13] dm snapshot: merge target should not allocate
 new exceptions
Message-ID: <20091120205416.GB9458@redhat.com>
References: <1258748873-24185-1-git-send-email-snitzer@redhat.com>
 <1258748873-24185-7-git-send-email-snitzer@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258748873-24185-7-git-send-email-snitzer@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 20 2009 at  3:27pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> If a write request to a merging snapshot device is to be dispatched
> directly to the origin (because the chunk is not remapped or was already
> merged), snapshot_merge_map() must make exceptions in other snapshots.
...
> +static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
> +			      union map_info *map_context)
> +{
> +	struct dm_exception *e;
> +	struct dm_snapshot *s = ti->private;
> +	int r = DM_MAPIO_REMAPPED;
> +	chunk_t chunk;
> +
> +	chunk = sector_to_chunk(s->store, bio->bi_sector);
> +
> +	down_read(&s->lock);
> +
> +	/* Full snapshots are not usable */
> +	if (!s->valid) {
> +		r = -EIO;
> +		goto out_unlock;
> +	}
> +
> +	/* If the block is already remapped - use that */
> +	e = dm_lookup_exception(&s->complete, chunk);
> +	if (e) {
> +		remap_exception(s, e, bio, chunk);
> +		goto out_unlock;
> +	}
> +
> +	bio->bi_bdev = s->origin->bdev;
> +
> +	if (bio_rw(bio) == WRITE) {
> +		up_write(&s->lock);
> +		return do_origin(s->origin, bio);
> +	}

OK, I caught this in review but clearly didn't refresh the patch; the
above up_write() should be up_read().

Mike
