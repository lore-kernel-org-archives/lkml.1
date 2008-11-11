Return-Path: <linux-kernel-owner+w=401wt.eu-S1753790AbYKKRIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790AbYKKRIR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:08:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYKKRIE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:08:04 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59745 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751458AbYKKRID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:08:03 -0500
Date: Tue, 11 Nov 2008 09:07:02 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do division
 with  rounding
Message-Id: <20081111090702.94be2a19.akpm@linux-foundation.org>
In-Reply-To: <20081111110454.073a6d94@hyperion.delvare>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
	<20081111110454.073a6d94@hyperion.delvare>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008 11:04:54 +0100 Jean Delvare <khali@linux-fr.org> wrote:

> Hi Darrick,
> 
> On Mon, 10 Nov 2008 17:01:32 -0800, Darrick J. Wong wrote:
> > 
> > Create a helper macro to divide two numbers and round the result to the
> > nearest whole number.  This is a helper macro for hwmon drivers that
> > want to convert incoming sysfs values per standard hwmon practice, though
> > the macro itself can be used by anyone.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
> > ---
> > 
> >  include/linux/kernel.h |    6 ++++++
> >  1 files changed, 6 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> > index fba141d..fb02266 100644
> > --- a/include/linux/kernel.h
> > +++ b/include/linux/kernel.h
> > @@ -48,6 +48,12 @@ extern const char linux_proc_banner[];
> >  #define FIELD_SIZEOF(t, f) (sizeof(((t*)0)->f))
> >  #define DIV_ROUND_UP(n,d) (((n) + (d) - 1) / (d))
> >  #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
> > +#define DIV_ROUND_CLOSEST(x, divisor)(			\
> > +{							\
> > +	typeof(divisor) __divisor = divisor;		\
> > +	(((x) + ((__divisor) / 2)) / (__divisor));	\
> > +}							\
> > +)
> >  
> >  #define _RET_IP_		(unsigned long)__builtin_return_address(0)
> >  #define _THIS_IP_  ({ __label__ __here; __here: (unsigned long)&&__here; })
> > 
> 
> I don't get why you implement this as a macro rather than an inline
> function? A function would look much better.

The idea is that DIV_ROUND_CLOSEST() can be used with arguments of any
size (char, short, ...  long long) and will do all the suitable
promotion and will return a type of the appropriate width and
signedness.

It's not particularly pretty and can hide traps and pitfalls, but the
other way is tricky as well - it'd need a family of functions and
there's a risk that programmers will choose the wrong one.

