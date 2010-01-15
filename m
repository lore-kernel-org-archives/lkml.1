Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708Ab0AOElO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 14 Jan 2010 23:41:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984Ab0AOElN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 23:41:13 -0500
Received: from mail-qy0-f194.google.com ([209.85.221.194]:51775 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab0AOElL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 23:41:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zb7b8/FhptlewgDPQym6hM4hTr8u++a3ogw++dw2QiYDerMuh+ZNna73bpCAURSYsc
         iI5lmHRsN2o3NVV+CN1hyc+8Vx2BhTPW4IITVYJP/pcFXY4c0xpbfJSDiy+Eh/mgPd05
         V0hNgXPFWcdKSPwf8QIcqaUmQSliDnYDYzfjw=
MIME-Version: 1.0
In-Reply-To: <20091202141458.12819.96170.stgit@paris.rdu.redhat.com>
References: <20091202141452.12819.93536.stgit@paris.rdu.redhat.com>
	 <20091202141458.12819.96170.stgit@paris.rdu.redhat.com>
Date: Thu, 14 Jan 2010 20:41:10 -0800
Message-ID: <6a12d2f31001142041j7f917b07l1e1a728790175321@mail.gmail.com>
Subject: Re: [PATCH 2/4] fanotify: Add pids to events
From: Matthew Helsley <matt.helsley@gmail.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        viro@zeniv.linux.org.uk, hch@infradead.org, agruen@suse.de,
        containers@lists.linux-foundation.org, matthltc@us.ibm.com,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 2, 2009 at 6:14 AM, Eric Paris <eparis@redhat.com> wrote:
> From: Andreas Gruenbacher <agruen@suse.de>
>
> Pass the process identifiers of the triggering processes to fanotify
> listeners: this information is useful for event filtering and logging.
>
> Signed-off-by: Andreas Gruenbacher <agruen@suse.de>
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
>
>  fs/notify/fanotify/fanotify.c      |    5 +++--
>  fs/notify/fanotify/fanotify_user.c |    1 +
>  fs/notify/notification.c           |    3 +++
>  include/linux/fanotify.h           |    1 +
>  include/linux/fsnotify_backend.h   |    1 +
>  5 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> index 5b0b6b4..881067d 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -10,8 +10,9 @@ static bool should_merge(struct fsnotify_event *old, struct fsnotify_event *new)
>  {
>        pr_debug("%s: old=%p new=%p\n", __func__, old, new);
>
> -       if ((old->to_tell == new->to_tell) &&
> -           (old->data_type == new->data_type)) {
> +       if (old->to_tell == new->to_tell &&
> +           old->data_type == new->data_type &&
> +           old->tgid == new->tgid) {
>                switch (old->data_type) {
>                case (FSNOTIFY_EVENT_PATH):
>                        if ((old->path.mnt == new->path.mnt) &&
> diff --git a/fs/notify/fanotify/fanotify_user.c b/fs/notify/fanotify/fanotify_user.c
> index 7646111..7cfb2f6 100644
> --- a/fs/notify/fanotify/fanotify_user.c
> +++ b/fs/notify/fanotify/fanotify_user.c
> @@ -108,6 +108,7 @@ static ssize_t fill_event_metadata(struct fsnotify_group *group,
>        metadata->event_len = FAN_EVENT_METADATA_LEN;
>        metadata->vers = FANOTIFY_METADATA_VERSION;
>        metadata->mask = fanotify_outgoing_mask(event->mask);
> +       metadata->pid = pid_vnr(event->tgid);

Eric, you never replied to my point about pid namespaces
(http://lkml.org/lkml/2009/7/1/2). I'm still concerned that it's a
problem for this patch. I've cc'd some pid namespace folks, listed the
problems, and some alternative solutions (where I could think of any)
below:

1. Since fanotify doesn't hold a reference to the struct pid then the
pid can become stale before the event is acted upon.
    solution a: Just ignoring this problem, like other interfaces
often do, is probably ok.
    ... ?
    solution z: Seems to require taking a reference to the pid and
giving userspace a way to drop the reference after it's done using
this value to refer to the process (yuck).

2. If the event recipient does a clone and enters a new pidns the pid
number will be incorrect without any indication.
  solution a: The events could be flushed during clone(CLONE_NEWPID)
but then userspace would miss
      them.
  solution b: Translating the pids wouldn't work because the tasks
generaly won't exist in the new
      namespace. So perhaps just write negative values in the pid
fields during clone(CLONE_NEWPID).

3. If the listening process is not in the same or an ancestor pid
namespace of the triggering process then there is no correct pid
corresponding to the event.  (Note: Always using the initial pid
namespace isn't a good [interim] solution -- then programs relying on
fanotify couldn't run in other pid namespaces).
    solution a: Again, perhaps they should be set to negative values.
    ... ?
    solution z: Disable fanotify in non-initial pid namespaces (yuck).

Cheers,
    -Matt Helsley
