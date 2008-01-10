Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYAJADX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYAJADX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 19:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755504AbYAJADH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 19:03:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.179]:60180 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754329AbYAJADE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 19:03:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gQGrG0HcbIAC5LSS8F8WHBpyOxqx5tZcy7Tsysos5YJRN4eYAIVfR5xeu2t6UIG7rSjC5W20F2entFB3NTfQPQGm2WdgxUcyJd1Ev2kODoli3Pb96ic+AXU5JdeNPK6QSDf7EI69bhpyJL/b1/EthzLLhN9/u+u4aZ200KsgGyI=
Message-ID: <4df4ef0c0801091603y2bf507e1q2b99971c6028d1f3@mail.gmail.com>
Date: Thu, 10 Jan 2008 03:03:03 +0300
From: "Anton Salikhmetov" <salikhmetov@gmail.com>
To: "Rik van Riel" <riel@redhat.com>
Subject: Re: [PATCH][RFC][BUG] updating the ctime and mtime time stamps in msync()
Cc: "Jakob Oestergaard" <jakob@unthought.net>, Valdis.Kletnieks@vt.edu,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080109184141.287189b8@bree.surriel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199728459.26463.11.camel@codedot>
	 <20080109155015.4d2d4c1d@cuia.boston.redhat.com>
	 <26932.1199912777@turing-police.cc.vt.edu>
	 <20080109170633.292644dc@cuia.boston.redhat.com>
	 <20080109223340.GH25527@unthought.net>
	 <20080109184141.287189b8@bree.surriel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/1/10, Rik van Riel <riel@redhat.com>:
> On Wed, 9 Jan 2008 23:33:40 +0100
> Jakob Oestergaard <jakob@unthought.net> wrote:
> > On Wed, Jan 09, 2008 at 05:06:33PM -0500, Rik van Riel wrote:
>
> > > Can we get by with simply updating the ctime and mtime every time msync()
> > > is called, regardless of whether or not the mmaped pages were still dirty
> > > by the time we called msync() ?
> >
> > The update must still happen, eventually, after a write to the mapped region
> > followed by an unmap/close even if no msync is ever called.
> >
> > The msync only serves as a "no later than" deadline. The write to the region
> > triggers the need for the update.
> >
> > At least this is how I read the standard - please feel free to correct me if I
> > am mistaken.
>
> You are absolutely right.  If we wrote dirty pages to disk, the ctime
> and mtime updates must happen no later than msync or close time.
>
> I guess a third possible time (if we want to minimize the number of
> updates) would be when natural syncing of the file data to disk, by
> other things in the VM, would be about to clear the I_DIRTY_PAGES
> flag on the inode.  That way we do not need to remember any special
> "we already flushed all dirty data, but we have not updated the mtime
> and ctime yet" state.
>
> Does this sound reasonable?

No, it doesn't. The msync() system call called with the MS_ASYNC flag
should (the POSIX standard requires that) update the st_ctime and
st_mtime stamps in the same manner as for the MS_SYNC flag. However,
the current implementation of msync() doesn't call the do_fsync()
function for the MS_ASYNC case. The msync() function may be called
with the MS_ASYNC flag before "natural syncing".
