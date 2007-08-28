Return-Path: <linux-kernel-owner+w=401wt.eu-S1760203AbXH1ANR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760203AbXH1ANR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 20:13:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754167AbXH1ANF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 20:13:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59488 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753816AbXH1AND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 20:13:03 -0400
Date: Mon, 27 Aug 2007 17:12:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
       Mike Travis <travis@sgi.com>
Subject: Re: [PATCH] trivial - convert "for(foo=0;foo<NR_CPUS;foo++)" to
 "for_each_possible_cpu(foo)"
Message-Id: <20070827171227.285b7383.akpm@linux-foundation.org>
In-Reply-To: <1188258887.18004.173.camel@localhost>
References: <1188258887.18004.173.camel@localhost>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2007 16:54:47 -0700
Joe Perches <joe@perches.com> wrote:

> Done via grep/sed and compile tested i386 with xen
> 
> Changed the foo++ and ++foo forms
> 
> $ egrep -r -l "for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\1\+\+[[:space:]]*[[:space:]]*\)" * | xargs sed -i -r -e "s/for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\1[[:space:]]*\+\+[[:space:]]*\)/for_each_possible_cpu\(\1\)/g"
> $ egrep -r -l "for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\+\+[[:space:]]*\1[[:space:]]*\)" * | xargs sed -i -r -e "s/for[[:space:]]*\([[:space:]]*([A-Za-z0-9_]+)[[:space:]]*=[[:space:]]*0[[:space:]]*;[[:space:]]*\1[[:space:]]*<[[:space:]]*NR_CPUS[[:space:]]*;[[:space:]]*\+\+[[:space:]]*\1[[:space:]]*\)/for_each_possible_cpu\(\1\)/g"

No, each of these sites needs careful attention.

- Can we reduce the amount of memory which is being used?  Because
  hweight(num_possible_cpus) <= hweight(NR_CPUS)

- Do we _really_ need to be iterating across all possible CPUS?  Or
  should we really have been using for_each_online_cpu() or
  for_each_present_cpu()?

See, many of these sites will be old code which predates cpu hotplug and
the more advanced cpu masks.  We shouldn't just blindly go and pretend that
these sites have been modernised when they haven't.

Right now, pretty much every instance of NR_CPUS in the tree is a flag
which says "old, krufty, fixme".   Let's not hide that please. 
