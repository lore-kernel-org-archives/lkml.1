Return-Path: <linux-kernel-owner+w=401wt.eu-S1758102AbXGCFXS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758102AbXGCFXS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 01:23:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752124AbXGCFXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 01:23:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:40986 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbXGCFXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 01:23:05 -0400
From: Len Brown <lenb@kernel.org>
Organization: Intel Open Source Technology Center
To: Al Viro <viro@ftp.linux.org.uk>, Dave Jones <davej@redhat.com>
Subject: Re: Fix empty macros in acpi.
Date: Tue, 3 Jul 2007 01:22:47 -0400
User-Agent: KMail/1.9.5
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
References: <20070612233309.GA24251@redhat.com> <20070613002115.GA28778@redhat.com> <20070613002631.GL21478@ftp.linux.org.uk>
In-Reply-To: <20070613002631.GL21478@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707030122.47747.lenb@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 12 June 2007 20:26, Al Viro wrote:
> On Tue, Jun 12, 2007 at 08:21:15PM -0400, Dave Jones wrote:
> > On Wed, Jun 13, 2007 at 01:00:29AM +0100, Al Viro wrote:
> >  > On Tue, Jun 12, 2007 at 07:33:09PM -0400, Dave Jones wrote:
> >  > > +#define DBG(x...) do { } while(0)
> >  > 
> >  > Eh...  Please, stop it - if you want a function-call-like no-op returning void,
> >  > use ((void)0).  At least that way one can say DBG(....),foo(), etc.
> > 
> > They both end up compiled to nothing anyway, so I'm not bothered
> > either way..   I'm not sure I follow why the syntax of that last part
> > is a good thing.  It looks like something we'd want to avoid rather
> > than promote?
> 
> If on one side of ifdef it's a void-valued expression, so it should be
> on another; the reason is that we don't get surprise differences between
> the builds...

true, DBG() in this case would expand to printk(), which returns int.

But in practice, DBG isn't used in any expressions -- and the other zillion
places in the kernel where it is used, it is used as in dave's patch.

Indeed, I don't see printk used in expressions either...

While I know it is common Linux style, and by default it is okay with gcc,
it seems somewhat half-baked to call functions and not check their return
value by default.  IMHO, if they return something, it should be checked,
or explicitly ignored -- or it shouldn't return anything in the first place...

> IOW, if it doesn't build in some context, it should consistently fail to
> build in that context.

whelp, it seems that the reason for this patch is this:

#define DBG()

if(...)
	DBG();
next_c_statement

which turns into
if(...) ;
next_c_statement

But since there is an intervening ';', this code is still functionally correct
and a decent compiler will delete the test altogether, yes?

So is there some real problem here that I missed,
or is this to make some code-checking tool that I don't have happy?

thanks,
-Len
