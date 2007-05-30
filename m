Return-Path: <linux-kernel-owner+w=401wt.eu-S1752891AbXE3QGU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891AbXE3QGU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 12:06:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbXE3QGN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 12:06:13 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:23031 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbXE3QGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 12:06:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=o+Hx//aoP+FLaYg5d3Jhbi0j3mCTPogSR94TZgCjZUyGFS5tXilcsk5D4CsM0gH2gHJvKr20mmz20MAZdBB3jAoVYVrLxiKdvCXf34Ku4/WlEICdEqgyq5PSFfkzuJ0ZvggI4wb1MLEgkMoN/VgsHRWnMlN8dP3VMdBM3hyaGP0=
Message-ID: <a781481a0705300906w69c43925xdfa95682f62c3087@mail.gmail.com>
Date: Wed, 30 May 2007 21:36:05 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Roland Dreier" <rdreier@cisco.com>
Subject: Re: dealing with gcc 'comparison is always false' warnings (was: [PATCH] drivers/infiniband: fix comparsion between unsigned and negative)
Cc: openib-general@openib.org, linux-kernel@vger.kernel.org
In-Reply-To: <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070530080518.GA29195@nostromo.devel.redhat.com>
	 <adazm3mqqh3.fsf@cisco.com>
	 <a781481a0705300841k2a02335eg66985129eaed28f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/30/07, Satyam Sharma <satyam.sharma@gmail.com> wrote:
> On 5/30/07, Roland Dreier <rdreier@cisco.com> wrote:
> > thanks... I'm wondering if there's a consensus among kernel hackers
> > about changes like:
> >
> >  > -    if (hdr.cmd < 0 || hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
> >  > +    if (hdr.cmd >= ARRAY_SIZE(ucma_cmd_table))
> >  >              return -EINVAL;
> >
> > I understand that new gcc sees that hdr.cmd is unsigned and hence
> > can't be < 0, and generates a warning for that, and having a build
> > cluttered with warnings hides bugs and so on.  However the code here
> > looks quite sensible to me -- otherwise we end up with missing range
> > checking if hdr.cmd ever changes to a signed type.  This seems like a
> > good way to introduce bugs: delete valid range checking code to shut
> > up a silly gcc warning, and then change the type of a variable.
>
> You're *absolutely* correct about the issue that these "fixes" that remove
> such conditions end up remove range-checking making the code more
> flakey / less readable.
>
> However, gcc is _just as correct_. It is only crying about seeing a condition
> that the programmer could have written with some purpose in mind but which
> is being completely compiled away by it when generating the code because
> of it being a tautology / contradiction ...
>
> > Can't we just make gcc shut up about the comparison and generate no
> > code for it because it knows it can't be true?

[ BTW gcc does not generate code for such cases already; either for the
condition whose truth value is already known, or for the codepath that
will never be executed as a result. ]

> No, shutting gcc up wouldn't be the right thing, IMHO. These warnings are
> a good reminder to the programmer to go and see if there is a real bug
> somewhere and if something really needs to be done with the code (could
> be simply to change the type of a variable to signed that was mistakenly
> declared unsigned, f.e.).

A common scenario I could imagine for the above would be where a typo
makes someone declare a var as size_t when it should've been ssize_t.
This is clearly a real bug that would get caught with this gcc warning
(but not with -Wall).

> But yes, the kind of "fixes" you pointed out that _remove_ these conditions
> are definitely *not* what we would want to do.

Erm, to qualify my rather strong opinion above: there could perhaps be
exceptions where the condition being removed could be truly redundant,
of course :-)

Satyam
