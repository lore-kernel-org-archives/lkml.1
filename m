Return-Path: <linux-kernel-owner+w=401wt.eu-S1764788AbYEHSa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764788AbYEHSa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 14:30:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYEHSap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 14:30:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.189]:56575 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753445AbYEHSan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 14:30:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mxjuLJ3It6dHCPXPEPpg62sFAhJx6fP5SFHGCvyTCGXFqfhFVXQrqKrX633pe944cpGiNxGwuF/AKw5HBwG19UYaGq6B03cDNU/bgwP0i1llRx1aGxSbO+qsQs148SJr8z+FWqjJd2kNxG2N6pnSWOZZ5XdWgeRvXrXKfyoBf30=
Message-ID: <91b13c310805081130s389195c1h8970290a8a34009a@mail.gmail.com>
Date: Fri, 9 May 2008 02:30:41 +0800
From: "rae l" <crquan@gmail.com>
To: "Steven Whitehouse" <swhiteho@redhat.com>
Subject: Re: [PATCH 1/2] [fs-devel] the real needs of just_schedule
Cc: "Al Viro" <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       cluster-devel@redhat.com, linux-kernel@vger.kernel.org
In-Reply-To: <1210252312.3635.484.camel@quoit>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1210096264-27426-1-git-send-email-crquan@gmail.com>
	 <1210252312.3635.484.camel@quoit>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 8, 2008 at 9:11 PM, Steven Whitehouse <swhiteho@redhat.com> wrote:
> Hi,
>
>  On Wed, 2008-05-07 at 01:51 +0800, Denis Cheng wrote:
>  > there are some situations which really need a just schedule,
>  > with int return value;
>  > and this should be moved into lib/ in the future.
>  >
>  > Signed-off-by: Denis Cheng <crquan@gmail.com>
>  > ---
>  >  fs/inode.c                |    2 +-
>  >  include/linux/writeback.h |   16 ++++++++++++----
>  >  2 files changed, 13 insertions(+), 5 deletions(-)
>  >
>  > diff --git a/fs/inode.c b/fs/inode.c
>  > index bf64781..b355a44 100644
>  > --- a/fs/inode.c
>  > +++ b/fs/inode.c
>  > @@ -1291,7 +1291,7 @@ int inode_needs_sync(struct inode *inode)
>  >
>  >  EXPORT_SYMBOL(inode_needs_sync);
>  >
>  > -int inode_wait(void *word)
>  > +int just_schedule(void *word)
>  >  {
>  >       schedule();
>  >       return 0;
>  > diff --git a/include/linux/writeback.h b/include/linux/writeback.h
>  > index f462439..80ff5eb 100644
>  > --- a/include/linux/writeback.h
>  > +++ b/include/linux/writeback.h
>  > @@ -67,23 +67,31 @@ struct writeback_control {
>  >
>  >  /*
>  >   * fs/fs-writeback.c
>  > - */
>  > + */
>  >  void writeback_inodes(struct writeback_control *wbc);
>  > -int inode_wait(void *);
>  >  void sync_inodes_sb(struct super_block *, int wait);
>  >  void sync_inodes(int wait);
>  >
>  > +/*
>  > + * fs/inode.c
>  > + *
>  > + * there are some situations which really need a just schedule,
>  > + * with int return value;
>  > + * and this should be moved into lib/ in the future.
>  > + */
>  > +int just_schedule(void *);
>  > +
>  Why is now not a good time? :-)
>
>  The patches look ok to me otherwise, but I wonder whether I should put
>  them in my tree (since they affect core code) or whether they'd be
>  better in -mm and/or linux-next?
The inode_wait in fs core code(fs/inode.c) is really just_schedule, so
is the gdlm_ast_wait, and they are all fs related code;

But inode_wait is not a better name for its work, instead just_schedule won.

So I should ask for opinions from fs core crew,

BTW, today I did a grep among the whole kernel tree and found that
just_schedule is also useful to other code, such as:

key_wait_bit(security/keys/request_key.c:25)

It's also really a just_schedule.

So just_schedule should go to lib/ ? Or we just append it into kernel/sched.c?

>
>  Steve.

-- 
Denis Cheng
