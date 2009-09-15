Return-Path: <linux-kernel-owner+w=401wt.eu-S934355AbZIODUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355AbZIODUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 23:20:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757515AbZIODUd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 23:20:33 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42258 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZIODUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 23:20:32 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 15 Sep 2009 12:18:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Christoph Lameter <clameter@sgi.com>, Ingo Molnar <mingo@elte.hu>,
       Tejun Heo <tj@kernel.org>, Nick Piggin <npiggin@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] vmalloc: ignore vmalloc area holes in vwrite()
Message-Id: <20090915121829.d78be0b8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090915031507.GA24963@localhost>
References: <20090915021851.168285585@intel.com>
	<20090915022328.328708489@intel.com>
	<20090915113425.d0bb3a2a.kamezawa.hiroyu@jp.fujitsu.com>
	<20090915031507.GA24963@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Sep 2009 11:15:07 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi Kame,
> 
> I'll go out for a while. If you are going to do your improvements to
> vmalloc.c, please feel free to do so. I can rebase the hwpoison bits
> after yours.
> 
> I could do the kmem part(in a modified patch 2/3) and let it return
> any error code vread/vwrite reports.  Ideally the kmem read/write
> could do
> 
>         if (zero bytes successfully read/written)
>                 return error_code;
>         else
>                 return bytes_so_far;
> 
> Do you agree?
> 
Okay. I'll write patches for vread/vwrite. And make them just return bool.
 true .....requested area includes valid memory range and worth to be copied.
 false.....no valid range found.

Thanks,
-Kame




> Thanks,
> Fengguang
> 
> On Tue, Sep 15, 2009 at 10:34:25AM +0800, KAMEZAWA Hiroyuki wrote:
> > On Tue, 15 Sep 2009 10:18:52 +0800
> > Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > > Siliently ignore all vmalloc area holes in vwrite(),
> > > and report success to the caller even if nothing is written.
> > > 
> > > CC: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Why don't you modify vread() at the same time ?
> > Because /proc/kcore ignores return value of vread(), I think you can
> > modify it without no side-effect.
> > 
> > Regards,
> > -Kame
> > 
> > > ---
> > >  mm/vmalloc.c |   13 ++-----------
> > >  1 file changed, 2 insertions(+), 11 deletions(-)
> > > 
> > > --- linux-mm.orig/mm/vmalloc.c	2009-09-15 10:08:33.000000000 +0800
> > > +++ linux-mm/mm/vmalloc.c	2009-09-15 10:14:18.000000000 +0800
> > > @@ -1805,10 +1805,8 @@ finished:
> > >   *	@addr:		vm address.
> > >   *	@count:		number of bytes to be read.
> > >   *
> > > - *	Returns # of bytes which addr and buf should be incresed.
> > > + *	Returns # of bytes which addr and buf should be increased.
> > >   *	(same number to @count).
> > > - *	If [addr...addr+count) doesn't includes any intersect with valid
> > > - *	vmalloc area, returns 0.
> > >   *
> > >   *	This function checks that addr is a valid vmalloc'ed area, and
> > >   *	copy data from a buffer to the given addr. If specified range of
> > > @@ -1816,8 +1814,6 @@ finished:
> > >   *	proper area of @buf. If there are memory holes, no copy to hole.
> > >   *	IOREMAP area is treated as memory hole and no copy is done.
> > >   *
> > > - *	If [addr...addr+count) doesn't includes any intersects with alive
> > > - *	vm_struct area, returns 0.
> > >   *	@buf should be kernel's buffer. Because	this function uses KM_USER0,
> > >   *	the caller should guarantee KM_USER0 is not used.
> > >   *
> > > @@ -1834,7 +1830,6 @@ long vwrite(char *buf, char *addr, unsig
> > >  	struct vm_struct *tmp;
> > >  	char *vaddr;
> > >  	unsigned long n, buflen;
> > > -	int copied = 0;
> > >  
> > >  	/* Don't allow overflow */
> > >  	if ((unsigned long) addr + count < count)
> > > @@ -1856,18 +1851,14 @@ long vwrite(char *buf, char *addr, unsig
> > >  		n = vaddr + tmp->size - PAGE_SIZE - addr;
> > >  		if (n > count)
> > >  			n = count;
> > > -		if (!(tmp->flags & VM_IOREMAP)) {
> > > +		if (!(tmp->flags & VM_IOREMAP))
> > >  			aligned_vwrite(buf, addr, n);
> > > -			copied++;
> > > -		}
> > >  		buf += n;
> > >  		addr += n;
> > >  		count -= n;
> > >  	}
> > >  finished:
> > >  	read_unlock(&vmlist_lock);
> > > -	if (!copied)
> > > -		return 0;
> > >  	return buflen;
> > >  }
> > >  
> > > 
> > > -- 
> > > 
> > > 
> 

