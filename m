Return-Path: <linux-kernel-owner+w=401wt.eu-S1760780AbZEKWrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760780AbZEKWrj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:47:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760686AbZEKWrO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:47:14 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37966 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760112AbZEKWrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:47:12 -0400
Date: Mon, 11 May 2009 15:40:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: marc.c.dionne@gmail.com, eparis@redhat.com, eparis@parisplace.org,
       hch@lst.de, alan@lxorguk.ukuu.org.uk, serue@us.ibm.com, hpa@zytor.com,
       sukadev@us.ibm.com, linux-kernel@vger.kernel.org, jbacik@redhat.com
Subject: Re: [v3][PATCH 5/5] Merge code for single
 andmultiple-instancemounts
Message-Id: <20090511154009.a6e10a0f.akpm@linux-foundation.org>
In-Reply-To: <20090511221502.GA32530@linux.vnet.ibm.com>
References: <20090307180816.GA30072@us.ibm.com>
	<20090307181232.GF30072@us.ibm.com>
	<7e0fb38c0905071335g7ebe972xa82faa1161f7ff0b@mail.gmail.com>
	<20090507212429.GA24064@linux.vnet.ibm.com>
	<1241735609.2907.4.camel@dhcp231-142.rdu.redhat.com>
	<20090507231844.GA27609@linux.vnet.ibm.com>
	<20090507232110.GB27609@linux.vnet.ibm.com>
	<4A04F5D7.2050909@gmail.com>
	<20090511221502.GA32530@linux.vnet.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 May 2009 15:15:02 -0700
Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> wrote:

> Marc Dionne [marc.c.dionne@gmail.com] wrote:
> > On 05/07/2009 07:21 PM, Sukadev Bhattiprolu wrote:
> >> Er. I meant add following lines after the memset().
> >>
> >> |         opts->mode    = DEVPTS_DEFAULT_MODE;
> >> |         opts->ptmxmode = DEVPTS_DEFAULT_PTMX_MODE;
> >
> > Adding those two lines (with . instead of ->) does fix the issue for me, 
> > thanks.
> >
> > | > Of course we would still need to understand if/
> > | > why this patch changes the settings.
> >
> > That particular patch changed things because the original memcpy in 
> > new_pts_mount() did this:
> >
> > memcpy(&fsi->mount_opts, opts, sizeof(opts));
> >
> > where opts was a pointer, not a structure.  So only the first few bytes of 
> > the blank opts actually got copied over.  The patch moved this memcpy to 
> > devpts_get_sb() and in the process fixed the sizeof error.
> 
> Here is a cleaner fix - When user space (/etc/rc.sysinit on RHEL5) mounts
> devpts, this problem might be masked since the mount system call could pass
> a non-NULL 'data' parmeter to devpts_get_sb().
> 
> I tested this patch by directly calling the system call mount() with a NULL
> data parameter. If you/Eric/Peter can confirm that this works for you, I will
> send this patch to Andrew.

You already sent it ;)

> >From 2f7746f4df78ff57125c4714f0cd64e739ccf804 Mon Sep 17 00:00:00 2001
> From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
> Date: Mon, 11 May 2009 13:11:11 -0700
> Subject: [PATCH] devpts: Correctly set default options
> 
> devpts_get_sb() calls memset(0) to clear mount options and calls
> parse_mount_options() if user specified any mount options. The memset(0) is
> bogus since the 'mode' and 'ptmxmode' options are non-zero by default.
> parse_mount_options() restores options to default anyway and can properly deal
> with NULL mount options.
> 
> So in devpts_get_sb() remove memset(0) and call parse_mount_options() even for
> NULL mount options.
> 
> Bug reported by Eric Paris: http://lkml.org/lkml/2009/5/7/448.

This patch fixes a post-2.6.29 regression, yes?

> Signed-off-by: Sukadev Bhattiprolu (sukadev@us.ibm.com)

Please use angled brackets around the email address.  Some lame
person's scripts probably require it.  <whistles innocently>

Under the he-merged-it-last rule, this patch should formally go via
Al's VFS tree.  But I would happily accept a stfu-and-merge it?

