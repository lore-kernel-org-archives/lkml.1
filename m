Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbYBIXyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbYBIXyw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 18:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756007AbYBIXym
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 18:54:42 -0500
Received: from mx1.redhat.com ([66.187.233.31]:60561 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755954AbYBIXyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 18:54:41 -0500
Date: Sat, 9 Feb 2008 21:54:33 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
Message-ID: <20080209235433.GS4352@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Johannes Weiner <hannes@saeurebad.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87zlugsox9.fsf@saeurebad.de> <20080204180753.GB16050@uranus.ravnborg.org> <Pine.LNX.4.64.0802092307520.6917@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802092307520.6917@fbirervta.pbzchgretzou.qr>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sat, Feb 09, 2008 at 11:08:45PM +0100, Jan Engelhardt escreveu:
> 
> On Feb 4 2008 19:07, Sam Ravnborg wrote:
> >> The attached patch allows something along the lines:
> >> 
> >> int __init some_function(void)
> >> {
> >>         [...]
> >>         pr_init(KERN_WARNING "failure %s in %s\n", ...);
> >>         [...]
> >> }
> >> 
> >> Another idea I had was to make printk a macro that figures out the
> >> section of the surrounding function and then moves the data
> >> automatically when it is a literal, but I couldn't find mechanisms that
> >> allow this.  Anyone of you got an idea?
> >> 
> >> What do you think in general?
> >
> >What is the rationale behind this?
> 
> To drop strings that are only shown once anyway, such as:
> 
> static int __init ebtables_init(void)
> {
>         int ret;
> 
>         mutex_lock(&ebt_mutex);
>         list_add(&ebt_standard_target.list, &ebt_targets);
>         mutex_unlock(&ebt_mutex);
>         if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
>                 return ret;
> 
> ->      printk(KERN_INFO "Ebtables v2.0 registered\n");
>         return 0;
> }
> 
> >If you say "saving memory" then please let us know with specific examples
> >in what area these savings will really pay off.

A long time ago I played with this, using a sparse based tool that was
inserted as the compiler and modified the code before passing to gcc,
i.e. a pre-pre-processor:

http://www.kernel.org/pub/linux/kernel/people/acme/sparse/initstr.c

I couldn't find in the archives, but IIRC some extra pages were freed
after boot, i.e. strings moved from .data to .init.data.

With a tool like this the advantage is that no source code has to be
changed, strings in __init functions are automagically moved to
.init.data, the disadvantage is that not all strings can be moved to
.init.data as there were (are?) subsystems that keep pointers to the
string passed and another tool would be involved in the build process.

- Arnaldo
