Return-Path: <linux-kernel-owner+w=401wt.eu-S1758121AbYJHAx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758121AbYJHAx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754455AbYJHAxs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:53:48 -0400
Received: from www.church-of-our-saviour.org ([69.25.196.31]:39466 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753459AbYJHAxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:53:47 -0400
Date: Tue, 7 Oct 2008 20:53:38 -0400
From: Theodore Tso <tytso@mit.edu>
To: Quentin Godfroy <godfroy@clipper.ens.fr>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: possible (ext4 related?) memory leak in kernel 2.6.26
Message-ID: <20081008005338.GH15929@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Quentin Godfroy <godfroy@clipper.ens.fr>,
	Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080930222358.1FF30EAC415@quatramaran.ens.fr> <20081003003548.GA18138@mit.edu> <20081005091526.GA678@goelette.ens.fr> <20081005122752.GB27335@mit.edu> <20081005161214.GA2985@goelette.ens.fr> <20081006025006.GA9289@mit.edu> <48EA2F20.7020309@redhat.com> <20081006175502.GA12937@mit.edu> <20081007221256.GF15929@mit.edu> <20081008000227.GA32052@goelette.ens.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081008000227.GA32052@goelette.ens.fr>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2008 at 02:02:27AM +0200, Quentin Godfroy wrote:
> 
> I rebooted, but as I didn't know exactly how to trigger the bug except than
> by waiting a few days I was waiting to see.
> 
> Do you have an idea about how to trigger the bug?

The bug is that each time a transaction commits, if the buffer head
hasn't been leaked already, it will leak pinning the memory until the
total size of the journal is taking up memory.  If you have a 2gigs of
memory, and a single filesystem with 256meg journal, you might not
notice the problem at all.  If you less than 256 megs of memory,
you'll notice fairly quickly.   

So you can test to see if you are running into problems by running the
buffer_dump program to trigger a dump of buffers in use.  Some buffers
will always be pinned, such as the super block, block group
descriptors, and journal super blocks.  And there will be some number
of buffers that are in use; but the number of dirty buffers should be
no more than, oh, 30 or 40, and over the next couple of hours, it
should not be growing.  Even before you start runninng to memory
exhaustion problems, the number of in-use buffers should relatively
quick rise to hundreds or thousands after a few hours of run-time.

Regards,

						- Ted
