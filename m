Return-Path: <linux-kernel-owner+w=401wt.eu-S1757562AbXGXGph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562AbXGXGph (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 02:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751208AbXGXGpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 02:45:30 -0400
Received: from ozlabs.org ([203.10.76.45]:60567 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751030AbXGXGpa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 02:45:30 -0400
Subject: Re: [kvm-devel] [RFC 0/8]KVM: swap out guest pages
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Cc: Shaohua Li <shaohua.li@intel.com>,
       kvm-devel <kvm-devel@lists.sourceforge.net>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <46A59A75.8050501@qumranet.com>
References: <1185173489.2645.64.camel@sli10-conroe.sh.intel.com>
	 <46A4829C.9080104@qumranet.com>
	 <1185232218.1803.36.camel@localhost.localdomain>
	 <46A58E8B.8050507@qumranet.com>
	 <1185257474.1803.216.camel@localhost.localdomain>
	 <46A59A75.8050501@qumranet.com>
Content-Type: text/plain
Date: Tue, 24 Jul 2007 16:45:09 +1000
Message-Id: <1185259509.1803.237.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-07-24 at 09:21 +0300, Avi Kivity wrote:
> Rusty Russell wrote:
> > Actually, get_user_pages() does that for you.  You have to make R/O any
> > writable pte where the guest doesn't set the dirty bit (so you can trap
> > it later) but last I put a printk in there, Linux doesn't do that.
> 
> Don't understand.  You mean Linux always sets the dirty bit when it
> makes a page writable?  Surely some mistake.
> 
> It probably does do so on demand write faults, but I'm sure the dirty
> bit can get cleaned out by the swapper.

Yeah, me dumb.  I should put that printk back and try doing a kernel
compile.

> > If not, it does get harder.  A callback in the mm struct to say "I want
> > to swap your page out" is required if we don't take a reference to the
> > page.  Dirty bit handling would be an interesting issue (maybe the
> > callback can say "No!" and dirty the page again?).
> 
> Since we have rmap, I don't see that as an issue.  Given a page, we can
> easily drop all refs.  Though lguest doesn't do that, right?

Yeah, rmap might maul some puppies.  I could do poor man's rmap tho with
one backref and a bit to say "there are more".  Then if that bit is set,
I just drop all 4 shadows 8)

> I'm also concerned with picking the correct page, but there's no good
> solution here.

But since you have rmap, if there was a cb when the the page was
undirtied, you could undirty the ptes.  When there "I want to kick this
page out" cb comes along, see if one of the ptes is now dirty, dirty the
page and return "no".

Maybe it's too simplistic, but it might work.
Rusty.

