Return-Path: <linux-kernel-owner+w=401wt.eu-S932506AbXIOAQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506AbXIOAQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 20:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755675AbXIOAQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 20:16:08 -0400
Received: from rv-out-0910.google.com ([209.85.198.186]:26185 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbXIOAQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 20:16:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=A0UU/PvGX3PY2K66Ok77ncWSmJmWD2wwm+X2wxAd3U/IvtErqeq9MJq+jJG4tRzzYrhmGk/ooeYaLopFJDwOhEAO0O14f4h2MnLXF+Mc1RBYT6S3uraqaVbQxZVZjgMtJHzdDKz6UeBRK/9b1vwFKwMVCDVnHSFtKu/ECRlDv4c=
Message-ID: <a781481a0709141716n569d54eeqbe51746d3a5110ca@mail.gmail.com>
Date: Sat, 15 Sep 2007 05:46:07 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/6] cpuset write dirty map
Cc: "Ethan Solomita" <solo@google.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>,
       "Christoph Lameter" <clameter@sgi.com>
In-Reply-To: <20070914170733.dbe89493.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>
	 <46E742A2.9040006@google.com>
	 <20070914161536.3ec5c533.akpm@linux-foundation.org>
	 <a781481a0709141647q3d019423s388c64bf6bed871a@mail.gmail.com>
	 <20070914170733.dbe89493.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/15/07, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Sat, 15 Sep 2007 05:17:48 +0530
> "Satyam Sharma" <satyam.sharma@gmail.com> wrote:
>
> > > It's unobvious why the break point is at MAX_NUMNODES = BITS_PER_LONG and
> > > we might want to tweak that in the future.  Yet another argument for
> > > centralising this comparison.
> >
> > Looks like just an optimization to me ... Ethan wants to economize and not bloat
> > struct address_space too much.
> >
> > So, if sizeof(nodemask_t) == sizeof(long), i.e. when:
> > MAX_NUMNODES <= BITS_PER_LONG, then we'll be adding only sizeof(long)
> > extra bytes to the struct (by plonking the object itself into it).
> >
> > But even when MAX_NUMNODES > BITS_PER_LONG, because we're storing
> > a pointer, and because sizeof(void *) == sizeof(long), so again the maximum
> > bloat addition to struct address_space would only be sizeof(long) bytes.
>
> yup.
>
> Note that "It's unobvious" != "It's unobvious to me".  I review code for
> understandability-by-others, not for understandability-by-me.
>
> > I didn't see the original mail, but if the #ifdeffery for this
> > conditional is too much
> > as a result of this optimization, Ethan should probably just do away
> > with all of it
> > entirely, and simply put a full nodemask_t object (irrespective of MAX_NUMNODES)
> > into the struct. After all, struct task_struct does the same unconditionally ...
> > but admittedly, there are several times more address_space struct's resident in
> > memory at any given time than there are task_struct's, so this optimization does
> > make sense too ...
>
> I think the optimisation is (probably) desirable, but it would be best to
> describe the tradeoff in the changelog and to add some suitable
> code-commentary for those who read the code in a year's time and to avoid
> sprinkling the logic all over the tree.

True, the other option could be to put the /pointer/ in there unconditionally,
but that would slow down the MAX_NUMNODES <= BITS_PER_LONG case,
which (after grepping through defconfigs) appears to be the common case on
all archs other than ia64. So I think your idea of making that conditional
centralized in the code with an accompanying comment is the way to go here ...


Satyam
