Return-Path: <linux-kernel-owner+w=401wt.eu-S1752440AbXFWE3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440AbXFWE3H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 00:29:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXFWE2z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 00:28:55 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:51705 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXFWE2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 00:28:54 -0400
Date: Fri, 22 Jun 2007 21:28:34 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>, zippel@linux-m68k.org
Cc: Ravikiran G Thirumalai <kiran@scalex86.org>, lenb@kernel.org,
       andreas.herrmann3@amd.com, swhiteho@redhat.com, ak@suse.de,
       shai@scalex86.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Subject: Re: [PATCH 7/12] acpi: fix another compile warning
Message-Id: <20070622212834.cfa69fd0.randy.dunlap@oracle.com>
In-Reply-To: <20070622205530.964ebef9.akpm@linux-foundation.org>
References: <20070619225035.GI5193@alberich.amd.com>
	<200706192338.02807.lenb@kernel.org>
	<20070620084911.GO5193@alberich.amd.com>
	<200706200936.31236.lenb@kernel.org>
	<20070620182548.GA561@localdomain>
	<20070622205530.964ebef9.akpm@linux-foundation.org>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jun 2007 20:55:30 -0700 Andrew Morton wrote:

> > On Wed, 20 Jun 2007 11:25:48 -0700 Ravikiran G Thirumalai <kiran@scalex86.org> wrote:
> > Paper over 'select' inadequacies.  
> > 
> > Signed-off-by: Ravikiran Thirumalai <kiran@scalex86.org>
> > 
> > Index: linux-2.6.22-rc5/arch/x86_64/Kconfig
> > ===================================================================
> > --- linux-2.6.22-rc5.orig/arch/x86_64/Kconfig	2007-06-18 16:02:19.571323415 -0700
> > +++ linux-2.6.22-rc5/arch/x86_64/Kconfig	2007-06-20 11:34:29.845354250 -0700
> > @@ -366,6 +366,7 @@ config X86_64_ACPI_NUMA
> >         depends on NUMA
> >         select ACPI 
> >  	select PCI
> > +  	select PM
> >         select ACPI_NUMA
> >         default y
> >         help
> 
> argh.  (and not just argh-at-your-email-client).
> 
> I went through some hair-tearing a few months ago working out why it is so
> damn hard to make CONFIG_PM go away and then I fixed it.  And now you're
> proposing a change which would reinstate the obnoxious old behaviour.
> 
> Is the "bug" which you're "fixing" here caused by the randconfig
> inadequacies?  Because randconfig is just busted and simply should auto-run
> oldconfig.

Running oldconfig won't fix randconfigs that have busted "select"
chains (i.e., select does not follow chains like "depends on" does).

However, lots of this bustage isn't due to randconfig at all.
It's due to Jan E.'s menuconfig changes (yes, which I supported).
It seems that Jan didn't realize that a transition of a tristate symbol
to a boolean converts y or m to y (and n to n) and all (?) of the new
menuconfig symbols that control whether a menu is displayed or not
are boolean.  One simple "fix" (or workaround) is to make them
tristate.  Now that seems a little odd for a symbol that just controls
whether a menu is displayed or not, so Satyam Sharma has made some
other suggestions, and of course Andreas Herrmann has produced lots
of patches to fix various issues that he has run into.

I can't tell you the final answer (I proposed the tristate fix).
I don't particularly like some of the patches that change
	depends on XYZ
to
	depends on XYZ && ksymbol
in many lines of kconfig entries.


Not that it answers your question, but we should have hit this
in -mm, not in mainline, but it appears that our testing was a bit
insufficient.

And of course, if someone would fix kconfig to follow "select" chains,
we should bestow an award on them.  :)
(however, I don't know if Roman would merge that patch)

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
