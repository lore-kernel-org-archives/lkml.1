Return-Path: <linux-kernel-owner+w=401wt.eu-S1759435AbYAHVWA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759435AbYAHVWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:22:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756898AbYAHVRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:17:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:51049 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbYAHVRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:17:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=hLfah7hMKPP6EOLHjOldF+D95kMQTTw0tCz/C6BvxzVsp7IRYr2bbuOn6z29UaMu1
	7ZhNigINf/T2sOSQo7hyw==
Message-ID: <532480950801081317y324ed146p25f08ed50ffd1911@mail.gmail.com>
Date: Tue, 8 Jan 2008 13:17:42 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Possible fix for lockup in drop_caches
Cc: richard <richard@rsk.demon.co.uk>, den@openvz.org,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20071222020611.9e4e78dd.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197893602.2866.13.camel@castor.localdomain>
	 <20071222020611.9e4e78dd.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 22, 2007 2:06 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> Oh boy.  Do we really want to add all this stuff to JBD just for
> drop_caches which is a silly root-only broken-in-22-other-ways thing?
>
> Michael, might your convert-inode-lists-to-tree patches eliminate the need
> for taking inode_lock in drop_pagecache_sb()?  Probably not, as it uses an
> rbtree.  It would have been possible if it was using a radix-tree, I
> suspect..

You are correct. The rbtree will still req
>
> > -void __journal_unfile_buffer(struct journal_head *jh)
> > +void __journal_unfile_buffer(struct journal_head *jh,
> > +             struct buffer_head **dirty_bh)
> >  {
> > -     __journal_temp_unlink_buffer(jh);
> > +     __journal_temp_unlink_buffer(jh, dirty_bh);
> >       jh->b_transaction = NULL;
> >  }
>
> I suspect the code would end up simpler if __journal_unfile_buffer() were
> to take an additional ref on the bh which it placed at *dirty_bh.
>
> Callers of __journal_unfile_buffer() could then call
>
> void handle_dirty_bh(struct buffer_head *bh)
> {
>         if (bh) {
>                 jbd_mark_buffer_dirty(bh);
>                 put_bh(bh);
>         }
> }
>
> ?
>
