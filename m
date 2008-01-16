Return-Path: <linux-kernel-owner+w=401wt.eu-S1751767AbYAPJ3H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767AbYAPJ3H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 04:29:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYAPJ2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 04:28:53 -0500
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:9698
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751328AbYAPJ2v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 04:28:51 -0500
Message-Id: <478DDC79.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 16 Jan 2008 09:29:13 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "David Brownell" <david-b@pacbell.net>,
       "Randy Dunlap" <rdunlap@xenotime.net>
Cc: "lkml" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.23-git Kconfig regression
References: <20071020012245.9B3FB23A5F7@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <20071019184607.06e1eef9.randy.dunlap@oracle.com>
 <20071020015735.270C923A748@adsl-69-226-248-13.dsl.pltn13.pacbell.net>
 <47196165.8070406@oracle.com>
 <20071019195535.0dbafd39.rdunlap@xenotime.net>
 <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
In-Reply-To: <20071019202140.ecbc4a0d.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Randy Dunlap <rdunlap@xenotime.net> 20.10.07 05:21 >>>

Sorry for only now getting back to this.

>On Fri, 19 Oct 2007 19:55:35 -0700 Randy Dunlap wrote:
>
>> On Fri, 19 Oct 2007 19:01:09 -0700 Randy Dunlap wrote:
>> 
>> > >>> I noticed a regression, visible in the drivers/usb/gadget Kconfig;
>> > >>> it seems to be quite recent.
>> > >>>
>> > >>> ...
>> > >> Hm, it does look very odd.  It looks like it has something to
>> > >> do with <choice> working differently for some reason.
>> > >>
>> > >> In xconfig, I set all of the View Options and when I click on one
>> > >> of the periph. controllers, it says
>> > >>
>> > >> 	depends on =y && PCI
>> > > 
>> > > That's what I saw too.  Looked dubious ... 
>> > > 
>> > > 
>> > >> but if I back up to -git7, it says
>> > >>
>> > >> 	depends on <choice> && PCI
>> > > 
>> > > And that git7 thing doesn't look _quite_ so odd.  Did git7 actually

But it still doesn't look like it ought to be that way. Still, I'll try to make
this display e.g. <choice>=y instead.

>> > > let you configure a modular GOKU (for example), i.e. work correctly?
>> > 
>> > Yes, -git9 does.
>> > 
>> > Looks to me like it broke on -git10.  -git9 is OK.
>> > 
>> > >> I'll keep looking.
>> > > 
>> > > Thanks.  Kconfig is one of the areas I prefer to let others
>> > > be the experts.  :)
>> 
>> [hm, odd email problems, changing SMTP]
>> 
>> David,
>> 
>> Just a small update.
>> 
>> If I set USB gadget support to Y instead of M and peripheral
>> controller menu item to Y instead of M, then I can select any of the
>> 4 periph. controllers that are available to me.  (on -git14)
>> I don't know why it's like this though.
>
>David,
>
>My (quick, meaning that I may have missed something) testing
>indicates that the problem is in the patches attached.
>
>Can you revert them and test that?
>
>From git:
>http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=a5bf3d891a6a0fb5aa122792d965e3774108b923 
>
>Change kconfig behavior so that mixing bool and tristate config settings in
>a choice is possible and has the desired effect of offering just the
>tristate options individually if the choice gets set to M, and a normal
>boolean selection if the choice gets set to Y.
>
>Odd, I don't recall seeing this patch...

I'm pretty convinced that drivers/usb/gadget/Kconfig isn't really
written properly:

The first choice contains a mixture of boolean and tristate values; all
of the tristate ones are auto-select values (i.e. such with no prompt),
which results in all of them being unavailable when the choice itself is
set to M (the default with the patch - previously, the choice type got
derived from just the first contained value's type, which was clearly
wrong). These prompt-less items should go after the choice (resulting
in the choice to become a boolean one), if they're needed at all (I
think, especially with the intended change, these options are just
pointless except for avoiding

#if defined(CONFIG_...) || defined(CONFIG_..._MODULE)'

in C sources. In that latter case, the choice could become a tristate
one, allowing all of the selections to be built at once as modules
(which really seems to be the way distro kernels would want to use
it) or any one of them to be built in (the current behavior, except
that at present even when using these as a module only a single
one can be selected).

The second choice appears suspicious altogether - is it really that
just any one of these items can be selected to be built into the
kernel? And again, there are items inside that choice that really
seem to belong outside - I think this is an abuse of the choice
construct, which just happened to work when the choice type (as
described above) was derived from only its first contained value.

Bottom line is, in order to suggest an appropriate adjustment to this
Kconfig file I need clarification on its intentions. Meanwhile I'll scan
the tree for other suspicious choices...

Thanks, Jan

