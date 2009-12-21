Return-Path: <linux-kernel-owner+w=401wt.eu-S1751590AbZLUXsT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590AbZLUXsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 18:48:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751097AbZLUXsS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 18:48:18 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:30044 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbZLUXsR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 18:48:17 -0500
MIME-Version: 1.0
Message-ID: <022609e4-9f30-4e8b-b26b-023cf58adf21@default>
Date: Mon, 21 Dec 2009 15:46:28 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: Nick Piggin <npiggin@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       jeremy@goop.org, xen-devel@lists.xensource.com,
       tmem-devel@oss.oracle.com, Rusty Russell <rusty@rustcorp.com.au>,
       Rik van Riel <riel@redhat.com>, dave.mccracken@oracle.com,
       Rusty@rcsinet15.oracle.com, sunil.mushran@oracle.com,
       Avi Kivity <avi@redhat.com>, Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Marcelo Tosatti <mtosatti@redhat.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, chris.mason@oracle.com,
       Pavel Machek <pavel@ucw.cz>, linux-mm <linux-mm@kvack.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: RE: Tmem [PATCH 0/5] (Take 3): Transcendent memory
In-Reply-To: <4B2F7C41.9020106@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.4  (308245) [OL
 9.0.0.6627]
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4B3008FE.005D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Nitin Gupta [mailto:ngupta@vflare.org]

> Hi Dan,

Hi Nitin --

Thanks for your review!

> (I'm not sure if gmane.org interface sends mail to everyone 
> in CC list, so
> sending again. Sorry if you are getting duplicate mail).

FWIW, I only got this one copy (at least so far)!
 
> I really like the idea of allocating cache memory from 
> hypervisor directly. This
> is much more flexible than assigning fixed size memory to guests.

Thanks!

> I think 'frontswap' part seriously overlaps the functionality 
> provided by 'ramzswap'

Could be, but I suspect there's a subtle difference.
A key part of the tmem frontswap api is that any
"put" at any time can be rejected.  There's no way
for the kernel to know a priori whether the put
will be rejected or not, and the kernel must be able
to react by writing the page to a "true" swap device
and must keep track of which pages were put
to tmem frontswap and which were written to disk.
As a result, tmem frontswap cannot be configured or
used as a true swap "device".

This is critical to acheive the flexibility you
commented above that you like.  Only the hypervisor
knows if a free page is available "now" because
it is flexibly managing tmem requests from multiple
guest kernels.

If my understanding of ramzswap is incorrect or you
have some clever solution that I misunderstood,
please let me know.

>> Cleancache is
> > "ephemeral" so whether a page is kept in cleancache 
> (between the "put" and
> > the "get") is dependent on a number of factors that are invisible to
> > the kernel.
> 
> Just an idea: as an alternate approach, we can create an 
> 'in-memory compressed
> storage' backend for FS-Cache. This way, all filesystems 
> modified to use
> fs-cache can benefit from this backend. To make it 
> virtualization friendly like
> tmem, we can again provide (per-cache?) option to allocate 
> from hypervisor  i.e.
> tmem_{put,get}_page() or use [compress]+alloc natively.

I looked at FS-Cache and cachefiles and thought I understood
that it is not restricted to clean pages only, thus
not a good match for tmem cleancache.

Again, if I'm wrong (or if it is easy to tell FS-Cache that
pages may "disappear" underneath it), let me know.

BTW, pages put to tmem (both frontswap and cleancache) can
be optionally compressed.

> For guest<-->hypervisor interface, maybe we can use virtio so that all
> hypervisors can benefit? Not quite sure about this one.

I'm not very familiar with virtio, but the existence of "I/O"
in the name concerns me because tmem is entirely synchronous.

Also, tmem is well-layered so very little work needs to be
done on the Linux side for other hypervisors to benefit.
Of course these other hypervisors would need to implement
the hypervisor-side of tmem as well, but there is a well-defined
API to guide other hypervisor-side implementations... and the
opensource tmem code in Xen has a clear split between the
hypervisor-dependent and hypervisor-independent code, which
should simplify implementation for other opensource hypervisors.

I realize in "Take 3" I didn't provide the URL for more information:
http://oss.oracle.com/projects/tmem
