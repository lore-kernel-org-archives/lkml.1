Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYBJA1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYBJA1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 19:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756218AbYBJA11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 19:27:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:42168 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756296AbYBJA10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 19:27:26 -0500
Date: Sat, 9 Feb 2008 22:27:18 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Johannes Weiner <hannes@saeurebad.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Sectionized printk data
Message-ID: <20080210002718.GT4352@ghostprotocols.net>
Mail-Followup-To: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	Sam Ravnborg <sam@ravnborg.org>,
	Johannes Weiner <hannes@saeurebad.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <87zlugsox9.fsf@saeurebad.de> <20080204180753.GB16050@uranus.ravnborg.org> <Pine.LNX.4.64.0802092307520.6917@fbirervta.pbzchgretzou.qr> <20080209235433.GS4352@ghostprotocols.net> <Pine.LNX.4.64.0802100116560.6917@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802100116560.6917@fbirervta.pbzchgretzou.qr>
X-Url: http://oops.ghostprotocols.net:81/blog
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Sun, Feb 10, 2008 at 01:18:18AM +0100, Jan Engelhardt escreveu:
> 
> On Feb 9 2008 21:54, Arnaldo Carvalho de Melo wrote:
> >> To drop strings that are only shown once anyway, such as:
> >> 
> >> static int __init ebtables_init(void)
> >> {
> >>         int ret;
> >> 
> >>         mutex_lock(&ebt_mutex);
> >>         list_add(&ebt_standard_target.list, &ebt_targets);
> >>         mutex_unlock(&ebt_mutex);
> >>         if ((ret = nf_register_sockopt(&ebt_sockopts)) < 0)
> >>                 return ret;
> >> 
> >> ->      printk(KERN_INFO "Ebtables v2.0 registered\n");
> >>         return 0;
> >> }
> >> 
> >> >If you say "saving memory" then please let us know with specific examples
> >> >in what area these savings will really pay off.
> >
> >[...]
> >With a tool like this the advantage is that no source code has to be
> >changed, strings in __init functions are automagically moved to
> >.init.data, the disadvantage is that not all strings can be moved to
> >.init.data as there were (are?) subsystems that keep pointers to the
> >string passed and another tool would be involved in the build process.
> 
> There is one corner case to consider:
> 
> 
> 	static char abc[] = "foo";
> 
> 	int __init init_module(void)
> 	{
> 		printk(abc);
> 	}
> 
> I am not sure if gcc/ld is smart enough to figure out that abc is
> only ever used from within an __init function and that it could hence
> be moved to __initdata.

The initstr tool mentioned doesn't touches this case, as it doesn't
searches specific functions such as printk, it looks for strings inside
__init marked functions. In the above example abc won't be marked as
__initdata.

So if there are two places where the same string is used, with one being
in a __init function one copy goes to .init.data and another to .data.

- Arnaldo
