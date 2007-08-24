Return-Path: <linux-kernel-owner+w=401wt.eu-S1762771AbXHXNY2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762771AbXHXNY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:24:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756853AbXHXNYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:24:19 -0400
Received: from rv-out-0910.google.com ([209.85.198.188]:56402 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756850AbXHXNYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:24:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=X5HTv+qWwf3n6+JpgOVc7//oBs87R9ynfGknA9eFzjspolgwP39aH8SS9ER//27JsM4Sa5313tXpfm9UmNPOfYNOyHY0kzkquw6vrktRt2LpsdbIdhAXK+7oEAmd9Vgb85in08NxvjSuyiYCmGCNC+My+utVHy8HVYaWO3V9XjY=
Message-ID: <8bd0f97a0708240624v64b47b4l726a66f9766bc4a0@mail.gmail.com>
Date: Fri, 24 Aug 2007 09:24:17 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "SL Baur" <steve@xemacs.org>
Subject: Re: false positive in checkpatch.pl (complex macro values)
Cc: "Andy Whitcroft" <apw@shadowen.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Michael Hennerich" <michael.hennerich@analog.com>
In-Reply-To: <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8bd0f97a0708240051w7fc00b01w8dc1b39fe606bfe4@mail.gmail.com>
	 <46CEC3D4.40805@shadowen.org>
	 <ed10ee420708240543r27db83e9l25300c2799c7c2cd@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/24/07, SL Baur <steve@xemacs.org> wrote:
> On 8/24/07, Andy Whitcroft <apw@shadowen.org> wrote:
> > Mike Frysinger wrote:
> > > in some code that does like:
> > > #define foo { a, b, c, \
> > >     d, e, f, g }
> > > ...
> > > int boo[] = foo;
> > > ...
> > >
> > > checkpatch.pl throws a fit:
> > > ERROR: Macros with complex values should be enclosed in parenthesis
> > > #10: FILE: ...
> > > +#define foo {a, b, c, d}
> > >
> > > perhaps the check should also allow {...} ?  or ignore lists like this ...
> >
> > Ok, we can add that to the check.  Next update will allow that.
> >
> > Thanks for the report.
>
> I sent a reply accidentally only to Mike and not the list.  I think the
> error message is wrong.  That is really ugly code.  Linux Kernel code
> believes in C not preprocessor tricks, so why would you need this?
>
> Who uses code like this, by the way?

the way we came across it was in code that hasnt been pushed to
mainline yet ... we run the code on our tree

however, there are plenty of cases in the tree right now ... a quick
grep picks out sound/pci/ice1712/aureon.h as the first offender

$ diff -Nu /dev/null ./sound/pci/ice1712/aureon.h | perl
./scripts/checkpatch.pl -
ERROR: Macros with complex values should be enclosed in parenthesis
#31: FILE: sound/pci/ice1712/aureon.h:28:
+#define  AUREON_DEVICE_DESC           "{Terratec,Aureon 5.1 Sky},"\

$ grep AUREON_DEVICE_DESC ./sound/pci/ice1712/aureon.h -A 5
#define  AUREON_DEVICE_DESC            "{Terratec,Aureon 5.1 Sky},"\
                                       "{Terratec,Aureon 7.1 Space},"\
                                       "{Terratec,Aureon 7.1 Universe}," \
                                        "{AudioTrak,Prodigy 7.1}," \
                                        "{AudioTrak,Prodigy 7.1 LT},"\
                                        "{AudioTrak,Prodigy 7.1 XT},"

seems like perfectly valid usage to me
-mike
