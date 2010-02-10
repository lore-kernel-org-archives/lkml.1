Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0BJCIu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 21:08:50 -0500
Received: from qw-out-2122.google.com ([74.125.92.26]:58481 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804Ab0BJCIt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 21:08:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ph5C4a4naPr0JNc1InmdbSKudDdyln39OX16jVWyLRlekPe4mVC2IbxHXgzZXFIctq
         O2tOwFH1I4x4Lw9750wdagS5GKMZE9ZQxTJeQjBfdxDVk9iPyx1X3Rnj3plFipNP1NiK
         kKitcOOUmNhtcdLCzpc3XfJ/BeuSQnrjzPKOE=
MIME-Version: 1.0
In-Reply-To: <19314.1869.847327.15190@notabene.brown>
References: <19314.1869.847327.15190@notabene.brown>
Date: Wed, 10 Feb 2010 10:08:48 +0800
Message-ID: <2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
Subject: Re: [PATCH] sysfs: differentiate between locking links and non-links
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Neil Brown <neilb@suse.de>
Cc: "Eric W ." <ebiederm@xmission.com>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 10, 2010 at 9:09 AM, Neil Brown <neilb@suse.de> wrote:
>
> Hi,
>  I've just spent a while sorting out some lockdep complaints triggered
>  by the recent addition of the "s_active" lockdep annotation in sysfs
>  (commit 846f99749ab68bbc7f75c74fec305de675b1a1bf)
>
>  Some of them are genuine and I have submitted a fix for those.
>  Some are, I think, debatable and I get to that is a minute.  I've
>  submitted a fix for them anyway.
>  But some are to my mind clearly bogus and I'm hoping that can be
>  fixed by the change below (or similar).
>  The 'bogus' ones are triggered by writing to a sysfs attribute file
>  for which the handler tries to delete a symlink from sysfs.
>  This appears to be a recursion on s_active as s_active is held while
>  the handler runs and is again needed to effect the delete.  However
>  as the thing being deleted is a symlink, it is very clearly a
>  different object to the thing triggering the delete, so there is no
>  real loop.
>
>  The following patch splits the lockdep context in two - one for
>  symlink and one for everything else.  This removes the apparent loop.
>  (An example report can be seen in
>     http://bugzilla.kernel.org/show_bug.cgi?id=15142).
>
>  The "debatable" dependency loops happen when writing to one attribute
>  causes a different attribute to be deleted.  In my (md) case this can
>  actually cause a deadlock as both the attributes take the same lock
>  while the handler is running.  This is because deleting the attribute
>  will block until the all accesses of that attribute have completed (I
>  think).
>  However it should be possible to delete a name from sysfs while there
>  are still accesses pending (it works for normal files!!).  So if
>  sysfs could be changed to simply unlink the file and leave deletion to
>  happen when the refcount become zero it would certainly make my life
>  a lot easier, and allow the removal of some ugly code from md.c.
>  I don't know sysfs well enough to suggest a patch though.
>

Hi, Neil,

Thanks for your patch.

This bug report is new for me. Recently we received lots of sysfs lockdep
warnings, I am working on a patch to fix all the bogus ones.

However, this one is _not_ similar to the other cases, as you decribed.
This patch could fix the problem, but not a good fix, IMO. We need more
work in sysfs layer to fix this kind of things. I will take care of this.

Thanks.
