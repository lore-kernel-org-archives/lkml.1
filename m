Return-Path: <linux-kernel-owner+w=401wt.eu-S1762147AbXHDLfX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762147AbXHDLfX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2007 07:35:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbXHDLfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Aug 2007 07:35:10 -0400
Received: from smtprelay05.ispgateway.de ([80.67.18.43]:33390 "EHLO
	smtprelay05.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751482AbXHDLfI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2007 07:35:08 -0400
From: Ingo Oeser <ioe-lkml@rameria.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [patch 03/11] fuse: add reference counting to fuse_file
Date: Sat, 4 Aug 2007 13:41:15 +0200
User-Agent: KMail/1.9.6
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070803174425.998083527@szeredi.hu> <20070803174918.484417699@szeredi.hu>
In-Reply-To: <20070803174918.484417699@szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708041341.16231.ioe-lkml@rameria.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Miklos,

On Friday 03 August 2007, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Make lifetime of 'struct fuse_file' independent from 'struct file' by
> adding a reference counter and destructor.

What about using krefs to implement that?

see include/linux/kref.h
and lib/kref.c

Just embed that "struct kref" inside your struct fuse_file

struct fuse_file {
...
	struct kref ref;
...
}

init in struct fuse_file *fuse_file_alloc(void) where you added the counter.
...
kref_init(&ff->ref);
...

and implement the release function like:

static void fuse_file_release(struct kref *ff_ref)
{
	struct fuse_file *ff = container_of(ff_ref, struct fuse_file, ref);
        struct fuse_req *req = ff->reserved_req;
        struct fuse_conn *fc = get_fuse_conn(req->dentry->d_inode);
        request_send_background(fc, req);
        kfree(ff);
}

This will also fix the missing smp_barriers, is very simple, saves code,
makes your life easier and is a well known known kernel infrastructure :-)

BTW: FUSE rocks! :-)

You can add my "Signed-off-by: Ingo Oeser <ioe-lkml@rameria.de>",
if you want to use that suggestion.

Best Regards

Ingo Oeser
