Return-Path: <linux-kernel-owner+w=401wt.eu-S1759016AbZFBFWQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759016AbZFBFWQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 01:22:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753471AbZFBFWB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 01:22:01 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751159AbZFBFWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 01:22:00 -0400
Date: Mon, 1 Jun 2009 22:21:05 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: vibi_sreenivasan@cms.com, Mimi Zohar <zohar@us.ibm.com>,
       Kylene Hall <kylene@us.ibm.com>, Serge Hallyn <serue@us.ibm.com>,
       Reiner Sailer <sailer@watson.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       James Morris <jmorris@namei.org>
Subject: Re: [PATCH]:RESEND : Return proper error value on failure of
 dentry_open
Message-Id: <20090601222105.16e20612.akpm@linux-foundation.org>
In-Reply-To: <4A2393DE.10300@gmail.com>
References: <1243836708.2163.3.camel@system>
	<4A238625.8060002@gmail.com>
	<1243844849.2327.27.camel@system>
	<4A2393DE.10300@gmail.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 01 Jun 2009 10:39:58 +0200 Jiri Slaby <jirislaby@gmail.com> wrote:

> On 06/01/2009 10:27 AM, vibi sreenivasan wrote:
> > --- a/security/integrity/ima/ima_main.c
> > +++ b/security/integrity/ima/ima_main.c
> > @@ -201,10 +201,10 @@ int ima_path_check(struct path *path, int mask)
> >  	}
> >  out:
> >  	mutex_unlock(&iint->mutex);
> > -	if (file)
> > +	if (!IS_ERR(file))
> >  		fput(file);
> 
> No, IS_ERR won't catch NULL and there is 'file = NULL' on the
> dentry_open fail path. I still think 'if (file)' is proper condition.
> 
> What bug did you hit?

	if (!(iint->flags & IMA_MEASURED)) {
		struct dentry *dentry = dget(path->dentry);
		struct vfsmount *mnt = mntget(path->mnt);

		file = dentry_open(dentry, mnt, O_RDONLY | O_LARGEFILE,
				   current_cred());
		if (IS_ERR(file)) {
			pr_info("%s dentry_open failed\n", dentry->d_name.name);
			rc = PTR_ERR(file);
			file = NULL;
			goto out;
		}
		rc = get_path_measurement(iint, file, dentry->d_name.name);
	}
out:
	mutex_unlock(&iint->mutex);
	if (file)
		fput(file);
	kref_put(&iint->refcount, iint_free);
	return 0;
}

The handling of `file' looks OK to me.

otoh the function just drops the error code on the floor.  Shouldn't it
return `rc'?

