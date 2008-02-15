Return-Path: <linux-kernel-owner+w=401wt.eu-S1759063AbYBOSOf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759063AbYBOSOf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 13:14:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYBOSO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 13:14:28 -0500
Received: from anchor-post-37.mail.demon.net ([194.217.242.87]:50440 "EHLO
	anchor-post-37.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753483AbYBOSO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 13:14:27 -0500
Subject: Re: kernel-doc : possible fix for non-fatal perl errors when
	parsing some function pointers
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20080215094437.5f6d7b3b.rdunlap@xenotime.net>
References: <1203095592.2929.54.camel@castor.localdomain>
	 <20080215092154.4a8cbba7.rdunlap@xenotime.net>
	 <20080215094437.5f6d7b3b.rdunlap@xenotime.net>
Content-Type: text/plain
Date: Fri, 15 Feb 2008 18:14:24 +0000
Message-Id: <1203099264.2929.70.camel@castor.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-15 at 09:44 -0800, Randy Dunlap wrote:
> On Fri, 15 Feb 2008 09:21:54 -0800 Randy Dunlap wrote:
> 
> > On Fri, 15 Feb 2008 17:13:12 +0000 Richard Kennedy wrote:
> > 
> > > When running "make htmldocs" I'm seeing some non-fatal perl errors
> > > caused by trying to parse the callback function definitions in
> > > blk-core.c.
> > > 
> > > The errors are "Use of uninitialized value in concatenation (.)..."
> > > 
> > > The function pointers are defined without a * i.e. 
> > > int (drv_callback)(struct request *)
> > > 
> > > The compiler is happy with them, but kernel-doc isn't. 
> > > 
> > > This patch teaches create_parameterlist in kernel-doc to parse this type
> > > of function pointer definition, but is it the right way to fix the
> > > problem ? The problem only seems to occur in blk-core.c.
> > > 
> > > However with the patch applied, kernel-doc finds the correct parameter
> > > description for the callback in blk_end_request_callback, which is
> > > doesn't normally.
> > > (the patch is against v2.6.25-rc1)
> > > 
> > > I thought it would be a bit odd to change to code to use the more normal
> > > form of function pointers just to get the documentation to work, so I
> > > fixed kernel-doc instead - even though this is teaching it to understand
> > > code that might go away (The comment for blk_end_request_callback says
> > > that it should not be used and will removed at some point). 
> > > 
> > > Any ideas on which is the best way to fix this?
> > 
> > Hi Richard,
> > Thanks for the patch.  I was planning to look into this problem
> > this weekend.
> > 
> > I think that changing scripts/kernel-doc to accept the current
> > kernel source tree usage is the right thing to do, even if the
> > block/blk code is a bit different.  I'll test it a bit and then
> > push it.
> 
> I'm not quite happy with the way that these function pointer
> parameters are presented.  E.g.,
> the callback function above is presented by kernel-doc as:
> 
> 		int ()(struct request *) drv_callback);
> whereas this
> 		int (drv_callback)(struct request *)
> would be much better.  If you could look into massaging that
> parameter output, that would be great.  If not, I'll look into
> later.

This simplest thing to do would be

-           push_parameter($param, $type, $file);
+           push_parameter($param, $arg, $file);

but then the function definition in the doc comes out as :- 

..., int (drv_callback)(struct request *)  drv_callback);

which is probably worse.

I don't see a simple way to fix this right now. But I'll let you know if
I come up with anything :)




> > I appreciate the patch.
> > 
> > > diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> > > index 26146cb..68b2e4e 100755
> > > --- a/scripts/kernel-doc
> > > +++ b/scripts/kernel-doc
> > > @@ -1512,13 +1512,13 @@ sub create_parameterlist($$$) {
> > >  	    # corresponding data structures "correctly". Catch it later in
> > >  	    # output_* subs.
> > >  	    push_parameter($arg, "", $file);
> > > -	} elsif ($arg =~ m/\(.*\*/) {
> > > +	} elsif ($arg =~ m/\(.+\)\s*\(/) {
> > >  	    # pointer-to-function
> > >  	    $arg =~ tr/#/,/;
> > > -	    $arg =~ m/[^\(]+\(\*\s*([^\)]+)\)/;
> > > +	    $arg =~ m/[^\(]+\(\*?\s*(\w*)\s*\)/;
> > >  	    $param = $1;
> > >  	    $type = $arg;
> > > -	    $type =~ s/([^\(]+\(\*)$param/$1/;
> > > +	    $type =~ s/([^\(]+\(\*?)$param/$1/;
> > >  	    push_parameter($param, $type, $file);
> > >  	} elsif ($arg) {
> > >  	    $arg =~ s/\s*:\s*/:/g;
> 
> 
> ---
Richard

