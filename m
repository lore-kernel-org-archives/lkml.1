Return-Path: <linux-kernel-owner+w=401wt.eu-S1753583AbYJCK7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753583AbYJCK7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 06:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753401AbYJCK6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 06:58:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:39090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbYJCK6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 06:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=fKrlsxwXDEwqt6LWsnVkddSuJZ3j1giK9yb8JcbtcETwbdiB/batweMdQVx2mh1wR2
         kNnKJzcJvSXBGmRPDFqrxMpGT3LQULfgP+zNujb7AY++He/KS3qO72LlzOorancjCrj4
         NG2LM/F5VxtO8nMxWaN4HVCXwmqi1cy0sA36g=
Message-ID: <7c86c4470810030358m1a0fdcc5i5512a1c2a6696457@mail.gmail.com>
Date: Fri, 3 Oct 2008 12:58:12 +0200
From: "stephane eranian" <eranian@googlemail.com>
Reply-To: eranian@gmail.com
To: "David Gibson" <david@gibson.dropbear.id.au>, eranian@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: perfmon3 interface overview
Cc: perfmon2-devel <perfmon2-devel@lists.sourceforge.net>
In-Reply-To: <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <7c86c4470809231432j4231cfa4g7dd158a7fe9c9277@mail.gmail.com>
	 <7c86c4470809251448j65fb99f1nfdb3980e0716149a@mail.gmail.com>
	 <20081003061713.GL3002@yookeroo.seuss>
	 <7c86c4470810030354x6984372akfe18761da7504a0c@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David,

On Fri, Oct 3, 2008 at 8:17 AM, David Gibson
<david@gibson.dropbear.id.au> wrote:
>
> > The new API now has 8 system calls in its fully-featured
> > version. Many data structures shared with user level have been
> > abandoned in favor of explicit syscall parameters.  Each syscall has
>
> Ah, excellent, big structures passed through an interface are often a
> pain to deal with, so I'm glad these are going.

 Thanks.

>
>
> I, at least, like the changes that have been made here.  I do have a
> few suggestions for further simplifications along the same lines
> though, see below.
>
> [snip]
> >  II) programming the registers
> >
> >  With v2.81:
> >       int pfm_write_pmcs(int fd, pfarg_pmc_t *pmds, int  n);
> >       int pfm_write_pmds(int fd, pfarg_pmd_t *pmcs, int n);
> >       int pfm_read_pmds(int fd, parg_pmd_t *pmds, int n);
> >
> >  With v3.0:
> >       int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
> >       int pfm_write_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n,
> >                                       pfarg_pmd_attr_t *pmas);
> >
> >       int pfm_read_pmrs(int fd, int flags, pfarg_pmr_t *pmrs, int n);
> >       int pfm_read_pmrs(int fd, int flags, parg_pmr_t *pmrs, int n,
> >                                      pfarg_pmd_attr_t *pmas);
>
> I would suggest adding 'type' and 'size' (int) parameters, and folding
> the pmrs and pmas arrays into one freeform array.  'size' gives the
> size in bytes of the array elements, 'type' selects the structure of
> each array element.  This means:
>        - if you ever have some sort of registers to access that are
> neither PMCs nor PMDs, you can access those two, using a new type
> value.
>        - if a new method of operation wants to supply different
> information for PMCs or PMDs, you can define a new structure and type
> value (one obvious example would be a minimal (num,value) only
> structure for minimum latency on simple applications).
>        - an explicit size value means things can marshal / copy /
> whatnot the parameters without having to know what size each type
> implies -  the code will stay valid when new types / structures are
> defined.

 So you are suggesting something along the lines:

   int pfm_read_pmrs(int fd, int flags, int type, void *tab, size_t sz);
   int pfm_write_pmrs(int fd, int flags, int type, void *tab, size_t sz);

 I have already introduced a type flag (PFM_RWFL_PMD, PFM_RWFL_PMC).
 Why separate the type into its own parameter?

 As for the freeform array, isn't that what people do not like because
of  void *
 and thus weak type checking?

 I will look at switching to size instead of count. I think it does make sense.

>
> [snip]
> > III) attaching and detaching
> >
> >   With v2.81:
> >      int pfm_load_context(int fd, pfarg_load_t *load);
> >      int pfm_unload_context(int fd);
> >
> >   With v3.0:
> >      int pfm_attach_session(int fd, int flags, int target);
> >      int pfm_detach_session(int fd, int flags);
>
> Couldn't you get rid of one more syscall here by making detach a
> special case of attach with a special "null" value for target, or a
> special flag?


 We could combine the two and use the flag field to indicate attach/detach.
 The target is not a pointer but an int. Some people suggested I use an
 unsigned long instead. In anycase, we could not use 0 to indicate "detach"
 because CPU0 is a valid choice for system-wide. Thus we would have to
 pick another value to mean "nothing", e.g, -1.

 >  IV) starting and stopping
 >
 >    With v2.81:
 >       int pfm_start(int fd, pfarg_start_t *st);
 >       int pfm_stop(int fd);
 >       int pfm_restart(int fd);
 >
 >    With v3.0:
 >       int pfm_start_session(int fd, int flags);
 >       int pfm_stop_session(int fd, int flags);

> Likewise, couldn't you cut this down by one more syscall by making it
>        int pfm_set_session_state(int fd, int flags);
> and having a 'RUNNING' flag, which selects start or stop behaviour?

 That one we can certainly do. That's a good idea.

 Thanks for your feedback, keep it coming.
