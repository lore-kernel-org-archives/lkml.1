Return-Path: <linux-kernel-owner+w=401wt.eu-S1756907AbZGMUiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756907AbZGMUiv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 16:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755654AbZGMUiu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 16:38:50 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:63680 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600AbZGMUit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 16:38:49 -0400
Message-ID: <4A5B9B55.6000404@codemonkey.ws>
Date: Mon, 13 Jul 2009 15:38:45 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Chris Mason <chris.mason@oracle.com>, Avi Kivity <avi@redhat.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
       npiggin@suse.de, akpm@osdl.org, jeremy@goop.org,
       xen-devel@lists.xensource.com, tmem-devel@oss.oracle.com,
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org, kurt.hackel@oracle.com,
       Rusty Russell <rusty@rustcorp.com.au>, dave.mccracken@oracle.com,
       Marcelo Tosatti <mtosatti@redhat.com>, sunil.mushran@oracle.com,
       Schwidefsky <schwidefsky@de.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 0/4] (Take 2): transcendent memory ("tmem") for Linux
References: <a09e4489-a755-46e7-a569-a0751e0fc39f@default> <4A5A1A51.2080301@redhat.com> <4A5A3AC1.5080800@codemonkey.ws> <20090713201745.GA3783@think>
In-Reply-To: <20090713201745.GA3783@think>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Mason wrote:
> This depends on the extent to which tmem is integrated into the VM.  For
> filesystem usage, the hooks are relatively simple because we already
> have a lot of code sharing in this area.  Basically tmem is concerned
> with when we free a clean page and when the contents of a particular
> offset in the file are no longer valid.
>   

But filesystem usage is perhaps the least interesting part of tmem.

The VMM already knows which pages in the guest are the result of disk IO 
(it's the one that put it there, afterall).  It also knows when those 
pages have been invalidated (or it can tell based on write-faulting).

The VMM also knows when the disk IO has been rerequested by tracking 
previous requests.  It can keep the old IO requests cached in memory and 
use that to satisfy re-reads as long as the memory isn't needed for 
something else.  Basically, we have tmem today with kvm and we use it by 
default by using the host page cache to do I/O caching (via 
cache=writethrough).

The difference between our "tmem" is that instead of providing an 
interface where the guest explicitly says, "I'm throwing away this 
memory, I may need it later", and then asking again for it, the guest 
throws away the page and then we can later satisfy the disk I/O request 
that results from re-requesting the page instantaneously.

This transparent approach is far superior too because it enables 
transparent sharing across multiple guests.  This works well for CoW 
images and would work really well if we had a file system capable of 
block-level deduplification... :-)

Regards,

Anthony Liguori
