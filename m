Return-Path: <linux-kernel-owner+w=401wt.eu-S637734AbXCIKIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S637734AbXCIKIw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 05:08:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993100AbXCIKIv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 05:08:51 -0500
Received: from pfx2.jmh.fr ([194.153.89.55]:60733 "EHLO pfx2.jmh.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993099AbXCIKIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 05:08:51 -0500
From: Eric Dumazet <dada1@cosmosbay.com>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 2/7] revoke: add f_light flag for struct file
Date: Fri, 9 Mar 2007 11:08:58 +0100
User-Agent: KMail/1.9.5
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, hch@infradead.org,
       alan@lxorguk.ukuu.org.uk, serue@us.ibm.com
References: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
In-Reply-To: <Pine.LNX.4.64.0703091014110.32320@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703091108.58371.dada1@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 March 2007 09:14, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
>
> This adds a f_light flag to struct file to indicate that the file was
> looked up with fget_light().  Needed by revoke to ensure we don't
> close a file pointer while someone is using it without actually
> holding a reference.
>
> These bits were taken from the forced unmount patches by Tigran
> Aivazian.

Well, I disagree very much with this patch.

One of the interest of fget_light() is not dirtying file structure (avoiding 
atomic changes to f_count).

You add a 'flag' (4 bytes !) at the end of the file structure (so in a 
different cache line than the parts that are usually accessed in a fd_related 
syscall) and dirty this part at syscall entry and exit. Thats really a heavy 
price for supporting an unlikely revoke() syscall.

Also, the thing is racy.

( BTW, the whole revoke() concept is evil, especially if we want to avoid 
using inodes/dentries for some kind of pseudo files like sockets / pipes)

Cannot we use a flag in 'struct files_struct', set to one when the task is 
mono-thread (at task creation in fact), and set to 0 when it creates a new 
thread  (or when someone remotely access to this "struct files_struct" 
in /proc/pid/fd/... )

No need to set back this flag to 1 when task revert to mono-threaded, since 
this case is probably unlikely. This way we can be non racy.

