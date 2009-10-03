Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbZJCCBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbZJCCBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 22:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752484AbZJCCBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 22:01:34 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:40339 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbZJCCBe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 22:01:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=p8AvMCdmyFEH8fjlTXIVKUVNNa04OpUXyLTTpgGAycW00AzVByL0FuLYDI4MfGC3ZQ
         vYnmKW9KtOUscUT8PGeuUJ1RE1qzEOc9CBhn8g4t5EL/bQ8EGflQ7ultKsEWjQTqnGNB
         ZUTNbZ/4VoYZUDapM8lkX2J/L1zWkuMsZ/eCU=
MIME-Version: 1.0
In-Reply-To: <1254518602.5050.4.camel@hurina>
References: <1254518602.5050.4.camel@hurina>
From: Bryan Donlan <bdonlan@gmail.com>
Date: Fri, 2 Oct 2009 22:01:17 -0400
Message-ID: <3e8340490910021901i35ba8a5v7647b1e02b054270@mail.gmail.com>
Subject: Re: [PATCH] Added PR_SET_PROCTITLE_AREA option for prctl()
To: Timo Sirainen <tss@iki.fi>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 2, 2009 at 5:23 PM, Timo Sirainen <tss@iki.fi> wrote:
> PR_SET_PROCTITLE_AREA updates mm_struct->arg_start and arg_end to the
> given pointers, which makes it possible for user space to implement
> setproctitle(3) cleanly.


> @@ -267,9 +267,12 @@ static int proc_pid_cmdline(struct task_struct *task, char * buffer)
>
>        res = access_process_vm(task, mm->arg_start, buffer, len, 0);
>
> -       // If the nul at the end of args has been overwritten, then
> -       // assume application is using setproctitle(3).
> -       if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> +       if (mm->arg_end != mm->env_start) {
> +               // PR_SET_PROCTITLE_AREA used
> +               res = strnlen(buffer, res);

Is this check really needed? Surely it's enough to simply state that
behavior if the area isn't null-terminated is undefined.

> +       } else if (res > 0 && buffer[res-1] != '\0' && len < PAGE_SIZE) {
> +               // If the nul at the end of args has been overwritten, then
> +               // assume application is using old style setproctitle(3).
>                len = strnlen(buffer, res);
>                if (len < res) {
>                    res = len;

Might want to fix the bug later on in that function while you're in
here - the second access_process_vm call is never checked for errors,
but (from my reading) it's possible that the page that the environment
is on could be unmapped between those two calls. The result could
either be a short read (not the end of the world) or a negative value
(error code + small original argument length) passed to strnlen.

That said, come to think of it, I'm not actually sure if this prctl
stuff is strictly necessary. Wouldn't it be enough for glibc to copy
the environment somewhere safe, and then have the kernel guarantee a
full PAGE_SIZE between arg_start and env_end, even if this means
padding out the environment? The process could then measure to make
sure it has this much space (in case of running on an old kernel) by
testing the difference between arg_start and the top of the stack, or
an auxiliary vector could be passed down from the kernel with the
maximum proctitle length.
