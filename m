Return-Path: <linux-kernel-owner+w=401wt.eu-S1755045AbZAIPKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755045AbZAIPKj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 10:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751189AbZAIPK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 10:10:29 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:58489 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750739AbZAIPK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 10:10:28 -0500
Subject: Re: [PATCH] async: Don't call async_synchronize_full_special()
 while holding sb_lock
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Grissiom <chaos.proton@gmail.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel <linux-fsdevel@vger.kernel.org>
In-Reply-To: <20090109082250.GQ9448@disturbed>
References: <a0adeea50901080007q5a3ed5c8y5a744ce37e677325@mail.gmail.com>
	 <1231425472.21528.13.camel@norville.austin.ibm.com>
	 <20090108072111.1ebadebd@infradead.org>
	 <1231429591.27353.14.camel@norville.austin.ibm.com>
	 <20090108225050.GL9448@disturbed> <49668388.708@linux.intel.com>
	 <20090109014054.GN9448@disturbed> <4966D652.4070105@linux.intel.com>
	 <20090109082250.GQ9448@disturbed>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 10:09:29 -0500
Message-Id: <1231513769.21333.17.camel@think.oraclecorp.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt707.oracle.com [141.146.40.85]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.496768AE.01A2:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-01-09 at 19:22 +1100, Dave Chinner wrote:
> >
> > the async code throttles at 32k outstanding.
> > Yes 32K is arbitrary, but if you delete  a million files fast, all
> > but the first few thousand are synchronous.
> 
> No, after the first 32k you get a mix of synchronous and async as
> the async queue gets processed in parallel. This means you are
> screwing up the temporal locality of the unlink of inodes. i.e. some
> unlinks are being done immediately, others are being delayed until
> another 32k inodes have been processed of the unlink list.
>
>
> If we've been careful about allocation locality during untar so
> that inodes that are allocated sequentially by untar will be
> deleted sequential by rm -rf, then this new pattern will break those
> optimisations because the unlink locality is being broken by
> the some sync/some async behaviour that this queuing mechanism
> creates.
> 

You won't notice on ext34, but xfs, btrfs and probably jfs should go
slower with this.  The throttle should wait for one of the entries on
the queue to finish, and then put this inode on the  queue in order.
Doing the current one synchronously will generate random IO.

On XFS, create 256,000 4k files, drop caches and then time find . |
xargs rm

> Hmmmm - I suspect that rm -rf will also trigger lots of kernel
> threads to be created. We do not want 256 kernel threads to
> be spawned to bang on the serialised regions of filesystem
> journals (generating lock contention) when one thread would
> be sufficient....

This could be good and bad.

-chris


