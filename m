Return-Path: <linux-kernel-owner+w=401wt.eu-S1755101AbZBCB2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755101AbZBCB2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 20:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751010AbZBCB2E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 20:28:04 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:41502 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283AbZBCB2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 20:28:03 -0500
Subject: Re: [PATCH 6/6] Integrity: IMA file free imbalance
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       James Morris <jmorris@namei.org>, Christoph Hellwig <hch@infradead.org>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       "<David Safford" <safford@watson.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20090202234702.GD18452@hallyn.com>
References: <cover.1233262162.git.zohar@linux.vnet.ibm.com>
	 <f4247c49806840ee466b0726932de31679c46248.1233262163.git.zohar@linux.vnet.ibm.com>
	 <20090202234702.GD18452@hallyn.com>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 20:27:54 -0500
Message-Id: <1233624474.3013.53.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 17:47 -0600, Serge E. Hallyn wrote:
> Quoting Mimi Zohar (zohar@linux.vnet.ibm.com):
> > The number of calls to ima_path_check()/ima_file_free()
> > should be balanced.  An extra call to fput(), indicates
> > the file could have been accessed without first being
> > measured.
> > 
> > Although f_count is incremented/decremented in places other
> > than fget/fput, like fget_light/fput_light and get_file, the
> > current task must already hold a file refcnt.  The call to
> > __fput() is delayed until the refcnt becomes 0, resulting
> > in ima_file_free() flagging any changes.
> > 
> > - add hook to increment opencount for IPC shared memory(SYSV)
> >   and shmat files
> > 
> > Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> 
> ...
> 
> > diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> 
> ...
> 
> > +static void opencount_get(struct file *file)
> > +{
> > +	struct inode *inode = file->f_dentry->d_inode;
> > +	struct ima_iint_cache *iint;
> > +
> > +	if (!ima_initialized || !S_ISREG(inode->i_mode))
> > +		return;
> > +	iint = ima_iint_find_insert_get(inode);
> > +	mutex_lock(&iint->mutex);
> > +	if (iint)
> 
> Hey, I think you've got those two lines above mixed
> up a bit :)

yes, thanks!

> Very neat, though.
> 
> Acked-by: Serge Hallyn <serue@us.ibm.com>
> 
> once that's fixed up.
> 
> thanks,
> -serge

