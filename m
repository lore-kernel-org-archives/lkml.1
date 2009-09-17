Return-Path: <linux-kernel-owner+w=401wt.eu-S1758603AbZIQHQg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603AbZIQHQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 03:16:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZIQHQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 03:16:36 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50549 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758526AbZIQHQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 03:16:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 17 Sep 2009 16:14:32 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: =?UTF-8?B?QW3DqXJpY28=?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: Re: [PATCH 3/3][mmotm] updateing size of kcore
Message-Id: <20090917161432.97e06050.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <2375c9f90909162359m14ec7640m88ddd7ba54d6e793@mail.gmail.com>
References: <2375c9f90909160235m1f052df0qb001f8243ed9291e@mail.gmail.com>
	<1bc66b163326564dafb5a7dd8959fd56.squirrel@webmail-b.css.fujitsu.com>
	<20090917114138.e14a1183.kamezawa.hiroyu@jp.fujitsu.com>
	<20090917114509.a9eb9f2c.kamezawa.hiroyu@jp.fujitsu.com>
	<2375c9f90909162359m14ec7640m88ddd7ba54d6e793@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Sep 2009 14:59:35 +0800
Américo Wang <xiyou.wangcong@gmail.com> wrote:

> On Thu, Sep 17, 2009 at 10:45 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > After memory hotplug (or other events in future), kcore size
> > can be modified.
> >
> > To update inode->i_size, we have to know inode/dentry but we
> > can't get it from inside /proc directly.
> > But considerinyg memory hotplug, kcore image is updated only when
> > it's opened. Then, updating inode->i_size at open() is enough.
> >
> > Cc: WANG Cong <xiyou.wangcong@gmail.com>
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> 
> This patch looks fine.
> 
> However, I am thinking if kcore is the only file under /proc whose size
> is changed dynamically? If no, that probably means we need to change
> generic proc code.
> 
I tried yesteray, and back to this ;)

One thing which makes me confused is that there is no way to get
inode or dentry from proc_dir_entry.

I tried to rewrite proc_getattr() for cheating "ls". But it just works for
"stat" and inode->i_size is used more widely. So, this implementation now.

But considering practically, inode->i_size itself is not meaningful in /proc
files even if it's correct. For example, /proc/vmstat or /proc/stat,
/proc/<pid>/maps... etc...

inode->i_size will be dynamically changed while reading. Now, most of users
know regular files under /proc is not a "real" file and handle them in proper
way. (programs can be used with pipe/stdin works well.)

I wonder /proc/kcore is a special one, which gdb/objdump/readelf may access.
Above 3 programs are for "usual" files and not considering pseudo files under
/proc. So, I think adding generic i->i_size support is an overkill until
there are users depends on that.

Thanks,
-Kame


> Thanks!
> 
> > ---
> >  fs/proc/kcore.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> >
> > Index: mmotm-2.6.31-Sep14/fs/proc/kcore.c
> > ===================================================================
> > --- mmotm-2.6.31-Sep14.orig/fs/proc/kcore.c
> > +++ mmotm-2.6.31-Sep14/fs/proc/kcore.c
> > @@ -546,6 +546,11 @@ static int open_kcore(struct inode *inod
> >                return -EPERM;
> >        if (kcore_need_update)
> >                kcore_update_ram();
> > +       if (i_size_read(inode) != proc_root_kcore->size) {
> > +               mutex_lock(&inode->i_mutex);
> > +               i_size_write(inode, proc_root_kcore->size);
> > +               mutex_unlock(&inode->i_mutex);
> > +       }
> >        return 0;
> >  }
> >
> >
> >
> 

