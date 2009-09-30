Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZI3UAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZI3UAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 16:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753517AbZI3UA3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 16:00:29 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:33133 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbZI3UA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 16:00:29 -0400
Subject: Re: [PATCH] ima: ecryptfs fix imbalance message
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Dustin Kirkland <kirkland@canonical.com>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>, stable@kernel.org,
       Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <4AC3AC33.1020907@linux.vnet.ibm.com>
References: <1254258535-18894-1-git-send-email-zohar@linux.vnet.ibm.com>
	 <4AC3AC33.1020907@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Wed, 30 Sep 2009 16:00:21 -0400
Message-Id: <1254340821.3544.12.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-09-30 at 14:06 -0500, Tyler Hicks wrote:
> On 09/29/2009 04:08 PM, Mimi Zohar wrote:
> > The underlying files are measured. Update the counters to get rid of
> > the ecryptfs imbalance message. (http://bugzilla.redhat.com/519737)
> > 
> > Reported-by: Sachin Garg <ascii79@gmail.com>
> > Cc: stable@kernel.org
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> > ---
> >  fs/ecryptfs/main.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
> > index 9f0aa98..177e61e 100644
> > --- a/fs/ecryptfs/main.c
> > +++ b/fs/ecryptfs/main.c
> > @@ -35,6 +35,7 @@
> >  #include <linux/key.h>
> >  #include <linux/parser.h>
> >  #include <linux/fs_stack.h>
> > +#include <linux/ima.h>
> >  #include "ecryptfs_kernel.h"
> > 
> >  /**
> > @@ -135,7 +136,8 @@ int ecryptfs_init_persistent_file(struct dentry *ecryptfs_dentry)
> >  			       "rc = [%d]\n", lower_dentry, lower_mnt, rc);
> >  			rc = PTR_ERR(inode_info->lower_file);
> >  			inode_info->lower_file = NULL;
> > -		}
> > +		} else
> > +			ima_counts_get(inode_info->lower_file);
> >  	}
> >  	mutex_unlock(&inode_info->lower_file_mutex);
> >  	return rc;
> 
> Hi Mimi - I can't think of why we would want to measure the underlying
> files.  The file contents are encrypted with a randomly generated key
> and there is eCryptfs metadata stored in the first 8K of the underlying
> file.  If you have two eCryptfs mounts, using the same key, and copy the
> same file into both mount points, you'll end up with two entirely
> different underlying files.
> 
> Taking a closer look at IMA is still on my TODO list, so I could be
> missing something obvious.  The upper (decrypted) file is being
> measured, right?
> 
> For performance and the reason mentioned above, it seems like the proper
> fix is to only measure the upper file.  What do you think?
> 
> Tyler

Yes, the terminology 'underlying files are measured' was incorrect. It
is measuring the decrypted files.

Thanks!

Mimi

