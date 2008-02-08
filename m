Return-Path: <linux-kernel-owner+w=401wt.eu-S1765312AbYBHWqw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765312AbYBHWqw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2008 17:46:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758032AbYBHWpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Feb 2008 17:45:17 -0500
Received: from wf-out-1314.google.com ([209.85.200.173]:56337 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbYBHWpN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2008 17:45:13 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=h7MirmbM/Ita6+vWIVFCW5p/PYahRHltGAEBg8Qrw7QsDfndXxs41xcNbH9idlg9fIrFHhvs2TiAIFopUYYdmr3dQ4BbihVIFtt2yew/eFBET986IK3Y+mSvpyroEKq21xNq1dJwtmx1LQP78CENA8Hojg2Wq11J6kwQlFl+jxw=
Message-ID: <170fa0d20802081445i42ff7f9em919946d0dc0537b0@mail.gmail.com>
Date: Fri, 8 Feb 2008 17:45:11 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Paul Clements" <paul.clements@steeleye.com>
Subject: Re: [Nbd] [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       nbd-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       "Jens Axboe" <jens.axboe@oracle.com>
In-Reply-To: <47ACA250.1010404@steeleye.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47AC87AE.9040408@steeleye.com>
	 <20080208093341.b4d02e22.randy.dunlap@oracle.com>
	 <20080208101151.935b575c.akpm@linux-foundation.org>
	 <47ACA250.1010404@steeleye.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 8, 2008 1:41 PM, Paul Clements <paul.clements@steeleye.com> wrote:
> Andrew Morton wrote:
> > On Fri, 8 Feb 2008 09:33:41 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >
> >> On Fri, 08 Feb 2008 11:47:42 -0500 Paul Clements wrote:
> >>
> >>> There have been numerous reports of problems with nbd and cfq. Deadline
> >>> gives better performance for nbd, anyway, so let's use it by default.
> >
> > Please define "problems".  If it's just "slowness" then we can live with
> > that, but I'd hope that Jens is aware and that it's understood.
> >
> > It it's "hangs" or "oopses" then we panic.
>
> The two problems I have experienced (which may already be fixed):
>
> 1) nbd hangs with cfq on RHEL 5 (2.6.18) -- this may well have been fixed

It has been fixed in RHEL5 (but not yet released AFAIK):
https://bugzilla.redhat.com/show_bug.cgi?id=241540#c43

On a slightly related performance note; I'm seeing that for NBD
devices both max_hw_sectors_kb  and max_sectors_kb are 127.  If I set
it to be 256 with the following patch I see a 25% improvement in
overall throughput:

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 5def9c5..ed63e2f 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -764,6 +764,7 @@ static int __init nbd_init(void)
                        put_disk(disk);
                        goto out;
                }
+               blk_queue_max_sectors(disk->queue, 512);
        }

        if (register_blkdev(NBD_MAJOR, "nbd")) {

Any chance we can take steps to make NBD not be artificially slow?
Any other recommendations for improving NBD throughput?

regards,
Mike
