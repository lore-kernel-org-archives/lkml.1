Return-Path: <linux-kernel-owner+w=401wt.eu-S934116AbYBVElz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934116AbYBVElz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 23:41:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758565AbYBVEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 23:41:41 -0500
Received: from kuber.nabble.com ([216.139.236.158]:55081 "EHLO
	kuber.nabble.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758401AbYBVElk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 23:41:40 -0500
Message-ID: <15627654.post@talk.nabble.com>
Date: Thu, 21 Feb 2008 20:41:39 -0800 (PST)
From: zzCherring <zzjolin2005@hotmail.com>
To: linux-kernel@vger.kernel.org
Subject: how to setup struct bio
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Nabble-From: zzjolin2005@hotmail.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,
I am having problem reading first several blocks from disk(/dev/sda1, for
example). Not sure if it is because i am not doing correctly as to creating
struct bio, filling its fields and sending it down to block device, or it is
because there are certain rools which prevent the first couple of blocks of
disk from being read out, which sounds ridiculous.

Following is how i am doing it now,

Thanks.


// used in completion routine, trying to sync back to the calling //thread.
struct __io_complete_d
{
wait_queue_head_t whead;

unsigned int err;
unsigned int len;
unsigned int flags;
};

// completion routine
int io_complete_r( struct bio *b, unsigned int n, int err )
{
struct __io_complete_d *icd = 0;

if( b != 0 )
{
if( b->bi_private )
{
icd = ( struct __io_complete_d *)b->bi_private;
icd->err = err;
icd->len = n;
icd->flags = 1;
wake_up(&icd->whead);
}

if( b->bi_destructor ) b->bi_destructor(b);
}

return err;
}

// alloc page, send bio down to block device
struct page * read_from_disk(
struct block_device *bdev,
void *d,
bio_end_io_t *io_complete,
sector_t sect_off,
unsigned int od
)
{
struct bio *b = 0;
struct page *pg = 0;

if( bdev == 0 ) return 0;

// having tried alloc_pages(as it is a macro), but failed somehow
pg = __alloc_pages(GFP_KERNEL, od, contig_page_data.node_zonelists +
(GFP_KERNEL & GFP_ZONEMASK));

if( pg )
{
b = bio_alloc(GFP_KERNEL, 1);
if( b == 0)
{
__free_pages( pg, od);
pg = 0;

return 0;
}

b->bi_sector = sect_off;
b->bi_next = 0;
b->bi_bdev = bdev;
b->bi_end_io = io_complete;

b->bi_private = d;

bio_add_page( b, pg, PAGE_SIZE << od, 0 );

submit_bio(0, b);

}

return pg;
}

// example using read_from_disk
void example(
struct block_device *bdev,
unsigned int nblocks
)
{
struct __io_complete_d *icd = 0;
struct page *pg = 0;

if( bdev == 0 )
{
return 0;
}

icd = kmalloc( GFP_KERNEL, sizeof(struct __io_complete_d));
if(icd == 0)
{
goto __end;
}

memset( icd, 0, sizeof(struct __io_complete_d));
icd->flags = 0;
init_waitqueue_head( &icd->whead);

pg = read_from_disk( bdev, icd, io_complete_r, nblock * BLOCK_SIZE
/SECT_SIZE, 0 );
if( pg == 0 ) goto __end;

wait_event( icd->whead, icd->flags != 0 );

if(icd->err == 0)
{
// After successfully reading from disk

}
//.....

_end:
if(icd)
{
kfree(icd);
}
if(pg)
{
__free_pages(pg, 0);
}

}
-- 
View this message in context: http://www.nabble.com/how-to-setup-struct-bio-tp15627654p15627654.html
Sent from the linux-kernel mailing list archive at Nabble.com.

