Return-Path: <linux-kernel-owner+w=401wt.eu-S1761617AbZDGV6J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761617AbZDGV6J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 17:58:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932160AbZDGV5k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 17:57:40 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52869 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932152AbZDGV5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 17:57:38 -0400
Date: Tue, 7 Apr 2009 23:59:53 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Andi Kleen <andi@firstfloor.org>, Lee.Schermerhorn@hp.com, npiggin@suse.de,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, x86@kernel.org
Subject: Re: [PATCH] [10/16] POISON: Use bitmask/action code for try_to_unmap behaviour
Message-ID: <20090407215953.GA17934@one.firstfloor.org>
References: <20090407509.382219156@firstfloor.org> <20090407151007.71F3F1D046F@basil.firstfloor.org> <alpine.DEB.1.10.0904071714450.12192@qirst.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.10.0904071714450.12192@qirst.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 07, 2009 at 05:19:19PM -0400, Christoph Lameter wrote:
> On Tue, 7 Apr 2009, Andi Kleen wrote:
> 
> > +
> > +enum ttu_flags {
> > +	TTU_UNMAP = 0,			/* unmap mode */
> > +	TTU_MIGRATION = 1,		/* migration mode */
> > +	TTU_MUNLOCK = 2,		/* munlock mode */
> > +	TTU_ACTION_MASK = 0xff,
> > +
> > +	TTU_IGNORE_MLOCK = (1 << 8),	/* ignore mlock */
> 
> 
> Ignoring MLOCK? This means we are violating POSIX which says that an
> MLOCKed page cannot be unmapped from a process? 

I'm sure if you can find sufficiently vague language in the document 
to standards lawyer around that requirement @)

The alternative would be to panic. 

> Note that page migration
> does this under special pte entries so that the page will never appear to
> be unmapped to user space.
> 
> How does that work for the poisoning case? We substitute a fresh page?

It depends on the state of the page. If it was a clean disk mapped
page yes (it's just invalidated and can be reloaded). If it's a dirty anon 
page the process is normally killed first (with advisory mode on) or only
killed when it hits the corrupted page. The process can also
catch the signal if it choses so. The late killing works with 
a special entry similar to the migration case, but that results
in a special SIGBUS.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
