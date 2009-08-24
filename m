Return-Path: <linux-kernel-owner+w=401wt.eu-S1753334AbZHXTJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753334AbZHXTJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 15:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753252AbZHXTJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 15:09:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZHXTJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 15:09:52 -0400
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify
 destruction
From: Eric Paris <eparis@redhat.com>
To: Frans Pop <elendil@planet.nl>
Cc: linux-kernel@vger.kernel.org, linux-fs-devel@vger.kernel.org,
       zdenek.kabelac@gmail.com, torvalds@linux-foundation.org,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk, mikko.cal@gmail.com
In-Reply-To: <200908242034.50885.elendil@planet.nl>
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173524.14196.25992.stgit@paris.rdu.redhat.com>
	 <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
	 <200908242034.50885.elendil@planet.nl>
Content-Type: text/plain
Date: Mon, 24 Aug 2009 15:09:09 -0400
Message-Id: <1251140949.25096.16.camel@dhcp231-106.rdu.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-24 at 20:34 +0200, Frans Pop wrote:
> Eric Paris wrote:
> 
> > If an inotify watch is left in the idr when an fsnotify group is destroyed
> > this will lead to a BUG.  This is not a dangerous situation and really
> > indicates a programming bug and leak of memory.  This patch changes it to
> > use a WARN and a printk rather than killing people's boxes.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > ---
> > 
> > --- a/fs/notify/inotify/inotify_fsnotify.c
> > +++ b/fs/notify/inotify/inotify_fsnotify.c
> > @@ -107,6 +107,16 @@ static bool inotify_should_send_event(struct
> > fsnotify_group *group, struct inode
> > 
> > static int idr_callback(int id, void *p, void *data)
> > {
> > +       struct fsnotify_mark_entry *entry;
> > +       struct inotify_inode_mark_entry *ientry;
> > +
> > +       entry = p;
> > +       ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
> > + 
> > +       WARN(1, "inotify closing but id=%d still in idr.  Probably leaking memory\n", id); +
> > +       printk(KERN_WARNING "group=%p entry->group=%p inode=%p wd=%d\n",
> > +              data, entry->group, entry->inode, ientry->wd);
> >         BUG();
> >         return 0;
> > }
> 
> I suspect you intended to remove the BUG?

You suspect correctly.  :(  I'll fix in my tree before I request a
pull....

-Eric

