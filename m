Return-Path: <linux-kernel-owner+w=401wt.eu-S1758265AbZCBKmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758265AbZCBKmu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:42:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZCBKml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:42:41 -0500
Received: from ns.firmix.at ([62.141.48.66]:1079 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753657AbZCBKml (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:42:41 -0500
X-Greylist: delayed 2886 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Mar 2009 05:42:40 EST
Subject: Re: [PATCH] lkdtm: reduce stack size
From: Bernd Petrovitsch <bernd@firmix.at>
To: Ankita Garg <ankita@in.ibm.com>
Cc: Frank Seidel <fseidel@suse.de>,
       linux kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Adrian Bunk <bunk@kernel.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       Frank Seidel <frank@f-seidel.de>, kernalert.de@gmail.com
In-Reply-To: <20090302041148.GA7410@in.ibm.com>
References: <49AAE94E.8080308@suse.de>  <20090302041148.GA7410@in.ibm.com>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Mon, 02 Mar 2009 10:51:30 +0100
Message-Id: <1235987490.19757.4.camel@spike.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -1.063 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-1.063 required=5
X-Spam-Score: -1.063 () AWL,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Mon, 2009-03-02 at 09:41 +0530, Ankita Garg wrote:
> Hi Frank,
> 
> On Sun, Mar 01, 2009 at 09:00:14PM +0100, Frank Seidel wrote:
> > From: Frank Seidel <frank@f-seidel.de>
> > 
> > Reduce stack memory footprint of lkdtm
> > (recursive_loop). From 1024 bytes on i386 down
> > to <10.
> >
> 
> The intention here is infact to trigger a stack overflow. This module is
> used to test kernel dumping mechanism like kdump. So the expectation is
> that the kernel will dump as soon as the stack overflows.

That answers why the variable exists at all. It is only zeroed and never
else used.
Hmm, adding the above as a comment makes probably sense.

> > Signed-off-by: Frank Seidel <frank@f-seidel.de>
> > ---
> >  drivers/misc/lkdtm.c |   16 +++++++++++++---
> >  1 file changed, 13 insertions(+), 3 deletions(-)
> > 
> > --- a/drivers/misc/lkdtm.c
> > +++ b/drivers/misc/lkdtm.c
> > @@ -225,14 +225,24 @@ static int lkdtm_parse_commandline(void)
> > 
> >  static int recursive_loop(int a)
> >  {
> > -	char buf[1024];
> > +	char *buf;
> > +	int ret;
> > +
> > +	buf = kmalloc(1024, GFP_KERNEL);
> > +	if (!buf) {
> > +		printk(KERN_ERR "lkdtm : couldn't allocate buffer\n");
> > +		return -ENOMEM;
> > +	}
> > 
> >  	memset(buf,0xFF,1024);
> >  	recur_count--;
> >  	if (!recur_count)
> > -		return 0;
> > +		ret = 0;
> >  	else
> > -        	return recursive_loop(a);
> > +		ret = recursive_loop(a);
> > +
> > +	kfree(buf);
> > +	return ret;
> >  }
> > 
> >  void lkdtm_handler(void)

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


