Return-Path: <linux-kernel-owner+w=401wt.eu-S1753262AbZASRca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753262AbZASRca (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 12:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758839AbZASR3Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 12:29:16 -0500
Received: from mx2.redhat.com ([66.187.237.31]:58957 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757602AbZASR3O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 12:29:14 -0500
Subject: Re: mmotm 2009-01-14-20-31 uploaded (gfs2)
From: Steven Whitehouse <swhiteho@redhat.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com
In-Reply-To: <4974B2D8.7010003@oracle.com>
References: <200901150432.n0F4WI66023742@imap1.linux-foundation.org>
	 <496F8AED.3020604@oracle.com>
	 <1232101203.3554.3.camel@localhost.localdomain>
	 <20090116084352.9f35b822.akpm@linux-foundation.org>
	 <1232125371.9571.587.camel@quoit> <4970BE8F.9090705@oracle.com>
	 <20090116093550.ce7229d5.akpm@linux-foundation.org>
	 <1232378200.9571.602.camel@quoit>  <4974B2D8.7010003@oracle.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Mon, 19 Jan 2009 17:27:30 +0000
Message-Id: <1232386050.9571.628.camel@quoit>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 2009-01-19 at 09:05 -0800, Randy Dunlap wrote:
> Steven Whitehouse wrote:
> > Hi,
> > 
> > On Fri, 2009-01-16 at 09:35 -0800, Andrew Morton wrote:
> >> On Fri, 16 Jan 2009 09:06:23 -0800 Randy Dunlap <randy.dunlap@oracle.com> wrote:
> >>
> >>>>>> which is not ideal, but I don't see any easy way to avoid the #ifdef,
> >>>>>>
> >>>>> Take a look in fs.h:
> >>>>>
> >>>>> #define generic_setlease(a, b, c) ({ -EINVAL; })
> >>>>>
> >>>>> If that wasn't a stupid macro, your code would have compiled and ran
> >>>>> just as intended.
> >>>>>
> >>>> There doesn't seem to be an easy answer though. If I #define it to NULL,
> >>>> that upsets other parts of the code that rely on that macro, and if I
> >>>> turn it into a inline function which returns -EINVAL, then presumably I
> >>>> can't take its address for my file_operations.
> >>> No, gcc will allow &inline_func and out-of-line it if it is needed (AFAIK;
> >>> I've seen a few cases of that).
> >>>
> >> yup.  It measn that we'll get a separate private copy of the
> >> generic_setlease() code in each compilation unit which takes its
> >> address, but I don't think that would kill us.
> >>
> >> The prevention is of course to put the stub function in a core kernel
> >> .c file and export it to modules.
> >>
> > Having looked into this in a bit more detail now, it seems that this
> > particular function (generic_setlease) is one of a number appearing in
> > fs.h which are replaced by macros in the case that CONFIG_FILE_LOCKING
> > is not set.
> > 
> > So rather than just do the one function, it seemed to make sense to me
> > to make them all the same. So this uses inline functions as originally
> > proposed. If you'd prefer that we don't inline them and instead have a
> > fs/no-locks.c or something like that with stub functions in it, then I"m
> > happy to revise the patch accordingly.
> 
> Acked-by/Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
> 
Ok, Thanks. I'll send a proper patch to a suitable tree. Presumably the
VFS tree would be best for this?

> > This patch passes my compile tests, modulo a small change that I need to
> > make in GFS2 to suppress a warning (not attached). That seems to be
> > related to yet another set of macros which appear only with
> > CONFIG_FILE_LOCKING not set. Maybe I should update those to be inline
> > functions as well....
> 
> You mean these?  Probably should update them as well.
> 
> #else /* !CONFIG_FILE_LOCKING */
> #define locks_mandatory_locked(a) ({ 0; })
> #define locks_mandatory_area(a, b, c, d, e) ({ 0; })
> #define __mandatory_lock(a) ({ 0; })
> #define mandatory_lock(a) ({ 0; })
> #define locks_verify_locked(a) ({ 0; })
> #define locks_verify_truncate(a, b, c) ({ 0; })
> #define break_lease(a, b) ({ 0; })
> #endif /* CONFIG_FILE_LOCKING */
> 
> 
Yes, I'll do a patch for those as well then,

Steve.


