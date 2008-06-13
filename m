Return-Path: <linux-kernel-owner+w=401wt.eu-S1759926AbYFMDex@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759926AbYFMDex (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 23:34:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbYFMDen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 23:34:43 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:32545 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429AbYFMDem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 23:34:42 -0400
Date: Thu, 12 Jun 2008 20:33:12 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Louis Rilling <Louis.Rilling@kerlabs.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [RFC] configfs: module reference counting rules
Message-ID: <20080613033309.GE20581@mail.oracle.com>
Mail-Followup-To: Louis Rilling <Louis.Rilling@kerlabs.com>,
	ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
References: <20080612235410.GC4012@localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080612235410.GC4012@localdomain>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
	come to perfection.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 13, 2008 at 01:54:11AM +0200, Louis Rilling wrote:
> I'm a bit confused by configfs module reference counting, and I feel
> that it does not really protect against module unloading. If my feeling
> is correct, I'd suggest to change module reference counting rules in
> configfs, for instance like in the attached patch. If my feeling is
> wrong, could someone shed some light?

	You're wrong, sort of :-)  I worked quite hard on this, so I was
scared you'd found something - you haven't.
	configfs is only responsible for its *own* references on the
client module.  The client module is responsible for protecting itself.
	What do I mean?  In mkdir(), the problem is racing
configfs_unregister_subsystem().  The group *has* to be live, because we
have i_mutex - unregister_subsystem can't tear down the directory until
we release it.  So we're safe to call ->make_item/group().  After we've
done that, we have a type, and we can try_module_get().  If someone else
is in unregister_subsystem, that fails and we clean up.  If not, we have
a reference and they can't unload.
	This is hard logic, and not something we want each and every
client module to have to figure out.  Your change has them explicitly
__module_get() in ->make_item/group(), which isn't safe because of this
race!
	What about attributes?  They can only be accessed via the
filesystem exposure.  If they are in the filesystem, unregister can't
happen.  If they are opened, the module refcount is incremented.
	Your big concern came from rmdir().  Specifically, while it was
safe to allocate an object during ->make_item/group(), what happens
after ->drop_item() is called and then module_put()?  If the item has a
reference count still, the ->release() is not called.  We may be
dropping our last reference on the module, and now the module can be
unloaded.  This is the module's problem, not ours!  configfs no longer
has a reference to the module, and thus cannot control its lifetime.
	Anyone who has just the single reference is safe, because that's
the last reference.  When we call the last config_item_put(), the
release happens.  That's the simple case.
	A module that takes an additional reference to the config item
needs to have this protection in place.  All in-kernel users take and
release items in one function call.  They don't hold long-term
references.  If they did, they'd have to have a way of ensuring their
structure remained alive - and this would be the case if configfs wasn't
even involved.

Joel

-- 

Life's Little Instruction Book #232

	"Keep your promises."

Joel Becker
Principal Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
