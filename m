Return-Path: <linux-kernel-owner+w=401wt.eu-S943517AbYCSX5I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943517AbYCSX5I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 19:57:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964985AbYCSWc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:32:29 -0400
Received: from mail.fieldses.org ([66.93.2.214]:39770 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964978AbYCSWc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:32:28 -0400
Date: Wed, 19 Mar 2008 18:32:21 -0400
To: Neil Brown <neilb@suse.de>
Cc: Lukas Hejtmanek <xhejtman@ics.muni.cz>, nfsv4@linux-nfs.org,
       linux-kernel@vger.kernel.org
Subject: Re: Oops in NFSv4 server in 2.6.23.17
Message-ID: <20080319223221.GL25636@fieldses.org>
References: <20080312122550.GB8141@ics.muni.cz> <20080312160007.GA10015@fieldses.org> <20080313143631.GH27873@ics.muni.cz> <20080314181413.GF2119@fieldses.org> <20080314193350.GK2119@fieldses.org> <20080314195303.GA4390@ics.muni.cz> <20080314200510.GL2119@fieldses.org> <20080314234205.GO2119@fieldses.org> <18397.43768.705353.514972@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18397.43768.705353.514972@notabene.brown>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 10:19:20AM +1100, Neil Brown wrote:
> On Friday March 14, bfields@fieldses.org wrote:
> > On Fri, Mar 14, 2008 at 04:05:10PM -0400, bfields wrote:
> > > I find that a little contorted.  So I'll go ahead and submit this small
> > > patch to 2.6.25 and stable now (I have since managed to reproduce what I
> > > believe is your bug, though my symptoms were a little different), and
> > > then submit to 2.6.26 some cleanup which makes this more understandable,
> > 
> > Here's an attempt.  We could break up fh_verify even more, though.--b.
> 
> Looks like a good attempt.
> 
> My only suggestion would be to put a comment at the top of
> nfsd_set_fh_dentry explaining what it does and who calls it.

OK!  I'm planning to just add:

+/*
+ * Use the given filehandle to look up the corresponding export and
+ * dentry.  On success, the results are used to set fh_export and
+ * fh_dentry.
+ */
 static __be32 nfsd_set_fh_dentry(struct svc_rqst *rqstp, struct svc_fh *fhp)
 {
 	struct knfsd_fh	*fh = &fhp->fh_handle;

(Nothing about "who calls it", but it's static and its only caller is
fh_verify, so that seemed uninteresting.)  Anything else you were
looking for?

> 
> It's long past time that code had some spring cleaning !!

If I had a little more time I think it might be clearer to make this:

	fhp->fh_export = nfsd_fh_get_export(rqstp, &fhp->fh_handle);
	if (IS_ERR(fhp->fh_export))
		return ERR_PTR(fhp->fh_export);
	error = nfsd_setuser_and_check_port(rqstp, exp);
	if (error)
		goto out;
	fhp->fh_export = nfsd_fh_get_dentry(rqstp, &fhp->fh_handle);
	if (IS_ERR(...))

etc., though that's probably not quite right.

--b.
