Return-Path: <linux-kernel-owner+w=401wt.eu-S1761698AbXK3F4b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761698AbXK3F4b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 00:56:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753027AbXK3F4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 00:56:17 -0500
Received: from hu-out-0506.google.com ([72.14.214.238]:28286 "EHLO
	hu-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbXK3F4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 00:56:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=h5TYwf/v9TF04Iwr5x13aTDFSeh7zgyNyz2bpKWc4Y8r6jsyah7ZfP4di38o6Bv5UO+campjMDGLGMGKwQ7SCjQq5UUSPlm4duhiUm/IH+LvOLK7kaxK6qa0KAOysqUYQLIiwce3Hb1XiS1Z6zWVu96RVj20k2wXS77I8/HitMA=
Date: Fri, 30 Nov 2007 13:57:02 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, jens.axboe@oracle.com
Subject: Re: [RFC] Sample kset/ktype/kobject implementation
Message-ID: <20071130055701.GA3537@darkstar.te-china.tietoenator.com>
References: <20071129203900.GA27877@kroah.com> <Pine.LNX.4.44L0.0711291708080.5666-100000@iolanthe.rowland.org> <a8e1da0711292107q4e2e0282o2d37798dc529288c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8e1da0711292107q4e2e0282o2d37798dc529288c@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2007 at 01:07:37PM +0800, Dave Young wrote:
> On Nov 30, 2007 6:11 AM, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Thu, 29 Nov 2007, Greg KH wrote:
> >
> > > > > > kobject_put(foo) is needed since it gets you through kobject_cleanup()
> > > > > > where the name can be freed.
> > > > >
> > > > > No, kobject_register() should have handled that for us, right?
> > > >
> > > > kobject_register() doesn't do a kobject_put() if kobject_add() failed.
> > >
> > > Crap.  If I can't get this code right in an example, the API is messed
> > > up.  Time to take Kay seriously and start to revamp the basic kobject
> > > api :)
> >
> > The rule is simple enough.  After calling kobject_register() you should
> > always use kobject_put() -- even if kobject_register() failed.
> >
> > In fact, after calling kobject_init() you should use kobject_put().
> > The first rule follows from this one, since kobject_register() calls
> > kobject_init() internally.
> >
> Hi,
> The behavior is not very clear here, the root problem is that :
> 
> 1. Should we call kobject_put so cleanup work can be done by refcount
> touch zero or call kfree every time after kobject_register failed?
> 
> 2. If kobject_put calling is true, should this be done in
> kobject_register error handling codes or by hand after
> kobject_register failed?
> 
IMO,I'd rather select kobject_put due to the kobj name should also be released.
After searching for kobject_register, I found one leaks as this issue in pktcdvd.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/block/pktcdvd.c |    4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

diff -upr linux/drivers/block/pktcdvd.c linux.new/drivers/block/pktcdvd.c
--- linux/drivers/block/pktcdvd.c	2007-11-30 13:13:44.000000000 +0800
+++ linux.new/drivers/block/pktcdvd.c	2007-11-30 13:24:08.000000000 +0800
@@ -117,8 +117,10 @@ static struct pktcdvd_kobj* pkt_kobj_cre
 	p->kobj.parent = parent;
 	p->kobj.ktype = ktype;
 	p->pd = pd;
-	if (kobject_register(&p->kobj) != 0)
+	if (kobject_register(&p->kobj) != 0) {
+		kobject_put(&p->kobj);
 		return NULL;
+	}
 	return p;
 }
 /*
> Regards
> dave
> > Alan Stern
> >
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
