Return-Path: <linux-kernel-owner+w=401wt.eu-S1750881AbXDENWY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750881AbXDENWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 09:22:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753108AbXDENWY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 09:22:24 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:25496 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750881AbXDENWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 09:22:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=l0jYOG2r1fg7VdO4PxW88XO4eh1KlRMeuAGJHmqKrdTuqby51mXMBl0ibsCdIHgNzJZ3o6UfvXzxWpQn4Ae+PgOtLDJRKY8hvUiI+NvsG9ittOzexPH6CObABWq9DBfiSzYXA4FEL3bNr9Ej9uXydS0UAY8vljj7iG0wYYKwyEA=
Date: Thu, 5 Apr 2007 21:22:09 +0800
From: lepton <ytht.net@gmail.com>
To: "Alexander E. Patrakov" <patrakov@ums.usu.ru>
Cc: lkm <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] 2.6.20.4 fix kernel panic on corrupted reiserfs directory
Message-ID: <20070405132209.GA24343@router.lepton.home>
References: <20070405064140.GA19620@router.lepton.home> <4614A692.5020605@ums.usu.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4614A692.5020605@ums.usu.ru>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, you are right.
I need more work on my trival patch.

On Thu, Apr 05, 2007 at 01:34:42PM +0600, Alexander E. Patrakov wrote:
> lepton wrote:
> >Hi,
> >  When reading corrupted reiserfs directory data, d_reclen
> >  could be a negative number, then memcpy will overflow
> >  kernel stack. This can lead to kernel panic.
> >  The following patch adds a sanity check. (against 2.6.20.4)
> 
> Is it possible to get a large positive number here due to other fs 
> corruption and bypass your sanity check? If I read the code correctly, this 
> would still oops in the "if" statement just below the part you patched.
> 
> >Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> >
> >diff -pru linux-2.6/fs/reiserfs/dir.c linux-2.6-lepton/fs/reiserfs/dir.c
> >--- linux-2.6/fs/reiserfs/dir.c	2007-02-20 14:34:32.000000000 +0800
> >+++ linux-2.6-lepton/fs/reiserfs/dir.c	2007-04-05 
> >14:35:58.000000000 +0800
> >@@ -121,6 +121,11 @@ static int reiserfs_readdir(struct file 
> > 					/* it is hidden entry */
> > 					continue;
> > 				d_reclen = entry_length(bh, ih, entry_num);
> >+				if (d_reclen < 0) {
> >+					pathrelse(&path_to_entry);
> >+					ret = -EIO;
> >+					goto out;
> >+				}
> > 				d_name = B_I_DEH_ENTRY_FILE_NAME(bh, ih, 
> > 				deh);
> > 				if (!d_name[d_reclen - 1])
> > 					d_reclen = strlen(d_name);
> >O
