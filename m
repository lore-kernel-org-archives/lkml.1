Return-Path: <linux-kernel-owner+w=401wt.eu-S932364AbZHCQ6H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932364AbZHCQ6H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 12:58:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755428AbZHCQ6G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 12:58:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:52988 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754902AbZHCQ6F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 12:58:05 -0400
Subject: Re: [Patch] pipe: use file_update_time() when hold i_mutex
From: Miklos Szeredi <mszeredi@suse.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       heiko.carstens@de.ibm.com, linux-fsdevel@vger.kernel.org,
       viro@zeniv.linux.org.uk
In-Reply-To: <4A66DA2E.90601@redhat.com>
References: <20090706053745.6338.50777.sendpatchset@localhost.localdomain>
	 <20090720141150.e9d081ca.akpm@linux-foundation.org>
	 <4A65934B.9050904@redhat.com> <1248174580.28516.595.camel@tucsk>
	 <4A66DA2E.90601@redhat.com>
Content-Type: text/plain
Date: Mon, 03 Aug 2009 18:58:07 +0200
Message-Id: <1249318687.29890.28.camel@tucsk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-07-22 at 17:21 +0800, Amerigo Wang wrote:
> Miklos Szeredi wrote:
> > On Tue, 2009-07-21 at 18:07 +0800, Amerigo Wang wrote:
> >   
> >> Andrew Morton wrote:
> >>     
> >>> On Mon, 6 Jul 2009 01:35:30 -0400
> >>> Amerigo Wang <amwang@redhat.com> wrote:
> >>>
> >>>   
> >>>       
> >>>> file_update_time() should be called with i_mutex held,
> >>>> move it before mutex_unlock().
> >>>>
> >>>>     
> >>>>         
> >>> Why do you believe that file_update_time() needs i_mutex?
> >>>   
> >>>       
> >> file_update_time() modifies inode, no? :)
> >>     
> >
> > So does touch_atime(), yet neither needs i_mutex.
> >   
> Yes?
> 
> Then how the inode is protected when file_update_time() modifies
> it?

Protected against what?

For example the inode isn't protected against concurrent access by
stat(2), since that doesn't take i_mutex.

And indeed it looks like there are races there, since set/get operations
are not atomic on the timestamp, so stat could return a garbled value if
it races with file_update_time() or touch_atime().

Possibly worth fixing, but I'm not sure how to do that without affecting
the scalability of stat and friends and without adding too much
complexity.

Thanks,
Miklos

