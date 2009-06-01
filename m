Return-Path: <linux-kernel-owner+w=401wt.eu-S1757662AbZFAM3F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662AbZFAM3F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 08:29:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753275AbZFAM3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 08:29:00 -0400
Received: from ozlabs.org ([203.10.76.45]:46322 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752978AbZFAM27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 08:28:59 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amerigo Wang <amwang@redhat.com>
Subject: Re: [Patch 4/4] module: trim exception table in module_free()
Date: Mon, 1 Jun 2009 21:58:56 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-11-generic; KDE/4.2.2; i686; ; )
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jdike@addtoit.com, mingo@elte.hu,
       sparclinux@vger.kernel.org, linux-ia64@vger.kernel.org
References: <20090526083717.5050.32719.sendpatchset@localhost.localdomain> <200905281625.24974.rusty@rustcorp.com.au> <4A221280.1050406@redhat.com>
In-Reply-To: <4A221280.1050406@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906012158.57581.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 May 2009 02:45:44 pm Amerigo Wang wrote:
> Rusty Russell wrote:
> > On Wed, 27 May 2009 05:16:11 pm Amerigo Wang wrote:
> >> Rusty Russell wrote:
> >>> __ex_table ends up with two entries:
> >>>
> >>> Contents of section __ex_table:
> >>>  0000 0c000000 00000000 0e000000 00000000  ................
> >>>  0010 10000000 0a000000 12000000 0a000000  ................
> >>>
> >>> The first is for the __put_user in .text (extable_not_init()) and the
> >>> second is for the one in .init.text (init()).
> >>>
> >>> Depending on how the module gets allocated, the one referring to
> >>> .init.text may be first or last.
> >>
> >> Hmm, how about the following? :-)
> >>
> >> struct exception_table_entry *p = mod->extable;
> >>
> >> for (;p <= mod->extable+mod->num_exentries; p++ )
> >>          if (with_in_module_init(p->insn, mod))
> >>                    trim_it(p);
> >
> > More like this:
> >
> > void trim_init_extable(struct module *m)
> > {
> > 	/* Since entries are sorted, init entries are at the start... */
> > 	while (m->num_exentries && within_module_init(m->extable[0].insn)) {
> > 		m->extable++;
> > 		m->num_exentries--;
> > 	}
> >
> > 	/* ... or the end. */
> > 	while (m->num_exentries &&
> > within_module_init(m->extable[m->num_exentries-1].insn))
> > m->num_exentries--;
> > }
>
> Great! Thank you!
> But does this works on all arch? Or only except sparc32?

Variations will work on all archs.  sparc32 doesn't sort its exception table 
AFAICT, so it will need something more sophisticated (ISTR they have exception 
areas, so perhaps setting length to 0 would 'delete' them).

Hope that helps,
Rusty.

