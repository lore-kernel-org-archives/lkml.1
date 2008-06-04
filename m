Return-Path: <linux-kernel-owner+w=401wt.eu-S1759661AbYFDJUk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759661AbYFDJUk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 05:20:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756300AbYFDJUW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 05:20:22 -0400
Received: from smtp-out.google.com ([216.239.33.17]:24164 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739AbYFDJUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 05:20:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=h3DmzFxDdFBZiv8B2CHf/NL++sJpah2LzLs6Mxg48qP8l06Bm1Y+A4VmOkY2zeyCw
	CDCG0UMe720HvsMjKq0CA==
Message-ID: <6599ad830806040220o26b34881tf57d3ad1ea4b651d@mail.gmail.com>
Date: Wed, 4 Jun 2008 02:20:02 -0700
From: "Paul Menage" <menage@google.com>
To: "Pavel Emelyanov" <xemul@openvz.org>
Subject: Re: [PATCH 2/2] devscgroup: relax task to dev_cgroup conversion
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Serge Hallyn" <serue@us.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <484646B4.3050904@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <484646B4.3050904@openvz.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 4, 2008 at 12:39 AM, Pavel Emelyanov <xemul@openvz.org> wrote:
> Two functions, that need to get a device_cgroup from a task (they
> are devcgroup_inode_permission and devcgroup_inode_mknod) make it
> in a strange way:
>
> They get a css_set from task, then a subsys_state from css_set,
> then a cgroup from the state and then a subsys_state again from
> the cgroup. Besides, the devices_subsys_id is read from memory,
> whilst there's a enum-ed constant for it.
>
> Optimize this part a bit:
> 1. Get the subsys_stats form the task and be done - no 2 extra
>   dereferences,
> 2. Use the device_subsys_id constant, not the value from memory
>   (i.e. one less dereference).
>
> Found while preparing 2.6.26 OpenVZ port.
>
> Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

Acked-by: Paul Menage <menage@google.com>

Yes, that's more how the css_set pointers are meant to be used. Maybe
improve it further by extracting a task_to_devcgroup() inline
function?

Paul

>
> ---
>  security/device_cgroup.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 15f2f80..f9941a7 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -506,7 +506,6 @@ struct cgroup_subsys devices_subsys = {
>
>  int devcgroup_inode_permission(struct inode *inode, int mask)
>  {
> -       struct cgroup *cgroup;
>        struct dev_cgroup *dev_cgroup;
>        struct dev_whitelist_item *wh;
>
> @@ -515,8 +514,8 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
>                return 0;
>        if (!S_ISBLK(inode->i_mode) && !S_ISCHR(inode->i_mode))
>                return 0;
> -       cgroup = task_cgroup(current, devices_subsys.subsys_id);
> -       dev_cgroup = cgroup_to_devcgroup(cgroup);
> +       dev_cgroup = css_to_devcgroup(task_subsys_state(current,
> +                               devices_subsys_id));
>        if (!dev_cgroup)
>                return 0;
>
> @@ -547,12 +546,11 @@ acc_check:
>
>  int devcgroup_inode_mknod(int mode, dev_t dev)
>  {
> -       struct cgroup *cgroup;
>        struct dev_cgroup *dev_cgroup;
>        struct dev_whitelist_item *wh;
>
> -       cgroup = task_cgroup(current, devices_subsys.subsys_id);
> -       dev_cgroup = cgroup_to_devcgroup(cgroup);
> +       dev_cgroup = css_to_devcgroup(task_subsys_state(current,
> +                               devices_subsys_id));
>        if (!dev_cgroup)
>                return 0;
>
> --
> 1.5.3.4
>
>
