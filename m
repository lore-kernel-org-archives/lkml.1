Return-Path: <linux-kernel-owner+w=401wt.eu-S1757663AbYHPAQr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757663AbYHPAQr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 20:16:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbYHPAQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 20:16:39 -0400
Received: from n3b.bullet.mail.ac4.yahoo.com ([76.13.13.73]:30224 "HELO
	n3b.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751046AbYHPAQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 20:16:38 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 78790.63885.bm@omp122.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:MIME-Version:Content-Type:Message-ID;
  b=BNdZCW8u6SdbK1Sj+AO3UXi5O+aM6lLaIGqwca+9MzG/t+MZ6o2+2O3eTww7cSIJSfWMCPqjDErNNOrxX0HnKSlrirTwIapacTWZhWEW3oqbh0W6h7k5rJoNafTCcCKmBd+VYW01BQSBnNA6mFnc6AeNbx7+7UXPjGmwTuXL/8g=;
X-Mailer: YahooMailWebService/0.7.218
Date: Fri, 15 Aug 2008 17:16:37 -0700 (PDT)
From: Tech Yes <techoyes@yahoo.com>
Reply-To: techoyes@yahoo.com
Subject: dm_io_async_bvec API in 2.6.26
To: Kernel Linux <linux-kernel@vger.kernel.org>
Cc: mbroz@redhat.com, agk@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <980080.67586.qm@web59704.mail.ac4.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All



I am in the process of porting a driver written for 2.6.21 that uses 
dm_io_async_bvec and dm_io_sync_vm. Looks like in the latest kernel
both these API s have been removed.

After looking at the patch I created 2 wrapper functions as follows. 

static int  _my_dm_io_async_bvec(unsigned int num_regions, struct io_region
*where, int rw, struct bio_vec *bvec, io_notify_fn fn, void *context)

{
    struct io_job *job=(struct io_job *)context;
    struct io_job_owner *cctx= job->owner;
    struct dm_io_request iorq;

    iorq.bi_rw = (rw | (1 << BIO_RW_SYNC));
    iorq.mem.type = DM_IO_BVEC;
    iorq.mem.ptr.bvec = bvec;
    iorq.notify.fn = fn;
    iorq.notify.context = context;
    iorq.client = cctx->dm_ioclnt; 
    return dm_io(&iorq,num_regions,where,NULL);
}



static int _my_dm_io_sync_vm(unsigned int num_regions, struct io_region *where, int rw, void *data, unsigned long *error_bits, struct io_job_owner *cctx)

{
    struct dm_io_request iorq;
    iorq.bi_rw= (rw | (1 << BIO_RW_SYNC));

    iorq.mem.type=DM_IO_VMA;
    iorq.mem.ptr.vma=data;
    iorq.notify.fn=NULL;
    iorq.notify.context=NULL;
    iorq.client=cctx->mdx_ioclnt;
    return dm_io(&iorq,num_regions,where,NULL);
}


Except
passing in the owner of the io job in dm_io_sync_vm the calling
convention is the same as what we had in 2.6.21. I create the dm io
clients in the constructor of the dm.

Here is the question. As advised in the comment in dm_io if I use the BIO_RW_SYNC flag my performance tanks. If I don't use it  I get  data corruption within my dm.  How do  I  get around this?  Is there an example  I could follow that previously used  these API s and now using dm-io that you can direct me to? 

My porting was based on the dm-raid1 port.

Interestingly they dont use the flag BIO_RW_SYNC and I cannot find a place
where they call blk_unplug() with regards to dm-io in that code. 

Some suggestions are very welcome

Thanks in advance

Yes2Tech


      

