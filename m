Return-Path: <linux-kernel-owner+w=401wt.eu-S1755242AbYICWC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242AbYICWC2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 18:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYICWCS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 18:02:18 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:53937 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbYICWCQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 18:02:16 -0400
Date: Wed, 3 Sep 2008 17:02:15 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: ebiederm@xmission.com, akpm@linux-foundation.org, hch@infradead.org,
       viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: unprivileged mounts git tree
Message-ID: <20080903220215.GA27705@us.ibm.com>
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

Ooh.

You predicate the turning of shared mount to a slave mount on
!capable(CAP_SYS_ADMIN).  But in fact it's the mount by a privileged
user, turning the mount into a user mount, which you want to convert.
So my series of steps was:

	as root:
		(1) mount --bind /mnt /mnt
		(2) mount --make-rshared /mnt
		(3) /usr/src/mmount-0.3/mmount --bind -o user=hallyn /mnt \
			/home/hallyn/etc/mnt
	as hallyn:
		(4) mount --bind /usr /home/hallyn/etc/mnt/usr

You are turning mounts from shared->slave at step 4, but in fact we need
to do it at step 3, where we do have CAP_SYS_ADMIN.

-serge
