Return-Path: <linux-kernel-owner+w=401wt.eu-S1753385AbYICVzJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbYICVzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 17:55:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754395AbYICVyp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 17:54:45 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:42020 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754191AbYICVyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 17:54:44 -0400
Date: Wed, 3 Sep 2008 16:54:43 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080903215443.GA25072@us.ibm.com>
References: <E1JtiOX-0004Qg-1z@pomaz-ex.szeredi.hu> <20080807222751.GA28412@us.ibm.com> <m1prokgyje.fsf@frodo.ebiederm.org> <20080808002537.GA5364@us.ibm.com> <E1KXZpC-0008Ie-6w@pomaz-ex.szeredi.hu> <20080827153628.GA11242@us.ibm.com> <E1KYNMl-0000TG-Qs@pomaz-ex.szeredi.hu> <20080827184600.GA8069@us.ibm.com> <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1KaxLm-0006OD-K8@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Miklos Szeredi (miklos@szeredi.hu):
> On Wed, 27 Aug 2008, Serge E. Hallyn wrote:
> > Ok, thanks.  I look forward to playing around with it when you publish
> > the resulting git tree  :)
> 
> A couple of centuries later...
> 
> ...here's the updated git tree:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git unprivileged-mounts
> 
> Changes since the previous version:
> 
>  - update to apply against latest git
>  - downgrade shared mounts to slave for unprivileged binds (if owners differ)
>  - don't allow unprivileged recursive binds
> 
> Serge, thanks again for testing and reviewing these patches!

Well I see where a shared mount *should* be turned into a slave mount
when bind-mounted as a user mount, but it doesn't seem to be happening.
In particular, after doing a user mount of /mnt onto
/home/hallyn/etc/mnt, /proc/self/mountinfo ends in:

22 13 3:1 /mnt /mnt rw shared:1 - ext3 /dev/root
rw,errors=continue,user_xattr,acl,data=ordered
23 13 3:1 /mnt /root/mnt rw shared:1 - ext3 /dev/root
rw,errors=continue,user_xattr,acl,data=ordered
24 13 3:1 /mnt /home/hallyn/etc/mnt rw,user=500 shared:1 - ext3
/dev/root rw,errors=continue,user_xattr,acl,data=ordered

I assume this means that /mnt and /home/hallyn/etc/mnt are peers
in peergroup 1?

And indeed if hallyn does mount --bind /usr /home/hallyn/etc/mnt/usr,
then /mnt/usr shows the contents of /usr.

I see that in do_loopback() you are adding CL_SLAVE|CL_MAKE_SHARED to
flags so I don't get what is going on.  Still looking through the code.

-serge
