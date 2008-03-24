Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbYCXJez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbYCXJez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2008 05:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755286AbYCXJep
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Mar 2008 05:34:45 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:33233 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755193AbYCXJeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2008 05:34:44 -0400
Date: Mon, 24 Mar 2008 09:34:36 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ram Pai <linuxram@us.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, akpm@linux-foundation.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 3/6] vfs: mountinfo stable peer group id
Message-ID: <20080324093436.GH10722@ZenIV.linux.org.uk>
References: <20080313212641.989467982@szeredi.hu> <20080313212735.741834181@szeredi.hu> <20080319114844.GK10722@ZenIV.linux.org.uk> <E1Jc1Ln-0003jm-Bt@pomaz-ex.szeredi.hu> <20080319182005.GP10722@ZenIV.linux.org.uk> <E1Jc3Ad-0004Xu-58@pomaz-ex.szeredi.hu> <20080322162700.GC10722@ZenIV.linux.org.uk> <1206346782.2961.16.camel@ram.us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206346782.2961.16.camel@ram.us.ibm.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2008 at 01:19:41AM -0700, Ram Pai wrote:
> > 	* in do_change_type(), outside of vfsmount_lock, do invent_group_ids()
> > If it fails - bugger off, if not - proceed as now.
> 
> Has it to be done outside vfsmount_lock?  AFAICT, invent_group_ids()
> does not sleep, nor does change_mnt_propagation().

It does allocation.  And no, GFP_ATOMIC is not appropriate for that.
The same goes for mount IDs, BTW, and there we _also_ don't need
vfsmount_lock - see my current tree, there we have clone_mnt()
serialized by namespace_sem in all cases.

> > 	* in attach_recursive_mnt() if IS_MNT_SHARED(dest_mnt) do
> > invent_group_ids() on the dest_mnt immediately and if it fails do
> 
> I think you meant, invent_group_ids() on the source_mnt.
Yes

> But again
> applying invent_group_ids() on the source_mnt has to be done carefully,
> because, source_mnt may have been shared to begin with.

And?  See the original posting - invent_group_ids() skips the vfsmounts
with already set group ID.
