Return-Path: <linux-kernel-owner+w=401wt.eu-S1758272AbZA2HKz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758272AbZA2HKz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 02:10:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752028AbZA2HKo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 02:10:44 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:42227 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbZA2HKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 02:10:43 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: open(2) says O_DIRECT works on 512 byte boundries?
Cc: kosaki.motohiro@jp.fujitsu.com, Greg KH <greg@kroah.com>,
       mtk.manpages@gmail.com, linux-man@vger.kernel.org,
       linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
In-Reply-To: <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com>
References: <20090128213322.GA15789@kroah.com> <20090129141338.34e44a1f.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20090129160826.701E.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Thu, 29 Jan 2009 16:10:39 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(CC to andrea)

> On Wed, 28 Jan 2009 13:33:22 -0800
> Greg KH <greg@kroah.com> wrote:
> 
> > In looking at open(2), it says that O_DIRECT works on 512 byte boundries
> > with the 2.6 kernel release:
> > 	Under Linux 2.4, transfer sizes, and the alignment of the user
> > 	buffer and  the file offset must all be multiples of the logical
> > 	block size of the file system.  Under Linux 2.6, alignment  to
> > 	512-byte  boundaries suffices.
> > 
> > However if you try to access an O_DIRECT opened file with a buffer that
> > is PAGE_SIZE aligned + 512 bytes, it fails in a bad way (wrong data is
> > read.)
> > 
> 
> IIUC, it's not related to 512bytes boundary. Just a race between
> direct-io v.s. copy-on-write. Copy-on-Write while reading a page via DIO
> is a problem.

Yes.
Greg's reproducer is a bit misleading.

>	    for (j = 0; j < workers; j++) {
>		worker[j].offset = offset + j * PAGE_SIZE;
>		worker[j].buffer = buffer + align + j * PAGE_SIZE;
>		worker[j].length = PAGE_SIZE;
>	    }

this code mean,
  - if align == 0, reader thread touch only one page.
    and the page is touched only one thread.
  - if align != 0, reader thread touch two page.
    and the page is touched two thread.

then, race is happend if align != 0.
We discussed this issue with andrea last month.
("Corruption with O_DIRECT and unaligned user buffers" thread)

As far as I know, he is working on fixing this issue now.


> 
> Maybe it's true that if buffer is aligned to page size, no copy-on-write will
> happen in usual program. But assuming HugeTLB page, which does Copy-on-Write,
> data corruption will happen again. HugeTLB aligned buffer is nonsense.





