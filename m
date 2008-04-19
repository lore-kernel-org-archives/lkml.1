Return-Path: <linux-kernel-owner+w=401wt.eu-S1762175AbYDSSVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762175AbYDSSVn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 14:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755435AbYDSSVg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 14:21:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:41545 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbYDSSVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 14:21:35 -0400
Date: Sat, 19 Apr 2008 11:21:27 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Joseph Fannin <jfannin@gmail.com>, linux-kernel@vger.kernel.org,
       Andres Salomon <dilinger@queued.net>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.25-mm1
Message-ID: <20080419112127.1499c9be@laptopd505.fenrus.org>
In-Reply-To: <20080418202925.b18452c5.akpm@linux-foundation.org>
References: <20080418014757.52fb4a4f.akpm@linux-foundation.org>
	<20080419031024.GC3503@nineveh.local>
	<20080418202925.b18452c5.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2008 20:29:25 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> That's
> 
>                 WARN_ON_ONCE(is_ram);
> 
> the changelog for the patch which added that warning is
> information-free 

it got added with a full changelog, then temporary removed and then added back ;(

> and there's no code comment explaining what went
> wrong, which makes things rather harder than they ought to be.
> 
> Yes it's due to the new OLPC code.  olpc_init() has
> 
> 	romsig = ioremap(0xffffffc0, 16);
> 
> which we probably just shouldn't do this at all unless we're running
> on the OLPC hardware.  But we need to do this to find out if we're
> running on the OLPC hardware!  Perhaps the warning should just be
> removed. --

calling ioremap() on something which COULD be ram is... REALLY nasty.
The kernel has to mark that page uncached, for all users and mappings of that memory.
A second hard case then is to find out when the last ioremap() user has
released that memory (since there's several cases where different parts of the same
4K page can be ioremapped) before it can map it cached again. The good news is that
until this olpc patch got in, there were no users of this capability....
Instead of outright forbidding it though we added a warn_on to find out if the
assumption of no users was correct... 
seems it caught some new code which is trying to do this here.

this code should probably be a lot more careful and check that
1) there is no actual kernel memory or something else at this region
   (what if there's some other device there? this code could blow up)
2) the machine won't tripple fault or otherwise throw tantrums if
   this hardcoded value is accessed (not automatic on x86!!)
3) it only runs if there's a really high degree of confidence that this really is
   an OLPC device.
or maybe
4) get this address from some other table or system provided resource




-- 
If you want to reach me at my work email, use arjan@linux.intel.com
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
