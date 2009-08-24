Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZHXSex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZHXSex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 14:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753029AbZHXSev
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 14:34:51 -0400
Received: from cpsmtpm-eml102.kpnxchange.com ([195.121.3.6]:54245 "EHLO
	CPSMTPM-EML102.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752959AbZHXSev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 14:34:51 -0400
From: Frans Pop <elendil@planet.nl>
To: Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 2/3] inotify: do not BUG on idr entries at inotify destruction
Date: Mon, 24 Aug 2009 20:34:47 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-fs-devel@vger.kernel.org,
       zdenek.kabelac@gmail.com, torvalds@linux-foundation.org,
       christoph.thielecke@gmx.de, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, grant.wilson@zen.co.uk, mikko.cal@gmail.com
References: <20090824173524.14196.25992.stgit@paris.rdu.redhat.com> <20090824173524.14196.25992.stgit@paris.rdu.redhat.com> <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
In-reply-To: <20090824173812.14196.381.stgit@paris.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200908242034.50885.elendil@planet.nl>
X-OriginalArrivalTime: 24 Aug 2009 18:34:51.0352 (UTC) FILETIME=[9114CD80:01CA24E9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Paris wrote:

> If an inotify watch is left in the idr when an fsnotify group is destroyed
> this will lead to a BUG.  This is not a dangerous situation and really
> indicates a programming bug and leak of memory.  This patch changes it to
> use a WARN and a printk rather than killing people's boxes.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -107,6 +107,16 @@ static bool inotify_should_send_event(struct
> fsnotify_group *group, struct inode
> 
> static int idr_callback(int id, void *p, void *data)
> {
> +       struct fsnotify_mark_entry *entry;
> +       struct inotify_inode_mark_entry *ientry;
> +
> +       entry = p;
> +       ientry = container_of(entry, struct inotify_inode_mark_entry, fsn_entry);
> + 
> +       WARN(1, "inotify closing but id=%d still in idr.  Probably leaking memory\n", id); +
> +       printk(KERN_WARNING "group=%p entry->group=%p inode=%p wd=%d\n",
> +              data, entry->group, entry->inode, ientry->wd);
>         BUG();
>         return 0;
> }

I suspect you intended to remove the BUG?

Cheers,
FJP
