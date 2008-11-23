Return-Path: <linux-kernel-owner+w=401wt.eu-S1758815AbYKWPiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815AbYKWPiD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2008 10:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752397AbYKWPhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Nov 2008 10:37:51 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:49722 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751072AbYKWPhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2008 10:37:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Iv8v6/pmZseK5zuWDtxqKI80xqaEG6ruBjqMZD4hiDfKYh7rtL1j4Axf5OqH+3suUB
         Zgbguw14uppDWNubPU9W3q5zzjWpDwedEaTQlsmifje/pp/J5C3mZAwQftY3sgOjQbUE
         2bwuua2evaVc56HPR4mR8iLMAp49/a2yQQyJg=
Message-ID: <804dabb00811230737g4c958ca1p74b661faabfece0b@mail.gmail.com>
Date: Sun, 23 Nov 2008 23:37:49 +0800
From: "Peter Teoh" <htmldeveloper@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] tracing: allow tracing of suspend/resume & hibernation code again
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, "Steven Rostedt" <srostedt@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081123094124.GO30453@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <804dabb00811220047q6e0f24eap23e9a7c4c7bd71b6@mail.gmail.com>
	 <200811221359.24808.rjw@sisk.pl> <20081123094124.GO30453@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Ingo,

I applied the patch (manually) agains Linus's git:

git describe
v2.6.28-rc6-7-ged31348

Previously, before the patch, I had no problem resuming - for
v2.6.28-rc6.   Now after s2ram, it cannot resume properly - nothing is
displayed.   And I had not applied any changes to ftrace's
/debug/tracing files yet.

Let me test it out again.   Thanks.   (I am on FC7).

On Sun, Nov 23, 2008 at 5:41 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
>> > Q2: how to ftrace s2ram and resume?  I attempted to do it, but the
>> > trace output is always filled with "resume" related functions when
>> > it started up, which is only logical.
>>
>> The tracing is disabled during suspend/resume, so you can't.
>
> i think we could lift this restriction now that dftrace is gone for
> good - which was causing most of the trouble.
>
>  41108eb10142e0552f2de1e4c0675b108c5f018f
>  f42ac38c59e0a03d6da0c24a63fb211393f484b0
>
> Completely untested patch below. Peter, does it work for you?
>
>        Ingo
>
> ------------------->
> From 3134c953216111a35d17f77b784e5d1fa2ba36d5 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Sun, 23 Nov 2008 10:37:12 +0100
> Subject: [PATCH] tracing: allow tracing of suspend/resume & hibernation code again:
>
> Now that the ftrace kernel thread is gone, we can allow tracing
> during suspend/resume again.
>
> So revert these two commits:
>
>  f42ac38c5 "ftrace: disable tracing for suspend to ram"
>  41108eb10 "ftrace: disable tracing for hibernation"
>
> This should be tested very carefully, as it could interact with
> altneratives instruction patching, etc.
>
> Not-Yet-Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/power/disk.c |   13 +++----------
>  kernel/power/main.c |    5 +----
>  2 files changed, 4 insertions(+), 14 deletions(-)
>
> diff --git a/kernel/power/disk.c b/kernel/power/disk.c
> index c9d7408..f77d381 100644
> --- a/kernel/power/disk.c
> +++ b/kernel/power/disk.c
> @@ -22,7 +22,6 @@
>  #include <linux/console.h>
>  #include <linux/cpu.h>
>  #include <linux/freezer.h>
> -#include <linux/ftrace.h>
>
>  #include "power.h"
>
> @@ -257,7 +256,7 @@ static int create_image(int platform_mode)
>
>  int hibernation_snapshot(int platform_mode)
>  {
> -       int error, ftrace_save;
> +       int error;
>
>        /* Free memory before shutting down devices. */
>        error = swsusp_shrink_memory();
> @@ -269,7 +268,6 @@ int hibernation_snapshot(int platform_mode)
>                goto Close;
>
>        suspend_console();
> -       ftrace_save = __ftrace_enabled_save();
>        error = device_suspend(PMSG_FREEZE);
>        if (error)
>                goto Recover_platform;
> @@ -299,7 +297,6 @@ int hibernation_snapshot(int platform_mode)
>  Resume_devices:
>        device_resume(in_suspend ?
>                (error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> -       __ftrace_enabled_restore(ftrace_save);
>        resume_console();
>  Close:
>        platform_end(platform_mode);
> @@ -370,11 +367,10 @@ static int resume_target_kernel(void)
>
>  int hibernation_restore(int platform_mode)
>  {
> -       int error, ftrace_save;
> +       int error;
>
>        pm_prepare_console();
>        suspend_console();
> -       ftrace_save = __ftrace_enabled_save();
>        error = device_suspend(PMSG_QUIESCE);
>        if (error)
>                goto Finish;
> @@ -389,7 +385,6 @@ int hibernation_restore(int platform_mode)
>        platform_restore_cleanup(platform_mode);
>        device_resume(PMSG_RECOVER);
>  Finish:
> -       __ftrace_enabled_restore(ftrace_save);
>        resume_console();
>        pm_restore_console();
>        return error;
> @@ -402,7 +397,7 @@ int hibernation_restore(int platform_mode)
>
>  int hibernation_platform_enter(void)
>  {
> -       int error, ftrace_save;
> +       int error;
>
>        if (!hibernation_ops)
>                return -ENOSYS;
> @@ -417,7 +412,6 @@ int hibernation_platform_enter(void)
>                goto Close;
>
>        suspend_console();
> -       ftrace_save = __ftrace_enabled_save();
>        error = device_suspend(PMSG_HIBERNATE);
>        if (error) {
>                if (hibernation_ops->recover)
> @@ -452,7 +446,6 @@ int hibernation_platform_enter(void)
>        hibernation_ops->finish();
>  Resume_devices:
>        device_resume(PMSG_RESTORE);
> -       __ftrace_enabled_restore(ftrace_save);
>        resume_console();
>  Close:
>        hibernation_ops->end();
> diff --git a/kernel/power/main.c b/kernel/power/main.c
> index eaa122b..142e005 100644
> --- a/kernel/power/main.c
> +++ b/kernel/power/main.c
> @@ -22,7 +22,6 @@
>  #include <linux/freezer.h>
>  #include <linux/vmstat.h>
>  #include <linux/syscalls.h>
> -#include <linux/ftrace.h>
>
>  #include "power.h"
>
> @@ -321,7 +320,7 @@ static int suspend_enter(suspend_state_t state)
>  */
>  int suspend_devices_and_enter(suspend_state_t state)
>  {
> -       int error, ftrace_save;
> +       int error;
>
>        if (!suspend_ops)
>                return -ENOSYS;
> @@ -332,7 +331,6 @@ int suspend_devices_and_enter(suspend_state_t state)
>                        goto Close;
>        }
>        suspend_console();
> -       ftrace_save = __ftrace_enabled_save();
>        suspend_test_start();
>        error = device_suspend(PMSG_SUSPEND);
>        if (error) {
> @@ -364,7 +362,6 @@ int suspend_devices_and_enter(suspend_state_t state)
>        suspend_test_start();
>        device_resume(PMSG_RESUME);
>        suspend_test_finish("resume devices");
> -       __ftrace_enabled_restore(ftrace_save);
>        resume_console();
>  Close:
>        if (suspend_ops->end)
>



-- 
Regards,
Peter Teoh
