Return-Path: <linux-kernel-owner+w=401wt.eu-S1756351AbZCCV23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756351AbZCCV23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 16:28:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZCCV2S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 16:28:18 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:24408 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbZCCV2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 16:28:17 -0500
Date: Tue, 3 Mar 2009 15:28:16 -0600
From: scameron@beardog.cca.cpqcorp.net
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-kernel@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com,
       fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com,
       iss_storagedev@hp.com
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Message-ID: <20090303212816.GC15340@beardog.cca.cpqcorp.net>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net> <49AD5F8B.8060602@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49AD5F8B.8060602@cs.wisc.edu>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 03, 2009 at 10:49:15AM -0600, Mike Christie wrote:
> scameron@beardog.cca.cpqcorp.net wrote:

[...]

> >It's fast, works well, and has needed very little maintenance over the 
> >years.  Without knowing what you have in mind specifically, I don't see a
> >big need to change this.
> >
> 
> Other drivers have had to convert to and modify the host tagging to get 
> merged. They too had stable and fast code, and we complained and fought 
> against changing it :) I have had to convert or help convert libfc and 
> qla4xxx and I will now convert iscsi, so I feel your pain :)

I wasn't complaining, or even resisting actually.  What I was replying to 
there suggested we use "lists", with no more detail than that specified,
and not anything like what you describe below, so it wasn't clear to me
that anything concrete was being proposed instead of what we had.
Given what was written, it seemed to be just complaining about 
some code that looked a little bit complicated.  So *that* I was
resisting a bit, or at least pushing for some justification, but if 
there's an already established way to share the command allocation logic
between the scsi layer and low level driver as you describe I've got no
problem with that.

> 
> To create the map call scsi_init_shared_tag_map after you allocate the 
> scsi host and before you add it. Then in slave_alloc set the 
> sdev->tag_supported  = 1 and call scsi_activate_tcq. Then replace your 
> bitmap with:
> 
> for scsi commands:
> 
> c = h->cmd_pool + scsi_cmnd->request->tag
> 
> And for the reset path I was thinking you could use my patch in the 
> other mail and do
> 
> tag = blk_map_start_tag(scsi_host->bqt, NULL, 0);
> if (tag < 0)
> 	goto fail;
> c = h->cmd_pool + tag;
> c->cmdindex = tag;
> 
> In the completion path you need to do a blk_map_end_tag(scsi_host->bqt, 
> c->cmdindex);. The scsi/block layer will free the tag for scsi commadns.

That makes sense.  Thanks.

-- steve

