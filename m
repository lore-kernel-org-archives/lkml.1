Return-Path: <linux-kernel-owner+w=401wt.eu-S1758022AbYH1WdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbYH1WdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 18:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754408AbYH1WdG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 18:33:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38765 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYH1WdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 18:33:05 -0400
Date: Thu, 28 Aug 2008 15:32:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <greg@kroah.com>
Cc: tj@kernel.org, fuse-devel@lists.sourceforge.net, miklos@szeredi.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] CUSE: implement CUSE - Character device in
 Userspace
Message-Id: <20080828153235.b005748f.akpm@linux-foundation.org>
In-Reply-To: <20080828221525.GA2855@kroah.com>
References: <1219947544-666-1-git-send-email-tj@kernel.org>
	<1219947544-666-6-git-send-email-tj@kernel.org>
	<20080828130740.344f7213.akpm@linux-foundation.org>
	<20080828221525.GA2855@kroah.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Aug 2008 15:15:25 -0700
Greg KH <greg@kroah.com> wrote:

> On Thu, Aug 28, 2008 at 01:07:40PM -0700, Andrew Morton wrote:
> > On Fri, 29 Aug 2008 03:19:04 +0900
> > Tejun Heo <tj@kernel.org> wrote:
> > > +#define fc_to_cc(_fc)		container_of((_fc), struct cuse_conn, fc)
> > > +#define cdev_to_cc(_cdev)	container_of((_cdev), struct cuse_conn, cdev)
> > > +#define cuse_conn_get(cc)	({mntget((cc)->mnt); cc;})
> > > +#define cuse_conn_put(cc)	mntput((cc)->mnt)
> > 
> > I believe all the above could be implemented in C.
> 
> "traditionally" container_of() is used in #define, not a function call
> as it is just pointer math that can be done at compile time.
> 

Well yeah.  But it isn't a very good tradition.

static inline struct cuse_conn *cdev_to_cc(struct cdev *cdev)
{
	return container_of(cdev, struct cuse_conn, cdev);
}

should generate the same code and is prettier.

Unfortunately it has no additional type-safety.  You can still pass it
the address of a tty_driver.cdev instead of a cuse_conn.cdev and the
compiler will happily swallow it.  Not a big problem in practice though.

