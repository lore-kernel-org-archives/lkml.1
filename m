Return-Path: <linux-kernel-owner+w=401wt.eu-S1753800Ab0AUCDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab0AUCDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:03:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211Ab0AUCDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:03:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64913 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863Ab0AUCDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:03:32 -0500
Date: Wed, 20 Jan 2010 21:02:57 -0500
From: Valerie Aurora <vaurora@redhat.com>
To: Erez Zadok <ezk@cs.sunysb.edu>
Cc: Jan Blunck <jblunck@suse.de>, Alexander Viro <viro@zeniv.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Andy Whitcroft <apw@canonical.com>,
       Scott James Remnant <scott@canonical.com>,
       Sandu Popa Marius <sandupopamarius@gmail.com>,
       Jan Rekorajski <baggins@sith.mimuw.edu.pl>,
       "J. R. Okajima" <hooanon05@yahoo.co.jp>, Arnd Bergmann <arnd@arndb.de>,
       Vladimir Dronnikov <dronnikov@gmail.com>,
       Felix Fietkau <nbd@openwrt.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 13/41] whiteout: tmpfs whiteout support
Message-ID: <20100121020257.GA31446@shell>
References: <1256152779-10054-14-git-send-email-vaurora@redhat.com> <200911300626.nAU6QrSv022100@agora.fsl.cs.sunysb.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200911300626.nAU6QrSv022100@agora.fsl.cs.sunysb.edu>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:26:53AM -0500, Erez Zadok wrote:
> In message <1256152779-10054-14-git-send-email-vaurora@redhat.com>, Valerie Aurora writes:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > Add support for whiteout dentries to tmpfs.
> 
> Shouldn't you CC Hugh Dickins here?  He's probably best positioned to review
> the changes in mm/shmem.c.

Thanks, I added him and linux-mm.

> > XXX - Not sure this is the right patch to put the code for supporting
> > whiteouts in d_genocide().
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  fs/dcache.c |    3 +-
> >  mm/shmem.c  |  149 +++++++++++++++++++++++++++++++++++++++++++++++++++++------
> >  2 files changed, 137 insertions(+), 15 deletions(-)
> > 
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index 0fcae4b..1fae1df 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -2280,7 +2280,8 @@ resume:
> >  		struct list_head *tmp = next;
> >  		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
> >  		next = tmp->next;
> > -		if (d_unhashed(dentry)||!dentry->d_inode)
> > +		if (d_unhashed(dentry)||(!dentry->d_inode &&
> > +					 !d_is_whiteout(dentry)))
> 
> I think this d_genocide patch should go elsewhere.  What does it have to do
> with tmpfs?

Without this patch, you can't unmount a tmpfs file system with
whiteouts.  d_genocide() is called by kill_litter_super() to evict all
the dcache entries used by tmpfs.

> Also, is your logic above correct?  If I understood d_genocide correctly,
> then the code you changed attempts to skip over dentries for which
> d_genocide has no work to do, like unhashed and negative dentries.  So I
> assume it should also skip over whiteout dentries.  Your condition is
> 
> if (d_unhashed(dentry) || (!dentry->d_inode && !d_is_whiteout(dentry)))
> 
> but perhaps it needs to be
> 
> if (d_unhashed(dentry) || !dentry->d_inode || d_is_whiteout(dentry))
> 
> No?
> 
> Either way, you may want to document any complex conditional that may be
> confusing to parse.

This is a good thing to document.  What we're dealing with here is
dropping the ref count on persistent dentries.  How about this comment?

  /*
   * Skip unhashed and negative dentries, but process
   * positive dentries and whiteouts.  A whiteout looks
   * kind of like a negative dentry for purposes of
   * lookup, but it has an extra pinning ref count
   * because it can't be evicted like a negative dentry
   * can.  What we care about here is ref counts - and
   * we need to drop the ref count on a whiteout before
   * we can evict it.
   */
  if (d_unhashed(dentry)||(!dentry->d_inode &&
                           !d_is_whiteout(dentry)))
          continue;

-VAL
