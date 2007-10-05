Return-Path: <linux-kernel-owner+w=401wt.eu-S1758476AbXJECx6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758476AbXJECx6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 22:53:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbXJECxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 22:53:48 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:47377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbXJECxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 22:53:47 -0400
Date: Thu, 4 Oct 2007 19:53:23 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Matthew Wilcox <matthew@wil.cx>, David Miller <davem@davemloft.net>,
       willy@linux.intel.com, nickpiggin@yahoo.com.au, hch@lst.de,
       mel@skynet.ie, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, dgc@sgi.com, jens.axboe@oracle.com,
       suresh.b.siddha@intel.com
Subject: Re: SLUB performance regression vs SLAB
Message-ID: <20071004195323.464f1c99@laptopd505.fenrus.org>
In-Reply-To: <Pine.LNX.4.64.0710041917020.14135@schroedinger.engr.sgi.com>
References: <20071004183224.GA8641@linux.intel.com>
	<Pine.LNX.4.64.0710041046270.11091@schroedinger.engr.sgi.com>
	<20071004192824.GA9852@linux.intel.com>
	<20071004.135537.39158051.davem@davemloft.net>
	<20071004210518.GR12049@parisc-linux.org>
	<Pine.LNX.4.64.0710041917020.14135@schroedinger.engr.sgi.com>
Organization: Intel
X-Mailer: Claws Mail 3.0.1 (GTK+ 2.12.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Oct 2007 19:43:58 -0700 (PDT)
Christoph Lameter <clameter@sgi.com> wrote:

> So there could still be page struct contention left if multiple
> processors frequently and simultaneously free to the same slab and
> that slab is not the per cpu slab of a cpu. That could be addressed
> by optimizing the object free handling further to not touch the page
> struct even if we miss the per cpu slab.
> 
> That get_partial* is far up indicates contention on the list lock
> that should be addressable by either increasing the slab size or by
> changing the object free handling to batch in some form.
> 
> This is an SMP system right? 2 cores with 4 cpus each? The main loop
> is always hitting on the same slabs? Which slabs would this be? Am I
> right in thinking that one process allocates objects and then lets
> multiple other processors do work and then the allocated object is
> freed from a cpu that did not allocate the object? If neighboring
> objects in one slab are allocated on one cpu and then are almost
> simultaneously freed from a set of different cpus then this may be
> explain the situation. -

one of the characteristics of the application in use is the following:
all cores submit IO (which means they allocate various scsi and block
structures on all cpus).. but only 1 will free it (the one the IRQ is
bound to). SO it's allocate-on-one-free-on-another at a high rate.

That is assuming this is the IO slab; that's a bit of an assumption
obviously (it's one of the slab things that are hot, but it's a complex
workload, there could be others)
