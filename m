Return-Path: <linux-kernel-owner+w=401wt.eu-S1753605AbZFXLNI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605AbZFXLNI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:13:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752314AbZFXLMz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:12:55 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:41848 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276AbZFXLMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:12:54 -0400
To: viro@ZenIV.linux.org.uk
CC: torvalds@linux-foundation.org, dhowells@redhat.com, miklos@szeredi.hu,
       alan@lxorguk.ukuu.org.uk, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       adilger@sun.com, akpm@linux-foundation.org
In-reply-to: <20090624105336.GO8633@ZenIV.linux.org.uk> (message from Al Viro
	on Wed, 24 Jun 2009 11:53:36 +0100)
Subject: Re: [RFC] O_NOACC: open without any access
References: <20090623170610.7fd8a3f8@lxorguk.ukuu.org.uk> <E1MJ7gC-0007mx-CY@pomaz-ex.szeredi.hu> <E1MHBX7-0001Mv-Li@pomaz-ex.szeredi.hu> <20090623134640.GA13831@infradead.org> <E1MJ6jW-0007cz-Mp@pomaz-ex.szeredi.hu> <20090623143408.GA2147@infradead.org> <16370.1245772337@redhat.com> <16755.1245773452@redhat.com> <17310.1245776720@redhat.com> <alpine.LFD.2.01.0906231019250.3240@localhost.localdomain> <20090624105336.GO8633@ZenIV.linux.org.uk>
Message-Id: <E1MJQOp-0001Tx-4c@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 24 Jun 2009 13:12:19 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009, Al Viro wrote:
> i_filesystem_fop is certainly bogus, but why do we want to bother with
> file_operations at all?
> 
> Unless you really insist on unlimited use of ioctl(2) on such beasts (and
> any users will be non-portable for obvious reasons anyway), there's no need
> to go anywhere near ->open() *or* ->f_op in general.
> 
> Just add new methods to ->i_op (and we already have that coming from
> fs code) and teach do_filp_open() to
> 	* call permission() with new flag (MAY_TALK_TO_FS_NODE) for such
> open()
> 	* do not die with -ELOOP on symlinks if we have O_NOFOLLOW + your flag
> 	* do not call ->f_op->open() at all for such open()
> and we are all set.

Sounds good.

>  Hell, we can even teach sys_ioctl() that given set
> of ioctls maps to calls of our new methods.  Taken from ->i_op...
>
> If we want full-blown ->ioctl() coming from the fs code on such opens, we
> will need distinct file_operations, no matter what we do with ->open().
> It's also doable (we'd need ->i_fop pointing to new foofs_special_file_ops
> and its ->open() to be a boilerplate that would replace file->f_op with
> the normal one in case of normal open()), but it's more boilerplate patches
> and I really don't see what would it buy...

Adding boilerplate to _every_ filesystem sounds really fragile and
stupid.  At least add a filesystem (or inode) flag:
FS_HANDLES_NODE_OPENS and otherwise don't call into filesystem's
->open().

Thanks,
Miklos
