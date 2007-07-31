Return-Path: <linux-kernel-owner+w=401wt.eu-S965673AbXGaCQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965673AbXGaCQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 22:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbXGaCQA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 22:16:00 -0400
Received: from cantor.suse.de ([195.135.220.2]:52629 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbXGaCP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 22:15:59 -0400
From: NeilBrown <neilb@suse.de>
To: linux-kernel@vger.kernel.org
Date: Tue, 31 Jul 2007 12:15:45 +1000
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YDui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Subject: [PATCH 000 of 35] Refactor block layer to improve support for stacked devices.
Message-ID: <20070731112539.22428.patches@notabene>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


The following 35(!) patches achieve a refactoring of some parts of the
block layer to provide better support for stacked devices.

The core issue is that of letting bio_add_page know the limitation
that the device imposes so that it doesn't create a bio that is too large.

For a unstacked disk device (e.g. scsi), bio_add_page can access
max_nr_sectors and max_nr_segments and some other details to know how
segments should be counted, and does the appropriate checks (this is a
simplification, get is close enough for this discussion).

For stacked devices (dm, md etc) bio_add_page can also call into the
driver via merge_bvec_fn to find out if a page can be added to a bio.

This mostly works for a simple stack (e.g. md on scsi) but breaks down
with more complicated stacks (dm on md on scsi) as the recusive calls
to merge_bvec_fn that are required are difficult to get right, and
don't provide any guarantees in the face of array reconfiguration anyway.
dm and md both take the approach of "if the never level down defines
merge_bvec_fn, then set max_sectors to PAGE_SIZE/512 and live with small
requests".

So this patchset introduces a new approach.  bio_add_page is allowed
to create bios as big as it likes, and each layer is responsible for
splitting that bio up as required.

For intermediate levels like raid0, a number of new bios might be
created which refer to parts of the original, including parts of the
bi_io_vec.

For the bottom level driver (__make_request), each "struct request"
can refer to just part of a bio, so a bio can be effectively split
among several requests (a request can still reference multiple small
bios, and can concievable list parts of large bios and some small bios
as well, though the merging required to achieve this isn't implemented
yet - that patch set is big enough as it is).

This requires that the bi_io_vec become immutable, and that certain
parts of the bio become immutable.

To achieve this, we introduce fields into the bio so that it can point
to just part of the bi_io_vec (an offset and a size) and introduce
similar fields into 'struct request' to refer to only part of a bio list.

I am keen to receive both review and testing.  I have tested it on
SATA drives with a range of md configurations, but haven't tested dm,
or ide-floppy, or various other bits that needed to be changed.

Probably the changes that are mostly likely to raise eyebrows involve
the code to iterate over the segments in a bio or in a 'struct
request', so I'll give a bit more detail about them here.

Previously these (bio_for_each_segment, rq_for_each_bio) were simple
macros that provided pointers into bi_io_vec.  

As the actual segments that a request might need to handle may no
longer be explicitly in bi_io_vec (e.g. an offset might need to be
added, or a size restriction might need to be imposed) this is no
longer possible.  Instead, these functions (now rq_for_each_segment
and bio_for_each_segment) fill in a 'struct bio_vec' with appropriate
values.  e.g.
  struct bio_vec bvec;
  struct bio_iterator i;
  bio_for_each_segment(bvec, bio, i)
	use bvec.bv_page, bvec.bi_offset, bvec.bv_len

This might seem like data is being copied around a bit more, but it
should all be in L1 cache and could conceivable be optimised into
registers by the compiler, so I don't believe this is a big problem
(no, I haven't figured a good way to test it).

To achieve this, the "for_each" macros are now somewhat more complex.
For example, rq_for_each_segment is:

#define bio_for_each_segment_offset(bv, bio, _i, offs, _size)		\
	for (_i.i = 0, _i.offset = (bio)->bi_offset + offs,		\
		 _i.size = min_t(int, _size, (bio)->bi_size - offs);   	\
	     _i.i < (bio)->bi_vcnt && _i.size > 0;			\
	     _i.i++)							\
		if (bv = *bio_iovec_idx((bio), _i.i),			\
		    bv.bv_offset += _i.offset,				\
		    bv.bv_len <= _i.offset				\
		    ? (_i.offset -= bv.bv_len, 0)			\
		    : (bv.bv_len -= _i.offset,				\
		       _i.offset = 0,					\
		       bv.bv_len < _i.size				\
		       ? (_i.size -= bv.bv_len, 1)			\
		       : (bv.bv_len = _i.size,				\
			  _i.size = 0,					\
			  bv.bv_len > 0)))

#define bio_for_each_segment(bv, bio, __i)				\
		bio_for_each_segment_offset(bv, bio, __i, 0, (bio)->bi_size)

It does some with some explanatory text in a comment, but it is still
a bit daunting.  Any suggestions on making this more approachable
would be very welcome.

Rather than 'cc' this to various lists or individuals who might be
stake-holders in the relevant code, I am posting this full patchset
just to linux-kernel and will separate email some stakeholders with
pointers and an offer of the full patch set.

The patches are against 2.6.23-rc1-mm1.

Thanks for any feedback.

NeilBrown


 [PATCH 001 of 35] Replace bio_data with blk_rq_data
 [PATCH 002 of 35] Replace bio_cur_sectors with blk_rq_cur_sectors.
 [PATCH 003 of 35] Introduce rq_for_each_segment replacing rq_for_each_bio
 [PATCH 004 of 35] Merge blk_recount_segments into blk_recalc_rq_segments
 [PATCH 005 of 35] Stop updating bi_idx, bv_len, bv_offset when a request completes
 [PATCH 006 of 35] Only call bi_end_io once for any bio.
 [PATCH 007 of 35] Drop 'size' argument from bio_endio and bi_end_io.
 [PATCH 008 of 35] Introduce bi_iocnt to count requests sharing the one bio.
 [PATCH 009 of 35] Remove overloading of bi_hw_segments in raid5.
 [PATCH 010 of 35] New function blk_req_append_bio
 [PATCH 011 of 35] Stop exporting blk_rq_bio_prep
 [PATCH 012 of 35] Share code between init_request_from_bio and blk_rq_bio_prep
 [PATCH 013 of 35] Don't update bi_hw_*_size if we aren't going to merge.
 [PATCH 014 of 35] Change blk_phys/hw_contig_segment to take requests, not bios.
 [PATCH 015 of 35] Move hw_front_size and hw_back_size from bio to request.
 [PATCH 016 of 35] Centralise setting for REQ_NOMERGE.
 [PATCH 017 of 35] Fix various abuse of bio fields in umem.c
 [PATCH 018 of 35] Remove bi_idx
 [PATCH 019 of 35] Convert bio_for_each_segment to fill in a fresh bio_vec
 [PATCH 020 of 35] Add bi_offset and allow a bio to reference only part of a bi_io_vec
 [PATCH 021 of 35] Teach umem.c about bi_offset and to limit to bi_size.
 [PATCH 022 of 35] Teach dm-crypt to honour bi_offset and bi_size
 [PATCH 023 of 35] Teach pktcdvd.c to honour bi_offset and bi_size
 [PATCH 024 of 35] Allow request bio list not to end with NULL
 [PATCH 025 of 35] Treat rq->hard_nr_sectors as setting an overriding limit in the size of the request
 [PATCH 026 of 35] Split any large bios that arrive at __make_request.
 [PATCH 027 of 35] Remove bi_XXX_segments and related code.
 [PATCH 028 of 35] Split arbitrarily large requests to md/raid0 and md/linear
 [PATCH 029 of 35] Teach md/raid10 to split arbitrarily large bios.
 [PATCH 030 of 35] Teach raid5 to split incoming bios.
 [PATCH 031 of 35] Use bio_multi_split to fully split bios for pktcdvd.
 [PATCH 032 of 35] Remove blk_queue_merge_bvec and bio_split and related code.
 [PATCH 033 of 35] Simplify stacking of IO restrictions
 [PATCH 034 of 35] Simplify bio_add_page and raid1/raid10 resync which use it.
 [PATCH 035 of 35] Simplify bio splitting in dm.
