Return-Path: <linux-kernel-owner+w=401wt.eu-S1762062AbXGVIeb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762062AbXGVIeb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 04:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756169AbXGVIeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 04:34:21 -0400
Received: from ozlabs.org ([203.10.76.45]:43609 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754449AbXGVIeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 04:34:19 -0400
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
From: Rusty Russell <rusty@rustcorp.com.au>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Dave Jones <davej@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>
In-Reply-To: <20070722081010.GA6317@mail.ustc.edu.cn>
References: <20070721210005.000228000@chello.nl>
	 <20070722023923.GA6438@mail.ustc.edu.cn> <20070722024428.GA724@redhat.com>
	 <20070722081010.GA6317@mail.ustc.edu.cn>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 18:33:56 +1000
Message-Id: <1185093236.6344.87.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> - It will avoid large-file-reads-thrashing-my-desktop problem,
>   so most desktop users should like it. But sure there will be counter
>   cases when a user want to keep the data cached.
> - File servers may hurt from it. Imagine a mp3/png file server. The
>   files are large enough to trigger drop-behind, but small (and hot)
>   enough to be cached. Also when a new fedora DVD iso is released, it
>   may be cached for some days. These are only the obvious cases.

I'm still not convinced of the latter case.  If a second user accesses
the file before it pages are thrown out, from my understanding there
won't be readahead but the pages will be put back on the active list
(ie. the dropbehind is undone).

AFAICT this patch truly biasses towards releasing pages from
sequentially accessed files.  So file servers where memory pressure
comes from lots of such files should be fine (bias will work correctly
against least-served files).

The main problem I can see is a low-memory server where we are currently
swapping out pages from non-sequential files (eg. gigantic running java
apps), and now performance might decline because we'll discard file
pages first.

> So I opt for it being made tunable, safe, and turned off by default.

I'd like to see it turned on by default in -mm, and try to come up with
some server-like workload to measure the effect.  Should be easy to
simulate something (eg. apache server, where clients grab some files in
preference, and apache server where clients grab different files).

Peter?

Thanks,
Rusty.

