Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab0BAWF0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 17:05:26 -0500
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:54255 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753747Ab0BAWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 17:05:24 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18msnlCJxZSTdB5RuHEALgn
Date: Mon, 1 Feb 2010 14:05:48 -0800
From: Tony Lindgren <tony@atomide.com>
To: Joe Perches <joe@perches.com>
Cc: d binderman <dcb314@hotmail.com>, linux-kernel@vger.kernel.org
Subject: Re: arch/arm/mach-omap2/mux.c: Off by one error
Message-ID: <20100201220548.GE22747@atomide.com>
References: <BLU108-W14539E61D58BF455B82CA59C590@phx.gbl>
 <20100201210633.GC22747@atomide.com>
 <1265059030.25140.349.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1265059030.25140.349.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Joe Perches <joe@perches.com> [100201 13:14]:
> On Mon, 2010-02-01 at 13:06 -0800, Tony Lindgren wrote:
> > * d binderman <dcb314@hotmail.com> [100131 04:14]:
> > > I just ran the sourceforge tool cppcheck over the source code of the
> > > new Linux kernel 2.6.33-rc6
> > > 
> > > It said
> > > 
> > > [./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds
> > > 
> > > The source code is
> > > 
> > >         char mode[14];
> > >         int i = -1;
> > > 
> > >         sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
> > > 13 characters + 1 digit + 1 zero byte is more than 14 characters.
> > > Suggest new code
> > >         char mode[15];
> > diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
> > index 32764be..047aa57 100644
> > --- a/arch/arm/mach-omap2/mux.c
> > +++ b/arch/arm/mach-omap2/mux.c
> > @@ -486,7 +486,7 @@ int __init omap_mux_init_signal(char *muxname, int val)
> >  static inline void omap_mux_decode(struct seq_file *s, u16 val)
> >  {
> >  	char *flags[OMAP_MUX_MAX_NR_FLAGS];
> > -	char mode[14];
> > +	char mode[15];
> 
> Maybe:
> 
> 	char mode[sizeof("OMAP_MUX_MODE") + 1];

Thanks, that makes it nicer. Updated patch below.

> or
> 	char mode[OMAP_MUX_DEFNAME_LEN];
> 
> with the #define moved up a bit?
> 

That's for the mux signal name, which is different from the mux mode.

But looking over that, it should eventually be done with strlen + kmalloc
if the signal names for mode0 start increasing for new omaps. So added a
comment there for now.

Regards,

Tony


>From ec5041da8d158ed601f18d6efbd779bb6733eb37 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Mon, 1 Feb 2010 13:03:42 -0800
Subject: [PATCH] omap: Fix arch/arm/mach-omap2/mux.c: Off by one error

David Binderman ran the sourceforge tool cppcheck over the source code of the
new Linux kernel 2.6.33-rc6:

[./arm/mach-omap2/mux.c:492]: (error) Buffer access out-of-bounds

13 characters + 1 digit + 1 zero byte is more than 14 characters.

Also add a comment on mode0 name length in case new omaps
start using longer names.

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Tony Lindgren <tony@atomide.com>

diff --git a/arch/arm/mach-omap2/mux.c b/arch/arm/mach-omap2/mux.c
index 32764be..6bfcbec 100644
--- a/arch/arm/mach-omap2/mux.c
+++ b/arch/arm/mach-omap2/mux.c
@@ -486,7 +486,7 @@ int __init omap_mux_init_signal(char *muxname, int val)
 static inline void omap_mux_decode(struct seq_file *s, u16 val)
 {
 	char *flags[OMAP_MUX_MAX_NR_FLAGS];
-	char mode[14];
+	char mode[sizeof("OMAP_MUX_MODE") + 1];
 	int i = -1;
 
 	sprintf(mode, "OMAP_MUX_MODE%d", val & 0x7);
@@ -553,6 +553,7 @@ static int omap_mux_dbg_board_show(struct seq_file *s, void *unused)
 		if (!m0_name)
 			continue;
 
+		/* REVISIT: Needs to be updated if mode0 names get longer */
 		for (i = 0; i < OMAP_MUX_DEFNAME_LEN; i++) {
 			if (m0_name[i] == '\0') {
 				m0_def[i] = m0_name[i];
