Return-Path: <linux-kernel-owner+w=401wt.eu-S1759989AbYCNUF2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989AbYCNUF2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 16:05:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755933AbYCNUFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 16:05:14 -0400
Received: from mail.fieldses.org ([66.93.2.214]:55471 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348AbYCNUFM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 16:05:12 -0400
Date: Fri, 14 Mar 2008 16:05:10 -0400
To: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       Neil Brown <neilb@suse.de>
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080314200510.GL2119@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org> <20080314195303.GA4390@ics.muni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080314195303.GA4390@ics.muni.cz>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2008 at 08:53:03PM +0100, Lukas Hejtmanek wrote:
> On Fri, Mar 14, 2008 at 03:33:50PM -0400, J. Bruce Fields wrote:
> > OK, yes, I think so.  Could you confirm whether this fixes it?
> 
> I will test it on Monday as I cannot reboot the machine right now.
> 
> Just a quick review - isn't the cache_get() call needed also on the line 185 in
> the same file?

Right before the first nfsd_setuser_and_check_port()?  I don't believe
so.

The way it works is: the rqst_exp_find() calls bump the reference count
on the export they return to us, as expected; so if we bail out after
that line 185, the exp_put() at "out:" drops that reference, as it
should, making fh_verify a no-op with respect to the reference count.

The only time we need a new reference is when we store that pointer in
the filehandle, around line 233, as that's what creates a long-lived
reference that will outlive the function.

The other cache_get() (in the "just rechecking" case) is there just to
balance out the final exp_put() so every code path can share the same
code at "out:".

I find that a little contorted.  So I'll go ahead and submit this small
patch to 2.6.25 and stable now (I have since managed to reproduce what I
believe is your bug, though my symptoms were a little different), and
then submit to 2.6.26 some cleanup which makes this more understandable,
and brings fh_verify() a little closer to the kernel's aesthetic of
small, minimally-indented functions.

That said, I'd definitely still appreciate your confirmation that this
fixes your bug, so thanks for offering to retest that Monday.

--b.

>  
> > diff --git a/fs/nfsd/nfsfh.c b/fs/nfsd/nfsfh.c
> > index 1eb771d..3e6b3f4 100644
> > --- a/fs/nfsd/nfsfh.c
> > +++ b/fs/nfsd/nfsfh.c
> > @@ -232,6 +232,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
> >  		fhp->fh_dentry = dentry;
> >  		fhp->fh_export = exp;
> >  		nfsd_nr_verified++;
> > +		cache_get(&exp->h);
> >  	} else {
> >  		/*
> >  		 * just rechecking permissions
> > @@ -241,6 +242,7 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
> >  		dprintk("nfsd: fh_verify - just checking\n");
> >  		dentry = fhp->fh_dentry;
> >  		exp = fhp->fh_export;
> > +		cache_get(&exp->h);
> >  		/*
> >  		 * Set user creds for this exportpoint; necessary even
> >  		 * in the "just checking" case because this may be a
> > @@ -252,8 +254,6 @@ fh_verify(struct svc_rqst *rqstp, struct svc_fh *fhp, int type, int access)
> >  		if (error)
> >  			goto out;
> >  	}
> > -	cache_get(&exp->h);
> > -
> >  
> >  	error = nfsd_mode_check(rqstp, dentry->d_inode->i_mode, type);
> >  	if (error)
> 
> -- 
> Lukáš Hejtmánek
