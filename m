Return-Path: <linux-kernel-owner+w=401wt.eu-S1030736AbXDJOej@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030736AbXDJOej (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 10:34:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030680AbXDJOej
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 10:34:39 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43743 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030736AbXDJOeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 10:34:37 -0400
Date: Tue, 10 Apr 2007 20:12:08 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@linux-foundation.org, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, rohitseth@google.com,
       devel@openvz.org
Subject: Re: [PATCH 3/7] Containers (V8): Add generic multi-subsystem API to containers
Message-ID: <20070410144208.GA3348@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070406233221.989528000@menage.corp.google.com> <20070407001324.271959000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070407001324.271959000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2007 at 04:32:24PM -0700, menage@google.com wrote:
> -static int container_create_dir(struct container *cont, const char *name, int mode)
> +static int container_create_dir(struct container *cont, struct dentry *dentry,
> +				int mode)
>  {
> -	struct dentry *dentry = NULL;
>  	struct dentry *parent;
>  	int error = 0;
> 
>  	parent = cont->parent->dentry;
> -	dentry = container_get_dentry(parent, name);

If you removed this line, then:

>  	if (IS_ERR(dentry))
>  		return PTR_ERR(dentry);
> -	error = container_create_file(dentry, S_IFDIR | mode);
> +	error = container_create_file(dentry, S_IFDIR | mode, cont->root->sb);
>  	if (!error) {
>  		dentry->d_fsdata = cont;
> -		parent->d_inode->i_nlink++;
> +		inc_nlink(parent->d_inode);
>  		cont->dentry = dentry;
>  	}
>  	dput(dentry);

We should remove this dput as well, otherwise we will be short of
required reference count on dentry by 1?

Basically, when user does:

        # cd /dev/container
        # mkdir a

and mkdir returns, what should be the (min) ref count of a's dentry? From my
understanding it should be total number of files under a + 1. The dput
above will cause this reqd count to be short by 1 ..

-- 
Regards,
vatsa
