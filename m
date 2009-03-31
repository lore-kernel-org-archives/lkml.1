Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbZCaKXU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbZCaKXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 06:23:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752317AbZCaKXF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 06:23:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155AbZCaKXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 06:23:04 -0400
Date: Tue, 31 Mar 2009 03:15:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Avishay Traeger <avishay@gmail.com>, Jeff Garzik <jeff@garzik.org>,
       Evgeniy Polyakov <zbr@ioremap.net>,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       open-osd <osd-dev@open-osd.org>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 4/8 ver5] exofs: address_space_operations
Message-Id: <20090331031523.fcf01cae.akpm@linux-foundation.org>
In-Reply-To: <49D1DCA4.6010306@panasas.com>
References: <49C1331D.1080805@panasas.com>
	<1237399473-29344-1-git-send-email-bharrosh@panasas.com>
	<49C64416.4060801@panasas.com>
	<20090331010420.8a12810e.akpm@linux-foundation.org>
	<49D1DCA4.6010306@panasas.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 12:04:36 +0300 Boaz Harrosh <bharrosh@panasas.com> wrote:

> >> +static int write_exec(struct page_collect *pcol)
> >> +{
> >> +	struct exofs_i_info *oi = exofs_i(pcol->inode);
> >> +	struct osd_obj_id obj = {pcol->sbi->s_pid,
> >> +					pcol->inode->i_ino + EXOFS_OBJ_OFF};
> >> +	struct osd_request *or = NULL;
> >> +	struct page_collect *pcol_copy = NULL;
> >> +	loff_t i_start = pcol->pg_first << PAGE_CACHE_SHIFT;
> > 
> > bug.  On 32-bit this shift will overflow prior to getting promoted to
> > 64-bit.  Do:
> > 
> > 	loff_t i_start = (loff_t)pcol->pg_first << PAGE_CACHE_SHIFT;
> > 
> 
> In that case I might make pcol->pg_first loff_t.

That would work.

> Why is inode->i_index not an loff_t then?

hm, what's i_index?

> Page-index <=> byte-offset, is done all the time 12 bits does not
> make a difference.

Page indices are 32-bit on 32-bit CPUs.  File offsets are 64-bit.  We
are careful to avoid the above overflow bug whenever the conversion
from page index to file size is made.  Try

	fgrep '(loff_t)' mm/*.c


