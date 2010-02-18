Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557Ab0BRJMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:12:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386Ab0BRJMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:12:44 -0500
Subject: Re: [PATCH 2/2] dlm: Remove obsolete lockspace lookup
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100217201243.GA29576@redhat.com>
References: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
	 <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
	 <1266399695-29885-3-git-send-email-swhiteho@redhat.com>
	 <20100217201243.GA29576@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Thu, 18 Feb 2010 09:16:03 +0000
Message-ID: <1266484563.2297.6.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2010-02-17 at 15:12 -0500, David Teigland wrote:
> On Wed, Feb 17, 2010 at 09:41:35AM +0000, Steven Whitehouse wrote:
> > We don't need to look up the lockspace in this particular
> > case since we already have a pointer to it (which was being
> > dereferenced in order to do the lookup in the first place).
> 
> It'll take more to convince me that that reference from find isn't needed.
> My assumption is that I added it because it was.
> 
> Dave
> 
I'm not sure what more I can say here.... this is a sysfs file store
function and one of the reasons for using it is that sysfs looks after
the ref counting for you.

Even aside from that, if you don't have a reference to the lockspace,
then the dereference that is done to discover the lockspace name would
be invalid, since the structure might have already been freed before the
reference is obtained.

You could also compare with with the other store and show functions in
that same file and notice that none of them try to grab a reference to
the lockspace in that way. So if this is required, then it must be
required for those functions too.

Either way there is something not quite right here and having studied
the code in some detail, I'm pretty sure this is the correct fix,

Steve.

> > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > ---
> >  fs/dlm/lockspace.c |    6 +-----
> >  1 files changed, 1 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> > index 26a8bd4..ce0fdf5 100644
> > --- a/fs/dlm/lockspace.c
> > +++ b/fs/dlm/lockspace.c
> > @@ -37,10 +37,6 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
> >  	ssize_t ret = len;
> >  	int n = simple_strtol(buf, NULL, 0);
> >  
> > -	ls = dlm_find_lockspace_local(ls->ls_local_handle);
> > -	if (!ls)
> > -		return -EINVAL;
> > -
> >  	switch (n) {
> >  	case 0:
> >  		dlm_ls_stop(ls);
> > @@ -51,7 +47,7 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
> >  	default:
> >  		ret = -EINVAL;
> >  	}
> > -	dlm_put_lockspace(ls);
> > +
> >  	return ret;
> >  }
> >  
> > -- 
> > 1.6.2.5


