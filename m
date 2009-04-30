Return-Path: <linux-kernel-owner+w=401wt.eu-S1760171AbZD3BnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760171AbZD3BnI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 21:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752631AbZD3Bmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 21:42:55 -0400
Received: from hera.kernel.org ([140.211.167.34]:44523 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753140AbZD3Bmy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 21:42:54 -0400
Message-ID: <49F900F3.2060009@kernel.org>
Date: Thu, 30 Apr 2009 10:37:55 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
CC: linux-scsi <linux-scsi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Boaz Harrosh <bharrosh@panasas.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Hannes Reinecke <hare@suse.de>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Douglas Gilbert <dgilbert@interlog.com>, Christoph Hellwig <hch@lst.de>,
       Jens Axboe <jens.axboe@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [PATCH] [Target_Core_Mod/pSCSI]: Add	block/blk-map.c:blk_rq_map_kern_sg()
 usage
References: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
In-Reply-To: <1240965782.32740.309.camel@haakon2.linux-iscsi.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 30 Apr 2009 01:38:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Nicholas.

Nicholas A. Bellinger wrote:
...
> Once Tejun's patches for block/blk-map.c:blk_rq_map_kern_sg() have
> been included upstream, the legacy pscsi_map_task_SG() will be
> removed and blk-map will become the preferred method for accessing
> struct scatterlist -> struct scsi_device for SCSI target operations.
> For now, I have created a blk-map branch in lio-core-2.6.git with
> LINUX_USE_NEW_BLK_MAP=1 and left LINUX_USE_NEW_BLK_MAP=0 in branch
> master.

Hmm... I don't think the patch will go in as-is although there seem to
be some places which can make use of sg mapping interface (including
OSD).  Currently there are following problems.

* Single kmalloc()ing the whole bio has higher chance of failing if
  the bvec becomes very large.

* Boaz is worried about performance implications with going back and
  forth between sgl and bvec.

In longer term, I think where we should be headed is...

* Expand sgl( or t) such that 1. it uses separate list for cpu and dma
  addresses so that it doesn't take up twice as much space
  unnecessarily, 2. sgl's can be easily chained (alerady somewhat
  there) and thus we don't have to worry about chaining in higher
  layer.

* Replace bvec with sgl in bio.

Dunno what we should do in the meantime tho.

Thanks.

-- 
tejun
