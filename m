Return-Path: <linux-kernel-owner+w=401wt.eu-S1763580AbXGYW2J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763580AbXGYW2J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 18:28:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754965AbXGYW15
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 18:27:57 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:48399 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbXGYW14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 18:27:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mUcpjxem15HgAltACEsrzeR+DCyUKZzpTjGn0jQUolWuxlFFoERPHVi6xD1ongqxzz7VCtd6MCJxDrna1xpNV9T7pc1q9hvHwSdULBmvaqTQwBICowjrChAT/0pyGx/gsydsYbTKe66WCM3chIZROwUw0bQcMXHPm1dHHX9lGfY=
Message-ID: <9a8748490707251527v3553355ldd0d2233425e298b@mail.gmail.com>
Date: Thu, 26 Jul 2007 00:27:47 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Paul Jackson" <pj@sgi.com>
Subject: Re: -mm merge plans for 2.6.23
Cc: "Ingo Molnar" <mingo@elte.hu>, rene.herman@gmail.com,
       Valdis.Kletnieks@vt.edu, david@lang.hm, nickpiggin@yahoo.com.au,
       ray-lk@madrabbit.org, akpm@linux-foundation.org, ck@vds.kolivas.org,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070725150509.4d80a85e.pj@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A58B49.3050508@yahoo.com.au> <46A6D7D2.4050708@gmail.com>
	 <Pine.LNX.4.64.0707242211210.2229@asgard.lang.hm>
	 <46A6DFFD.9030202@gmail.com>
	 <30701.1185347660@turing-police.cc.vt.edu> <46A7074B.50608@gmail.com>
	 <20070725082822.GA13098@elte.hu> <46A70D37.3060005@gmail.com>
	 <20070725113401.GA23341@elte.hu> <20070725150509.4d80a85e.pj@sgi.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/07/07, Paul Jackson <pj@sgi.com> wrote:
> > and the fact is: updatedb discards a considerable portion of the cache
> > completely unnecessarily: on a reasonably complex box no way do all the
>
> I'm wondering how much of this updatedb problem is due to poor layout
> of swap and other file systems across disk spindles.
>
> I'll wager that those most impacted by updatedb have just one disk.
>
[snip]
>
> Question:
>   Could those who have found this prefetch helps them alot say how
>   many disks they have?  In particular, is their swap on the same
>   disk spindle as their root and user files?
>

Swap prefetch helps me.

In my case I have a single (10K RPM, Ultra 160 SCSI) disk.

# fdisk -l /dev/sda

Disk /dev/sda: 36.7 GB, 36703918080 bytes
255 heads, 63 sectors/track, 4462 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1         974     7823623+  83  Linux
/dev/sda2             975        1218     1959930   83  Linux
/dev/sda3            1219        1341      987997+  82  Linux swap
/dev/sda4            1342        4462    25069432+  83  Linux

sda1 is "/", sda2 is "/usr/local/" and sda4 is "/home/"


But, I don't think updatedb is the problem, at least not just updatedb
on its own.
My machine has 2GB of RAM, so a single updatedb on its own will not
cause it to start swapping, but it does eat up a chunk of mem no doubt
about that.
The problem with updatedb is simply that it can be a contributing
factor to stuff being swapped out, but any memory hungry application
can do that - just try building an allyesconfig kernel and see how
much the linker eats towards the end.

What swap prefetch helps is not updatedb specifically, In my
experience it helps any case where you have applications running, then
start some memory hungry job that runs for a limited time, push the
previously started apps out to swap and then dies (like updatedb or a
compile job).

Without swap prefetch those apps that were pushed to swap won't be
brought back in before they are used (at which time the user is going
to have to sit there and wait for them).
With swap prefetch, the apps that got swapped out will slowly make
their way back once the mem hungry app has died and will then be fully
or partly back in memory when the user comes back to them.

That's how swap prefetch helps, it's got nothing to do with updatedb
as such - at least not as I see it.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
