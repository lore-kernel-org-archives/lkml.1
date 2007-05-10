Return-Path: <linux-kernel-owner+w=401wt.eu-S1761987AbXEJVpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761987AbXEJVpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 17:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758448AbXEJVow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 17:44:52 -0400
Received: from wr-out-0506.google.com ([64.233.184.231]:57487 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756931AbXEJVow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 17:44:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=akbwAW4MzUU7y8zZA+iTZ0FboOzX6PYxRCi6E5uc6xKycNcjYTjszKBsMFDpI2M0k6MJ4paf/3yS/E+DTaTdFb/D69qsTVFoWhmUWHEKO6nCm1ZfLOUwJIiC9KlhsfwY50MVUGE+HLXLE8mv0U6DMI5Wz1c0TGagk6YOrjFmBxk=
Message-ID: <a781481a0705101444o4d04bb99xac7cbb587355e56f@mail.gmail.com>
Date: Fri, 11 May 2007 03:14:50 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "jimmy bahuleyan" <knight.camelot@gmail.com>
Subject: Re: [PATCH] "volatile considered harmful", take 2
Cc: "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <464382DE.5020206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6143.1178828419@lwn.net> <464382DE.5020206@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/11/07, jimmy bahuleyan <knight.camelot@gmail.com> wrote:
> Jonathan Corbet wrote:
> [snip..]
> > +
> > +  - The jiffies variable is special in that it can have a different value
> > +    every time it is referenced, but it can be read without any special
> > +    locking.  So jiffies can be volatile, but the addition of other
> > +    variables of this type is strongly frowned upon.  Jiffies is considered
> > +    to be a "stupid legacy" issue in this regard.
>
> Why is it that you consider jiffies to be a "stupid legacy"?

You could find better explanations in previous threads, but to
summarize my understanding of the matter:

Because it is not humanly possible to audit the entire kernel tree to
find all usages of jiffies and fix them appropriately (i.e. "stupid
legacy reasons"). Hence, we just define jiffies as volatile.

> Isn't it natural to have a externally modified variable which is only /read/ to
> be volatile?

No, even in such a case, it would have been saner to simply define the
jiffies _without_ volatile, and only cast _accesses_ to it with the
volatile type qualifier.

Unfortunately, even this is not possible to do in all existing users
in the kernel (i.e. "stupid legacy reasons").

> (or is jiffies supposed to be replaced with something smarter/better :)

Not _replace_ jiffies. But if it were _really_ possible to do so (i.e.
assuming for a moment that we could change all kernel code in one
magic sweep), then again we wouldn't need to use volatile for jiffies
(or even use a volatile cast, IMO).

Just ensure all accesses to jiffies are protected behind an
appropriate barrier() instead, the effects of which are more clearly
defined than the vague and insufficient "volatile", and which
*guarantees* that all memory would be re-read from that point (note
that "volatile" is merely a hint to a C compiler, it comes with no
guarantees at all, which is particularly worrisome these days when
compilers are not the only entities that can re-order code -- hardware
can do so too).

However, yet again, it is _not_ possible to fix the above for all the
existing kernel code that uses jiffies (i.e. "stupid legacy reasons"),
so we just define jiffies as volatile.

My understanding, at least.
