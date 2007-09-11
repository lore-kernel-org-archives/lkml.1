Return-Path: <linux-kernel-owner+w=401wt.eu-S1763606AbXIKRfR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763606AbXIKRfR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 13:35:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757550AbXIKRfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 13:35:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:34938 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757409AbXIKRfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 13:35:05 -0400
From: Neil Brown <neilb@suse.de>
To: "J. Bruce Fields" <bfields@fieldses.org>
Date: Tue, 11 Sep 2007 19:33:43 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <18150.53623.525080.865402@notabene.brown>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dcache: trivial comment fix
In-Reply-To: message from J. Bruce Fields on Monday September 10
References: <20070910184632.GF2947@fieldses.org>
	<20070910185400.GG2947@fieldses.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
X-face: [Gw_3E*Gng}4rRrKRYotwlE?.2|**#s9D<ml'fY1Vw+@XfR[fRCsUoP?K6bt3YD\ui5Fh?f
	LONpR';(ql)VM_TQ/<l_^D3~B:z$\YC7gUCuC=sYm/80G=$tt"98mr8(l))QzVKCk$6~gldn~*FK9x
	8`;pM{3S8679sP+MbP,72<3_PIH-$I&iaiIb|hV1d%cYg))BmI)AZ
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday September 10, bfields@fieldses.org wrote:
> On Mon, Sep 10, 2007 at 02:46:32PM -0400, J. Bruce Fields wrote:
> >   * This forceful removal will result in ugly /proc output if
> >   * somebody holds a file open that got deleted due to a rename.
> >   * We could be nicer about the deleted file, and let it show
> > - * up under the name it got deleted rather than the name that
> > - * deleted it.
> > + * up under the name it had before it was deleted rather than
> > + * under the original name of the file that was moved on top of it.
> 
> By the way, on further examination of the code it doesn't actually do
> what's described in the case where the target name is large and the
> moved-from name is small.  Instead, it reports random garbage (usually
> part of a name left over from some other dentry?) as far as I can tell:
> 
> from switch_names():
> 
> 
> 	if (dname_external(target)) {
>                 if (dname_external(dentry)) {
> 			...
>                 } else {
>                         /*
>                          * dentry:internal, target:external.  Steal target's
>                          * storage and make target internal.
>                          */
>                         dentry->d_name.name = target->d_name.name;
>                         target->d_name.name = target->d_iname;
> 
> ... but target->d_iname could have anything in it, right?

Right, but not relevant.
The name "switch_names" is somewhat misleading.  It is really
"copyname" or similar.  From the comment at the top:

 * When switching names, the actual string doesn't strictly have to
 * be preserved in the target - because we're dropping the target
 * anyway. As such, we can just do a simple memcpy() to copy over
 * the new name before we switch.

so the apparent name of 'target' after the 'swap' is not important.

The purpose of the assignment
                         target->d_name.name = target->d_iname;
is to make "dname_external(target)" false, that making "target
internal" as the comment says.

static inline int dname_external(struct dentry *dentry)
{
	return dentry->d_name.name != dentry->d_iname;
}

This could possibly be made a little more clear....

NeilBrown
