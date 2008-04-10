Return-Path: <linux-kernel-owner+w=401wt.eu-S1758783AbYDJUKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783AbYDJUKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 16:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752918AbYDJUKp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 16:10:45 -0400
Received: from smtp-out.google.com ([216.239.33.17]:38229 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbYDJUKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 16:10:44 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=c9BOj+oQZ/l++YFpQd03l/bfHPHjZEvoChIlD8FdSMCXDzT4Jig0XY7KjtH9YtjGn
	fyxaPw1kfWL6eiAXn88lQ==
Message-ID: <6599ad830804101310p297536aeld5931073598ec7e6@mail.gmail.com>
Date: Thu, 10 Apr 2008 13:10:30 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [RFC] Control Groups Roadmap ideas
Cc: "Linux Containers" <containers@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <47FC29BF.20701@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6599ad830804081414x7be75d2fte5b500a7f81df40c@mail.gmail.com>
	 <47FC29BF.20701@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 8, 2008 at 7:28 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>
>  Sounds good, and I wrote a prototype in a quick:

Yes, that's pretty much what I was envisaging, thanks.

Paul

>
>  diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>  index a6a6035..091bc21 100644
>  --- a/include/linux/cgroup.h
>  +++ b/include/linux/cgroup.h
>  @@ -254,6 +254,7 @@ struct cgroup_subsys {
>                         struct cgroup *cgrp);
>         void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
>         void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
>  +       int (*can_mount)(struct cgroup_subsys *ss, unsigned long subsys_bits);
>         int subsys_id;
>         int active;
>         int disabled;
>  diff --git a/kernel/cgroup.c b/kernel/cgroup.c
>  index 62f1a52..3d43ff2 100644
>  --- a/kernel/cgroup.c
>  +++ b/kernel/cgroup.c
>  @@ -824,6 +824,25 @@ static int parse_cgroupfs_options(char *data,
>         return 0;
>   }
>
>  +static int check_mount(unsigned long subsys_bits)
>  +{
>  +       int i;
>  +       int ret;
>  +       struct cgroup_subsys *ss;
>  +
>  +       for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
>  +               ss = subsys[i];
>  +
>  +               if (test_bit(i, &subsys_bits) && ss->can_mount) {
>  +                       ret = ss->can_mount(ss, subsys_bits);
>  +                       if (ret)
>  +                               return ret;
>  +               }
>  +       }
>  +
>  +       return 0;
>  +}
>  +
>   static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>   {
>         int ret = 0;
>  @@ -839,6 +858,10 @@ static int cgroup_remount(struct super_block *sb, int *flags, char *data)
>         if (ret)
>                 goto out_unlock;
>
>  +       ret = check_mount(opts.subsys_bits);
>  +       if (ret)
>  +               goto out_unlock;
>  +
>         /* Don't allow flags to change at remount */
>         if (opts.flags != root->flags) {
>                 ret = -EINVAL;
>  @@ -959,6 +982,13 @@ static int cgroup_get_sb(struct file_system_type *fs_type,
>                 return ret;
>         }
>
>  +       ret = check_mount(opts.subsys_bits);
>  +       if (ret) {
>  +               if (opts.release_agent)
>  +                       kfree(opts.release_agent);
>  +               return ret;
>  +       }
>  +
>         root = kzalloc(sizeof(*root), GFP_KERNEL);
>         if (!root) {
>                 if (opts.release_agent)
>  -------
>
>  for the example about swap controller and memory controller:
>
>  static int swap_cgroup_can_mount(struct cgroup_subsys *ss,
>                                 unsigned long subsys_bits)
>  {
>         if (!test_bit(mem_cgroup_subsys_id, &subsys_bits))
>                 return -EINVAL;
>         return 0;
>  }
>
>  'mem_cgroup_subsys_id' is a member of enum cgroup_subsys_id defined in cgroup.h
>
