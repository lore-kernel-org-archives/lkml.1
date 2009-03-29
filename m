Return-Path: <linux-kernel-owner+w=401wt.eu-S1753701AbZC2XWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701AbZC2XWS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Mar 2009 19:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751390AbZC2XWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Mar 2009 19:22:01 -0400
Received: from ipmail01.adl6.internode.on.net ([203.16.214.146]:46979 "EHLO
	ipmail01.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751366AbZC2XWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Mar 2009 19:22:00 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Sun, 29 Mar 2009 19:21:59 EDT
Date: Mon, 30 Mar 2009 10:14:51 +1100
From: Dave Chinner <david@fromorbit.com>
To: Mark Lord <lkml@rtr.ca>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090329231451.GR26138@disturbed>
Mail-Followup-To: Mark Lord <lkml@rtr.ca>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Jeff Garzik <jeff@garzik.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Theodore Tso <tytso@mit.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <49CD4DDF.3000001@garzik.org> <alpine.LFD.2.00.0903271511230.3994@localhost.localdomain> <alpine.LFD.2.00.0903271522210.3994@localhost.localdomain> <49CD7B10.7010601@garzik.org> <49CD891A.7030103@rtr.ca> <49CD9047.4060500@garzik.org> <49CE2633.2000903@s5r6.in-berlin.de> <49CE3186.8090903@garzik.org> <49CE35AE.1080702@s5r6.in-berlin.de> <49CE3F74.6090103@rtr.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49CE3F74.6090103@rtr.ca>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 11:17:08AM -0400, Mark Lord wrote:
> The better solution seems to be the rather obvious one:
>
>   the filesystem should commit data to disk before altering metadata.

Generalities are bad. For example:

write();
unlink();
<do more stuff>
close();

This is a clear case where you want metadata changed before data is
committed to disk. In many cases, you don't even want the data to
hit the disk here.

Similarly, rsync does the magic open,write,close,rename sequence
without an fsync before the rename. And it doesn't need the fsync,
either. The proposed implicit fsync on rename will kill rsync
performance, and I think that may make many people unhappy....

> Much easier and more reliable to centralize it there, rather than
> rely (falsely) upon thousands of programs each performing numerous
> performance-killing fsync's.

The filesystem should batch the fsyncs efficiently. if the
filesystem doesn't handle fsync efficiently, then it is a bad
filesystem choice for that workload....


Cheers,
Dave.
-- 
Dave Chinner
david@fromorbit.com
