Return-Path: <linux-kernel-owner+w=401wt.eu-S1760113AbYD2TMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760113AbYD2TMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 15:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756141AbYD2TMP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 15:12:15 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44570 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582AbYD2TMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 15:12:14 -0400
Date: Tue, 29 Apr 2008 12:09:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org, tpiepho@freescale.com,
       hartleys@visionengravers.com, bn@niasdigital.com, vapier.adi@gmail.com,
       cooloney@kernel.org
Subject: Re: [patch/rfc 2.6.25-git] gpio: sysfs interface
Message-Id: <20080429120929.ec1899d4.akpm@linux-foundation.org>
In-Reply-To: <200804291145.14172.david-b@pacbell.net>
References: <200804281239.51729.david-b@pacbell.net>
	<20080428195455.6e07cb8d.akpm@linux-foundation.org>
	<20080429034219.GA1413@kroah.com>
	<200804291145.14172.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Apr 2008 11:45:13 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Monday 28 April 2008, Greg KH wrote:
> > On Mon, Apr 28, 2008 at 07:54:55PM -0700, Andrew Morton wrote:
> > > On Mon, 28 Apr 2008 16:28:13 -0700 David Brownell <david-b@pacbell.net> wrote:
> > > 
> > > > > If we had a strcmp() variant which treats a \n in the first arg as a \0
> > > > > the above would become
> > > > > 
> > > > > 	if (sysfs_streq(buf, "high"))
> > > > > 		status = gpio_direction_output(gpio, 1);
> > > > > 	else if (sysfs_streq(buf, "out") || sysfs_streq(buf, "low"))
> > > > > 		status = gpio_direction_output(gpio, 0);
> > > > > 	else if (sysfs_streq(buf, "in"))
> > > > > 		status = gpio_direction_input(gpio);
> > > > 
> > > > That would indeed be better.  Maybe I should whip up a sysfs
> > > > patch adding that, and have this depend on that patch.  (I've
> > > > CC'd Greg in case he has comments on that...)
> > > 
> > > Yes, it would be a standalone patch.  The sort which generates oceans of
> > > useful feedback ;) The sort which also generates hundreds of
> > > use-new-toy-to-clean-up-old-code patches for me to merge :(
> > 
> > Heh, sounds good to me :)
> 
> Hard to say where should live, but lib/strings.c seemed fair.
> See the appended patch.  I made it not care which string has
> newline termination, since caring seems very error-prone.
> 
> - Dave
> 
> ========= CUT HERE
> Add a new sysfs_streq() string comparison function, which ignores
> the trailing newlines found in sysfs inputs.  By example:
> 
> 	sysfs_streq("a", "b")	==> false
> 	sysfs_streq("a", "a")	==> true
> 	sysfs_streq("a", "a\n")	==> true
> 	sysfs_streq("a\n", "a")	==> true

And

	sysfs_streq("a\n", "a\n") ==> true

which actually isn't very interesting.

> This is intended to simplify parsing of sysfs inputs, letting them
> avoid the need to manually strip off newlines from inputs.
> 
> Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> ---
>  include/linux/string.h |    2 ++
>  lib/string.c           |   27 +++++++++++++++++++++++++++
>  2 files changed, 29 insertions(+)
> 
> --- g26.orig/include/linux/string.h	2008-04-29 05:45:53.000000000 -0700
> +++ g26/include/linux/string.h	2008-04-29 05:55:14.000000000 -0700
> @@ -109,5 +109,7 @@ extern void *kmemdup(const void *src, si
>  extern char **argv_split(gfp_t gfp, const char *str, int *argcp);
>  extern void argv_free(char **argv);
>  
> +extern bool sysfs_streq(const char *s1, const char *s2);
> +
>  #endif
>  #endif /* _LINUX_STRING_H_ */
> --- g26.orig/lib/string.c	2008-04-29 05:15:52.000000000 -0700
> +++ g26/lib/string.c	2008-04-29 05:55:32.000000000 -0700
> @@ -493,6 +493,33 @@ char *strsep(char **s, const char *ct)
>  EXPORT_SYMBOL(strsep);
>  #endif
>  
> +/**
> + * sysfs_streq - return true if strings are equal, modulo trailing newline
> + * @s1: one string
> + * @s2: another string
> + *
> + * This routine returns true iff two strings are equal, treating both
> + * NUL and newline-then-NUL as equivalent string terminations.  It's
> + * geared for use with sysfs input strings, which generally terminate
> + * with newlines but are compared against values without newlines.
> + */
> +bool sysfs_streq(const char *s1, const char *s2)
> +{
> +	while (*s1 && *s1 == *s2) {
> +		s1++;
> +		s2++;
> +	}
> +
> +	if (*s1 == *s2)
> +		return true;
> +	if (!*s1 && *s2 == '\n' && !s2[1])
> +		return true;
> +	if (*s1 == '\n' && !s1[1] && !*s2)
> +		return true;
> +	return false;
> +}
> +EXPORT_SYMBOL(sysfs_streq);
> +

Looks good to me.  I'll plan on sliding it into 2.6.26 a few days
hence.

