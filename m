Return-Path: <linux-kernel-owner+w=401wt.eu-S1751231AbYEDUlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751231AbYEDUlf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753321AbYEDUlI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:41:08 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752679AbYEDUlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:41:06 -0400
Date: Sun, 4 May 2008 16:39:20 -0400
From: "Frank Ch. Eigler" <fche@redhat.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 34/37] LTTng instrumentation ipc
Message-ID: <20080504203920.GE23961@redhat.com>
References: <20080424150324.802695381@polymtl.ca> <20080424151407.622943449@polymtl.ca> <20080424230238.GA11699@martell.zuzino.mipt.ru> <y0mve26r874.fsf@ton.toronto.redhat.com> <20080425125607.GC28411@Krystal> <20080504210433.GB1040@martell.zuzino.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080504210433.GB1040@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi -

On Mon, May 05, 2008 at 01:04:33AM +0400, Alexey Dobriyan wrote:
> [...]
> > for the rest, a way that would not export too much information about
> > kernel's internals :
> > 
> > trace_mark(shm_start, "is_shm_fop %d file %p",
> >   file->f_op == &shm_file_operations, file);
> 
> And this is totally unexpected from you.
> 		In the name of bug-free kernel,
> 		  I DO WANT KERNEL INTERNALS!
> And I perfectly know which ones at which spots!

You as (or having the ear of) a subsystem maintainer can make that
judgement.  If your marker is more of a low-level field diagnostic
sort of thing, feel free to pass the most appropriate values - even
binary dumps of things.  An end user will not normally attach to those
markers.

> [...]
> And finally, systemtap.

(Thanks for trying it.)

> Reading some systemtap docs,
> http://sourceware.org/systemtap/wiki/UsingMarkers
> where examples of intelligent filtering are shown:
> 
> 	function inode_get_i_ino:long (i:long) %{ /* pure */
> 		struct inode *inode = (struct inode *)(long)THIS->i;
> 		THIS->__retvalue = kread(&(inode->i_ino));
> 		CATCH_DEREF_FAULT();
> 	%}
> 	probe kernel.mark("kfunc_entry")
> 	{
> 		printf("inode number: %d\n", inode_get_i_ino($arg1))
> 	}
> 
> Is this representative example?

I hope not -- this embedded-C stuff should only be necessary if we
need to compensate for the data-stingyness of the marker.  See just
below that on the wiki page for a more generous marker.

> If yes, systemtap only wants marker's name and ignores totally its
> fmt string. So, why add them in the first place?

Actually, systemtap will have consumed the format strings by then
(during script translate time), in order to figure out the types of
$argN.

> And if systemtap can hook at any place, it doesn't need markers (I
> haven't used it though, so correct me).

Systemtap doesn't *need* markers in the sense of it being an essential
prerequisite.  But it is beneficial to have them around, in order to:

- suffer only a small fraction of kprobes dispatching overhead
- pass pretty arbitrary parameters without relying on much compiler
  cooperation, and specifically without requiring debugging info


- FChE
