Return-Path: <linux-kernel-owner+w=401wt.eu-S1753267AbYIDQAV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267AbYIDQAV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:00:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750822AbYIDQAH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:00:07 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:44332 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbYIDQAE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:00:04 -0400
Date: Thu, 4 Sep 2008 11:00:00 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, containers@lists.linux-foundation.org,
       jeremy@goop.org, linux-kernel@vger.kernel.org, arnd@arndb.de,
       dave@linux.vnet.ibm.com
Subject: Re: [RFC v3][PATCH 2/9] General infrastructure for checkpoint
	restart
Message-ID: <20080904160000.GB19364@us.ibm.com>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu> <Pine.LNX.4.64.0809040402170.5982@takamine.ncl.cs.columbia.edu> <20080904091230.GW14473@hawkmoon.kerlabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904091230.GW14473@hawkmoon.kerlabs.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Louis Rilling (Louis.Rilling@kerlabs.com):
> On Thu, Sep 04, 2008 at 04:02:38AM -0400, Oren Laadan wrote:
> >
> > Add those interfaces, as well as helpers needed to easily manage the
> > file format. The code is roughly broken out as follows:
> >
> > checkpoint/sys.c - user/kernel data transfer, as well as setup of the
> > checkpoint/restart context (a per-checkpoint data structure for
> > housekeeping)
> >
> > checkpoint/checkpoint.c - output wrappers and basic checkpoint handling
> >
> > checkpoint/restart.c - input wrappers and basic restart handling
> >
> > Patches to add the per-architecture support as well as the actual
> > work to do the memory checkpoint follow in subsequent patches.
> >
> 
> [...]
> 
> > diff --git a/include/linux/ckpt_hdr.h b/include/linux/ckpt_hdr.h
> > new file mode 100644
> > index 0000000..629ad5a
> > --- /dev/null
> > +++ b/include/linux/ckpt_hdr.h
> > @@ -0,0 +1,82 @@
> > +#ifndef _CHECKPOINT_CKPT_HDR_H_
> > +#define _CHECKPOINT_CKPT_HDR_H_
> > +/*
> > + *  Generic container checkpoint-restart
> > + *
> > + *  Copyright (C) 2008 Oren Laadan
> > + *
> > + *  This file is subject to the terms and conditions of the GNU General Public
> > + *  License.  See the file COPYING in the main directory of the Linux
> > + *  distribution for more details.
> > + */
> > +
> > +#include <linux/types.h>
> > +#include <linux/utsname.h>
> > +
> > +/*
> > + * To maintain compatibility between 32-bit and 64-bit architecture flavors,
> > + * keep data 64-bit aligned: use padding for structure members, and use
> > + * __attribute__ ((aligned (8))) for the entire structure.
> > + */
> > +
> > +/* records: generic header */
> > +
> > +struct cr_hdr {
> > +	__s16 type;
> > +	__s16 len;
> > +	__u32 parent;
> > +};
> > +
> > +/* header types */
> > +enum {
> > +	CR_HDR_HEAD = 1,
> > +	CR_HDR_STRING,
> > +
> > +	CR_HDR_TASK = 101,
> > +	CR_HDR_THREAD,
> > +	CR_HDR_CPU,
> > +
> > +	CR_HDR_MM = 201,
> > +	CR_HDR_VMA,
> > +	CR_HDR_MM_CONTEXT,
> > +
> > +	CR_HDR_TAIL = 5001
> > +};
> > +
> > +struct cr_hdr_head {
> > +	__u64 magic;
> > +
> > +	__u16 major;
> > +	__u16 minor;
> > +	__u16 patch;
> > +	__u16 rev;
> > +
> > +	__u64 time;	/* when checkpoint taken */
> > +	__u64 flags;	/* checkpoint options */
> > +
> > +	char release[__NEW_UTS_LEN];
> > +	char version[__NEW_UTS_LEN];
> > +	char machine[__NEW_UTS_LEN];
> > +} __attribute__((aligned(8)));
> > +
> > +struct cr_hdr_tail {
> > +	__u64 magic;
> > +} __attribute__((aligned(8)));
> > +
> > +struct cr_hdr_task {
> > +	__u64 state;
> > +	__u32 exit_state;
> > +	__u32 exit_code, exit_signal;
> 
> 64bits alignment issue?
> I probably missed it in previous versions...

In the first version it was followed by two __u16's (pid and tgid)...

-serge
