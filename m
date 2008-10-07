Return-Path: <linux-kernel-owner+w=401wt.eu-S1754704AbYJGNjh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704AbYJGNjh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 09:39:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYJGNj2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 09:39:28 -0400
Received: from rv-out-0506.google.com ([209.85.198.234]:48776 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbYJGNj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 09:39:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=HE0rXGL/2kXg3ziunrfbN29LiG8GqPj8NZcBWy9eCw8v4W4/0/55MEoHnR/DJLuvFT
         W3AFcacZFWdOH7cfKpfrQanJCz5jd5gBGXBhFgEOBNM1PHRvU0JHhZbLa9lVdGbcCFBD
         fI7kpfdqPvZ9rpAxUVGc8Je65VJ3tEXXt/zWQ=
Message-ID: <517f3f820810070639q549ed2a1pe297e45108dfa007@mail.gmail.com>
Date: Tue, 7 Oct 2008 15:39:26 +0200
From: "Michael Kerrisk" <mtk.manpages@gmail.com>
To: "Kees Cook" <kees.cook@canonical.com>
Subject: Re: [PATCH v2] proc: show personality via /proc/pid/personality
Cc: "Alexey Dobriyan" <adobriyan@gmail.com>,
       "Arjan van de Ven" <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       "Michael Kerrisk" <mtk.manpages@gmail.com>, linux-api@vger.kernel.org
In-Reply-To: <20081005101438.GR10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081002211424.GJ10632@outflux.net>
	 <20081004145149.52c34ee7@infradead.org>
	 <20081004220220.GK10632@outflux.net>
	 <20081004164239.0c1483a4@infradead.org>
	 <20081005004233.GL10632@outflux.net>
	 <20081004174843.6fe48a8e@infradead.org>
	 <20081005091120.GA21003@x200.localdomain>
	 <20081005101438.GR10632@outflux.net>
X-Google-Sender-Auth: 0259a3746c8fced8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees,

On Sun, Oct 5, 2008 at 12:14 PM, Kees Cook <kees.cook@canonical.com> wrote:
> Make process personality flags visible in /proc.  Since a process's
> personality is potentially sensitive (e.g. READ_IMPLIES_EXEC), make this
> file only readable by the process owner.

Please CC userland interface changes to linux-api@vger.kernel.org

Ceers,

Michael

> Signed-off-by: Kees Cook <kees.cook@canonical.com>
> ---
> Please revert the prior patch against the "status" file -- this is the
> alternative.
> ---
>  fs/proc/array.c    |    8 ++++++++
>  fs/proc/base.c     |    2 ++
>  fs/proc/internal.h |    2 ++
>  3 files changed, 12 insertions(+), 0 deletions(-)
>
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index 71c9be5..6b6b492 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -337,6 +337,14 @@ int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>        return 0;
>  }
>
> +int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
> +                       struct pid *pid, struct task_struct *task)
> +{
> +       seq_printf(m, "%08x\n", task->personality);
> +
> +       return 0;
> +}
> +
>  static int do_task_stat(struct seq_file *m, struct pid_namespace *ns,
>                        struct pid *pid, struct task_struct *task, int whole)
>  {
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index a28840b..c675c62 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -2459,6 +2459,7 @@ static const struct pid_entry tgid_base_stuff[] = {
>        REG("environ",    S_IRUSR, environ),
>        INF("auxv",       S_IRUSR, pid_auxv),
>        ONE("status",     S_IRUGO, pid_status),
> +       ONE("personality", S_IRUSR, pid_personality),
>        INF("limits",     S_IRUSR, pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>        REG("sched",      S_IRUGO|S_IWUSR, pid_sched),
> @@ -2794,6 +2795,7 @@ static const struct pid_entry tid_base_stuff[] = {
>        REG("environ",   S_IRUSR, environ),
>        INF("auxv",      S_IRUSR, pid_auxv),
>        ONE("status",    S_IRUGO, pid_status),
> +       ONE("personality", S_IRUSR, pid_personality),
>        INF("limits",    S_IRUSR, pid_limits),
>  #ifdef CONFIG_SCHED_DEBUG
>        REG("sched",     S_IRUGO|S_IWUSR, pid_sched),
> diff --git a/fs/proc/internal.h b/fs/proc/internal.h
> index 4422023..747e3de 100644
> --- a/fs/proc/internal.h
> +++ b/fs/proc/internal.h
> @@ -53,6 +53,8 @@ extern int proc_tgid_stat(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
>  extern int proc_pid_status(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
> +extern int proc_pid_personality(struct seq_file *m, struct pid_namespace *ns,
> +                               struct pid *pid, struct task_struct *task);
>  extern int proc_pid_statm(struct seq_file *m, struct pid_namespace *ns,
>                                struct pid *pid, struct task_struct *task);
>  extern loff_t mem_lseek(struct file *file, loff_t offset, int orig);
> --
> 1.5.6.3
>
>
> --
> Kees Cook
> Ubuntu Security Team
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Michael Kerrisk Linux man-pages maintainer;
http://www.kernel.org/doc/man-pages/ Found a documentation bug?
http://www.kernel.org/doc/man-pages/reporting_bugs.html
