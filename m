Return-Path: <linux-kernel-owner+w=401wt.eu-S1755936AbZLDSzg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936AbZLDSzg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 13:55:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071AbZLDSze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 13:55:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49198 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442AbZLDSzd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 13:55:33 -0500
Subject: Re: [RFC PATCH 2/6] pipes: use alloc-file instead of duplicating
 code
From: Eric Paris <eparis@redhat.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, viro@zeniv.linux.org.uk, jmorris@namei.org,
       npiggin@suse.de, zohar@us.ibm.com, jack@suse.cz, jmalicki@metacarta.com,
       dsmith@redhat.com, serue@us.ibm.com, hch@lst.de, john@johnmccutchan.com,
       rlove@rlove.org, ebiederm@xmission.com, heiko.carstens@de.ibm.com,
       penguin-kernel@I-love.SAKURA.ne.jp, mszeredi@suse.cz,
       jens.axboe@oracle.com, akpm@linux-foundation.org, matthew@wil.cx,
       hugh.dickins@tiscali.co.uk, kamezawa.hiroyu@jp.fujitsu.com,
       nishimura@mxp.nes.nec.co.jp, davem@davemloft.net, arnd@arndb.de,
       eric.dumazet@gmail.com
In-Reply-To: <E1NGRLH-0004fr-Gb@pomaz-ex.szeredi.hu>
References: <20091203195851.8925.30926.stgit@paris.rdu.redhat.com>
	 <20091203195902.8925.2985.stgit@paris.rdu.redhat.com>
	 <E1NGRLH-0004fr-Gb@pomaz-ex.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Dec 2009 13:54:43 -0500
Message-Id: <1259952883.2722.26.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-12-04 at 07:08 +0100, Miklos Szeredi wrote:
> On Thu, 03 Dec 2009, Eric Paris wrote:
> > The pipe code duplicates the functionality of alloc-file and init-file.  Use
> > the generic vfs functions instead of duplicating code.
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> 
> Acked-by: Miklos Szeredi <miklos@szeredi.hu>
> 
> As a side note: I wonder why we aren't passing a "struct path" to
> alloc_file() and why are the refcount rules wrt. dentries/vfsmounts so
> weird?

It's probably because of the slightly weird refcnt rules that it asks
for the dentry and vfsmount separately rather than as a struct path.
The rules make perfect sense if you consider

d_alloc()  <-- reference on dentry
d_instantiate()
alloc_file() <-- reference on vfsmount
  so here file->f_path() is all good.

Which a number of callers user.  They make less sense when you consider
something that is not allocating the dentry right there (like this path)

dget(dentry);  <-- reference here
alloc_file() <-- reference on vfsmount;
  so here file->f_path is all good.

It would be a reasonable interface if it took a struct path and then
took a reference on the struct path.  The second case would look more
clean, but the first case would turn into

d_alloc()
d_instantiate()
alloc_file()
d_put() /* matches d_alloc() */

and

alloc_file()

Is this better?  I'll gladly do it if other think so it makes more
sense....

-Eric

