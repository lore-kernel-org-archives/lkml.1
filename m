Return-Path: <linux-kernel-owner+w=401wt.eu-S1030584AbXDJUhA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030584AbXDJUhA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 16:37:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030588AbXDJUg7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 16:36:59 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:64554 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030584AbXDJUg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 16:36:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=jVq/qByQuHfpuW8sTsS4LUTPKmgZgF8urVJfDUHjuFvAOYvTGTFd+aYyBsdwQCBm4wNN20uqwfP29rmCVs5ydwDBAT8+F7V/Hs5OLyGZ9QOegNzXzmKNR+CIk9P66aysJ8sGdWqL+diqHjY2p5SF9m6n8LsyrmdldN3EjlXwJdQ=
Date: Wed, 11 Apr 2007 00:37:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Add spaces on either side of case "..." operator.
Message-ID: <20070410203744.GA5840@martell.zuzino.mipt.ru>
References: <Pine.LNX.4.64.0704100721050.13729@CPE00045a9c397f-CM001225dbafb6> <20070410090555.d847d466.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070410090555.d847d466.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2007 at 09:05:55AM -0700, Andrew Morton wrote:
> On Tue, 10 Apr 2007 07:23:35 -0400 (EDT) "Robert P. J. Day" <rpjday@mindspring.com> wrote:
> > Following the programming advice laid down in the gcc manual, make
> > sure the case "..." operator has spaces on either side.

> > http://gcc.gnu.org/onlinedocs/gcc-4.1.2/gcc/Case-Ranges.html#Case-Ranges:
> >
> >   "Be careful: Write spaces around the ..., for otherwise it may be
> > parsed wrong when you use it with integer values."

> > --- a/kernel/audit.c
> > +++ b/kernel/audit.c
> > @@ -515,8 +515,8 @@ static int audit_netlink_ok(struct sk_buff *skb, u16 msg_type)
> >  			err = -EPERM;
> >  		break;
> >  	case AUDIT_USER:
> > -	case AUDIT_FIRST_USER_MSG...AUDIT_LAST_USER_MSG:
> > -	case AUDIT_FIRST_USER_MSG2...AUDIT_LAST_USER_MSG2:
> > +	case AUDIT_FIRST_USER_MSG ... AUDIT_LAST_USER_MSG:
> > +	case AUDIT_FIRST_USER_MSG2 ... AUDIT_LAST_USER_MSG2:
>
> hm... We have:
>
> #define AUDIT_FIRST_USER_MSG    1100    /* Userspace messages mostly uninteresting to kernel */
> #define AUDIT_USER_AVC          1107    /* We filter this differently */
> #define AUDIT_LAST_USER_MSG     1199
>
> and CPP turns that into
>
>  case 1100 ...1199:
>  case 2100 ...2999:
>
> and it does the same when the comments are stripped from the #defines.
>
> So we were saved by the trailing space which cpp added to the expanded
> macro.  I wonder why cpp did that, and to what extent one can rely cpp
> doing that.

The only reason I can come up with is temporary files with preprocessing
output. Imagine the code:

	#define FOO 1
	FOO.

Here we have
a) replacement list of token FOO consists of one token -- 1,
b) pp-token list after preprocessing consists of 4 pp-tokens: newline, 1, .,
   newline

BUT, write it to temporary file:

	
	1.

Whoops, there are 3 or 4 pp-tokens? If you don't know history, there are
3, if you do, there are 4.

