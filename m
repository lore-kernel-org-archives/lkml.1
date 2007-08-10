Return-Path: <linux-kernel-owner+w=401wt.eu-S965527AbXHJUXI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965527AbXHJUXI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 16:23:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937457AbXHJUWx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 16:22:53 -0400
Received: from smtp-105-friday.nerim.net ([62.4.16.105]:63466 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S935845AbXHJUWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 16:22:51 -0400
Date: Fri, 10 Aug 2007 22:22:51 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Joe Perches <joe@perches.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mm-commits@vger.kernel.org, adaplas@pol.net, greg@kroah.com,
       jeff@garzik.org
Subject: Re: + remove-current-defines-and-uses-of-pr_err-add-pr_emerg.patch
 added to -mm tree
Message-ID: <20070810222251.7a53ce2b@hyperion.delvare>
In-Reply-To: <1186611713.3073.41.camel@localhost>
References: <tI4NY5SL.1186153543.0764100.khali@localhost>
	<1186179369.13852.36.camel@localhost>
	<20070807131949.fa060048.akpm@linux-foundation.org>
	<20070808220226.1dc03a67@hyperion.delvare>
	<1186605086.11897.67.camel@localhost>
	<Pine.LNX.4.64.0708082237210.10387@fbirervta.pbzchgretzou.qr>
	<1186608977.3073.30.camel@localhost>
	<Pine.LNX.4.64.0708082345320.10387@fbirervta.pbzchgretzou.qr>
	<1186611713.3073.41.camel@localhost>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

On Wed, 08 Aug 2007 15:21:53 -0700, Joe Perches wrote:
> On Wed, 2007-08-08 at 23:57 +0200, Jan Engelhardt wrote:
> > fs/freevxfs/vxfs_bmap.c:line 169 (near "case VXFS_TYPED_DATA_DEV4")
> > 
> >                         printk(KERN_INFO "\n\nTYPED_DEV4 detected!\n");
> > Seems normal.
> 
> The second output log line of the first printk isn't prefixed
> with KERN_INFO.  It's output with log_level_unknown.

True. This simply means that the leading \n's shouldn't be there.
Pretty easy to fix.

> > So it looks like your regex has some false positives.
> > (which nothing can be done about - the 61 must be hand-sorted)
> 
> Must have copy/pasted the wrong regex
> 
> $ egrep -r "printk[[:space:]]*\([[:space:]]*KERN.*\\\n[A-JL-Za-jl-z[:space:]]" --include=*.[ch] * | wc -l
> 61
> 
> > [My idea is above]
> 
> Any sequence of printks can be interleaved.  I don't see
> how your suggestion changes that.
> 
> > >Maybe an external tool to reassemble complete messages from
> > >prefixed {{cookie}} message logs would be fine for awhile.
> > >
> > >Perhaps something like:
> > >
> > >cookie = printk_block_start()
> > >printk_block[s](cookie)
> > >printk_block_end(cookie)?
> > >
> > >where printk_block emits cookie when multiple cookies
> > >are active.
> > 
> > How is this supposed to work? Are you suggesting that the printk buffer is
> > locked?
> 
> No, just another identifier placed into logs that allow messages
> to be reassembled into something readable when multiple printk_block's
> are active.
> 
> > Now, if you hold the output of a printk block until it's _end()
> > counterpart is executed, the user does not get any output when the
> > machine locks up during the for loop.
> 
> External tool scans logs.  No blocking or delay in output.

Assuming that the related messages are prefixed in a similar way (as
dev_info and friends do), grouping them is already possible, and pretty
trivial: grep can select whatever you are interested in.

I'm not saying that your ideas are all bad. The ability to build a
kernel without the least interesting messages is valuable. Having a
more standard formatting for log messages is interesting as well,
although dev_info and friends already offer this to some extent. But
you have to realize that kernel logging must stay something very
simple, and that the first tool to read them is "dmesg" and not some
funky log scanner. So the current implementation can't be that far from
what we need.

Thanks,
-- 
Jean Delvare
