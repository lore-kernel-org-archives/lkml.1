Return-Path: <linux-kernel-owner+w=401wt.eu-S1759344AbYHSVoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759344AbYHSVoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 17:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753615AbYHSVoK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 17:44:10 -0400
Received: from mail.fieldses.org ([66.93.2.214]:47118 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752849AbYHSVoI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:44:08 -0400
Date: Tue, 19 Aug 2008 17:43:39 -0400
To: Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
       Eric Paris <eparis@redhat.com>, tvrtko.ursulin@sophos.com,
       alan@lxorguk.ukuu.org.uk, andi@firstfloor.org,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       malware-list@lists.printk.net, malware-list-bounces@dmesg.printk.net,
       peterz@infradead.org, viro@ZenIV.linux.org.uk
Subject: Re: [malware-list] TALPA - a threat model?  well sorta.
Message-ID: <20080819214339.GE8331@fieldses.org>
References: <20080814132455.GE6469@mit.edu> <1218721713.3540.125.camel@localhost.localdomain> <20080814155028.GB8256@mit.edu> <1218734985.9375.5.camel@paris.rdu.redhat.com> <20080814191726.GG22488@mit.edu> <20080814193408.GA10236@infradead.org> <20080814194111.GH22488@mit.edu> <20080814202039.GA4509@infradead.org> <20080814212109.GM23859@fieldses.org> <20080814233430.GC13048@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080814233430.GC13048@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 07:34:30PM -0400, Theodore Tso wrote:
> On Thu, Aug 14, 2008 at 05:21:09PM -0400, J. Bruce Fields wrote:
> > > I have not yet seen code actually using it at all, neither in mainline
> > > nor on one of the many nfs development lists.
> > 
> > Oops, I'd love to, and it should be very easy.  How do I find out if
> > i_version is supported on a given superblock?
> 
> We don't have a way of exporting this fact at the moment.  I assume
> the best way would be to add a flag in struct super.
> 
> > There's nothing particularly "advanced" about this, by the way--this is
> > a very minor variation on the caching model that nfs has always had, and
> > our nfsv4 server is currently pretty broken without it.
> 
> Well, if you're willing to try it out, as I've mentioned on my
> blog[1][2], ext4 is working pretty well on my laptop --- I'm running
> it as my primary filesystem.  There are a few problems with ext3
> filesystems converted to use ext4, as opposed to starting afresh via
> "mke2fs -t ext4dev /dev/hdXX" that we've just found in the past week
> (and fixed within a day or two, although they haven't been pushed to
> Linus yet), but overall, it's been pretty stable.
>
> So this would be a good time for someone who is familiar wiht NFSv4 to
> try it out and let us know if the i_version support is as you would
> like in ext4 --- we're in the bugfixing/stablization phase right now,
> so this would be an ideal time to get that feedback.  For more
> information, on how to get started, please see:
> 
> http://ext4.wiki.kernel.org/index.php/Ext4_Howto
> 
> for instructions, and mount the filesystem with the "-o i_version"
> mount option.

Neato, thanks.  I set up a toy ext4 filesystem (just a 512 meg sparse
file loopback mounted) on one of my test machines--so I just need to
add the superblock flag and a bit of nfsd code and then I should be able
to try it out.

> > Actually, it's pretty broken even on nfsv2/v3 for filesystems with poor
> > time resolution.
> 
> And that's fixed in ext4 as well....

That's an improvement, yes.  Of course the time is still updated only
every jiffy, so there's still a race:

				file updated
	client checks ctime
				file updated again within a jiffy
	client checks ctime again, concludes file hasn't changed.

--b.
