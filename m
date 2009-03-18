Return-Path: <linux-kernel-owner+w=401wt.eu-S1757853AbZCRSuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757853AbZCRSuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 14:50:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbZCRSuV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 14:50:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:36013 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbZCRSuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 14:50:20 -0400
Date: Wed, 18 Mar 2009 19:50:15 +0100
From: Jan Kara <jack@suse.cz>
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH 3/4] fs: Avoid data corruption with blocksize < pagesize
Message-ID: <20090318185015.GA1129@duck.suse.cz>
References: <1237311235-13623-1-git-send-email-jack@suse.cz> <1237311235-13623-2-git-send-email-jack@suse.cz> <1237311235-13623-3-git-send-email-jack@suse.cz> <1237311235-13623-4-git-send-email-jack@suse.cz> <20090318184222.GA6369@skywalker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318184222.GA6369@skywalker>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 19-03-09 00:12:22, Aneesh Kumar K.V wrote:
> On Tue, Mar 17, 2009 at 06:33:54PM +0100, Jan Kara wrote:
> > Assume the following situation:
> > Filesystem with blocksize < pagesize - suppose blocksize = 1024,
> > pagesize = 4096. File 'f' has first four blocks already allocated.
> > (line with "state:" contains the state of buffers in the page - m = mapped,
> > u = uptodate, d = dirty)
> > 
> >   process 1:                       process 2:
> > 
> > write to 'f' bytes 0 - 1024
> >   state: |mud,-,-,-|, page dirty
> >                                    write to 'f' bytes 1024 - 4096:
> >                                      __block_prepare_write() maps blocks
> >                                        state: |mud,m,m,m|, page dirty
> >                                      we fail to copy data -> copied = 0
> >                                      block_write_end() does nothing
> >                                      page gets unlocked
> 
> 
> If copied = 0 then in  block_write_end we do
> 
> page_zero_new_buffers(page, start+copied, start+len
> 
> which would mean we should not see garbage.
  But this will zero only *new* buffers - so if they are already allocated,
get_block() won't set new flag and they won't be zeroed...
  But I'm not saying I understand why this seems to help against a corruption
under UML because we don't seem to be writing !uptodate buffers there.

									Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
