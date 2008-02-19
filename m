Return-Path: <linux-kernel-owner+w=401wt.eu-S1763298AbYBSKDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763298AbYBSKDe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 05:03:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754078AbYBSKD1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 05:03:27 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46245 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753846AbYBSKD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 05:03:26 -0500
Date: Tue, 19 Feb 2008 02:02:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Paul Clements <paul.clements@steeleye.com>, randy.dunlap@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] NBD: make nbd default to deadline I/O scheduler
Message-Id: <20080219020204.2d448269.akpm@linux-foundation.org>
In-Reply-To: <20080219092428.GT23197@kernel.dk>
References: <47ACA250.1010404@steeleye.com>
	<20080208204510.GD23197@kernel.dk>
	<20080208204713.GF23197@kernel.dk>
	<47ACC835.4070102@steeleye.com>
	<20080208140244.c850a5d3.akpm@linux-foundation.org>
	<47ADAB00.90306@steeleye.com>
	<20080212151602.f1803ef0.akpm@linux-foundation.org>
	<20080218181630.GI23197@kernel.dk>
	<20080218155001.97bf5976.akpm@linux-foundation.org>
	<20080219091943.GS23197@kernel.dk>
	<20080219092428.GT23197@kernel.dk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Feb 2008 10:24:28 +0100 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Feb 19 2008, Jens Axboe wrote:
> > On Mon, Feb 18 2008, Andrew Morton wrote:
> > > > +
> > > >  	if (e && !try_module_get(e->elevator_owner))
> > > >  		e = NULL;
> > > 
> > > Looks nice and simple.  There might be some of the usual ordering problems
> > > when this is called during boot, maybe is-initramfs-available-yet problems,
> > > etc.  But it's unlikely to make things regress from where they are now.
> > 
> > Isn't request_module() and below robust enough to handle that?
> 
> BTW, I've verified that it works as expected (at least after boot):
> 
> carl:/sys/block/sda/queue # cat scheduler 
> noop [cfq] 
> carl:/sys/block/sda/queue # echo anticipatory > scheduler 
> carl:/sys/block/sda/queue # dmesg
> [...]
> io scheduler anticipatory registered
> carl:/sys/block/sda/queue # cat scheduler 
> noop cfq [anticipatory] 
> 
> So it properly loads as-iosched instead of failing, like it would have
> done before and required the user to do a modprobe as-iosched first.
> 
> carl:/sys/block/sda/queue # echo foobar > scheduler 
> -bash: echo: write error: Invalid argument
> carl:/sys/block/sda/queue # dmesg
> [...]
> elevator: type foobar not found

Looks promising - let's run with it.  If there _are_ startup ordering
problems then we won't be any worse off than we are now.

otoh, the system must have _some_ io scheduler installed when talking to
disks, so perhaps there won't be any such problems at all.

