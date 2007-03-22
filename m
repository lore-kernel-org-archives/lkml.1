Return-Path: <linux-kernel-owner+w=401wt.eu-S934006AbXCVAZS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934006AbXCVAZS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 20:25:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932469AbXCVAZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 20:25:18 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:38171 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934006AbXCVAZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 20:25:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=XASZBxoWS4qB9GZJbva8iVRe4XMIR1GRuhUbfQMWspqFb28Xr+j1PBaOYp66Z4krXPzr35tj5E2G3bnGKmHtgBLW322QBniKpmQC42X9lCtKvH9lVPdDV813qHGcko0Ib2vRjo1op28sqfseui6+fUsBpBhMUag/a20GYWvehRQ=
From: Maxim <maximlevitsky@gmail.com>
To: nigel@nigel.suspend2.net
Subject: Re: [BUG] Code reordering in swsusp breaks suspend on SMP systems
Date: Thu, 22 Mar 2007 02:25:07 +0200
User-Agent: KMail/1.9.6
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, David Chinner <dgc@sgi.com>
References: <200703211840.53242.maximlevitsky@gmail.com> <200703212238.33897.rjw@sisk.pl> <1174520825.6665.105.camel@nigel.suspend2.net>
In-Reply-To: <1174520825.6665.105.camel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703220225.07663.maximlevitsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 March 2007 01:47:05 Nigel Cunningham wrote:
> Hi.
> 
> On Wed, 2007-03-21 at 22:38 +0100, Rafael J. Wysocki wrote:
> > > Do you know exactly which mutex was being waited on and where it was
> > > taken? If you can say that, it would be much more helpful.
> 
> Yeah, me too, but assuming too much sometimes bites me :)
> 
> > I think this is the XFS problem with freezable workqueues.
> > 
> > Maxim, please try to apply the appended patch and see if it helps.
> 
> Thanks for your subsequent messages, Maxim. Could you confirm for us
> that the patch Rafael attached fixes it?
> 
> Regards,
> 
> Nigel
> 
> > ---
> > Since freezable workqueues are broken in 2.6.21-rc
> > (cf. http://marc.theaimsgroup.com/?l=linux-kernel&m=116855740612755,
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=117261312523921&w=2)
> > it's better to remove them altogether for 2.6.21 and change the only user of
> > them (XFS) accordingly.
> > 
> > ---
> >  fs/xfs/linux-2.6/xfs_buf.c |    4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > ===================================================================
> > --- linux-2.6.21-rc4.orig/fs/xfs/linux-2.6/xfs_buf.c
> > +++ linux-2.6.21-rc4/fs/xfs/linux-2.6/xfs_buf.c
> > @@ -1829,11 +1829,11 @@ xfs_buf_init(void)
> >  	if (!xfs_buf_zone)
> >  		goto out_free_trace_buf;
> >  
> > -	xfslogd_workqueue = create_freezeable_workqueue("xfslogd");
> > +	xfslogd_workqueue = create_workqueue("xfslogd");
> >  	if (!xfslogd_workqueue)
> >  		goto out_free_buf_zone;
> >  
> > -	xfsdatad_workqueue = create_freezeable_workqueue("xfsdatad");
> > +	xfsdatad_workqueue = create_workqueue("xfsdatad");
> >  	if (!xfsdatad_workqueue)
> >  		goto out_destroy_xfslogd_workqueue;
> >  
> 
> 

Hello,

I can confirm now that the above patch work,

First as I said I did try to suspend with this patch and without XFS, and it did work,
Now I reverted it and now system still suspends correctly without xfs module loaded ( I didn't tell you that i use now ext3,
and that I generally compile everything in kernel, so i put XFS too, because I used it once, and I still have a XFS disk image)

But system hangs with XFS loaded, so this patch works.

Regards,
	Maxim Levitsky


