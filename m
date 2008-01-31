Return-Path: <linux-kernel-owner+w=401wt.eu-S933916AbYAaWnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933916AbYAaWnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:43:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761444AbYAaWnI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:43:08 -0500
Received: from nwd2mail11.analog.com ([137.71.25.57]:57963 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761670AbYAaWnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:43:07 -0500
X-IronPort-AV: E=Sophos;i="4.25,287,1199682000"; 
   d="scan'208";a="47741022"
From: Robin Getz <rgetz@blackfin.uclinux.org>
Organization: Blackfin uClinux org
To: "Paulo Marques" <pmarques@grupopie.com>
Subject: Re: managing kallsyms_addresses
Date: Thu, 31 Jan 2008 17:44:27 -0500
User-Agent: KMail/1.9.5
Cc: "Rusty Russell" <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org,
       "Sam Ravnborg" <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>
References: <200801311148.18859.rgetz@blackfin.uclinux.org> <47A204FD.70607@grupopie.com>
In-Reply-To: <47A204FD.70607@grupopie.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311744.27692.rgetz@blackfin.uclinux.org>
X-OriginalArrivalTime: 31 Jan 2008 22:43:04.0919 (UTC) FILETIME=[A4778670:01C8645A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 31 Jan 2008 12:27, Paulo Marques pondered:
> Robin Getz wrote:
> > When the kernel needs to find out what symbol is at a specific address, it 
> > uses kallsyms_lookup() This seems to work pretty well - almost.
> > 
> > The problem is today, we don't to remove the symbols from the init section 
> > when the init section is freed. There is invalid data in
> > kallsyms_addresses. 
> > [...]
> > There would be two solutions:
> >  - when freeing the init section, remove all the init labels from the 
> > kallsyms_addresses, and resort/pack it.
> 
> This should be doable, but to be worth it, we would need to use 
> different structures for the init symbols, that would be stored in 
> __initdata.
> 
> Then, ideally we would have separate functions in the __init section to 
> look up symbols in those structures that would only be called until we 
> released the init sections.
> 
> On the plus side, this would avoid the "repacking" the kallsyms 
> structures to remove the init labels.

I think this would be a good long term thing, but would require restructuring 
of all the kallsyms scripts, as well as everything in the kernel...

> >  - if the init section is unloaded, have is_kernel_inittext always 
> >  return 0. 
> 
> This is by far the simplest solution. I even STR a patch floating around 
> to do this, by I can't seem to locate it now... :(

I can put something together if Rusty agrees this is the way to go.

> > I assume that similar things need to be handled for module init too, but I 
> > have not run into that yet.
> 
> It seems that at least the last solution should be easy enough to 
> implement there.
> 
> > Thoughts?
> 
> I think that the simplest solution (the second one) is probably the best 
> for now.
> 
> One thing that did cross my mind though, is stuff like lockdep.

Hmmm - I would need to defer to Ingo to understand the dependencies in lockdep 
and init labels/addresses in kallsyms_addresses.

> If we run a locking sequence that is called from init code, and later a 
> different locking sequence is used when we already freed init data, how 
> can the debug information show the names of the functions that generated 
> the previous locking sequence?

Maybe the lockdep needs to keep track of the label, not the address.

> It seems that the only "correct" approach would be to store a "before 
> freeing init sections" flag together with the function pointer, and then 
> have a kallsyms interface that could receive this flag to know where to 
> look.
> 
> In that case, the first solution can not be used at all (because we need 
> to keep the init symbols anyway) and the second solution could be simply 
> implemented by having a default value for the flag that is the "current 
> state" for that flag...

That seems a little cumbersome to me...

-Robin
