Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbZDHBS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbZDHBS1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 21:18:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761015AbZDHBR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 21:17:56 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50076 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760946AbZDHBRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 21:17:55 -0400
Date: Tue, 7 Apr 2009 18:15:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Robin Holt <holt@sgi.com>
Cc: linux-kernel@vger.kernel.org, dcn@sgi.com
Subject: Re: [Patch 2/3] Prevent false sgi-xpc heartbeat failures.
Message-Id: <20090407181537.aca1364e.akpm@linux-foundation.org>
In-Reply-To: <20090408010449.GC10768@sgi.com>
References: <20090403160440.637837240@attica.americas.sgi.com>
	<20090403160449.144474404@attica.americas.sgi.com>
	<20090407124933.c2fb210f.akpm@linux-foundation.org>
	<20090408010449.GC10768@sgi.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 20:04:49 -0500 Robin Holt <holt@sgi.com> wrote:

> On Tue, Apr 07, 2009 at 12:49:33PM -0700, Andrew Morton wrote:
> > On Fri, 03 Apr 2009 11:04:42 -0500
> > holt@sgi.com wrote:
> > 
> > > +void (*xpc_allow_hb) (short partid);
> > > +void (*xpc_disallow_hb) (short partid);
> > > +void (*xpc_disallow_all_hbs) (void);
> > >  void (*xpc_heartbeat_init) (void);
> > >  void (*xpc_heartbeat_exit) (void);
> > >  void (*xpc_increment_heartbeat) (void);
> > 
> > The driver adds a huge number of globals.
> > 
> > As a pointless cleanup it might be nice to convert all this:
> 
> 
> Andrew,
> 
> Was this what you were thinking?  I just slapped this together.  It is not
> ready for inclusion yet.  I need to review the patch and test it first.
> 
> Index: 20090407-dcn-fixes/drivers/misc/sgi-xp/xpc.h
> ===================================================================
> --- 20090407-dcn-fixes.orig/drivers/misc/sgi-xp/xpc.h	2009-04-07 16:33:11.000000000 -0500
> +++ 20090407-dcn-fixes/drivers/misc/sgi-xp/xpc.h	2009-04-07 19:50:26.000000000 -0500
> @@ -780,6 +780,67 @@ struct xpc_partition {
>  
>  } ____cacheline_aligned;
>  
> +struct xpc_arch_operations {
> ...
> +};
>
> ...
>
> +extern struct xpc_arch_operations *xpc_arch_ops;

That adds an extra pointer dereference for each call.  I was thinking

  extern struct xpc_arch_operations xpc_arch_ops;

  static void
  xpc_start_hb_beater(void)
  {
	xpc_heartbeat_init();
	xpc_arch_ops.heartbeat_init();

which should generate the same code - it's just syntactic sugar.

