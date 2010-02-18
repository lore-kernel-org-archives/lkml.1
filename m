Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab0BRVEQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 16:04:16 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751255Ab0BRVEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 16:04:15 -0500
Date: Thu, 18 Feb 2010 16:04:07 -0500
From: David Teigland <teigland@redhat.com>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] dlm: Remove obsolete lockspace lookup
Message-ID: <20100218210407.GB13276@redhat.com>
References: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
 <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
 <1266399695-29885-3-git-send-email-swhiteho@redhat.com>
 <20100217201243.GA29576@redhat.com>
 <1266484563.2297.6.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266484563.2297.6.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 18, 2010 at 09:16:03AM +0000, Steven Whitehouse wrote:
> I'm not sure what more I can say here.... this is a sysfs file store
> function and one of the reasons for using it is that sysfs looks after
> the ref counting for you.
> 
> Even aside from that, if you don't have a reference to the lockspace,
> then the dereference that is done to discover the lockspace name would
> be invalid, since the structure might have already been freed before the
> reference is obtained.
> 
> You could also compare with with the other store and show functions in
> that same file and notice that none of them try to grab a reference to
> the lockspace in that way. So if this is required, then it must be
> required for those functions too.
> 
> Either way there is something not quite right here and having studied
> the code in some detail, I'm pretty sure this is the correct fix,

I guess you didn't see this oops in your tests.  Can you show that the
situation in this commit is no longer possible?

commit e2de7f565521a76fbbb927f701c5a1d381c71a93
Author: Patrick Caulfield <pcaulfie@redhat.com>
Date:   Mon Nov 6 08:53:28 2006 +0000

    [DLM] fix oops in kref_put when removing a lockspace
    
    Now that the lockspace struct is freed when the last sysfs object is released
    this patch prevents use of that lockspace by sysfs. We attempt to re-get the
    lockspace from the lockspace list and fail the request if it has been removed.
    
    Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
    Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 499ee11..f8842ca 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -43,6 +43,10 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 	ssize_t ret = len;
 	int n = simple_strtol(buf, NULL, 0);
 
+	ls = dlm_find_lockspace_local(ls->ls_local_handle);
+	if (!ls)
+		return -EINVAL;
+
 	switch (n) {
 	case 0:
 		dlm_ls_stop(ls);
@@ -53,6 +57,7 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
 	default:
 		ret = -EINVAL;
 	}
+	dlm_put_lockspace(ls);
 	return ret;
 }
 

> 
> Steve.
> 
> > > Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
> > > ---
> > >  fs/dlm/lockspace.c |    6 +-----
> > >  1 files changed, 1 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
> > > index 26a8bd4..ce0fdf5 100644
> > > --- a/fs/dlm/lockspace.c
> > > +++ b/fs/dlm/lockspace.c
> > > @@ -37,10 +37,6 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
> > >  	ssize_t ret = len;
> > >  	int n = simple_strtol(buf, NULL, 0);
> > >  
> > > -	ls = dlm_find_lockspace_local(ls->ls_local_handle);
> > > -	if (!ls)
> > > -		return -EINVAL;
> > > -
> > >  	switch (n) {
> > >  	case 0:
> > >  		dlm_ls_stop(ls);
> > > @@ -51,7 +47,7 @@ static ssize_t dlm_control_store(struct dlm_ls *ls, const char *buf, size_t len)
> > >  	default:
> > >  		ret = -EINVAL;
> > >  	}
> > > -	dlm_put_lockspace(ls);
> > > +
> > >  	return ret;
> > >  }
> > >  
> > > -- 
> > > 1.6.2.5
> 
